<?php

namespace App\Http\Controllers\Api;

use DB;
use Validator;
use App\Http\Controllers\BaseController;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class SearchController extends Controller
{
    protected $shared;

    public function __construct (BaseController $shared) {
        $this->shared = $shared;
    }

    public function search (Request $request) {
        $request->validate([
          'searched_string' => 'nullable|max:30|regex:/(^[A-Za-z0-9 ]+$)+/',
          'items_per_page' => 'required|integer|min:0',
          'filters' => 'required'
        ]);

        $filters = json_decode($request->filters);
        $product_price_ini = (isset($filters->price->x)) ? $filters->price->x : 0;
        $product_price_end = (isset($filters->price->y)) ? $filters->price->y : 0;
        $manufacturer_ids = implode(',',$filters->manufacturer);
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
}
