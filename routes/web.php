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


Route::get('/postpago/smartphones/{product}', 'ProductController@show')->where(['product'=>'[0-9]+'])->name('postpago_detail');
Route::get('/prepago/smartphones/{product}', 'ProductController@show')->where(['product'=>'[0-9]+'])->name('prepago_detail');

Route::resource('/product', 'ProductController', ['only' => ['index', 'create', 'store']]);

Route::get('/test', function () {
  return round(3.5);
});
