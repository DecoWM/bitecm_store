<?php

namespace App\Http\Controllers;

use DB;
use App\Mail\OrderCompleted;
use App\Jobs\ProcessPorta;
use Illuminate\Support\Facades\Mail;
use App\Http\Controllers\BaseController;
use Illuminate\Http\Request;
use Artisaninweb\SoapWrapper\SoapWrapper; // For use client SOAP service
use Illuminate\Support\Facades\Log;
use Illuminate\Queue\QueueManager;

class OrderController extends Controller
{
  protected $shared;

  /**
  * @var SoapWrapper
  * @var portingRequestId : ID when Consultant Request is created
  */
  protected $soapWrapper;
  protected $portingRequestId;
  protected $queueManager;

  /**
  * SoapController constructor.
  *
  * @param SoapWrapper $soapWrapper
  */

  public function __construct (BaseController $shared, SoapWrapper $soapWrapper, QueueManager $queueManager) {
    $this->shared = $shared;
    $this->soapWrapper = $soapWrapper;
    $this->queueManager = $queueManager;
  }

  private function initSoapWrapper(){
    try {
      $this->soapWrapper->add('bitelSoap', function ($service) {
        $service
          ->wsdl('http://10.121.4.36:8236/BCCSWS?wsdl')
          ->trace(true);
      });
    } catch (\Exception $e) {
      Log::error('No se tiene acceso al servidor BCCSWS. Puede que no se esté dentro de la red privada');
      Log::error($e->getMessage());
    }

    try {
      $this->soapWrapper->add('bitelSoapGW', function ($service) {
        $service
          ->wsdl('http://10.121.4.61:8570/BCCSGateway?wsdl')
          ->trace(true);
      });
    } catch (\Exception $e) {
      Log::error('No se tiene acceso al servidor BCCSGateway. Puede que no se esté dentro de la red privada');
      Log::error($e->getMessage());
    }
  }

  /**
  * ********** Temporary model from SOAP services here. Move to a model file !!!!
  * Use the SoapWrapper
  **/

  /**
  * Function for verify if customer have many lines
  * @var isOverQuota: 0 -> return false
  *                  else -> return true
  **/
  protected function checkIsOverQouta($order_detail) {
    try {
      $response = $this->soapWrapper->call('bitelSoap.checkOverQoutaIdNo', [
        'checkOverQoutaIdNo' => array(
          'paymethodType' => strval($order_detail['type_id']),
          'busType' => 'INDI',
          'idNo' => strval($order_detail['id_number']),
          'productCode' => strval($order_detail['product_code'])
        )
      ]);
      Log::info('Respuesta bitelSoap.checkOverQoutaIdNo: ', (array) $response->return);
      return ($response->return->isOverQouta != 0);
    } catch (\Exception $e) {
      Log::error('El método checkOverQoutaIdNo no se encuentra disponible o recibió parametros erroneos');
      Log::error($e->getMessage());
      return false;
    }
  }

  /**
  * Verify if customer exists in bitel database
  * @var result: if exists -> return object result
  *              else -> return false: Not have debt
  */
  protected function getInfoCustomer($order_detail) {
    try {
      $response = $this->soapWrapper->call('bitelSoap.getCustomer', [
        'getCustomer' => array(
          'idType' => '01', // persona natural !!!
          'idNo' => $order_detail['id_number']
        )
      ]);
      if(isset($response->return->result)) {
        Log::info('Respuesta bitelSoap.getCustomer: ', (array) $response->return);
        return $response->return->result;
      }
      else {
        Log::warning('Respuesta bitelSoap.getCustomer: ', (array) $response->return);
        return false;
      }
    } catch (\Exception $e) {
      Log::error('El método getCustomer no se encuentra disponible o recibió parametros erroneos');
      Log::error($e->getMessage());
      return null;
    }
  }

  /**
  * Verify if customer have pending debt
  * @var errorCode: -1 -> return true
  *                 else -> return false: Not have debt
  */
  protected function checkHaveDebit($custId) {
    try {
      $response = $this->soapWrapper->call('bitelSoap.getInfoDebitByCustId', [
        'getInfoDebitByCustId' => array(
          'custId' => strval($custId)
        )
      ]);
      if ( isset($response->return->errorCode) && $response->return->errorCode == -1) {  
        Log::info('Respuesta bitelSoap.getInfoDebitByCustId: ', (array) $response->return);
        return true;
      }
      Log::warning('Respuesta bitelSoap.getInfoDebitByCustId: ', (array) $response->return);
      return false;
    } catch (\Exception $e) {
      Log::error('El método getInfoDebitByCustId no se encuentra disponible o recibió parametros erroneos');
      Log::error($e->getMessage());
      return true;
    }
  }

