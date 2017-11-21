<?php

namespace App\Http\Controllers\Api;

use DB;
use Validator;
use App\Http\Controllers\BaseController;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Pagination\LengthAwarePaginator as Paginator;

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
        $product_price_ini = (isset($filters->price->value->x)) ? $filters->price->value->x : 0;
        $product_price_end = (isset($filters->price->value->y)) ? $filters->price->value->y : 0;
        $manufacturer_ids = implode(',',$filters->manufacturer->value);
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

    public function searchPrepaid (Request $request) {
        $request->validate([
          'searched_string' => 'nullable|max:30|regex:/(^[A-Za-z0-9 ]+$)+/',
          'items_per_page' => 'required|integer|min:0'
        ]);

        $filters = json_decode($request->filters);

        $product_price_ini = (isset($filters->price->value->x)) ? $filters->price->value->x : 0;

        $product_price_end = (isset($filters->price->value->y)) ? $filters->price->value->y : 0;

        $manufacturer_ids = implode(',',$filters->manufacturer->value);

        $search_result = $this->shared->searchProductPrepaid(1, $request->items_per_page, 1, "product_model", "desc", $manufacturer_ids, $product_price_ini, $product_price_end, $request->searched_string);

        $data = collect($search_result)->map(function ($item, $key) {
            $item->picture_url = asset('images/productos/'.$item->picture_url);
            return $item;
        });

        $response = [
            'data' => $data
        ];

        return response()->json($response);
    }

    public function searchPostpaid (Request $request) {
        $request->validate([
          'searched_string' => 'nullable|max:30|regex:/(^[A-Za-z0-9 ]+$)+/',
          'items_per_page' => 'required|integer|min:0'
        ]);

        $items_per_page = $request->items_per_page;
        $current_page = ($request->has('pag')) ? $request->pag : 1 ;
        $filters = json_decode($request->filters);
        $product_price_ini = (isset($filters->price->value->x)) ? $filters->price->value->x : 0;
        $product_price_end = (isset($filters->price->value->y)) ? $filters->price->value->y : 0;
        $manufacturer_ids = implode(',',$filters->manufacturer->value);
        $affiliation_id = (isset($filters->affiliation->value)) ? $filters->affiliation->value : 2;
        $plan_id = (isset($filters->plan->value)) ? ( $filters->plan->value!="" ? $filters->plan->value : 6) : 6;

        $search_result = $this->shared->searchProductPostpaid(1, $items_per_page, $current_page, "product_model", "desc", $manufacturer_ids, $product_price_ini, $product_price_end, $request->searched_string, $affiliation_id, $plan_id);
        $pages = intval(ceil($search_result['total'] / $items_per_page));

        $data = collect($search_result['products'])->map(function ($item, $key) {
            $item->picture_url = asset('images/productos/'.$item->picture_url);
            return $item;
        });

        $paginator = new Paginator(
            $data,
            $search_result['total'],
            $items_per_page, $current_page,
            [
                'pageName' => 'pag'
            ]
        );
        $paginator->withPath('postpago');

        return response()->json($paginator);

        // $items_per_page = 12;
        //
        // $search_result =  $this->shared->searchProductPostpaid(1, $items_per_page, $current_page);
        // $pages = intval(ceil($search_result['total'] / $items_per_page));
        // $paginator = new Paginator(
        //     $search_result['products'],
        //     $search_result['total'],
        //     $items_per_page, $current_page,
        //     [
        //         'pageName' => 'pag'
        //     ]
        // );
        // $paginator->withPath('postpago');
        // return view('smartphones.postpago.index', ['products' => $paginator, 'pages' => $pages]);
    }
}
