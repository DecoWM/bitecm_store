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
Route::get('/producto/{brand}/{product}/{color?}', 'ProductController@show')
    ->where(
      [
        'brand' => '^([a-zA-Z0-9_-]+)$',
        'product' => '^([a-zA-Z0-9_-]+)$',
        'color' => '^([a-zA-Z0-9_-]+)$',
      ])
    ->name('product_detail');

//RUTAS PREPAGO
Route::get('/prepago', 'PrepaidController@index')->name('prepaid');
Route::get('/prepago/{brand}/{product}/{plan}/{color?}', 'PrepaidController@show')
    ->where(
      [
        'brand' => '^([a-zA-Z0-9_-]+)$',
        'product' => '^([a-zA-Z0-9_-]+)$',
        'plan' => '^([a-zA-Z0-9_-]+)$',
        'color' => '^([a-zA-Z0-9_-]+)$',
      ])
    ->name('prepaid_detail');

//RUTAS POSTPAGO
Route::get('/postpago', 'PostpaidController@index')->name('postpaid');
Route::get('/postpago/{brand}/{product}/{affiliation}/{plan}/{contract}/{color?}', 'PostpaidController@show')
    ->where(
      [
        'brand' => '^([a-zA-Z0-9_-]+)$',
        'product' => '^([a-zA-Z0-9_-]+)$',
        'affiliation' => '^([a-zA-Z0-9_-]+)$',
        'plan' => '^([a-zA-Z0-9_-]+)$',
        'contract' => '^([a-zA-Z0-9_-]+)$',
        'color' => '^([a-zA-Z0-9_-]+)$',
      ])
    ->name('postpaid_detail');

//RUTAS ACCESORIOS
Route::get('/accesorios', 'AccessoriesController@index')->name('accessories');
Route::get('/accesorios/{brand}/{product}/{color?}', 'AccessoriesController@show')
    ->where(
      [
        'brand' => '^([a-zA-Z0-9_-]+)$',
        'product' => '^([a-zA-Z0-9_-]+)$',
        'color' => '^([a-zA-Z0-9_-]+)$',
      ])
    ->name('accessory_detail');

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
Route::post('/carrito/actualizar', 'CartController@updateCart')->name('update_cart');
// Route::delete('/carrito/{product}', 'CartController@removeFromCart')->name('remove_from_cart');

//RUTAS ORDEN
Route::get('/envio', 'OrderController@createOrder')->name('create_order');
Route::get('/envio/currency', 'OrderController@show')->name('currency');
Route::post('/envio', 'OrderController@storeOrder')->name('store_order');
Route::get('/pedido', 'OrderController@showOrder')->name('show_order');
Route::get('/trackeo/{order_id}', 'OrderController@trackOrder')->name('track_order');

//ENLACES FOOTER
Route::get('/files/aviso', 'FileController@downloadFileAviso')->where(['filename'=>'[A-Za-z0-9/-]+'])->name('download_Aviso');
Route::get('/files/consideraciones', 'FileController@downloadFileConsideraciones')->name('download_Consideraciones');
Route::get('/files/terminos', 'FileController@downloadFileTerminos')->name('download_Terminos');
Route::get('/files/fichatecnica/{product_id}', 'FileController@downloadFileFichaTecnica')->name('download_FichaTecnica');

//RUTAS ARCHIVOS
Route::get('/files/{filename}', 'FileController@downloadFile')->where(['filename'=>'[A-Za-z0-9/-]+'])->name('download_file');

//RUTAS ARCHIVOS
Route::get('/files/{filename}', 'FileController@downloadFile')->where(['filename'=>'[A-Za-z0-9/-]+'])->name('download_file');

//MAIL
Route::get('/email/orden', function () {
    //$invoice = App\Invoice::find(1);

    return new App\Mail\OrderCompleted();
});

//TEST
// Route::get('/carrito', 'CartController@index')->name('carrito');
// Route::get('/envio', 'CartController@index2')->name('envio');
Route::get('/finalizado', 'CartController@index3')->name('finalizado');
Route::get('/rastreo', 'TrackingController@index')->name('rastreo');

Route::get('/test_job', 'OrderController@testJob');
//Route::get('/borrar_session', 'OrderController@borrar_session');
