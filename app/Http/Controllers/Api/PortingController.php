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
    $porting_request_id = $request->input('porting_request_id', null);

    if(!isset($dni) || !isset($isdn) || !isset($porting_request_id)) {
      return response()->json(false);
    }

    $this->initSoapWrapper();

    $order_detail = [
      'id_number' => $dni,
      'porting_phone' => $isdn,
      'porting_request_id' => $porting_request_id
    ];

    if ($r = $this->checkSuccessPortingRequest($order_detail)) {
      DB::table('tbl_order')
        ->where('order_id', $order_id)
        ->update($order_detail);
      return response()->json($r);
    }

    return response()->json(false);
  }

  public function test(Request $request, $order_id) {
    $dni = $request->input('dni', null);
    $isdn = $request->input('isdn', null);

    if(!isset($dni) || !isset($isdn)) {
      return response()->json(false);
    }

    /*return response()->json([
      'order_id' => $order_id,
      'dni' => $dni,
      'isdn' => $isdn
    ]);*/

    return response()->json(true);
  }

  private function initSoapWrapper(){
    try {
      $this->soapWrapper->add('bitelSoap', function ($service) {
        $service
          ->wsdl('http://10.121.4.36:8236/BCCSWS?wsdl')
          ->trace(true);
      });
    } catch (\Exception $e) {
      Log::error($e->getMessage());
    }
  }

  private function checkSuccessPortingRequest(&$order_detail)
  {
    try {
      $response = $this->soapWrapper->call('bitelSoap.getListPortingRequest', [ 
        'getListPortingRequest' => [
          'staffCode' => 'CM_THUYNTT',
          'dni' => strval($order_detail['id_number']),
          'isdn' => strval($order_detail['porting_phone'])
        ]
      ]);

      if ($response->return->errorCodeMNP == '0' && !empty($response->return->listPortingRequest)) {
        if (is_array($response->return->listPortingRequest)) {
          foreach($response->return->listPortingRequest as $pRequest) {
            if($pRequest->portingRequestId == $order_detail['porting_request_id']) {
              $portingRequest = $pRequest;
              $order_detail['mnp_request_id'] = $portingRequest->requestId;
              $order_detail['porting_state_code'] = $portingRequest->stateCode;
              $order_detail['porting_status'] = $portingRequest->status;
              $order_detail['porting_status_desc'] = $portingRequest->statusDescription;
            }
          }
        } else {
          $portingRequest = $response->return->listPortingRequest;
          $order_detail['mnp_request_id'] = $portingRequest->requestId;
          $order_detail['porting_state_code'] = $portingRequest->stateCode;
          $order_detail['porting_status'] = $portingRequest->status;
          $order_detail['porting_status_desc'] = $portingRequest->statusDescription;
        }
        if ($portingRequest->statusDescription == '01_NEW') {
          Log::warning('Solicitud de portabilidad nueva aun no procesada. Debe regresar a la cola.');
          return 1;
        } else if ($portingRequest->statusDescription == '01_PROCESSING') {
          Log::warning('Solicitud de portabilidad procesandose. Debe regresar a la cola.');
          return 1;
        } else {
          Log::warning('Solicitud de portabilidad procesada. Trabajo finalizado. No debe regresar a la cola.');
          return 2;
        }
        Log::info('Respuesta bitelSoap.getListPortingRequest: ', (array) $response->return);
      }

      Log::warning('Respuesta bitelSoap.getListPortingRequest: ', (array) $response->return);
      return 0;
      // return ($response->return->errorCode == '02');
    } catch (\Exception $e) {
      Log::error($e->getMessage());
      return 0;
    }
  }
}
