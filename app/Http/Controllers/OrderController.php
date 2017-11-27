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
  protected function checkIsOverQouta($request) 
  {
    $response = $this->soapWrapper->call('bitelSoap.checkOverQoutaIdNo', [
      'paymethodType' => $request->payment_method,
      'busType' => 'INDI',
      'idNo' => $request->document_number,
      'productCode' => 'IchipVoz29_9',   // AQUI INDICAR EL CODIGO DEL PLAN QUE SE HA SELECCIONADO !!!
    ]);

    return ($response->return->isOverQouta != 0);
  }

  /**
  * Verify if customer exists in bitel database
  * @var result: if exists -> return object result
  *              else -> return false: Not have debt
  */
  protected function getInfoCustomer($request) 
  // public function show() 
  {
    $response = $this->soapWrapper->call('bitelSoap.getCustomer', [
      'idType' => '03', // persona natural !!!
      'idNo' => $request->document_number
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
  protected function createConsultantRequest($request) 
  // public function show() 
  {
    $response = $this->soapWrapper->call('bitelSoap.createConsultantRequest', [
      'staffCode' => 'CM_THUYNTT', // ***** Change it for dynamic Value !!!
      'shopCode' => 'VTP', // ***** Change it for dynamic Value !!!
      'dni' => $request->document_number,
      'isdn' => $request->phone_number,
      'sourceOperator' => isset($request->operator) ? $request->operator : '',
      'sourcePayment' => $request->payment_method,
      'email' => $request->contact_email,
      'phone' => $request->contact_phone,
      'custName' => $request->first_name . ' ' . $request->last_name,
      'contactName' => $request->first_name . ' ' . $request->last_name,
      'reasonId' => '123' // ***** Change it for dynamic Value !!!
    ]);

    if($response->return->errorCodeMNP == '0'){
      // set the portingRequestId from response
      $this->portingRequestId = $response->return->portingRequestId;
      return true;
    }

    return false;
  }

  /**
  * get request response if is  created previously ONLY FOR PORTABILITY
  * @var stateCode: 02 -> return true: Exito
  *                 else -> return false: Rechazado
  */
  protected function checkSuccessPortingRequest($request) 
  // public function show() 
  {
    $response = $this->soapWrapper->call('bitelSoap.getListPortingRequest', [
      'staffCode' => 'CM_THUYNTT', // ***** Change it for dynamic Value !!!
      'dni' => $request->document_number,
      'isdn' => $request->phone_number,
    ]);

    return ($response->return->errorCode == '02');
  }

  public function createOrder (Request $request) {
    $distritos = ['LIMA', 'ANCÓN', 'ATE', 'BARRANCO', 'BRENA', 'CARABAYLLO', 
      'CHACLACAYO', 'CHORRILLOS', 'CIENEGUILLA', 'COMAS', 'EL AGUSTINO', 
      'INDEPENDENCIA', 'JESÚS MARÍA', 'LA MOLINA', 'LA VICTORIA', 'LINCE', 
      'LOS OLIVOS', 'LURIGANCHO', 'LURIN', 'MAGDALENA DEL MAR', 'MAGDALENA VIEJA', 
      'MIRAFLORES', 'PACHACAMAC', 'PUCUSANA', 'PUENTE PIEDRA', 'PUNTA HERMOSA',
      'PUNTA NEGRA', 'RÍMAC', 'SAN BARTOLO', 'SAN BORJA', 'SAN ISIDRO',
      'SAN JUAN DE LURIGANCHO', 'SAN JUAN DE MIRAFLORES', 'SAN LUIS',
      'SAN MARTÍN DE PORRES', 'SAN MIGUEL', 'SANTA ANITA', 'SANTA MARÍA DEL MAR',
      'SANTA ROSA', 'SANTIAGO DE SURCO', 'SURQUILLO', 'VILLA EL SALVADOR',
      'SURQUILLO', 'VILLA EL SALVADOR', 'VILLA MARÍA DEL TRIUNFO',  'CALLAO', 
      'BELLAVISTA', 'CARMEN DE LA LEGUA REYNOSO', 'LA PERLA', 'LA PUNTA', 'VENTANILLA'
    ];

    //ASIGNACIÓN DE VALORES A VARIABLES
    $cart = collect($request->session()->get('cart')); //Carrito de compras

    if (count($cart) > 0) {
      return view('order_form', ['distritos' => $distritos]);
    } else {
      return redirect()->route('home');
    }
  }

  public function storeOrder (Request $request) {
    //VARIABLES
    $products = []; //Lista de productos

    $order_id = "";
    $order_detail = [];
    $order_items = [];
    $total = 0;

    //ASIGNACIÓN DE VALORES A VARIABLES
    $cart = collect($request->session()->get('cart'));

    $order_detail = [
      'idtype_id' => $request->document_type,
      'payment_method_id' => $request->payment_method,
      'branch_id' => null,
      'first_name' => $request->first_name,
      'last_name' => $request->last_name,
      'id_number' => $request->document_number,
      'tracking_code' => $id_number,
      'billing_district' => $request->district,
      'billing_phone' => $request->phone_number,
      'delivery_address' => $request->delivery_address,
      'delivery_district' => $request->delivery_distric,
      'contact_email' => $request->email,
      'contact_phone' => $request->contact_phone,
      'credit_status' => 1,
    ];

    if ($request->has('operator')) {
      $order_detail'source_operator'] = $source_operator;
    }

    if (count($cart) == 0) {
      return redirect()->route('show_cart');
    }

    // Apply validations with Bitel webservice before insert
    $this->initSoapWrapper(); // Init the bitel soap webservice

    // Check if have many lines
    if($this->checkIsOverQouta($order_detail)){
      return 'No puede tener más números telefónicos';
    }

    // check if is client
    if($data_customer = $this->getInfoCustomer($order_detail)){
      // check if have debt
      if($this->checkHaveDebit($data_customer->custId)){
        return 'Actualmente tiene deudas pendientes';
      }
    }

    // IF IS PORTABILITY APPLY THE NEXT PROCCESS AND VALIDATIONS
    if($request->affiliation; == 1){
      // process request portability
      if($this->createConsultantRequest($order_detail)){
        // check if is possible migrate to bitel
        if(!$this->checkSuccessPortingRequest($order_detail)){  // ***** REVISAR LAS POSIBLES RESPUESTAS DESPUES DE LA RESPUESTA DE BITEL AL CORREO SOBRE LOS SERVICIOS !!!
          return 'No es posible realizar la portabilidad con su número';
        }
      }
      else{
        return 'Error creando la solicitud de portabilidad';
      }
    }

    $igv = \Config::get('filter.igv');

    foreach ($cart as $item) {
      switch ($item['type_id']) {
        case 0:
          $product = $this->shared->productByStock($item['stock_model_id']);
          array_push($products, ['product' => $product, 'quantity' => $item['quantity']]);
          break;
        case 1:
          $product = $this->shared->productPrepagoByStock($item['stock_model_id'],$item['product_variation_id']);
          array_push($products, ['product' => $product, 'quantity' => $item['quantity']]);
          break;
        case 2:
          $product = $this->shared->productPrepagoByStock($item['stock_model_id'],$item['product_variation_id']);
          array_push($products, ['product' => $product, 'quantity' => $item['quantity']]);
          break;
      }
      $subtotal = $product->product_variation_price * $item['quantity'];
      $total += $subtotal;
      array_push($order_items, [
        'stock_model_id' => $item['stock_model_id'],
        'product_variation_id' => $item['product_variation_id'] ? $item['product_variation_id'] : null,
        'promo_id' => null,//$product->promo_id,
        'quantity' => $item['quantity'],
        'subtotal' => $subtotal,
        'subtotal_igv' => $subtotal*(1+$igv)
      ]);
    }

    $order_detail['total'] = $total;
    $order_detail['total_igv'] = $total*(1+$igv);
    $order_id = DB::table('tbl_order')->insertGetId($order_detail);

    foreach($order_items as $i => $item) {
      $order_items[$i]['order_id'] = $order_id;
    }

    DB::table('tbl_order_item')->insert($order_items);

    Mail::to($request->email)->send(new OrderCompleted(['order_id' => $order_id, 'order_detail' => $order_detail, 'order_items' => $order_items]));

    $request->session()->flush();

    return view('order_detail', ['products' => $products, 'order_id' => $order_id]);
  }

  public function trackOrder (Request $request, $order_id) {
    $order = DB::table('tbl_order')->where('order_id', $order_id)->first();

    $products = DB::select('call PA_orderItems(
      :order_id
    )', [
      'order_id' => $order_id
    ]);

    return view('tracking', ['order' => $order, 'products' => $products]);
  }
}
