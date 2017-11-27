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