  /**
  * make a consultant request ONLY FOR PORTABILITY
  * @var errorCodeMNP: 0 -> return true: Consultant created
  *                 else -> return false: consultant not created
  * @var portingRequestId: id for request created
  */
 // 'sourcePayment' => strval($order_detail['type_number_carry']),

  protected function createConsultantRequest(&$order_detail) {
    try {
      $req = [
        'createConsultantRequest' => array(
          'staffCode' => 'CM_THUYNTT',
          'shopCode' => 'VTP',
          'dni' => strval($order_detail['id_number']),
          'isdn' => strval($order_detail['porting_phone']),
          'sourceOperator' => isset($order_detail['source_operator_id']) ? strval($order_detail['source_operator_id']) : '',
          'sourcePayment' => strval($order_detail['type_id']),
          'email' => strval($order_detail['contact_email']),
          'phone' => strval($order_detail['contact_phone']),
          'sourcePayment' => strval($order_detail['type_number_carry']),
          'custName' => strval($order_detail['first_name'] . ' ' . $order_detail['last_name']),
          'contactName' => strval($order_detail['first_name'] . ' ' . $order_detail['last_name']),
          'reasonId' => isset($order_detail['reason_code']) ? strval($order_detail['reason_code']) : ''
        )
      ];

      $response = $this->soapWrapper->call('bitelSoap.createConsultantRequest', $req);

      if ($response->return->errorCodeMNP == '0') {
        // set the portingRequestId from response
        // $this->portingRequestId = $response->return->portingRequestId;
        $order_detail['porting_request_id'] = $response->return->portingRequestId;
        Log::info('Respuesta bitelSoap.createConsultantRequest: ', (array) $response->return);
        return true;
      }

      Log::warning('Respuesta bitelSoap.createConsultantRequest: ', (array) $response->return);
      return false;
    } catch (\Exception $e) {
      Log::error('El método createConsultantRequest no se encuentra disponible o recibió parametros erroneos');
      Log::error($e->getMessage());
      return true;
    }
  }

  /**
  * get request response if is  created previously ONLY FOR PORTABILITY
  * @var stateCode: 02 -> return true: Exito
  *                 else -> return false: Rechazado
  */
  protected function checkSuccessPortingRequest(&$order_detail) {
    try {
      $response = $this->soapWrapper->call('bitelSoap.getListPortingRequest', [
        'getListPortingRequest' => array(
          'staffCode' => 'CM_THUYNTT', // ***** Change it for dynamic Value !!!
          'dni' => strval($order_detail['id_number']),
          'isdn' => strval($order_detail['porting_phone']),
        )
      ]);

      if ($response->return->errorCodeMNP == '0') {
        $order_detail['mnp_request_id'] = $response->return->listPortingRequest->requestId;
        $order_detail['porting_state_code'] = $response->return->listPortingRequest->stateCode;
        $order_detail['porting_status'] = $response->return->listPortingRequest->status;
        $order_detail['porting_status_desc'] = $response->return->listPortingRequest->statusDescription;
        Log::info('Respuesta bitelSoap.getListPortingRequest: ', (array) $response->return);
        return true;
      }

      Log::warning('Respuesta bitelSoap.getListPortingRequest: ', (array) $response->return);
      return false;
      // return ($response->return->errorCode == '02');
    } catch (\Exception $e) {
      Log::error('El método getListPortingRequest no se encuentra disponible o recibió parametros erroneos');
      Log::error($e->getMessage());
      return true;
    }
  }

