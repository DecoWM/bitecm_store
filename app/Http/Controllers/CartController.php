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

    foreach ($cart as $item) {
      if (!isset($item['type_id']) || !isset($item['stock_model_id'])) {
        continue;
      }
      switch ($item['type_id']) {
        case 0:
          $product = $this->shared->productByStock($item['stock_model_id']);
          $product->quantity = $item['quantity'];
          $product->type_id = $item['type_id'];
          array_push($products, $product);
          break;
        case 1:
          if(isset($item['product_variation_id'])) {
            $product = $this->shared->productPrepagoByStock($item['stock_model_id'],$item['product_variation_id']);
            $product->quantity = $item['quantity'];
            $product->type_id = $item['type_id'];
            array_push($products, $product);
          }
          break;
        case 2:
          if(isset($item['product_variation_id'])) {
            $product = $this->shared->productPostpaidByStock($item['stock_model_id'],$item['product_variation_id']);
            $product->quantity = $item['quantity'];
            $product->type_id = $item['type_id'];
            array_push($products, $product);
          }
          break;
      }
    }

    if (count($products) == 0 && count($cart) > 0) {
      $request->session()->forget('cart');
    }

    $igv = \Config::get('filter.igv');

    return view('cart', ['products' => $products, 'igv' => $igv]);
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

  public function createOrder (Request $request) {
    $distritos = ['LIMA', 'ANCÓN', 'ATE', 'BARRANCO', 'BRENA', 'CARABAYLLO', 
      'CHACLACAYO', 'CHORRILLOS', 'CIENEGUILLA', 'COMAS', 'EL AGUSTINO', 
      'INDEPENDENCIA', 'JESÚS MARÍA', 'LA MOLINA', 'LA VICTORIA', 'LINCE', 
      'LOS OLIVOS', 'LURIGANCHO', 'LURIN', 'MAGDALENA DEL MAR', 'MAGDALENA VIEJA', 
      'MIRAFLORES', 'PACHACAMAC', 'PUCUSANA', 'PUENTE PIEDRA', 'PUNTA HERMOSA',
      'PUNTA NEGRA', 'RÍMAC', 'SAN BARTOLO', 'SAN BORJA', 'SAN ISIDRO',
      'SAN JUAN DE LURIGANCHO', 'SAN JUAN DE MIRAFLORES', 'SAN LUIS',
      'SAN MARTÍN DE PORRES', 'SAN MIGUEL', 'SANTA ANITA', 'SANTA MARÍA DEL MAR',
      'SANTA ROSA', 'SANTIAGO DE SURCO', 'SURQUILLO', 'VILLA EL SALVADOR',
      'SURQUILLO', 'VILLA EL SALVADOR', 'VILLA MARÍA DEL TRIUNFO',  'CALLAO', 
      'BELLAVISTA', 'CARMEN DE LA LEGUA REYNOSO', 'LA PERLA', 'LA PUNTA', 'VENTANILLA'
    ];

    //ASIGNACIÓN DE VALORES A VARIABLES
    $cart = collect($request->session()->get('cart')); //Carrito de compras

    if (count($cart) > 0) {
      return view('order_form', ['distritos' => $distritos]);
    } else {
      return redirect()->route('home');
    }
  }

  public function storeOrder (Request $request) {
    //VARIABLES
    $products = []; //Lista de productos

    $order_id = "";
    $order_detail = [];
    $order_items = [];
    $total = 0;

    //ASIGNACIÓN DE VALORES A VARIABLES
    $cart = collect($request->session()->get('cart'));
    $idtype_id = $request->document_type;
    $payment_method_id = $request->payment_method;
    $branch_id = null;
    $first_name = $request->first_name;
    $last_name = $request->last_name;
    $id_number = $request->document_number;
    $tracking_code = $id_number;
    $billing_district = $request->district;
    $billing_phone = $request->phone_number;
    if ($request->has('operator')) {
        $previous_provider = $request->operator;
    }
    $delivery_address = $request->delivery_address;
    $delivery_district = $request->delivery_distric;
    $contact_email = $request->email;
    $contact_phone = $request->contact_phone;
    $credit_status = 1;

    if (count($cart) == 0) {
      return redirect()->route('show_cart');
    }

    $order_detail = [
      'idtype_id' => $idtype_id,
      'payment_method_id' => $payment_method_id,
      'branch_id' => $branch_id,
      'tracking_code' => $tracking_code,
      'first_name' => $first_name,
      'last_name' => $last_name,
      'id_number' => $id_number,
      'billing_district' => $billing_district,
      'billing_phone' => $billing_phone,
      'previous_provider' => $previous_provider,
      'delivery_address' => $delivery_address,
      'delivery_district' => $delivery_district,
      'contact_email' => $contact_email,
      'contact_phone' => $contact_phone,
      'credit_status' => $credit_status,
    ];

    $igv = \Config::get('filter.igv');

    foreach ($cart as $item) {
      switch ($item['type_id']) {
        case 0:
          $product = $this->shared->productByStock($item['stock_model_id']);
          array_push($products, ['product' => $product, 'quantity' => $item['quantity']]);
          break;
        case 1:
          $product = $this->shared->productPrepagoByStock($item['stock_model_id'],$item['product_variation_id']);
          array_push($products, ['product' => $product, 'quantity' => $item['quantity']]);
          break;
        case 2:
          $product = $this->shared->productPrepagoByStock($item['stock_model_id'],$item['product_variation_id']);
          array_push($products, ['product' => $product, 'quantity' => $item['quantity']]);
          break;
      }
      $subtotal = $product->product_variation_price * $item['quantity'];
      $total += $subtotal;
      array_push($order_items, [
        'stock_model_id' => $item['stock_model_id'],
        'product_variation_id' => $item['product_variation_id'] ? $item['product_variation_id'] : null,
        'promo_id' => null,//$product->promo_id,
        'quantity' => $item['quantity'],
        'subtotal' => $subtotal,
        'subtotal_igv' => $subtotal*(1+$igv)
      ]);
    }

    $order_detail['total'] = $total;
    $order_detail['total_igv'] = $total*(1+$igv);
    $order_id = DB::table('tbl_order')->insertGetId($order_detail);

    foreach($order_items as $i => $item) {
      $order_items[$i]['order_id'] = $order_id;
    }

    DB::table('tbl_order_item')->insert($order_items);

    Mail::to($request->email)->send(new OrderCompleted(['order_id' => $order_id, 'order_detail' => $order_detail, 'order_items' => $order_items]));

    $request->session()->flush();

    return view('order_detail', ['products' => $products, 'order_id' => $order_id]);
  }

  public function trackOrder (Request $request, $order_id) {
    $order = DB::table('tbl_order')->where('order_id', $order_id)->first();

    $products = DB::select('call PA_orderItems(
      :order_id
    )', [
      'order_id' => $order_id
    ]);

    return view('tracking', ['order' => $order, 'products' => $products]);
  }
}
