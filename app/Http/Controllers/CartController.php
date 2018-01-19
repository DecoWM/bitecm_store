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
    $products = []; //Lista de productos
    $equipo = null;
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
            $equipo = $product;
          }
          break;
        case 2:
          if(isset($item['product_variation_id'])) {
            $product = $this->shared->productPostpagoByStock($item['stock_model_id'],$item['product_variation_id']);
            $equipo = $product;
          }
          break;
      }
      if(!isset($product)) {
        continue;
      }
      $product->quantity = $item['quantity'];
      $product->type_id = $item['type_id'];

      if(isset($product->promo_id)) {
        $product->promo_price = number_format($product->promo_price * $product->quantity, 2, '.', '');
        $product->product_price = number_format($product->product_price * $product->quantity, 2, '.', '');
        $total += $product->promo_price;
        $total_igv += $product->promo_price; //$product->promo_price * (1 + $igv);
      } else {
        $product->product_price = number_format($product->product_price * $product->quantity, 2, '.', '');
        $total += $product->product_price;
        $total_igv += $product->product_price; //$product->product_price * (1 + $igv);
      }

      array_push($products, $product);
    }

    if (count($products) == 0 && count($cart) > 0) {
      $request->session()->forget('cart');
    }

    $this->preventHistory();
    
    return view('cart', [
      'equipo' => $equipo,
      'products' => $products,
      'total' => number_format($total, 2, '.', ''),
      'total_igv' => number_format($total_igv, 2, '.', ''),
      'igv' => $igv,
    ]);
  }

  public function addToCart (Request $request) {
    if(!isset($request->type) || !isset($request->stock_model)) {
      return redirect()->route('show_cart');
    }

    $cart = collect($request->session()->get('cart',[])); //Carrito de compras

    $cart_item = [
      'type_id' => $request->type, //Prepago o postpago o sin variación
      'stock_model_id' => $request->stock_model, //Id del producto en stock
      'quantity' => $request->quantity //Unidades
    ];

    $limit_message = 'Al momento solo está disponible hacer la compra de un solo producto por pedido, si deseas comprar un producto adicional, termina el pedido seleccionado o borra el producto elegido.';

    switch ($cart_item['type_id']) {
      case 0:
        $cart_item['product_variation_id'] = null;
        $has_item = $cart->search(function($item, $key) use ($cart_item) {
          return !isset($item['product_variation_id']) && $item['stock_model_id'] == $cart_item['stock_model_id'];
        });
        if ($has_item === false) {
          $request->session()->push('cart', $cart_item);
        } else {
          return redirect()->route('show_cart')->with('msg', $limit_message);
        }
        break;
      case 1:
        $cart_item['product_variation_id'] = $request->product_variation;
        $has_item = $cart->search(function($item, $key) use ($cart_item) {
          return $item['product_variation_id'] == $cart_item['product_variation_id'] && $item['stock_model_id'] == $cart_item['stock_model_id'];
        });
        if ($has_item === false && !$cart->contains('type_id', 1) && !$cart->contains('type_id', 2)) {
          $request->session()->push('cart', $cart_item);
        } else {
          return redirect()->route('show_cart')->with('msg', $limit_message);
        }
        break;
      case 2:
        $cart_item['product_variation_id'] = $request->product_variation;
        $cart_item['affiliation_id'] = $request->affiliation;
        $has_item = $cart->search(function($item, $key) use ($cart_item) {
          return $item['product_variation_id'] == $cart_item['product_variation_id'] && $item['stock_model_id'] == $cart_item['stock_model_id'];
        });
        if ($has_item === false && !$cart->contains('type_id', 1) && !$cart->contains('type_id', 2)) {
          $request->session()->push('cart', $cart_item);
        } else {
          return redirect()->route('show_cart')->with('msg', $limit_message);
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
    $this->preventHistory();
    return redirect()->route('show_cart');
  }

  public function updateCart(Request $request) {
    $cart = collect($request->session()->get('cart',[])); //Carrito de compras
    if(!isset($request->product_variation)) {
      foreach ($cart as $i => $item) {
        if($request->stock_model == $item['stock_model_id']) {
          $item['quantity'] = $request->quantity;
          $request->session()->put('cart.'.$i, $item);
          break;
        }
      }
    } else {
      foreach ($cart as $i => $item) {
        if($request->stock_model == $item['stock_model_id'] && $request->product_variation == $item['product_variation_id']) {
          $item['quantity'] = $request->quantity;
          $request->session()->put('cart.'.$i, $item);
          break;
        }
      }
    }
    $this->preventHistory();
    return redirect()->route('show_cart');
  }

  private function preventHistory() {
    if (!in_array(url()->previous(), [route('create_order'), route('update_cart'), route('show_cart')])) {
      $this->shared->setPreviousUrl(url()->previous());
    }
  }
}