  protected function checkIsRenovationUnavailable(&$order_detail) {
    try {
      $response = $this->soapWrapper->call('bitelSoapGW.gwOperation', [
        'gwOperation' => [
          'username' => '938ed30650f53b911f39c8818c9bc6e1',
          'password' => '313d4015d3d32ba16b951ee3e4029b71',
          'wscode' => 'checkSubscriberExist',
          'param' => [
            [
              '_' => '',
              'name' => 'idNo',
              'value' => strval($order_detail['id_number'])
            ],
            [
              '_' => '',
              'name' => 'idType',
              'value' => strval($order_detail['idtype_id'])
            ],
            [
              '_' => '',
              'name' => 'isdn',
              'value' => strval($order_detail['billing_phone'])
            ]
          ]
        ]
      ]);

      Log::info('Respuesta bitelSoapGW.gwOperation: ', (array) $response);

      if ($response->error == '0') {
        if (!empty($response->original)) {
          $original = $this->shared->namespacedXMLToArray($response->original);
          $original = $original['Body']['checkSubscriberExistResponse']['return'];
          Log::info('bitelSoapGW.gwOperation.original: ', (array) $original);
          if ($original['code'] != '0') {
            if ($original['checkedSubscriber']['isExist'] != 'false') {
              return false; 
            } else {
              return true;
            }
          }
        }
      }

      $order_detail['renov_ws_fail'] = 1;
      return true;
    } catch (\Exception $e) {
      $order_detail['renov_ws_fail'] = 1;
      Log::error('El método gwOperation no se encuentra disponible o recibió parametros erroneos');
      Log::error($e->getMessage());
      return true;
    }
  }

  protected function schedulePortingRequestJob($order_detail) {
    $payload = [
      'order_id' => $order_detail['order_id'],
      'dni' => $order_detail['id_number'],
      'isdn' => $order_detail['porting_phone'],
      'porting_request_id' => $order_detail['porting_request_id']
    ];
    $connectionName = config('queue.default');
    $this->queueManager->connection($connectionName)->pushRaw(json_encode($payload), 'porta');
    // ProcessPorta::dispatch($payload)->onQueue('porta');
  }

  protected function schedulePortingRequestJobRequest($order_detail) {
    $client = new \GuzzleHttp\Client();
    try {
      $res = $client->request('POST', \Config::get('filter.notification_server_url').'/api/schedule/check_porting_status/'.$order_detail['order_id'], [
        \GuzzleHttp\RequestOptions::JSON => [
          'dni' => $order_detail['id_number'],
          'isdn' => $order_detail['porting_phone'],
          'porting_request_id' => $order_detail['porting_request_id']
        ]
      ]);
    } catch (\Exception $e) {
      Log::error($e->getMessage());
      Log::warning('Error al enviar la solicitud de cola de portabilidad');
    }
  }

  protected function notifyAdmin($order_detail) {
    $client = new \GuzzleHttp\Client();
    try {
      $res = $client->request('POST', \Config::get('filter.notification_server_url').'/api/notify/order_complete', [
        \GuzzleHttp\RequestOptions::JSON => [
          'order_id' => $order_detail['order_id'],
          'plan_name' => $order_detail['plan_name']
        ]
      ]);
    } catch (\Exception $e) {
      Log::error($e->getMessage());
      Log::warning('Error al enviar la solicitud de notificación');
    }
  }

