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

class OrderController extends Controller
{
  protected $shared;

  /**
  * @var SoapWrapper
  * @var portingRequestId : ID when Consultant Request is created
  */
  protected $soapWrapper;
  protected $portingRequestId;

  /**
  * SoapController constructor.
  *
  * @param SoapWrapper $soapWrapper
  */

  public function __construct (BaseController $shared, SoapWrapper $soapWrapper) {
    $this->shared = $shared;
    $this->soapWrapper = $soapWrapper;
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
  protected function checkIsOverQouta($order_detail)
  {
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
      return false;
    }
  }

  /**
  * Verify if customer exists in bitel database
  * @var result: if exists -> return object result
  *              else -> return false: Not have debt
  */
  protected function getInfoCustomer($order_detail)
  {
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
      return null;
    }
  }

  /**
  * Verify if customer have pending debt
  * @var errorCode: -1 -> return true
  *                 else -> return false: Not have debt
  */
  protected function checkHaveDebit($custId)
  {
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
      return true;
    }
  }

  /**
  * make a consultant request ONLY FOR PORTABILITY
  * @var errorCodeMNP: 0 -> return true: Consultant created
  *                 else -> return false: consultant not created
  * @var portingRequestId: id for request created
  */
  protected function createConsultantRequest(&$order_detail)
  {
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
      return true;
    }
  }

  /**
  * get request response if is  created previously ONLY FOR PORTABILITY
  * @var stateCode: 02 -> return true: Exito
  *                 else -> return false: Rechazado
  */
  protected function checkSuccessPortingRequest(&$order_detail)
  {
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
      Log::error('El método checkSuccessPortingRequest no se encuentra disponible o recibió parametros erroneos');
      return true;
    }
  }

  protected function schedulePortingRequestJob($order_detail) {
    
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
      Log::warning('Error al enviar la solicitud de notificación');
    }
  }

  public function createOrder (Request $request) {
    $cart = collect($request->session()->get('cart')); //Carrito de compras

    if (!count($cart)) {
      return redirect()->route('home');
    }

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

    $distritos = $this->shared->districtsList();

    $source_operators = $this->shared->operatorList();

    $affiliation_list = DB::select('call PA_affiliationList()');

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

    return view('order_form', [
      'item' => $equipo,
      'distritos' => $distritos,
      'source_operators' => $source_operators,
      'affiliation_list' => $affiliation_list
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

      // CLES 09-04-2018
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
    $order_detail['branch_id'] = $this->shared->branchByDistrict($request->delivery_district);
    $order_detail['first_name'] = $request->first_name;
    $order_detail['last_name'] = $request->last_name;
    $order_detail['id_number'] = $request->document_number;
    $order_detail['tracking_code'] = $request->document_number;
    $order_detail['billing_district'] = $request->district;
    $order_detail['billing_phone'] = $request->phone_number;
    $order_detail['delivery_address'] = $request->delivery_address;
    $order_detail['delivery_district'] = $request->delivery_district;
    $order_detail['contact_email'] = $request->email;
    $order_detail['contact_phone'] = $request->contact_phone;
    $order_detail['porting_request_id'] = null;

    if(isset($equipo) && isset($request->affiliation) && $request->affiliation == 1) {
      $source_operators = $this->shared->operatorList();
      $order_detail['source_operator'] = $source_operators[$request->operator];
      $order_detail['source_operator_id'] = $request->operator;
      $order_detail['porting_phone'] = $request->porting_phone;
    } else {
      $order_detail['source_operator'] = null;
      $order_detail['porting_phone'] = null;
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
        $order_detail['porting_request_id'],
        number_format($order_detail['total'], 2, '.', ''),
        number_format($order_detail['total_igv'], 2, '.', '')
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
      ProcessPorta::dispatch($order_detail);
      // $this->schedulePortingRequestJob($order_detail);
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
    $status_list = $this->shared->statusList();
    return view('tracking', [
      'order' => $order,
      'products' => $products,
      'status_list' => $status_list,
      'status_id' => $status_history[0]->order_status_id
    ]);
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

  public function borrar_session() {
    DB::table('sessions')->delete();
  }
}
