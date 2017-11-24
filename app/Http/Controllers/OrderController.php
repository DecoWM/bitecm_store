<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use Artisaninweb\SoapWrapper\SoapWrapper;
use App\Soap\Request\GetConversionAmount;
use App\Soap\Response\GetConversionAmountResponse;

class OrderController extends Controller
{
      /**
     * @var SoapWrapper
     */
    protected $soapWrapper;

    /**
     * SoapController constructor.
     *
     * @param SoapWrapper $soapWrapper
     */
    public function __construct (SoapWrapper $soapWrapper) {
      $this->soapWrapper = $soapWrapper;
    }

    /**
     * Use the SoapWrapper
     */
    public function show () {
        $this->soapWrapper->add('Currency', function ($service) {
            $service
              ->wsdl('http://currencyconverter.kowabunga.net/converter.asmx?WSDL')
              ->trace(true)
              ->classmap([
                GetConversionAmount::class,
                GetConversionAmountResponse::class,
              ]);
        });

        // Without classmap
        $response = $this->soapWrapper->call('Currency.GetConversionAmount', [
          'CurrencyFrom' => 'USD',
          'CurrencyTo'   => 'EUR',
          'RateDate'     => '2014-06-05',
          'Amount'       => '1000',
        ]);

        var_dump($response);

        // With classmap
        $response = $this->soapWrapper->call('Currency.GetConversionAmount', [
          new GetConversionAmount('USD', 'EUR', '2014-06-05', '1000')
        ]);

        var_dump($response);
        exit;
    }
}
