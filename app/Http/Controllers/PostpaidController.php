<?php

namespace App\Http\Controllers;

use DB;
use Validator;
use App\Http\Controllers\BaseController;
use Illuminate\Http\Request;

class PostpaidController extends Controller
{
    protected $shared;

    public function __construct (BaseController $shared) {
        $this->shared = $shared;
    }

    public function index () {
        $search_result =  $this->shared->searchProduct(1, 12);
        return view('smartphones.postpago.index', ['products' => $search_result]);
    }

    public function show($product_id) {
        $product = DB::select('call PA_productDetail(:product_id)', ['product_id' => $product_id]);
        $available_products = $this->shared->searchProduct(1, 4);
        $response = [
            'product' => $product[0],
            'available' => $available_products
        ];
        return view('smartphones.postpago.detail', $response);
    }

    public function search (Request $request) {
        $request->validate([
          'searched_string' => 'nullable|max:30|regex:/(^[A-Za-z0-9 ]+$)+/',
          'items_per_page' => 'required|integer|min:0'
        ]);

        $filters = json_decode($request->filters);

        $product_price_ini = (isset($filters->price)) ? $filters->price->x : 0;
        // $product_price_ini = 0;

        $product_price_end = (isset($filters->price)) ? $filters->price->y : 0;
        // $product_price_end = 0;

        $manufacturer_ids = implode(',',$filters->manufacturer);

        // return [$manufacturer_ids];

        $search_result = $this->shared->searchProduct(1, $request->items_per_page, 1, "product_name", "desc", $manufacturer_ids, $product_price_ini, $product_price_end, $request->searched_string);

        $data = collect($search_result)->map(function ($item, $key) {
            $item->picture_url = asset('images/productos/'.$item->picture_url);
            return $item;
        });

        $response = [
            'data' => $data
        ];

        return response()->json($response);
    }

    public function compare (Request $request) {
        $request->validate([
          'product_id' => 'required|array',
          'product_id.*' => 'required|max:9|regex:/(^[0-9]+$)+/',
        ]);
        // return $request->all();
        $products = [];
        foreach ($request->product_id as $product_id) {
            $product = DB::select('call PA_productDetail(:product_id)', ['product_id' => $product_id]);
            if (isset($product[0])) {
              array_push($products, $product[0]);
            } else {
              abort(404);
            }
        }
        // return $products;
        return view('smartphones.postpago.compare', ['products' => $products]);
    }
}
