<?php

namespace App\Http\Controllers;

use DB;
use App\Mail\OrderCompleted;
use Illuminate\Support\Facades\Mail;
use App\Http\Controllers\BaseController;
use Illuminate\Http\Request;

class CartController extends Controller
{
    protected $shared;

    public function __construct (BaseController $shared) {
        $this->shared = $shared;
    }

    public function showCart (Request $request) {
        //VARIABLES
        $cart = "";             //Carrito de compras
        $products = [];         //Lista de productos

        //ASIGNACIÓN DE VALORES A VARIABLES
        $cart = collect($request->session()->get('cart'));
        // dump($cart);
        foreach ($cart as $item) {
            switch ($item['type_id']) {
              case 1:
                $product = DB::select('call PA_productDetail(:product_id)', ['product_id' => $item['product_id']]);
                array_push($products, ['product' => $product[0], 'quantity' => $item['quantity']]);
                break;
              case 2:
                $product = DB::select('call PA_productDetail(:product_id)', ['product_id' => $item['product_id']]);
                $plan = DB::table('tbl_product_variation')
                ->join('tbl_plan', 'tbl_product_variation.plan_id', '=', 'tbl_plan.plan_id')
                ->join('tbl_affiliation', 'tbl_product_variation.affiliation_id', '=', 'tbl_affiliation.affiliation_id')
                ->where('tbl_product_variation.product_id', $item['product_id'])
                ->where('tbl_product_variation.plan_id', $item['plan_id'])
                ->where('tbl_product_variation.affiliation_id', $item['affiliation_id'])->get();
                array_push($products, ['product' => $product[0], 'plan' => $plan[0], 'quantity' => $item['quantity']]);
                break;
            }
        }
        // dump($products);
        return view('cart', ['products' => $products]);
    }

    public function addToCart (Request $request) {
        //VARIABLES
        $cart = "";             //Carrito de compras
        $type_id = "";          //Prepago o postpago
        $product_id = "";       //Id del producto
        $quantity = "";         //Unidades
        $color = "";            //Color del producto
        $affiliation_id = "";   //Id de la afiliación (Linea nueva, portabilidad, renovación)
        $plan_id = "";          //Id del plan seleccionado (solo en postpago)

        //ASIGNACIÓN DE VALORES A VARIABLES
        $cart = collect($request->session()->get('cart'));
        $type_id = $request->type;
        $product_id = $request->product;
        $quantity = $request->quantity;
        $color = $request->color;
        if ($type_id == 2) {    //Si el tipo de producto es postpago
            $affiliation_id = $request->affiliation;
            $plan_id = $request->plan;
        }

        //CREACIÓN DEL ITEM PARA EL CARRITO
        $cart_item = [
            'type_id' => $type_id,
            'product_id' => $product_id,
            'quantity' => $quantity,
            'color' => $color,
            'affiliation_id' => $affiliation_id,
            'plan_id' => $plan_id,
        ];

        $has_item = $cart->search($cart_item);

        //SE AGREGA EL ITEM A LA VARIABLE DE SESIÓN
        if ($has_item === false) {
            if (!$cart->contains('type_id', 2)) {
                if (count($cart) < 2) {
                    $request->session()->push('cart', $cart_item);
                }
            } else {
                if (count($cart) < 3 && $cart_item['type_id'] == 1) {
                    $request->session()->push('cart', $cart_item);
                }
            }
        }

        return redirect()->route('show_cart');
        // $data = $request->session()->all();
        // // dd($data);
        // return [$data];
    }

    public function removeFromCart (Request $request) {

    }

    public function createOrder (Request $request) {
        //VARIABLES
        $cart = "";             //Carrito de compras

        $distritos = ['LIMA',
        'ANCÓN',
        'ATE',
        'BARRANCO',
        'BRENA',
        'CARABAYLLO',
        'CHACLACAYO',
        'CHORRILLOS',
        'CIENEGUILLA',
        'COMAS',
        'EL AGUSTINO',
        'INDEPENDENCIA',
        'JESÚS MARÍA',
        'LA MOLINA',
        'LA VICTORIA',
        'LINCE',
        'LOS OLIVOS',
        'LURIGANCHO',
        'LURIN',
        'MAGDALENA DEL MAR',
        'MAGDALENA VIEJA',
        'MIRAFLORES',
        'PACHACAMAC',
        'PUCUSANA',
        'PUENTE PIEDRA',
        'PUNTA HERMOSA',
        'PUNTA NEGRA',
        'RÍMAC',
        'SAN BARTOLO',
        'SAN BORJA',
        'SAN ISIDRO',
        'SAN JUAN DE LURIGANCHO',
        'SAN JUAN DE MIRAFLORES',
        'SAN LUIS',
        'SAN MARTÍN DE PORRES',
        'SAN MIGUEL',
        'SANTA ANITA',
        'SANTA MARÍA DEL MAR',
        'SANTA ROSA',
        'SANTIAGO DE SURCO',
        'SURQUILLO',
        'VILLA EL SALVADOR',
        'SURQUILLO',
        'VILLA EL SALVADOR',
        'VILLA MARÍA DEL TRIUNFO',
        'CALLAO',
        'BELLAVISTA',
        'CARMEN DE LA LEGUA REYNOSO',
        'LA PERLA',
        'LA PUNTA',
        'VENTANILLA'];

        //ASIGNACIÓN DE VALORES A VARIABLES
        $cart = collect($request->session()->get('cart'));

        if (count($cart) > 0) {
            return view('order_form', ['distritos' => $distritos]);
        } else {
            return redirect()->route('home');
        }
    }

