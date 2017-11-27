<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', 'HomeController@index')->name('home');

//RUTA PRODUCTO
Route::get('/producto/{brand}/{product}/{color?}', 'ProductController@show')->name('product_detail');

//RUTAS PREPAGO
Route::get('/prepago', 'PrepaidController@index')->name('prepaid');
Route::get('/prepago/{brand}/{product}/{plan}/{color?}', 'PrepaidController@show')->name('prepaid_detail');

//RUTAS POSTPAGO
Route::get('/postpago', 'PostpaidController@index')->name('postpaid');
Route::get('/postpago/{brand}/{product}/{affiliation}/{plan}/{contract}/{color?}', 'PostpaidController@show')->name('postpaid_detail');

//RUTAS ACCESORIOS
Route::get('/accesorios', 'AccessoriesController@index')->name('accessories');
Route::get('/accesorios/{brand}/{product}/{color?}', 'AccessoriesController@show')->name('accessory_detail');

//RUTAS ACCESORIOS
Route::get('/promociones', 'PromoController@index')->name('promociones');

//RUTAS COMPARAR
Route::get('/prepago/comparar', 'PrepaidController@compare');
Route::get('/postpago/comparar', 'PostpaidController@compare');
Route::get('/producto/comparar', 'PostpaidController@compare');

//RUTAS CARRITO
Route::get('/carrito', 'CartController@showCart')->name('show_cart');
Route::post('/carrito', 'CartController@addToCart')->name('add_to_cart');
Route::post('/carrito/borrar', 'CartController@removeFromCart')->name('remove_from_cart');
// Route::delete('/carrito/{product}', 'CartController@removeFromCart')->name('remove_from_cart');

//RUTAS ORDEN
Route::get('/envio', 'OrderController@createOrder')->name('create_order');
Route::get('/envio/currency', 'OrderController@show')->name('currency');
Route::post('/envio', 'OrderController@storeOrder')->name('store_order');
Route::get('/pedido', 'OrderController@showOrder')->name('show_order');
Route::get('/rastreo/{order_id}', 'OrderController@trackOrder')->name('track_order');

//RUTAS ARCHIVOS
Route::get('/files/{filename}', 'FileController@downloadFile')->where(['filename'=>'[A-Za-z0-9/-]+'])->name('download_file');

//TEST
// Route::get('/carrito', 'CartController@index')->name('carrito');
// Route::get('/envio', 'CartController@index2')->name('envio');
Route::get('/finalizado', 'CartController@index3')->name('finalizado');
Route::get('/rastreo', 'TrackingController@index')->name('rastreo');
