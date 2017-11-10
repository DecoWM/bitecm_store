<?php

namespace App\Http\Controllers;

use DB;
use Illuminate\Http\Request;

class TrackingController extends Controller
{
    public function index (Request $request) {
        $product_id = $request->product;
        $product = DB::select('call PA_productDetail(:product_id)', ['product_id' => $product_id]);
        return view('tracking', ['product' => $product[0]]);
    }
}
