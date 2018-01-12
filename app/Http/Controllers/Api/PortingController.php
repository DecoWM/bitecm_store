<?php

namespace App\Http\Controllers\Api;

use DB;
use Validator;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Artisaninweb\SoapWrapper\SoapWrapper;
use Illuminate\Support\Facades\Log;

class PortingController extends Controller
{
  protected $soapWrapper;

  public function __construct (SoapWrapper $soapWrapper) {
    $this->soapWrapper = $soapWrapper;
  }

  public function handle(Request $request, $order_id) {
    $dni = $request->input('dni', null);
    $isdn = $request->input('isdn', null);

    if(!isset($dni) || !isset($isdn)) {
      return response()->json(false);
    }

    $this->initSoapWrapper();

    $order_detail = [
      'id_number' => $dni,
      'porting_phone' => $isdn
    ];

    if ($this->checkSuccessPortingRequest($order_detail)) {
      DB::table('tbl_order')
        ->where('order_id', $order_id)
        ->update($order_detail);
      return response()->json(true);
    }

    return response()->json(false);
  }

  private function initSoapWrapper(){
    $this->soapWrapper->add('bitelSoap', function ($service) {
      $service
        ->wsdl('http://10.121.4.36:8236/BCCSWS?wsdl')
        ->trace(true);
    });
  }

  private function checkSuccessPortingRequest(&$order_detail)
  {
    $response = $this->soapWrapper->call('bitelSoap.getListPortingRequest', [
      'staffCode' => 'CM_THUYNTT', // ***** Change it for dynamic Value !!!
      'dni' => strval($order_detail['id_number']),
      'isdn' => strval($order_detail['porting_phone']),
    ]);

    if ($response->return->errorCodeMNP == '0') {
      $order_detail['mnp_request_id'] = $response->return->listPortingRequest->requestId;
      $order_detail['porting_state_code'] = $response->return->listPortingRequest->stateCode;
      $order_detail['porting_status'] = $response->return->listPortingRequest->status;
      $order_detail['porting_status_desc'] = $response->return->listPortingRequest->statusDescription;
      return true;
    }

    Log::warning('Respuesta bitelSoap.getListPortingRequest: ', (array) $response->return);
    return false;
    // return ($response->return->errorCode == '02');
  }
}
