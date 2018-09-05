<?php

namespace App\Http\Controllers\Api;

use DB;
use Validator;
use App\Http\Controllers\BaseController;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Pagination\LengthAwarePaginator as Paginator;
use Illuminate\Support\Facades\Storage;

class SearchController extends Controller
{
  protected $shared;

  public function __construct (BaseController $shared) {
    $this->shared = $shared;
  }

  public function searchPrepaid(Request $request) {
    $request->validate([
      'searched_string' => 'nullable|max:30|regex:/(^[A-Za-z0-9.\+\- ]+$)+/',
      'items_per_page' => 'required|integer|min:0'
    ]);

    $plan_post_slug = $this->shared->planSlug(\Config::get('filter.plan_post_id'));
    $affiliation_slug = $this->shared->affiliationSlug(\Config::get('filter.affiliation_id'));
    $contract_slug = $this->shared->contractSlug(\Config::get('filter.contract_id'));

    $items_per_page = $request->items_per_page;
    $current_page = ($request->has('pag')) ? $request->pag : 1 ;

    $filters = json_decode($request->filters);

    $product_price_ini = (isset($filters->price->value->x)) ? $filters->price->value->x : 0;

    $product_price_end = (isset($filters->price->value->y)) ? $filters->price->value->y : 0;

    $brand_ids = implode(',',$filters->manufacturer->value);

    $plan_pre_id = (isset($filters->plan->value) && $filters->plan->value!="") ? $filters->plan->value : \Config::get('filter.plan_pre_id');

    $searched_string = $request->searched_string;

    $search_result = $this->shared->searchProductPrepaid('1,3', $plan_pre_id, $brand_ids, $items_per_page, $current_page, "publish_at", "desc", $product_price_ini, $product_price_end, $searched_string);

    $filtered_product = null;
    foreach ($search_result['products'] as $ix => $prod) {
      $prod_full_name = strtolower($prod->brand_name.' '.$prod->product_model);
      $prod_model_name = strtolower($prod->product_model);
      $searched_string = strtolower(trim($searched_string));
      if ($searched_string == $prod_full_name || $searched_string == $prod_model_name) {
        $filtered_product = $prod;
      }
    }

    if (isset($filtered_product)) {
      $search_result['products'] = [$filtered_product];
      $search_result['total'] = 1;  
    }

    $data = collect($search_result['products'])->map(function ($item, $key) use ($affiliation_slug,$plan_post_slug,$contract_slug) {
      $item->picture_url = asset(Storage::url($item->picture_url));
      $item->route = route('prepaid_detail', [
        'brand'=>$item->brand_slug,
        'product'=>$item->product_slug,
        'plan'=>$item->plan_slug
      ]);
      $item->route_post = route('postpaid_detail', [
        'brand'=>$item->brand_slug,
        'product'=>$item->product_slug,
        'affiliation'=>$affiliation_slug,
        'plan'=>$plan_post_slug,
        'contract'=>$contract_slug
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
    $paginator->withPath('prepago');

    return response()->json($paginator);
  }

  public function searchPostpaid (Request $request) {
    $request->validate([
      'searched_string' => 'nullable|max:30|regex:/(^[A-Za-z0-9.\+\- ]+$)+/',
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
    $contract_id = (isset($filters->contract->value)) ? $filters->contract->value : $contract_id;
    //\Config::get('filter.contract_id');

    //error_log($plan_post_id, 3, 'c:/nginx-1.12.2/logs/frutaldia.log');

    $searched_string = $request->searched_string;

    $search_result = $this->shared->searchProductPostpaid('1,3', $affiliation_id, $plan_post_id, $contract_id, $brand_ids, $items_per_page, $current_page, "publish_at", "desc", $product_price_ini, $product_price_end, $searched_string);

    $filtered_product = null;
    foreach ($search_result['products'] as $ix => $prod) {
      $prod_full_name = strtolower($prod->brand_name.' '.$prod->product_model);
      $prod_model_name = strtolower($prod->product_model);
      $searched_string = strtolower(trim($searched_string));
      if ($searched_string == $prod_full_name || $searched_string == $prod_model_name) {
        $filtered_product = $prod;
      }
    }

    if (isset($filtered_product)) {
      $search_result['products'] = [$filtered_product];
      $search_result['total'] = 1;  
    }

    $data = collect($search_result['products'])->map(function ($item, $key) {
      $item->picture_url = asset(Storage::url($item->picture_url));
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
      'searched_string' => 'nullable|max:30|regex:/(^[A-Za-z0-9.\+\- ]+$)+/',
      'items_per_page' => 'required|integer|min:0'
    ]);

    $items_per_page = $request->items_per_page;
    $current_page = ($request->has('pag')) ? $request->pag : 1 ;

    $filters = json_decode($request->filters);

    $product_price_ini = (isset($filters->price->value->x)) ? $filters->price->value->x : 0;

    $product_price_end = (isset($filters->price->value->y)) ? $filters->price->value->y : 0;

    $brand_ids = implode(',',$filters->manufacturer->value);

    $searched_string = $request->searched_string;

    $search_result = $this->shared->productSearch(2, $brand_ids, $items_per_page, $current_page, "publish_at", "desc", $product_price_ini, $product_price_end, $searched_string);

    $filtered_product = null;
    foreach ($search_result['products'] as $ix => $prod) {
      $prod_full_name = strtolower($prod->brand_name.' '.$prod->product_model);
      $prod_model_name = strtolower($prod->product_model);
      $searched_string = strtolower(trim($searched_string));
      if ($searched_string == $prod_full_name || $searched_string == $prod_model_name) {
        $filtered_product = $prod;
      }
    }

    if (isset($filtered_product)) {
      $search_result['products'] = [$filtered_product];
      $search_result['total'] = 1;  
    }

    $data = collect($search_result['products'])->map(function ($item, $key) {
      $item->picture_url = asset(Storage::url($item->picture_url));
      $item->route = route('accessory_detail', [
        'brand'=>$item->brand_slug,
        'product'=>$item->product_slug,
      ]);
      return $item;
    });

    // $response = [
    //   'data' => $data
    // ];
    //
    // return response()->json($response);

    $paginator = new Paginator(
      $data,
      $search_result['total'],
      $items_per_page, $current_page,
      [
        'pageName' => 'pag'
      ]
    );
    $paginator->withPath('accesorios');

    return response()->json($paginator);
  }

  public function searchPromos (Request $request) {
    $request->validate([
      'searched_string' => 'nullable|max:30|regex:/(^[A-Za-z0-9.\+\- ]+$)+/',
      'items_per_page' => 'required|integer|min:0'
    ]);

    $items_per_page = $request->items_per_page;
    $current_page = ($request->has('pag')) ? $request->pag : 1 ;

    $filters = json_decode($request->filters);

    $product_price_ini = (isset($filters->price->value->x)) ? $filters->price->value->x : 0;

    $product_price_end = (isset($filters->price->value->y)) ? $filters->price->value->y : 0;

    $brand_ids = implode(',',$filters->manufacturer->value);

    $affiliation_id = \Config::get('filter.affiliation_id');
    $plan_pre_id = \Config::get('filter.plan_pre_id');
    $plan_post_id = \Config::get('filter.plan_post_id');
    $contract_id = \Config::get('filter.contract_id');

    $searched_string = $request->searched_string;

    $contract_id = (isset($filters->contract->value)) ? $filters->contract->value : $contract_id;

    $datalog = 'null'.' | '. $plan_pre_id.' | '.$plan_post_id.' | '.$affiliation_id.' | '.$contract_id.' | '.$brand_ids.' | '.$request->items_per_page.' | '. '1'.' | '.'publish_at'.' | '.'desc'.' | '.$product_price_ini.' | '.$product_price_end.' | '.$searched_string;

    error_log($datalog,3,'c:/nginx-1.12.2/logs/bitel-store.log');

    $search_result = $this->shared->productSearchPromo(null, $plan_pre_id, $plan_post_id, $affiliation_id, $contract_id, $brand_ids, $request->items_per_page, 1, "publish_at", "desc", $product_price_ini, $product_price_end, $searched_string);

    $filtered_product = null;
    foreach ($search_result['products'] as $ix => $prod) {
      $prod_full_name = strtolower($prod->brand_name.' '.$prod->product_model);
      $prod_model_name = strtolower($prod->product_model);
      $searched_string = strtolower(trim($searched_string));
      if ($searched_string == $prod_full_name || $searched_string == $prod_model_name) {
        $filtered_product = $prod;
      }
    }

    if (isset($filtered_product)) {
      $search_result['products'] = [$filtered_product];
      $search_result['total'] = 1;  
    }
    
    $data = collect($search_result['products'])->map(function ($item, $key) {
      $item->picture_url = asset(Storage::url($item->picture_url));

      if (isset($item->product_variation_id)) {
        $item->product_price = $item->product_variation_price;
        switch ($item->variation_type_id) {
          case 1:
            $item->route = route('prepaid_detail', [
              'brand' => $item->brand_slug,
              'product' => $item->product_slug,
              'plan' => $item->plan_slug
            ]);
            break;
          case 2:
            $item->route = route('postpaid_detail', [
              'brand' => $item->brand_slug,
              'product' => $item->product_slug,
              'plan' => $item->plan_slug,
              'affiliation'=>$item->affiliation_slug,
              'contract'=>$item->contract_slug
            ]);
            break;
        }
      } else {
        if ($item->category_id == \Config::get('filter.accessory_cat_id')) {
          $item->route = route('accessory_detail', [
            'brand'=>$item->brand_slug,
            'product'=>$item->product_slug
          ]);
        }
      }

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
    $paginator->withPath('promociones');

    return response()->json($paginator);
  }
}
