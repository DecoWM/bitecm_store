<?php

namespace App\Http\Controllers;

use DB;
use Validator;
use App\Http\Controllers\BaseController;
use Illuminate\Http\Request;
use Illuminate\Pagination\LengthAwarePaginator as Paginator;
use Illuminate\Support\Facades\Storage;

class ChipController extends Controller
{
  protected $shared;

  public function __construct (BaseController $shared) {
    $this->shared = $shared;
  }

  // CHIP PREPAGO
  public function index(Request $request) {  

    $brand_slug = 'Bitel'; 
    $product_slug = 'chip-bitel';
    //$affiliation_slug = 'portabilidad';
    $plan_slug = 'b-voz';
   //$contract_slug = '18-meses';
    $color_slug = null;

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
    return view('chips.index', $response);
  }

  /*
  public function index(Request $request) {
    $brand_slug = 'lg'; 
    $product_slug = 'stylus-3';
    $affiliation_slug = 'portabilidad';
    $plan_slug = 'ichip-129_90';
    $contract_slug = '18-meses';
    $color_slug = null;

    $brand_slug = 'Bitel'; 
    $product_slug = 'chip-bitel';
    $affiliation_slug = 'portabilidad';
    $plan_slug = 'ichip-29_90';
    $contract_slug = '18-meses';
    $color_slug = null;

    $inputs = [
        'brand_slug' => $brand_slug,
        'product_slug' => $product_slug,
        'affiliation_slug' => $affiliation_slug,
        'plan_slug' => $plan_slug,
        'contract_slug' => $contract_slug,
        'color_slug' => $color_slug
    ];

    $validator = Validator::make($inputs, [
        'brand_slug' => 'required|exists:tbl_brand',
        'product_slug' => 'required|exists:tbl_product',
        'affiliation_slug' => 'required|exists:tbl_affiliation',
        'plan_slug' => 'required|exists:tbl_plan',
        'contract_slug' => 'required|exists:tbl_contract',
        'color_slug' => 'nullable|exists:tbl_color'
    ]);

    if ($validator->fails()) {
        abort(404);
    }

    $product = $this->shared->productPostpaidBySlug($brand_slug,$product_slug,$affiliation_slug,$plan_slug,$contract_slug,$color_slug);
    //error_log(print_r($product), 3, 'c:/nginx-1.12.2/logs/frutaldia.log');

    if(empty($product)) {
      abort(404);
    }

    $available_products = $this->shared->searchProductPostpaid('1,3', $product->affiliation_id, $product->plan_id, $product->contract_id, '', 4, 1, null, null,null, null, null, null, $product->product_id);

    $available = $available_products['products'];
    foreach($available as $i => $item) {
      $available[$i]->route = route('postpaid_detail', [
        'brand'=>$item->brand_slug,
        'product'=>$item->product_slug,
        'plan'=>$plan_slug,
        'affiliation'=>$affiliation_slug,
        'contract'=>$contract_slug
      ]);
      $available[$i]->api_route = route('api_postpaid_detail', [
        'brand'=>$item->brand_slug,
        'product'=>$item->product_slug,
        'plan'=>$plan_slug,
        'affiliation'=>$affiliation_slug,
        'contract'=>$contract_slug
      ]);
    }

    $stock_models = [];
    $product_images = [];
    if($product->stock_model_id) {
      $stock_models = $this->shared->productStockModels($product->product_id);
      foreach($stock_models as $i => $item) {
        $stock_models[$i]->route = route('postpaid_detail', [
          'brand'=>$brand_slug,
          'product'=>$product->product_slug,
          'plan'=>$plan_slug,
          'affiliation'=>$affiliation_slug,
          'contract'=>$contract_slug,
          'color'=>$item->color_slug
        ]);
        $stock_models[$i]->api_route = route('api_postpaid_detail', [
          'brand'=>$brand_slug,
          'product'=>$product->product_slug,
          'plan'=>$plan_slug,
          'affiliation'=>$affiliation_slug,
          'contract'=>$contract_slug,
          'color'=>$item->color_slug
        ]);
      }
      $product_images = $this->shared->productImagesByStock($product->stock_model_id);
    }
    
    $product_plans = $this->shared->getProductPlans($product);
    $product_affiliations = $this->shared->getProductAffiliations($product);

    collect($product_plans)->map(function ($item, $key) use ($product, $color_slug) {
      $item->route = route('postpaid_detail', [
        'brand'=>$product->brand_slug,
        'product'=>$product->product_slug,
        'plan'=>$item->plan_slug,
        'affiliation'=>$item->affiliation_slug,
        'contract'=>$item->contract_slug,
        'color' => isset($color_slug) ? $color_slug : null
      ]);
      $item->api_route = route('api_postpaid_detail', [
        'brand'=>$product->brand_slug,
        'product'=>$product->product_slug,
        'plan'=>$item->plan_slug,
        'affiliation'=>$item->affiliation_slug,
        'contract'=>$item->contract_slug,
        'color' => isset($color_slug) ? $color_slug : null
      ]);
      foreach ($item->affiliations as $key => $affil) {
        $item->affil_classes[] = 'plan_aff_'.$affil;
      }
      $item->affil_classes = implode(' ', $item->affil_classes);
      return $item;
    });

    collect($product_affiliations)->map(function ($item, $key) use ($product, $color_slug) {
      $item->route = route('postpaid_detail', [
        'brand'=>$product->brand_slug,
        'product'=>$product->product_slug,
        'plan'=>$item->plan_slug,
        'affiliation'=>$item->affiliation_slug,
        'contract'=>$item->contract_slug,
        'color' => isset($color_slug) ? $color_slug : null
      ]);
      $item->api_route = route('api_postpaid_detail', [
        'brand'=>$product->brand_slug,
        'product'=>$product->product_slug,
        'plan'=>$item->plan_slug,
        'affiliation'=>$item->affiliation_slug,
        'contract'=>$item->contract_slug,
        'color' => isset($color_slug) ? $color_slug : null
      ]);
      return $item;
    });

    $i = 0;
    foreach($product_plans as $plan) {
      if($plan->affiliation_id == $product->affiliation_id) {
        if($plan->plan_id == $product->plan_id) {
          $selected_plan = $i;
        }
        $i++;
      }
    }

    if(!isset($selected_plan)) {
      $selected_plan = 0;
    }

    $response = [
      'product' => $product,
      'product_images' => $product_images,
      'stock_models' => $stock_models,
      'available' => $available,
      'plans' => $product_plans,
      'affiliations' => $product_affiliations,
      'selected_plan' => $selected_plan,
      'just_3' => $i <= 3
    ];

    return view('chips.index',$response);
  }
*/
}