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

  public function searchPrepaid(Request $request) {
    $request->validate([
      'searched_string' => 'nullable|max:30|regex:/(^[A-Za-z0-9 ]+$)+/',
      'items_per_page' => 'required|integer|min:0'
    ]);

    $plan_pre_id = \Config::get('filter.plan_pre_id');

    $filters = json_decode($request->filters);

    $product_price_ini = (isset($filters->price->value->x)) ? $filters->price->value->x : 0;

    $product_price_end = (isset($filters->price->value->y)) ? $filters->price->value->y : 0;

    $brand_ids = implode(',',$filters->manufacturer->value);

    $plan_pre_id = (isset($filters->plan->value) && $filters->plan->value!="") ? $filters->plan->value : $plan_pre_id;

    $search_result = $this->shared->searchProductPrepaid(1, $plan_pre_id, $brand_ids, $request->items_per_page, 1, "product_model", "desc", $product_price_ini, $product_price_end, $request->searched_string);

    $data = collect($search_result['products'])->map(function ($item, $key) {
      $item->picture_url = asset('images/productos/'.$item->picture_url);
      $item->route = route('prepaid_detail', [
        'brand'=>$item->brand_slug,
        'product'=>$item->product_slug,
        'plan'=>$item->plan_slug
      ]);
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

    $affiliation_id = \Config::get('filter.affiliation_id');
    $plan_post_id = \Config::get('filter.plan_post_id');
    $contract_id = \Config::get('filter.contract_id');

    $items_per_page = $request->items_per_page;
    $current_page = ($request->has('pag')) ? $request->pag : 1 ;
    $filters = json_decode($request->filters);
    $product_price_ini = (isset($filters->price->value->x)) ? $filters->price->value->x : 0;
    $product_price_end = (isset($filters->price->value->y)) ? $filters->price->value->y : 0;
    $brand_ids = implode(',',$filters->manufacturer->value);
    $affiliation_id = (isset($filters->affiliation->value)) ? $filters->affiliation->value : $affiliation_id;
    $plan_post_id = (isset($filters->plan->value) && $filters->plan->value!="") ? $filters->plan->value : $plan_post_id;
    $contract_id = \Config::get('filter.contract_id');

    $search_result = $this->shared->searchProductPostpaid(1, $affiliation_id, $plan_post_id, $contract_id, $brand_ids, $items_per_page, $current_page, "product_model", "desc", $product_price_ini, $product_price_end, $request->searched_string);
    $pages = intval(ceil($search_result['total'] / $items_per_page));

    $data = collect($search_result['products'])->map(function ($item, $key) {
      $item->picture_url = asset('images/productos/'.$item->picture_url);
      $item->route = route('postpaid_detail', [
        'brand'=>$item->brand_slug,
        'product'=>$item->product_slug,
        'plan'=>$item->plan_slug,
        'affiliation'=>$item->affiliation_slug,
        'contract'=>$item->contract_slug
      ]);
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
  }

  public function searchAccesorios (Request $request) {
    $request->validate([
      'searched_string' => 'nullable|max:30|regex:/(^[A-Za-z0-9 ]+$)+/',
      'items_per_page' => 'required|integer|min:0'
    ]);

    $filters = json_decode($request->filters);

    $product_price_ini = (isset($filters->price->value->x)) ? $filters->price->value->x : 0;

    $product_price_end = (isset($filters->price->value->y)) ? $filters->price->value->y : 0;

    $brand_ids = implode(',',$filters->manufacturer->value);

    $search_result = $this->shared->productSearch(2, $brand_ids, $request->items_per_page, 1, "product_model", "desc", $product_price_ini, $product_price_end, $request->searched_string);
    
    $data = collect($search_result['products'])->map(function ($item, $key) {
      $item->picture_url = asset('images/productos/'.$item->picture_url);
      $item->route = route('accessory_detail', [
        'brand'=>$item->brand_slug,
        'product'=>$item->product_slug,
      ]);
      return $item;
    });

    $response = [
      'data' => $data
    ];

    return response()->json($response);
  }

  public function searchPromos (Request $request) {

  }
}