  public function createOrder (Request $request) {
    $cart = collect($request->session()->get('cart')); //Carrito de compras

    if (!count($cart)) {
      return redirect()->route('home');
    }

    /*
    if ($request->session()->has('order_detail')) {
      $order_detail = json_decode($request->session()->get('order_detail'));
      Log::info('Detalle de orden', (array) $order_detail);
    } else {
      $order_detail = [];
    }
    */

    // $distritos = ['LIMA', 'ANCÓN', 'ATE', 'BARRANCO', 'BRENA', 'CARABAYLLO',
    //   'CHACLACAYO', 'CHORRILLOS', 'CIENEGUILLA', 'COMAS', 'EL AGUSTINO',
    //   'INDEPENDENCIA', 'JESÚS MARÍA', 'LA MOLINA', 'LA VICTORIA', 'LINCE',
    //   'LOS OLIVOS', 'LURIGANCHO', 'LURIN', 'MAGDALENA DEL MAR', 'MAGDALENA VIEJA',
    //   'MIRAFLORES', 'PACHACAMAC', 'PUCUSANA', 'PUENTE PIEDRA', 'PUNTA HERMOSA',
    //   'PUNTA NEGRA', 'RÍMAC', 'SAN BARTOLO', 'SAN BORJA', 'SAN ISIDRO',
    //   'SAN JUAN DE LURIGANCHO', 'SAN JUAN DE MIRAFLORES', 'SAN LUIS',
    //   'SAN MARTÍN DE PORRES', 'SAN MIGUEL', 'SANTA ANITA', 'SANTA MARÍA DEL MAR',
    //   'SANTA ROSA', 'SANTIAGO DE SURCO', 'SURQUILLO', 'VILLA EL SALVADOR',
    //   'SURQUILLO', 'VILLA EL SALVADOR', 'VILLA MARÍA DEL TRIUNFO',  'CALLAO',
    //   'BELLAVISTA', 'CARMEN DE LA LEGUA REYNOSO', 'LA PERLA', 'LA PUNTA', 'VENTANILLA'
    // ];

    /*
    $distritos = $this->shared->districtsList();

    $source_operators = $this->shared->operatorList();

    $affiliation_list = DB::select('call PA_affiliationList()');

    $dept_prov_dist_branch_list = DB::select('call PA_deptprovdistbrachList()');

    $equipo = null;
    foreach ($cart as $item) {
      switch ($item['type_id']) {
        case 0:
          break;
        case 1:
          $equipo = $item;
          break;
        case 2:
          $equipo = $item;
          break;
      }
    }

    // obtener los dfatos de departamento , provincia y distrito en base al primer registro 
    $departamento = $dept_prov_dist_branch_list[0]->departament_id;
    $provincia = $dept_prov_dist_branch_list[0]->province_id;
    $distrito = $dept_prov_dist_branch_list[0]->district_id;

    // obtener los datos de los departamentos unicos
    $departamentos = array();
    foreach ($dept_prov_dist_branch_list as $dept){
      $departamentos[$dept->departament_id] = $dept;
    }

    // obtener las provincias en funciona al primer departamento
    $provincias = array();
    foreach ($dept_prov_dist_branch_list as $prov){
      if($prov->departament_id == $departamento){
        $provincias[$prov->province_id] = $prov;
      }
    }
    
    // obtener los distritos en funcion a la primera provincia
    $distritos = array();
    foreach ($dept_prov_dist_branch_list as $dist){
      if($dist->departament_id == $departamento and $dist->province_id == $provincia){
        $distritos[$dist->district_id] = $dist;
      }
    }
    */

    $equipo = null;
    foreach ($cart as $item) {
      switch ($item['type_id']) {
        case 0:
          break;
        case 1:
          $equipo = $item;
          break;
        case 2:
          $equipo = $item;
          break;
      }
    }
    
    $sentinel_check = DB::table('tbl_sentinel_check')->first();

    if ((isset($equipo['sentinel']) && $equipo['sentinel']) && !$sentinel_check) {
      return redirect()->route('show_cart')->with('msg', 'Este equipo requiere <b>aprobación de credito inmediata</b>. Antes de continuar con la compra debe verificar su estado crediticio con Bitel haciendo click en el botón <b>EVALUACIÓN CREDITICIA</b>');
    }

    if ($request->session()->has('order_detail')) {
      $order_detail = json_decode($request->session()->get('order_detail'));
      Log::info('Detalle de orden', (array) $order_detail);
    } 
    else {
      $order_detail = [];
    }

    $distritosd = $this->shared->districtsList();
    $source_operators = $this->shared->operatorList();
    $affiliation_list = DB::select('call PA_affiliationList()');
    $schedule_list = DB::select('call PA_scheduleList()');
    $dept_prov_dist_branch_list = DB::select('call PA_deptprovdistbrachList()');

    // obtener los dfatos de departamento , provincia y distrito en base al primer registro 
    $departamento = $dept_prov_dist_branch_list[0]->departament_id;
    $provincia = $dept_prov_dist_branch_list[0]->province_id;
    $distrito = $dept_prov_dist_branch_list[0]->district_id;

    // obtener los datos de los departamentos unicos
    $departamentos = array();
    foreach ($dept_prov_dist_branch_list as $dept){
      $departamentos[$dept->departament_id] = $dept;
    }

    // obtener las provincias en funciona al primer departamento
    $provincias = array();
    foreach ($dept_prov_dist_branch_list as $prov){
      if($prov->departament_id == $departamento){
        $provincias[$prov->province_id] = $prov;
      }
    }
    
    // obtener los distritos en funcion a la primera provincia
    $distritos = array();
    foreach ($dept_prov_dist_branch_list as $dist){
      if($dist->departament_id == $departamento and $dist->province_id == $provincia){
        $distritos[$dist->district_id] = $dist;
      }
    }

    return view('order_form', [
      'item' => $equipo,
      'departamentos' => $departamentos,
      'provincias' => $provincias,
      'distritos' => $distritos,
      'distritosd' => $distritosd,
      'horarios' => $schedule_list,
      'source_operators' => $source_operators,
      'affiliation_list' => $affiliation_list,
      'order_detail' => $order_detail,
      'dept_prov_dist_branch_list' => $dept_prov_dist_branch_list
    ]);

  }

