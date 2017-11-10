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

    public function index (Request $request) {
        $product_id = $request->product;
        $product = DB::select('call PA_productDetail(:product_id)', ['product_id' => $product_id]);
        return view('cart', ['product' => $product[0]]);
    }

    public function index2 (Request $request) {
        $product_id = $request->product;
        $product = DB::select('call PA_productDetail(:product_id)', ['product_id' => $product_id]);
        // dd($product);
        return view('cart2', ['product' => $product[0]]);
    }

    public function index3 (Request $request) {
        $product_id = $request->product;
        $product = DB::select('call PA_productDetail(:product_id)', ['product_id' => $product_id]);
        // dd($product);
        Mail::to($request->email)->send(new OrderCompleted($request->all()));
        return view('cart3', ['data' => $request->all(), 'product' => $product[0]]);
    }

}