    public function storeOrder (Request $request) {
        //VARIABLES
        $cart = "";             //Carrito de compras
        $products = [];         //Lista de productos

        $order_id = "";
        $order_detail = [];
        $order_items = [];

        $idtype_id = '';
        $payment_method_id = '';
        $branch_id = '';
        $tracking_code = '';
        $first_name = '';
        $last_name = '';
        $id_number = '';
        $billing_district = '';
        $billing_phone = '';
        $previous_provider = '';
        $delivery_address = '';
        $delivery_district = '';
        $contact_email = '';
        $contact_phone = '';
        $credit_status = '';
        $total = '';

        //ASIGNACIÓN DE VALORES A VARIABLES
        $cart = collect($request->session()->get('cart'));
        $idtype_id = $request->document_type;
        $payment_method_id = $request->payment_method;
        $branch_id = null;
        $tracking_code = null;
        $first_name = $request->first_name;
        $last_name = $request->last_name;
        $id_number = $request->document_number;
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
        $total = 0;

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
            'total' => $total,
        ];

        $order_id = DB::table('tbl_order')->insertGetId(
            $order_detail
        );

        foreach ($cart as $item) {
            switch ($item['type_id']) {
              case 1:
                $product = DB::select('call PA_productDetail(:product_id)', ['product_id' => $item['product_id']]);
                array_push($products, ['product' => $product[0], 'quantity' => $item['quantity']]);
                break;
              case 2:
                $product = DB::select('call PA_productDetail(:product_id)', ['product_id' => $item['product_id']]);
                $plan = DB::table('tbl_product_variation')
                ->join('tbl_plan', 'tbl_product_variation.plan_id', '=', 'tbl_plan.plan_id')
                ->join('tbl_affiliation', 'tbl_product_variation.affiliation_id', '=', 'tbl_affiliation.affiliation_id')
                ->where('tbl_product_variation.product_id', $item['product_id'])
                ->where('tbl_product_variation.plan_id', $item['plan_id'])
                ->where('tbl_product_variation.affiliation_id', $item['affiliation_id'])->get();
                array_push($products, ['product' => $product[0], 'plan' => $plan[0], 'quantity' => $item['quantity']]);
                break;
            }
            array_push($order_items, [
                // 'order_item_id' => ,
                'order_id' => $order_id,
                'product_id' => $item['product_id'],
                'product_variation_id' => $item['type_id'] == 2 ? $plan[0]->product_variation_id : null,
                'promo_id' => null,
                'quantity' => $item['quantity'],
                'subtotal' => $item['type_id'] == 2 ? $plan[0]->product_variation_price *  $item['quantity'] : $product[0]->product_price_prepaid * $item['quantity'],
            ]);
        }

        DB::table('tbl_order_item')->insert(
            $order_items
        );

        Mail::to($request->email)->send(new OrderCompleted(['order_id' => $order_id, 'order_detail' => $order_detail, 'order_items' => $order_items]));

        $request->session()->flush();

        return view('order_detail', ['products' => $products, 'order_id' => $order_id]);
    }

    public function trackOrder (Request $request, $order_id) {
        $products = [];

        $order = DB::table('tbl_order')->where('order_id', $order_id)->first();
        $items = DB::table('tbl_order_item')
        ->where('order_id', $order_id)->get();

        foreach ($items as $item) {
          if ($item->product_variation_id != "") {
              $product = DB::select('call PA_productDetail(:product_id)', ['product_id' => $item->product_id]);
              $plan = DB::table('tbl_product_variation')
              ->join('tbl_plan', 'tbl_product_variation.plan_id', '=', 'tbl_plan.plan_id')
              ->join('tbl_affiliation', 'tbl_product_variation.affiliation_id', '=', 'tbl_affiliation.affiliation_id')
              ->where('tbl_product_variation.product_variation_id', $item->product_variation_id)->get();
              array_push($products, ['product' => $product[0], 'plan' => $plan[0], 'quantity' => $item->quantity]);
          } else {
              $product = DB::select('call PA_productDetail(:product_id)', ['product_id' => $item->product_id]);
              array_push($products, ['product' => $product[0], 'quantity' => $item->quantity]);
          }
        }
        // dd($products);
        return view('tracking', ['order' => $order, 'products' => $products]);
    }

}