  public function storeOrder (Request $request) {

    $cart = collect($request->session()->get('cart'));

    if (count($cart) == 0) {
      return redirect()->route('show_cart');
    }

    $igv = \Config::get('filter.igv');

    $products = [];
    $order_items = [];
    $total_net = 0;
    $total_igv = 0;
    $equipo = null;

    $schedule_porting_request = false;
    $order_detail = [];

    foreach ($cart as $item) {
      switch ($item['type_id']) {
        case 0:
          $product = $this->shared->productByStock($item['stock_model_id']);
          break;
        case 1:
          $product = $this->shared->productPrepagoByStock($item['stock_model_id'],$item['product_variation_id']);
          $equipo = $product;
          break;
        case 2:
          $product = $this->shared->productPostpagoByStock($item['stock_model_id'],$item['product_variation_id']);
          $equipo = $product;
          break;
      }

      if(!isset($product)) {
        continue;
      }

      $product->quantity = $item['quantity'];
      array_push($products, $product);

      if(isset($product->promo_id)) {
        $final_price = $product->promo_price;
      } else {
        $final_price = $product->product_price;
      }

      $subtotal = $final_price * $item['quantity'];
      $subtotal_net = $subtotal * (1 - $igv);
      $subtotal_igv = $subtotal;
      $total_net += $subtotal_net;
      $total_igv += $subtotal_igv;

      $equipo_plan = 0;
      // si es solo un chip (producto de categoria chip)
      if($product->category_id === 4){
        $equipo_plan = 1;
      }

      array_push($order_items, [
        'stock_model_id' => $item['stock_model_id'],
        'product_variation_id' => $item['product_variation_id'],
        'promo_id' => $product->promo_id,
        'quantity' => $item['quantity'],
        'subtotal' => number_format($subtotal_net, 2, '.', ''),
        'subtotal_igv' => number_format($subtotal_igv, 2, '.', ''),
        'equipo_plan' => $equipo_plan
      ]);
    }

    if(!isset($equipo)) { //Accesorio
      $order_detail['service_type'] = 'Accesorios';
      $order_detail['affiliation_type'] = null;
    } else {
      if ($equipo->product_sentinel) {
        $equipo->product_model .= ' +S';
      }
      $order_detail['affiliation_id'] = $request->affiliation;
      if (!isset($equipo->affiliation_name)) { //Prepago
        $order_detail['service_type'] = 'Prepago';
        $affiliation = DB::table('tbl_affiliation')
          ->where('affiliation_id', $request->affiliation)
          ->first();
        if (isset($affiliation)) {
          $order_detail['affiliation_type'] = $affiliation->affiliation_name;
        } else {
          $order_detail['affiliation_type'] = null;
        }
      } else { //Postpago
        $order_detail['service_type'] = 'Postpago';
        $order_detail['affiliation_type'] = $equipo->affiliation_name;
      }
    }

    if (count($order_items) == 0 && count($cart) > 0) {
      $request->session()->forget('cart');
      return redirect()->route('show_cart')->with('msg', 'Ha ocurrido un error con el carrito de compras');
    }

    $order_detail['idtype_id'] = $request->document_type;
    $order_detail['payment_method_id'] = $request->payment_method;
    $order_detail['branch_id'] = $this->shared->branchByDistrict($request->delivery_district_1);
    $order_detail['first_name'] = $request->first_name;
    $order_detail['last_name'] = ''; //$request->last_name;
    $order_detail['id_number'] = $request->document_number;
    $order_detail['tracking_code'] = $request->document_number;
    $order_detail['billing_district'] = 0; //$request->district; por el nuevo diseño
    //$order_detail['billing_phone'] = $request->phone_number;
    $order_detail['delivery_address'] = $request->delivery_address;
    $order_detail['delivery_district'] = $request->delivery_district_1;
    $order_detail['contact_email'] = $request->email;
    $order_detail['contact_phone'] = $request->contact_phone;

    $order_detail['terminos_condiciones'] = 0;
    if($request->terminos_condiciones == 'on'){
      $order_detail['terminos_condiciones'] = 1;
    }
    $order_detail['idschedule_id'] = $request->delivery_schedule;
    $order_detail['porting_request_id'] = null;

    if(isset($equipo) && isset($request->affiliation) && $request->affiliation == 1) {
      $source_operators = $this->shared->operatorList();
      $order_detail['source_operator'] = $source_operators[$request->operator];
      $order_detail['source_operator_id'] = $request->operator;
      $order_detail['billing_phone'] = $request->porting_phone;
      $order_detail['porting_phone'] = $request->porting_phone;
      $order_detail['type_number_carry'] = $request->type_number_carry; 
    } else {
      $order_detail['source_operator'] = null;
      $order_detail['porting_phone'] = null;
      $order_detail['type_number_carry'] = '';
      $order_detail['billing_phone'] = $request->phone_number;
    }

    if(isset($equipo) && isset($equipo->variation_type_id)) {
      $order_detail['type_id'] = '0'.$equipo->variation_type_id;
    }

    if(isset($equipo) && isset($equipo->reason_code)) {
      $order_detail['reason_code'] = $equipo->reason_code;
    }

    if(isset($equipo) && isset($equipo->product_package)) {
      $order_detail['product_package'] = $equipo->product_package;
    }

    if(isset($equipo) && isset($equipo->product_code)) {
      $order_detail['product_code'] = $equipo->product_code;
    }

    if(isset($equipo) && \Config::get('filter.use_bcss')) { 
      // Apply validations with Bitel webservice before insert
      $this->initSoapWrapper(); // Init the bitel soap webservice

      if(isset($request->affiliation) && $request->affiliation == 3) {
        if($this->checkIsRenovationUnavailable($order_detail)) {
          if (isset($order_detail['renov_ws_fail'])) {
            return redirect()->route('create_order')->with('ws_result', json_encode([
              'title' => 'te comunica que',
              'message' => 'Ocurrio un error al validar si usted es aplicable para renovación. Por favor, intente mas tarde.'
            ]));
          } else {
            $request->session()->flash('order_detail', json_encode($order_detail));
            $tried_phone = implode(str_split($order_detail['billing_phone'], 3), ' ');
            if (!isset($equipo->affiliation_name)) { //Prepago
              return view('renov_fail', ['postpago' => false, 'tried_phone' => $tried_phone]);
            } else {
              return view('renov_fail', ['postpago' => true, 'tried_phone' => $tried_phone]);
            }
          }
        }
      }

      // Check if have many lines
      if(isset($order_detail['product_code']) && $this->checkIsOverQouta($order_detail)) {
        return redirect()->route('create_order')->with('ws_result', json_encode([
          'title' => 'te comunica que',
          'message' => 'No puede tener más números telefónicos.'
        ]));
      }

      // check if is client
      if($data_customer = $this->getInfoCustomer($order_detail)) {
        // check if have debt
        if($this->checkHaveDebit($data_customer->custId)){
          return redirect()->route('create_order')->with('ws_result', json_encode([
            'title' => 'te recuerda que',
            'message' => 'Tienes una deuda pendiente con BITEL, acércate a cancelar a la agencia más cercana.'
          ]));
        }
      }

      // IF IS PORTABILITY APPLY THE NEXT PROCCESS AND VALIDATIONS
      if(isset($request->affiliation) && $request->affiliation == 1) {
        // process request portability
        if($this->createConsultantRequest($order_detail)) {
          $schedule_porting_request = true;
          /* if(!$this->checkSuccessPortingRequest($order_detail)){ 
            return redirect()->route('create_order')->with('ws_result', json_encode([
              'title' => 'te comunica que',
              'message' => 'No es posible realizar la portabilidad con su número.'
            ]));
          }*/
        }
        else {
          return redirect()->route('create_order')->with('ws_result', json_encode([
            'title' => 'te comunica que',
            'message' => 'Ocurrió un error creando la solicitud de portabilidad.'
          ]));
        }
      }
    }

    $order_detail['total'] = $total_net;
    $order_detail['total_igv'] = $total_igv;

    $order_detail['credit_status'] = DB::table('tbl_sentinel_check')->first() ? 'Aprobada' : 'Pendiente';

    error_log(print_r($order_detail, true), 3, 'c:/nginx-1.12.2/logs/bitel-store.log');

    try {
      DB::beginTransaction();

      $order_id = $this->shared->getMaxStoreOrderID();

      $res = $this->shared->insertStoreOrder(
        $order_id,
        $order_detail['idtype_id'],
        $order_detail['payment_method_id'],
        $order_detail['branch_id'],
        $order_detail['tracking_code'],
        $order_detail['first_name'],
        $order_detail['last_name'],
        $order_detail['id_number'],
        $order_detail['billing_district'],
        $order_detail['billing_phone'],
        $order_detail['source_operator'],
        $order_detail['porting_phone'],
        $order_detail['delivery_address'],
        $order_detail['delivery_district'],
        $order_detail['contact_email'],
        $order_detail['contact_phone'],
        $order_detail['service_type'], 
        $order_detail['affiliation_type'],
        $order_detail['type_number_carry'],  
        $order_detail['porting_request_id'],
        $order_detail['credit_status'],
        number_format($order_detail['total'], 2, '.', ''),
        number_format($order_detail['total_igv'], 2, '.', ''),
        $order_detail['terminos_condiciones'],
        $order_detail['idschedule_id']
      );

      $now = new \DateTime('America/Lima');
      $order_detail['fecha'] = $now->format('d/m/Y H:i:s');

      foreach($order_items as $i => $item) {
        $order_items[$i]['order_id'] = $order_id;
      }

      DB::table('tbl_order_item')->insert($order_items);

      DB::table('tbl_order_status_history')->insert([
        'order_id' => $order_id,
        'order_status_id' => \Config::get('filter.order_status_id')
      ]);
      
      DB::table('tbl_sentinel_check')->delete();

      DB::commit();
    } catch(\Illuminate\Database\QueryException $e) {
      DB::rollback();
      Log::error($e->getMessage());
      return redirect()->route('create_order')->with('ws_result', json_encode([
        'title' => 'te informa que',
        'message' => 'Ocurrió un error creando la orden.'
      ]));
    }
    
    if (!isset($order_id)) {
      Log::error('Ocurrió un error creando la orden, no se tiene el order_id');
      return redirect()->route('create_order')->with('ws_result', json_encode([
        'title' => 'te informa que',
        'message' => 'Ocurrió un error creando la orden.'
      ]));
    }

    $order_detail['order_id'] = $order_id;

    if (isset($equipo)) {
      $order_detail['plan_name'] = $equipo->plan_name;
    }

    if ($schedule_porting_request) {
      $this->schedulePortingRequestJob($order_detail);
    }

    $this->notifyAdmin($order_detail);

    try {
      Mail::to($request->email)->send(new OrderCompleted([
        'order_id' => $order_id,
        'order_detail' => $order_detail,
        'order_items' => $order_items,
        'products' => $products
      ]));
    } catch (\Exception $e) {
      Log::warning('Error al enviar correo a '.$request->email.' por la orden #'.$order_id);
      Log::warning($e->getMessage());
    }

    DB::commit();
    $request->session()->flush();

    return view('order_detail', ['products' => $products, 'order_id' => $order_id, 'order' => $order_detail]);
  }

