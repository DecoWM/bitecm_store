<?php

namespace App\Http\Controllers;

use DB;
use Validator;
use App\Http\Controllers\BaseController;
use Illuminate\Http\Request;
use Illuminate\Pagination\LengthAwarePaginator as Paginator;

class PrepaidController extends Controller
{
  protected $shared;

  public function __construct (BaseController $shared) {
    $this->shared = $shared;
  }

  public function index(Request $request) {
    $plan_pre_id = \Config::get('filter.plan_pre_id');

    $plan_post_slug = $this->shared->planSlug(\Config::get('filter.plan_post_id'));
    $affiliation_slug = $this->shared->affiliationSlug(\Config::get('filter.affiliation_id'));
    $contract_slug = $this->shared->contractSlug(\Config::get('filter.contract_id'));

    $items_per_page = 12;
    $current_page = ($request->has('pag')) ? $request->pag : 1 ;

    $search_result =  $this->shared->searchProductPrepaid(1, $plan_pre_id, null, $items_per_page, $current_page, "publish_at", "desc");

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

    $pages = intval(ceil($search_result['total'] / $items_per_page));
    $paginator = new Paginator(
      $search_result['products'],
      $search_result['total'],
      $items_per_page, $current_page,
      [ 'pageName' => 'pag' ]
    );
    $paginator->withPath('prepago');

    $filterList = $this->shared->getFiltersPrepaid();

    return view('smartphones.prepago.index', ['products' => $paginator, 'pages' => $pages, 'filters' => $filterList, 'affiliation_slug' => $affiliation_slug, 'plan_post_slug' => $plan_post_slug, 'contract_slug' => $contract_slug]);
  }

  public function show($brand_slug,$product_slug,$plan_slug,$color_slug=null) {
    $inputs = [
      'brand_slug' => $brand_slug,
      'product_slug' => $product_slug,
      'plan_slug' => $plan_slug,
      'color_slug' => $color_slug
    ];

    $validator = Validator::make($inputs, [
      'brand_slug' => 'required|exists:tbl_brand',
      'product_slug' => 'required|exists:tbl_product',
      'plan_slug' => 'required|exists:tbl_plan',
      'color_slug' => 'nullable|exists:tbl_color'
    ]);

    if ($validator->fails()) {
      abort(404);
    }

    $product = $this->shared->productPrepaidBySlug($brand_slug,$product_slug,$plan_slug,$color_slug);

    if(empty($product)) {
      abort(404);
    }

    $available_products = $this->shared->searchProductPrepaid('1,3', $product->plan_id, null, 4, 1, null, null, null, null, null, null, $product->product_id);

    $available = $available_products['products'];
    foreach($available as $i => $item) {
      $available[$i]->route = route('prepaid_detail', [
        'brand'=>$item->brand_slug,
        'product'=>$item->product_slug,
        'plan'=>$plan_slug,
      ]);
    }

    $stock_models = [];
    $product_images = [];
    if($product->stock_model_id) {
      $stock_models = $this->shared->productStockModels($product->product_id);
      foreach($stock_models as $i => $item) {
        $stock_models[$i]->route = route('prepaid_detail', [
          'brand'=>$brand_slug,
          'product'=>$product->product_slug,
          'plan'=>$plan_slug,
          'color'=>$item->color_slug
        ]);
        $stock_models[$i]->api_route = route('api_prepaid_detail', [
          'brand'=>$brand_slug,
          'product'=>$product->product_slug,
          'plan'=>$plan_slug,
          'color'=>$item->color_slug
        ]);
      }
      $product_images = $this->shared->productImagesByStock($product->stock_model_id);
    }

    $plan_post_id = \Config::get('filter.plan_post_id');
    $affiliation_id = \Config::get('filter.affiliation_id');
    $contract_id = \Config::get('filter.contract_id');

    $variation = DB::table('tbl_product_variation')
      ->join('tbl_plan', 'tbl_plan.plan_id', '=', 'tbl_product_variation.plan_id')
      ->join('tbl_affiliation', 'tbl_affiliation.affiliation_id', '=', 'tbl_product_variation.affiliation_id')
      ->join('tbl_contract', 'tbl_contract.contract_id', '=', 'tbl_product_variation.contract_id')
      ->where('tbl_product_variation.variation_type_id', 2)
      ->where('tbl_product_variation.plan_id', $plan_post_id)
      ->where('tbl_product_variation.affiliation_id', $affiliation_id)
      ->where('tbl_product_variation.contract_id', $contract_id)
      ->where('tbl_product_variation.product_id', $product->product_id)
      ->where('tbl_product_variation.active', 1)
      ->where('tbl_plan.active', 1)
      ->where('tbl_affiliation.active', 1)
      ->where('tbl_contract.active', 1)
      ->limit(1)
      ->get();

    if (!count($variation)) {
      $variation = DB::table('tbl_product_variation')
        ->join('tbl_plan', 'tbl_plan.plan_id', '=', 'tbl_product_variation.plan_id')
        ->join('tbl_affiliation', 'tbl_affiliation.affiliation_id', '=', 'tbl_product_variation.affiliation_id')
        ->join('tbl_contract', 'tbl_contract.contract_id', '=', 'tbl_product_variation.contract_id')
        ->where('tbl_product_variation.variation_type_id', 2)
        ->where('tbl_product_variation.product_id', $product->product_id)
        ->where('tbl_product_variation.active', 1)
        ->where('tbl_plan.active', 1)
        ->where('tbl_affiliation.active', 1)
        ->where('tbl_contract.active', 1)
        ->limit(1)
        ->get();
      if (count($variation)) {
        $plan_post_id = $variation[0]->plan_id;
        $affiliation_id = $variation[0]->affiliation_id;
        $contract_id = $variation[0]->contract_id;
      }
    }

    if (count($variation)) {
      $plan_post_slug = $this->shared->planSlug($plan_post_id);
      $affiliation_slug = $this->shared->affiliationSlug($affiliation_id);
      $contract_slug = $this->shared->contractSlug($contract_id);

      $product->route_postpago = route('postpaid_detail', [
        'brand'=>$product->brand_slug,
        'product'=>$product->product_slug,
        'affiliation'=>$affiliation_slug,
        'plan'=>$plan_post_slug,
        'contract'=>$contract_slug
      ]);
    } else {
      $product->route_postpago = null;
    }

    $response = [
      'product' => $product,
      'product_images' => $product_images,
      'stock_models' => $stock_models,
      'available' => $available
    ];
    return view('smartphones.prepago.detail', $response);
  }

  public function compare (Request $request) {
    $request->validate([
      'product_variation_id' => 'required|array',
      'product_variation_id.*' => 'required|max:9|regex:/(^[0-9]+$)+/',
    ]);

    $products = [];
    foreach ($request->product_variation_id as $product_variation_id) {
      $product = $this->shared->productVariationDetail($product_variation_id);
      if (isset($product)) {
        $product->route = route('prepaid_detail', [
          'brand'=>$product->brand_slug,
          'product'=>$product->product_slug,
          'plan'=>$product->plan_slug,
        ]);
        array_push($products, $product);
      } else {
        abort(404);
      }
    }
    // return $products;
    return view('smartphones.prepago.compare', ['products' => $products]);
  }
}