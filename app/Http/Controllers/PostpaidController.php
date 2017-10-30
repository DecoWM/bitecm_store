<?php

namespace App\Http\Controllers;

use DB;
use App\Http\Controllers\BaseController;
use Illuminate\Http\Request;

class PostpaidController extends Controller
{
    protected $shared;

    public function __construct (BaseController $shared) {
        $this->shared = $shared;
    }

    public function index () {
        $search_result =  $this->shared->searchProduct(1, 9);
        return view('smartphones.postpago.index', ['products' => $search_result]);
    }

    public function search (Request $request) {
        $this->validate($request, [
          'searched_string' => 'required|max:30|regex:/(^[A-Za-z0-9 ]+$)+/'
        ]);
        $search_result = $this->shared->searchProduct(1, 9, 1, "", "", 0, 0, 0, $request->searched_string);
        $response = [
            'data' => $search_result
        ];
        return response()->json($response);
        // $product_category_id=1, $pag_total_by_page=20, $pag_actual=1, $sort_by="", $sort_direction="", $product_manufacturer_id=0, $product_price_ini=0, $product_price_end=0, $product_string_search=""
    }
}
