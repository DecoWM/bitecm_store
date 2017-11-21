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
              array_push($products, ['product' => $product[0]]);
              break;
              case 2:
                $product = DB::select('call PA_productDetail(:product_id)', ['product_id' => $item['product_id']]);
                $plan = DB::table('tbl_product_variation')
                ->join('tbl_plan', 'tbl_product_variation.plan_id', '=', 'tbl_plan.plan_id')
                ->join('tbl_affiliation', 'tbl_product_variation.affiliation_id', '=', 'tbl_affiliation.affiliation_id')
                ->where('tbl_product_variation.product_id', $item['product_id'])
                ->where('tbl_product_variation.plan_id', $item['plan_id'])
                ->where('tbl_product_variation.affiliation_id', $item['affiliation_id'])->get();
                array_push($products, ['product' => $product[0], 'plan' => $plan[0]]);
                break;
            }
        }
        // dump($products);
        return view('cart', ['products' => $products]);
    }

    public function addToCart (Request $request) {
        $request->session()->flush();
        //VARIABLES
        $cart = "";             //Carrito de compras
        $type_id = "";          //Prepago o postpago
        $product_id = "";       //Id del producto
        $color = "";            //Color del producto
        $affiliation_id = "";   //Id de la afiliación (Linea nueva, portabilidad, renovación)
        $plan_id = "";          //Id del plan seleccionado (solo en postpago)

        //ASIGNACIÓN DE VALORES A VARIABLES
        $cart = collect($request->session()->get('cart'));
        $type_id = $request->type;
        $product_id = $request->product;
        $color = $request->color;
        if ($type_id == 2) {    //Si el tipo de producto es postpago
            $affiliation_id = $request->affiliation;
            $plan_id = $request->plan;
        }

        //CREACIÓN DEL ITEM PARA EL CARRITO
        $cart_item = [
            'type_id' => $type_id,
            'product_id' => $product_id,
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
            }
        }

        return redirect()->route('show_cart');
        // $data = $request->session()->all();
        // // dd($data);
        // return [$data];
    }

    public function removeFromCart (Request $request) {

    }

    public function index (Request $request) {
        $product_id = $request->product;
        $product = DB::select('call PA_productDetail(:product_id)', ['product_id' => $product_id]);
        return view('cart', ['product' => $product[0]]);
    }

    public function index2 (Request $request) {
        $product_id = $request->product;
        $product = DB::select('call PA_productDetail(:product_id)', ['product_id' => $product_id]);
        // dd($product);
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
        return view('cart2', ['product' => $product[0], 'distritos' => $distritos]);
    }

    public function index3 (Request $request) {
        $product_id = $request->product;
        $product = DB::select('call PA_productDetail(:product_id)', ['product_id' => $product_id]);
        // dd($product);
        Mail::to($request->email)->send(new OrderCompleted($request->all()));
        return view('cart3', ['data' => $request->all(), 'product' => $product[0]]);
    }

}
