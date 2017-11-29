<?php

namespace App\Http\Controllers;

use DB;
use App\Mail\OrderCompleted;
use Illuminate\Support\Facades\Mail;
use App\Http\Controllers\BaseController;
use Illuminate\Http\Request;
use Artisaninweb\SoapWrapper\SoapWrapper; // For use client SOAP service

class CartController extends Controller
{
  protected $shared;

  public function __construct (BaseController $shared) {
    $this->shared = $shared;
  }

  public function showCart (Request $request) {
    //VARIABLES
    $products = []; //Lista de productos

    //ASIGNACIÓN DE VALORES A VARIABLES
    $cart = collect($request->session()->get('cart')); //Carrito de compras

    $total = 0;
    $total_igv = 0;

    $igv = \Config::get('filter.igv');

    foreach ($cart as $item) {
      if (!isset($item['type_id']) || !isset($item['stock_model_id'])) {
        continue;
      }
      switch ($item['type_id']) {
        case 0:
          $product = $this->shared->productByStock($item['stock_model_id']);
          break;
        case 1:
          if(isset($item['product_variation_id'])) {
            $product = $this->shared->productPrepagoByStock($item['stock_model_id'],$item['product_variation_id']);
          }
          break;
        case 2:
          if(isset($item['product_variation_id'])) {
            $product = $this->shared->productPostpagoByStock($item['stock_model_id'],$item['product_variation_id']);
          }
          break;
      }
      $product->quantity = $item['quantity'];
      $product->type_id = $item['type_id'];

      if(isset($product->promo_id)) {
        $total += $product->promo_price;
        $total_igv += $product->promo_price * (1 + $igv);
      } else {
        $total += $product->product_price;
        $total_igv += $product->product_price * (1 + $igv);
      }

      array_push($products, $product);
    }

    if (count($products) == 0 && count($cart) > 0) {
      $request->session()->forget('cart');
    }

    return view('cart', [
      'products' => $products, 
      'total' => $total,
      'total_igv' => $total_igv,
      'igv' => $igv
    ]);
  }

  public function addToCart (Request $request) {
    if(!isset($request->type) || !isset($request->stock_model)) {
      return redirect()->route('show_cart');
    }

    //ASIGNACIÓN DE VALORES A VARIABLES
    $cart = collect($request->session()->get('cart',[])); //Carrito de compras

    //CREACIÓN DEL ITEM PARA EL CARRITO
    $cart_item = [
      'type_id' => $request->type, //Prepago o postpago o sin variación
      'stock_model_id' => $request->stock_model, //Id del producto en stock
      'quantity' => 1 //Unidades
    ];

    switch ($cart_item['type_id']) {
      case 0:
        $has_item = $cart->search($cart_item);
        if ($has_item === false && !$cart->contains('type_id', 1) && !$cart->contains('type_id', 2)) {
          $request->session()->push('cart', $cart_item);
        }
        break;
      case 1:
        $cart_item['product_variation_id'] = $request->product_variation;
        $has_item = $cart->search($cart_item);
        if ($has_item === false && !$cart->contains('type_id', 0) && !$cart->contains('type_id', 2) && count($cart) < 2) {
          $request->session()->push('cart', $cart_item);
        }
        break;
      case 2:
        $cart_item['product_variation_id'] = $request->product_variation;
        $has_item = $cart->search($cart_item);
        if ($has_item === false && !$cart->contains('type_id', 0) && !$cart->contains('type_id', 1) && count($cart) < 1) {
          $request->session()->push('cart', $cart_item);
        }
        break;
    }

    return redirect()->route('show_cart');
  }

  public function removeFromCart (Request $request) {
    $cart = collect($request->session()->get('cart',[])); //Carrito de compras
    if(!isset($request->product_variation)) {
      foreach ($cart as $i => $item) {
        if($request->stock_model == $item['stock_model_id']) {
          $request->session()->forget('cart.'.$i);
          break;
        }
      }
    } else {
      foreach ($cart as $i => $item) {
        if($request->stock_model == $item['stock_model_id'] && $request->product_variation == $item['product_variation_id']) {
          $request->session()->forget('cart.'.$i);
          break;
        }
      }
    }
    return redirect()->route('show_cart');
  }
}
