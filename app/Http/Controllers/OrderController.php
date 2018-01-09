<?php

namespace App\Http\Controllers;

use DB;
use App\Mail\OrderCompleted;
use Illuminate\Support\Facades\Mail;
use App\Http\Controllers\BaseController;
use Illuminate\Http\Request;
use Artisaninweb\SoapWrapper\SoapWrapper; // For use client SOAP service

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
    $this->soapWrapper->add('bitelSoap', function ($service) {
      $service
        ->wsdl('http://10.121.4.36:8236/BCCSWS?wsdl')   // La ip se debe mover a una variable de configuración !!!
        ->trace(true);
    });
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
    $response = $this->soapWrapper->call('bitelSoap.checkOverQoutaIdNo', [
      'paymethodType' => $order_detail['type_id'],
      'busType' => 'INDI',
      'idNo' => $order_detail['id_number'],
      'productCode' => $order_detail['product_code']
    ]);
    return ($response->return->isOverQouta != 0);
  }

  /**
  * Verify if customer exists in bitel database
  * @var result: if exists -> return object result
  *              else -> return false: Not have debt
  */
  protected function getInfoCustomer($order_detail)
  // public function show()
  {
    $response = $this->soapWrapper->call('bitelSoap.getCustomer', [
      'idType' => '01', // persona natural !!!
      'idNo' => $order_detail['id_number']
    ]);
    if(isset($response->return->result))
      return $response->return->result;
    else
      return false;
  }

  /**
  * Verify if customer have pending debt
  * @var errorCode: -1 -> return true
  *                 else -> return false: Not have debt
  */
  protected function checkHaveDebit($custId)
  // public function show()
  {
    $response = $this->soapWrapper->call('bitelSoap.getInfoDebitByCustId', [
      'custId' => $custId
    ]);
    return ($response->return->errorCode == -1);
  }

  /**
  * make a consultant request ONLY FOR PORTABILITY
  * @var errorCodeMNP: 0 -> return true: Consultant created
  *                 else -> return false: consultant not created
  * @var portingRequestId: id for request created
  */
  protected function createConsultantRequest(&$order_detail)
  // public function show()
  {
    $req = [
      'staffCode' => 'CM_THUYNTT',
      'shopCode' => 'VTP',
      'dni' => $order_detail['id_number'],
      'isdn' => $order_detail['porting_phone'],
      'sourceOperator' => isset($order_detail['source_operator']) ? $order_detail['source_operator'] : '',
      'sourcePayment' => $order_detail['type_id'],
      'email' => $order_detail['contact_email'],
      'phone' => $order_detail['contact_phone'],
      'custName' => $order_detail['first_name'] . ' ' . $order_detail['last_name'],
      'contactName' => $order_detail['first_name'] . ' ' . $order_detail['last_name'],
      'reasonId' => $order_detail['reason_code']
    ];

    $response = $this->soapWrapper->call('bitelSoap.createConsultantRequest', $req);

    if($response->return->errorCodeMNP == '0'){
      // set the portingRequestId from response
      $this->portingRequestId = $response->return->portingRequestId;
      $order_detail['porting_request_id'] = $response->return->portingRequestId;
      return true;
    }

    return false;
  }

  /**
  * get request response if is  created previously ONLY FOR PORTABILITY
  * @var stateCode: 02 -> return true: Exito
  *                 else -> return false: Rechazado
  */
  protected function checkSuccessPortingRequest(&$order_detail)
  // public function show()
  {
    $response = $this->soapWrapper->call('bitelSoap.getListPortingRequest', [
      'staffCode' => 'CM_THUYNTT', // ***** Change it for dynamic Value !!!
      'dni' => $order_detail['id_number'],
      'isdn' => $order_detail['porting_phone'],
    ]);

    if ($response->return->errorCodeMNP == '0') {
      $order_detail['mnp_request_id'] = $response->return->listPortingRequest->requestId;
      $order_detail['porting_state_code'] = $response->return->listPortingRequest->stateCode;
      $order_detail['porting_status'] = $response->return->listPortingRequest->status;
      $order_detail['porting_status_desc'] = $response->return->listPortingRequest->statusDescription;
      return true;
    }

    return false;
    // return ($response->return->errorCode == '02');
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
    $total = 0;
    $total_igv = 0;
    $equipo = null;

    $order_detail = [];

    foreach ($cart as $item) {
      switch ($item['type_id']) {
        case 0:
          $product = $this->shared->productByStock($item['stock_model_id']);
          $order_detail['service_type'] = 'Accesorios';
          $order_detail['affiliation_type'] = null;
          break;
        case 1:
          $product = $this->shared->productPrepagoByStock($item['stock_model_id'],$item['product_variation_id']);
          $equipo = $product;
          $order_detail['service_type'] = 'Prepago';
          $affiliation = DB::table('tbl_affiliation')
            ->where('affiliation_id', $request->affiliation)
            ->get();
          if (count($affiliation)) {
            $order_detail['affiliation_type'] = $affiliation[0]->affiliation_name;
          } else {
            $order_detail['affiliation_type'] = null;
          }
          break;
        case 2:
          $product = $this->shared->productPostpagoByStock($item['stock_model_id'],$item['product_variation_id']);
          $equipo = $product;
          $order_detail['service_type'] = 'Postpago';
          $order_detail['affiliation_type'] = $equipo->affiliation_name;
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
      $subtotal_igv = $subtotal * (1+$igv);
      $total += $subtotal;
      $total_igv += $subtotal_igv;
      array_push($order_items, [
        'stock_model_id' => $item['stock_model_id'],
        'product_variation_id' => $item['product_variation_id'],
        'promo_id' => $product->promo_id,
        'quantity' => $item['quantity'],
        'subtotal' => $subtotal,
        'subtotal_igv' => round($subtotal_igv, 2)
      ]);
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

    if(isset($equipo) && isset($request->affiliation) && $request->affiliation == 1) {
      $source_operators = $this->shared->operatorList();
      $order_detail['source_operator'] = $source_operators[$request->operator];
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
      if(isset($order_detail['product_code']) && $this->checkIsOverQouta($order_detail)){
        return redirect()->route('create_order')->with('ws_result', json_encode([
            'title' => 'te comunica que',
            'message' => 'No puede tener más números telefónicos.'
          ]));
      }

      // check if is client
      if($data_customer = $this->getInfoCustomer($order_detail)){
        // check if have debt
        if($this->checkHaveDebit($data_customer->custId)){
          return redirect()->route('create_order')->with('ws_result', json_encode([
            'title' => 'te recuerda que',
            'message' => 'Tienes una deuda pendiente con BITEL, acércate a cancelar a la agencia más cercana.'
          ]));
        }
      }

      // IF IS PORTABILITY APPLY THE NEXT PROCCESS AND VALIDATIONS
      if(isset($order_detail['reason_code']) && isset($request->affiliation) && $request->affiliation == 1){
        // process request portability
        if($this->createConsultantRequest($order_detail)){
          // check if is possible migrate to bitel
          if(!$this->checkSuccessPortingRequest($order_detail)){  // ***** REVISAR LAS POSIBLES RESPUESTAS DESPUES DE LA RESPUESTA DE BITEL AL CORREO SOBRE LOS SERVICIOS !!!
            return redirect()->route('create_order')->with('ws_result', json_encode([
              'title' => 'te comunica que',
              'message' => 'No es posible realizar la portabilidad con su número.'
            ]));
          }
        }
        else {
          return redirect()->route('create_order')->with('ws_result', json_encode([
            'title' => 'te comunica que',
            'message' => 'Ocurrió un error creando la solicitud de portabilidad.'
          ]));
        }
      }
    }

    $order_detail['total'] = $total;
    $order_detail['total_igv'] = $total_igv;
    $order_id = DB::table('tbl_order')->insertGetId([
      'idtype_id' => $order_detail['idtype_id'],
      'payment_method_id' => $order_detail['payment_method_id'],
      'branch_id' => $order_detail['branch_id'],
      'tracking_code' => $order_detail['tracking_code'],
      'first_name' => $order_detail['first_name'],
      'last_name' => $order_detail['last_name'],
      'id_number' => $order_detail['id_number'],
      'billing_district' => $order_detail['billing_district'],
      'billing_phone' => $order_detail['billing_phone'],
      'source_operator' => $order_detail['source_operator'],
      'porting_phone' => $order_detail['porting_phone'],
      'delivery_address' => $order_detail['delivery_address'],
      'delivery_district' => $order_detail['delivery_district'],
      'contact_email' => $order_detail['contact_email'],
      'contact_phone' => $order_detail['contact_phone'],
      'service_type' => $order_detail['service_type'],
      'affiliation_type' => $order_detail['affiliation_type'],
      'total' => $order_detail['total'],
      'total_igv' => round($order_detail['total_igv'], 2)
    ]);

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

    Mail::to($request->email)->send(new OrderCompleted([
      'order_id' => $order_id,
      'order_detail' => $order_detail,
      'order_items' => $order_items,
      'products' => $products
    ]));

    DB::commit();
    
    $request->session()->flush();

    return view('order_detail', ['products' => $products, 'order_id' => $order_id]);
  }

  public function trackOrder (Request $request, $order_id) {
    $order = DB::table('tbl_order')->where('order_id', $order_id)->first();
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
}
