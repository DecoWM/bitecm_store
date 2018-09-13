<?php

namespace App\Http\Controllers\Api;

use DB;
use Validator;
use App\Http\Controllers\BaseController;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Artisaninweb\SoapWrapper\SoapWrapper; // For use client SOAP service

class CartController extends Controller
{
  protected $soapWrapper;

  public function __construct (SoapWrapper $soapWrapper) {
    $this->soapWrapper = $soapWrapper;
  }

  public function checkCreditStatus(Request $request) {
    $dni = $request->input('dni', null);
    $stock_model_code = $request->input('stock_model_code', null);
    $product_code = $request->input('product_code', null);

    if(!isset($dni) || !isset($stock_model_code) || !isset($product_code)) {
      return response()->json([
        'success' => false,
        'error' => 'Se requiere dni, stock model code y product code'
      ]);
    }

    /*$cart = collect($request->session()->get('cart')); //Carrito de compras
    if (!count($cart)) {
      return response()->json([
        'success' => false,
        'error' => 'El carrito esta vacio'
      ]);
    }*/

    if (\Config::get('filter.use_bcss')) {
      $this->initSoapWrapper();

      $data = [
        'dni' => $dni,
        'stock_model_code' => $stock_model_code,
        'product_code' => $product_code
      ];

      if ($r = $this->checkCreditStatusSentinel($data)) {
        if ($r->status === 'Aprobada') {
          DB::table('tbl_sentinel_check')->delete();
          DB::table('tbl_sentinel_check')->insert(['status' => 1]);
          /*foreach ($cart as $i => $item) {
            if (isset($item['product_variation_id']) && $item['product_variation_id'] == $product_variation_id) {
              $item['credit_status_checked'] = 1;
              $request->session()->put('cart.'.$i, $item);
            }
          }*/
          return response()->json([
            'success' => true,
            'aprobado' => true,
            'msg' => 'Su credito fue aprobado'
          ]);
        } else {
          return response()->json([
            'success' => true,
            'aprobado' => false,
            'msg' => 'Su credito no fue aprobado'
          ]);
        }
      }
    } else {
      DB::table('tbl_sentinel_check')->delete();
      DB::table('tbl_sentinel_check')->insert(['status' => 1]);
      return response()->json([
        'success' => true,
        'aprobado' => true,
        'msg' => 'Su credito fue aprobado'
      ]);
    }

    return response()->json([
      'success' => false,
      'msg' => 'Ocurrio un error con la evaluación crediticia'
    ]);
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

  private function checkCreditStatusSentinel(&$data)
  {
    try {
      $response = $this->soapWrapper->call('bitelSoap.getListPortingRequest', [
        'getListPortingRequest' => [
          'dni' => strval($data['dni']),
          'stock_model_code' => strval($data['stock_model_code']),
          'product_code' => strval($data['product_code'])
        ]
      ]);

      $portingRequest = null;

      if ($response->return->errorCodeMNP == '0' && !empty($response->return->listPortingRequest)) {
        if (is_array($response->return->listPortingRequest)) {
          foreach($response->return->listPortingRequest as $pRequest) {
            if($pRequest->portingRequestId == $order_detail['porting_request_id']) {
              $portingRequest = $pRequest;
              $order_detail['mnp_request_id'] = $portingRequest->requestId;
              $order_detail['porting_state_code'] = $portingRequest->stateCode;
              $order_detail['porting_status'] = $portingRequest->statusDescription;
              if(property_exists($portingRequest, 'errorMessage'))
                $order_detail['porting_status_desc'] = $portingRequest->errorMessage;
            }
          }
        } else {
          $portingRequest = $response->return->listPortingRequest;
          $order_detail['mnp_request_id'] = $portingRequest->requestId;
          $order_detail['porting_state_code'] = $portingRequest->stateCode;
          $order_detail['porting_status'] = $portingRequest->statusDescription;
          if(property_exists($portingRequest, 'errorMessage'))
            $order_detail['porting_status_desc'] = $portingRequest->errorMessage;
        }

        if (!isset($portingRequest)) {
          Log::warning('No existe esta solicitud de portabilidad');
          return 3;
        }

        Log::info('Respuesta bitelSoap.getListPortingRequest: ', (array) $response->return);

        if ($portingRequest->statusDescription == '01_NEW') {
          Log::warning('Solicitud de portabilidad nueva aun no procesada. Debe regresar a la cola.');
          return 2;
        } else if ($portingRequest->statusDescription == '01_PROCESSING') {
          Log::warning('Solicitud de portabilidad aun procesandose. Debe regresar a la cola.');
          return 2;
        } else {
          Log::info('Solicitud de portabilidad procesada. Trabajo finalizado. No debe regresar a la cola.');
          return 1;
        }
      }

      Log::warning('Respuesta bitelSoap.getListPortingRequest: ', (array) $response->return);
      return false;
      // return ($response->return->errorCode == '02');
    } catch (\Exception $e) {
      Log::error($e->getMessage());
      return false;
    }
  }
}
