<?php

namespace App\Http\Controllers\Api;

use DB;
use Validator;
use App\Http\Controllers\BaseController;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Pagination\LengthAwarePaginator as Paginator;
use Illuminate\Support\Facades\Storage;

class PrepaidController extends Controller
{

    protected $shared;

    public function __construct (BaseController $shared) {
      $this->shared = $shared;
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
            return response()->json(["error" => ["message" => "Product not found."]], 404);
        }

      $product = $this->shared->productPrepaidBySlug($brand_slug,$product_slug,$plan_slug,$color_slug);

      if(empty($product)) {
          return response()->json(["error" => ["message" => "Product not found."]], 404);
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

      $plan_post_slug = $this->shared->planSlug(\Config::get('filter.plan_post_id'));
      $affiliation_slug = $this->shared->affiliationSlug(\Config::get('filter.affiliation_id'));
      $contract_slug = $this->shared->contractSlug(\Config::get('filter.contract_id'));

      $response = [
        'product' => $product,
        'product_images' => $product_images,
        'stock_models' => $stock_models,
        'available' => $available,
        'affiliation_slug' => $affiliation_slug,
        'plan_post_slug' => $plan_post_slug,
        'contract_slug' => $contract_slug
      ];

      return response()->json($response, 200);
    }
}
