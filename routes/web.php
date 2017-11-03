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
Route::get('product/search', 'PostpaidController@search');
// Route::resource('/product', 'ProductController', ['only' => ['index', 'create', 'store']]);