  public function trackOrder (Request $request, $order_id) {
    $order = DB::table('tbl_order')->where('order_id', $order_id)->first();
    if (!isset($order)) {
      return abort(404);
    }
    $products = $this->shared->orderItems($order_id);
    
    $status_history = $this->shared->statusHistory($order_id);

    // Al inicio todos los estados por default
    // Pendiente >> Aceptado >> Programado >> En Envío >> Completado
    $status_list = $this->shared->statusList_12356();
    $flag = 0;
    // Pendiente >> Aceptado >> Programado >> En Envío >> Completado
    if(count($status_history) == 1 && $status_history[0]->order_status_name == 'Pendiente'){
      $status_list = $this->shared->statusList_12356();
    }
    elseif(count($status_history) == 2 && 
      $status_history[0]->order_status_name == 'Aceptado' && $status_history[1]->order_status_name == 'Pendiente'){
      // Pendiente >> Aceptado >> Programado >> En Envío >> Completado
      $status_list = $this->shared->statusList_12356();
    }
    elseif($status_history[0]->order_status_name == 'No Contactado' && $status_history[1]->order_status_name == 'Pendiente' ||
           $status_history[1]->order_status_name == 'No Contactado' && $status_history[2]->order_status_name == 'Pendiente'){
      // Pendiente >> No Contactado >> Cancelado
      if($status_history[0]->order_status_name == 'Cancelado'){
        $status_list = $this->shared->statusList_174();
      }
      // Pendiente >> No Contactado >> Aceptado
      elseif($status_history[0]->order_status_name == 'Aceptado'){
        $flag = 1;
        $status_list = $this->shared->statusList_172();
      }  
      else{
        $status_list = $this->shared->statusList_174();
      }   
    }
    // Pendiente >> Aceptado >> Programado >> En Envío >> Cancelado
    elseif(count($status_history) == 5 && 
      $status_history[0]->order_status_name == 'Cancelado' &&
      $status_history[1]->order_status_name == 'En Envío' &&
      $status_history[2]->order_status_name == 'Programado' &&
      $status_history[3]->order_status_name == 'Aceptado' &&
      $status_history[4]->order_status_name == 'Pendiente'
     ){
      $status_list = $this->shared->statusList_12634();
    }

    // valida que sea cualquier caso excepto : Pendiente -> No Contactado -> Aceeptado
    // dado que es un caso que rompe la logica de la secuencia normal de estados
    if($flag == 0){
        return view('tracking', [
          'order' => $order,
          'products' => $products,
          'status_list' => $status_list,
          'status_id' => $status_history[0]->order_status_id,
          'weight' => $status_history[0]->weight
        ]);
    }
    // valida que SOLO sea el caso : Pendiente -> No Contactado -> Aceeptado
    elseif($flag == 1){

      $x = 0;
      while($x < count($status_list)){
        $status_list[$x]->weight =  $status_list[$x]->weight2;
        $x++;
      }

      return view('tracking', [
          'order' => $order,
          'products' => $products,
          'status_list' => $status_list,
          'status_id' => $status_history[0]->order_status_id,
          'weight' => $status_history[0]->weight2
      ]);
    }

  }

