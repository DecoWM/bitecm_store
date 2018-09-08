<?php

use Illuminate\Http\Request;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:api')->get('/user', function (Request $request) {
    return $request->user();
});

//RUTAS BUSQUEDA
Route::get('/prepago/buscar', 'Api\SearchController@searchPrepaid');
Route::get('/postpago/buscar', 'Api\SearchController@searchPostpaid');
Route::get('/accesorios/buscar', 'Api\SearchController@searchAccesorios');
Route::get('/promociones/buscar', 'Api\SearchController@searchPromos');

Route::get('/postpago/{brand}/{product}/{affiliation}/{plan}/{contract?}/{color?}', 'Api\PostpaidController@show')
    ->where(
      [
        'brand' => '^([a-zA-Z0-9_-]+)$',
        'product' => '^([a-zA-Z0-9_-]+)$',
        'affiliation' => '^([a-zA-Z0-9_-]+)$',
        'plan' => '^([a-zA-Z0-9_-]+)$',
        'contract' => '^([a-zA-Z0-9_-]+)$',
        'color' => '^([a-zA-Z0-9_-]+)$',
      ])
    ->name('api_postpaid_detail');

Route::get('/prepago/{brand}/{product}/{plan}/{color?}', 'Api\PrepaidController@show')
    ->where(
      [
        'brand' => '^([a-zA-Z0-9_-]+)$',
        'product' => '^([a-zA-Z0-9_-]+)$',
        'plan' => '^([a-zA-Z0-9_-]+)$',
        'color' => '^([a-zA-Z0-9_-]+)$',
      ])
    ->name('api_prepaid_detail');

Route::get('/accesorios/{brand}/{product}/{color?}', 'Api\ProductController@show')
    ->where(
      [
        'brand' => '^([a-zA-Z0-9_-]+)$',
        'product' => '^([a-zA-Z0-9_-]+)$',
        'color' => '^([a-zA-Z0-9_-]+)$',
      ])
    ->name('api_accessory_detail');

Route::post('check_porting_status/{order_id}', 'Api\PortingController@handle');

Route::post('test/{param}', 'Api\PortingController@test');

Route::post('check_credit_status', 'Api\CartController@checkCreditStatus');
