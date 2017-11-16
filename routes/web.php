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

// Route::get('/productos/{category}/{product}', 'ProductController@show')->where(['category'=>'[A-Za-z]+', 'product'=>'[0-9]+'])->name('product_detail');
Route::get('/productos/smartphones/{product}', 'ProductController@show')->where(['product'=>'[0-9]+'])->name('smartphone_detail');
Route::get('/productos/tablets/{product}', 'ProductController@show')->where(['product'=>'[0-9]+'])->name('tablet_detail');

//RUTAS PREPAGO
Route::get('/prepago', 'PrepaidController@index')->name('prepaid');
Route::get('/prepago/smartphones/{product}', 'PrepaidController@show')->where(['product'=>'[0-9]+'])->name('prepaid_detail');

//RUTAS POSTPAGO
Route::get('/postpago', 'PostpaidController@index')->name('postpaid');
Route::get('/postpago/smartphones/{product}', 'PostpaidController@show')->where(['product'=>'[0-9]+'])->name('postpaid_detail');

//RUTAS ACCESORIOS
Route::get('/accesorios', 'AccessoriesController@index')->name('accessories');

//RUTAS BUSQUEDA
Route::get('/product/search', 'PostpaidController@search');
Route::get('/prepago/buscar', 'Api\SearchController@searchPrepaid');
Route::get('/postpago/buscar', 'Api\SearchController@searchPostpaid');
// Route::resource('/product', 'ProductController', ['only' => ['index', 'create', 'store']]);

//RUTAS COMPARAR
Route::get('/prepago/comparar', 'PrepaidController@compare');
Route::get('/postpago/comparar', 'PostpaidController@compare');
Route::get('/product/compare', 'PostpaidController@compare');

//RUTAS ARCHIVOS
Route::get('/files/{filename}', 'FileController@downloadFile')->where(['filename'=>'[A-Za-z0-9/-]+'])->name('download_file');

//TEST
Route::get('/carrito', 'CartController@index')->name('carrito');
Route::get('/envio', 'CartController@index2')->name('envio');
Route::get('/finalizado', 'CartController@index3')->name('finalizado');
Route::get('/rastreo', 'TrackingController@index')->name('rastreo');