  public function testJob (Request $request) {
    $client = new \GuzzleHttp\Client();
    $res = $client->request('POST', \Config::get('filter.notification_server_url').'/api/schedule/test/12', [
      \GuzzleHttp\RequestOptions::JSON => [
        'dni' => '45677136',
        'isdn' => '996800986'
      ]
    ]);
    echo $res->getStatusCode();
    // 200
    echo $res->getHeaderLine('content-type');
    // 'application/json; charset=utf8'
    echo $res->getBody();
    // '{"id": 1420053, "name": "guzzle", ...}'
  }

  public function deleteSession() {
    DB::table('sessions')->delete();
  }

  public function renovFail() {
    return view('renov_fail');
  }

  public function changeAffil(Request $request) {
    $cart = collect($request->session()->get('cart'));

    if (count($cart) > 0) {
      foreach ($cart as $item) {
        switch ($item['type_id']) {
          case 1:
            $product = $this->shared->productPrepagoByStock($item['stock_model_id'], $item['product_variation_id']);
            $route = 'prepaid_detail';
            $params = [
              'brand' => $product->brand_slug,
              'product' => $product->product_slug,
              'plan' => $product->plan_slug
            ];
            if (!empty($product->color_slug)) $params['color'] = $product->color_slug;
            break;
          case 2:
            $product = $this->shared->productPostpagoByStock($item['stock_model_id'], $item['product_variation_id']);
            $route = 'postpaid_detail';
            $params = [
              'brand' => $product->brand_slug,
              'product' => $product->product_slug,
              'affiliation' => $product->affiliation_slug,
              'plan' => $product->plan_slug,
              'contract' => $product->contract_slug
            ];
            if (!empty($product->color_slug)) $params['color'] = $product->color_slug;
            break;
        }

        if(!isset($product)) {
          continue;
        }
      }

      $request->session()->forget('cart');

      if (isset($product)) {
        return redirect()->route($route, $params);
      } else {
        return redirect()->route('home');
      }
    } else {
      return redirect()->route('home');
    }    
  }

  public function retryCreateOrder(Request $request) {
    $request->session()->keep('order_detail');
    return redirect()->route('create_order');
  }

  public function changeAffilTo(Request $request, $affiliation_id) {
    $cart = collect($request->session()->get('cart'));

    if (count($cart) > 0) {
      foreach ($cart as $item) {
        if ($item['type_id'] == 2) {
          $product = $this->shared->productPostpagoByStock($item['stock_model_id'], $item['product_variation_id']);
          $route = 'postpaid_detail';
          $params = [
            'brand' => $product->brand_slug,
            'product' => $product->product_slug,
            'plan' => $product->plan_slug,
            'contract' => $product->contract_slug
          ];
          $params['affiliation'] = $this->shared->affiliationSlug($affiliation_id);

          if (!empty($product->color_slug)) {
            $params['color'] = $product->color_slug;
            $product = $this->shared->productPostpaidBySlug($params['brand'],$params['product'],$params['affiliation'],$params['plan'],$params['contract'],$params['color']);
          } else {
            $product = $this->shared->productPostpaidBySlug($params['brand'],$params['product'],$params['affiliation'],$params['plan'],$params['contract']);
          }
          
          if(empty($product)) {
            return redirect()->route('postpaid');
          }
        }

        if(!isset($product)) {
          continue;
        }
      }

      $request->session()->forget('cart');

      if (isset($product)) {
        return redirect()->route($route, $params);
      } else {
        return redirect()->route('home');
      }
    } else {
      return redirect()->route('home');
    }
  }
}
