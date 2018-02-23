<?php

namespace App\Http\Controllers;

use DB;
use Route;
use Illuminate\Support\Facades\Session;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;


class BaseController extends Controller
{
  public function searchProductPrepaid ($category_id=1, $plan_id=null, $product_brands='', $pag_total_by_page=20, $pag_actual=1, $sort_by="", $sort_direction="", $product_price_ini=0, $product_price_end=0, $product_string_search="", $product_tag="", $product_ignore_ids="") {
    $products = DB::select('call PA_productSearchPrepago(
      :product_categories,
      :product_brands,
      :plan_id,
      :product_price_ini,
      :product_price_end,
      :product_string_search,
      :pag_total_by_page,
      :pag_actual,
      :sort_by,
      :sort_direction,
      :product_tag,
      :product_ignore_ids
    )', [
      'product_categories' => $category_id,
      'product_brands' => strval($product_brands),
      'plan_id' => $plan_id,
      'product_price_ini' => $product_price_ini,
      'product_price_end' => $product_price_end,
      'product_string_search' => $product_string_search,
      'pag_total_by_page' => $pag_total_by_page,
      'pag_actual' => $pag_actual,
      'sort_by' => $sort_by,
      'sort_direction' => $sort_direction,
      'product_tag' => $product_tag,
      'product_ignore_ids' => $product_ignore_ids
    ]);

    $total = DB::select('call PA_productCountPrepago(
      :product_categories,
      :product_brands,
      :plan_id,
      :product_price_ini,
      :product_price_end,
      :product_string_search,
      :product_tag,
      :product_ignore_ids
    )', [
      'product_categories' => $category_id,
      'product_brands' => strval($product_brands),
      'plan_id' => $plan_id,
      'product_price_ini' => $product_price_ini,
      'product_price_end' => $product_price_end,
      'product_string_search' => $product_string_search,
      'product_tag' => $product_tag,
      'product_ignore_ids' => $product_ignore_ids
    ]);

    return ['products' => $products, 'total' => $total[0]->total_products];
  }

  public function productPrepaidBySlug($brand,$product,$plan,$color=null) {
    $result = DB::select('call PA_productPrepagoBySlug(
      :brand_slug,
      :product_slug,
      :plan_slug,
      :color_slug
    )', [
      'brand_slug' => $brand,
      'product_slug' => $product,
      'plan_slug' => $plan,
      'color_slug' => $color
    ]);

    return count($result) > 0 ? $result[0] : null;
  }

  public function productPrepagoByStock($stock_model_id,$product_variation_id) {
    $result = DB::select('call PA_productPrepagoByStock(
      :stock_model_id,
      :product_variation_id
    )', [
      'stock_model_id' => $stock_model_id,
      'product_variation_id' => $product_variation_id
    ]);

    return count($result) > 0 ? $result[0] : null;
  }

  public function searchProductPostpaid($category_id=1, $affiliation_id=1, $plan_id=7, $contract_id=1, $product_brands='', $pag_total_by_page=20, $pag_actual=1, $sort_by="", $sort_direction="", $product_price_ini=0, $product_price_end=0, $product_string_search="", $product_tag="", $product_ignore_ids = "") {
    $products = DB::select('call PA_productSearchPostpago(
      :product_categories,
      :product_brands,
      :affiliation_id,
      :plan_id,
      :contract_id,
      :product_price_ini,
      :product_price_end,
      :product_string_search,
      :pag_total_by_page,
      :pag_actual,
      :sort_by,
      :sort_direction,
      :product_tag,
      :product_ignore_ids
    )', [
      'product_categories' => $category_id,
      'product_brands' => strval($product_brands),
      'affiliation_id' => $affiliation_id,
      'plan_id' => $plan_id,
      'contract_id' => $contract_id,
      'product_price_ini' => $product_price_ini,
      'product_price_end' => $product_price_end,
      'product_string_search' => $product_string_search,
      'pag_total_by_page' => $pag_total_by_page,
      'pag_actual' => $pag_actual,
      'sort_by' => $sort_by,
      'sort_direction' => $sort_direction,
      'product_tag' => $product_tag,
      'product_ignore_ids' => $product_ignore_ids
    ]);

    $total = DB::select('call PA_productCountPostpago(
      :product_categories,
      :product_brands,
      :affiliation_id,
      :plan_id,
      :contract_id,
      :product_price_ini,
      :product_price_end,
      :product_string_search,
      :product_tag,
      :product_ignore_ids
    )', [
      'product_categories' => $category_id,
      'product_brands' => strval($product_brands),
      'affiliation_id' => $affiliation_id,
      'plan_id' => $plan_id,
      'contract_id' => $contract_id,
      'product_price_ini' => $product_price_ini,
      'product_price_end' => $product_price_end,
      'product_string_search' => $product_string_search,
      'product_tag' => $product_tag,
      'product_ignore_ids' => $product_ignore_ids
    ]);

    return ['products' => $products, 'total' => $total[0]->total_products];
  }

  public function productPostpaidBySlug($brand,$product,$affiliation,$plan,$contract,$color=null) {
    $result = DB::select('call PA_productPostpagoBySlug(
      :brand_slug,
      :product_slug,
      :affiliation_slug,
      :plan_slug,
      :contract_slug,
      :color_slug
    )', [
      'brand_slug' => $brand,
      'product_slug' => $product,
      'affiliation_slug' => $affiliation,
      'plan_slug' => $plan,
      'contract_slug' => $contract,
      'color_slug' => $color
    ]);

    return count($result) > 0 ? $result[0] : null;
  }

  public function productPostpagoByStock($stock_model_id,$product_variation_id) {
    $result = DB::select('call PA_productPostpagoByStock(
      :stock_model_id,
      :product_variation_id
    )', [
      'stock_model_id' => $stock_model_id,
      'product_variation_id' => $product_variation_id
    ]);

    return count($result) > 0 ? $result[0] : null;
  }

  public function productSearch($category_id=2, $product_brands='', $pag_total_by_page=20, $pag_actual=1, $sort_by="", $sort_direction="", $product_price_ini=0, $product_price_end=0, $product_string_search="", $product_ignore_ids="") {
    $products = DB::select('call PA_productSearch(
      :product_categories,
      :product_brands,
      :product_price_ini,
      :product_price_end,
      :product_string_search,
      :pag_total_by_page,
      :pag_actual,
      :sort_by,
      :sort_direction,
      :product_ignore_ids
    )', [
      'product_categories' => $category_id,
      'product_brands' => strval($product_brands),
      'product_price_ini' => $product_price_ini,
      'product_price_end' => $product_price_end,
      'product_string_search' => $product_string_search,
      'pag_total_by_page' => $pag_total_by_page,
      'pag_actual' => $pag_actual,
      'sort_by' => $sort_by,
      'sort_direction' => $sort_direction,
      'product_ignore_ids' => $product_ignore_ids
    ]);

    $total = DB::select('call PA_productCount(
      :product_categories,
      :product_brands,
      :product_price_ini,
      :product_price_end,
      :product_string_search,
      :product_ignore_ids
    )', [
      'product_categories' => $category_id,
      'product_brands' => strval($product_brands),
      'product_price_ini' => $product_price_ini,
      'product_price_end' => $product_price_end,
      'product_string_search' => $product_string_search,
      'product_ignore_ids' => $product_ignore_ids
    ]);

    return ['products' => $products, 'total' => $total[0]->total_products];
  }

  public function productBySlug($brand,$product,$color=null) {
    $result = DB::select('call PA_productBySlug(
      :brand_slug,
      :product_slug,
      :color_slug
    )', [
      'brand_slug' => $brand,
      'product_slug' => $product,
      'color_slug' => $color
    ]);

    return count($result) > 0 ? $result[0] : null;
  }

  public function productByStock($stock_model_id) {
    $result = DB::select('call PA_productByStock(
      :stock_model_id
    )', [
      'stock_model_id' => $stock_model_id
    ]);

    return count($result) > 0 ? $result[0] : null;
  }

  public function productDetail($product_id = null) {
    $result = DB::select('call PA_productDetail(
      :product_id
    )', [
      'product_id' => $product_id
    ]);
    return count($result) > 0 ? $result[0] : null;
  }

  public function productVariationDetail($product_variation_id = null) {

    $result = DB::select('call PA_productVariationDetail(
      :product_variation_id
    )', [
      'product_variation_id' => $product_variation_id
    ]);
    return count($result) > 0 ? $result[0] : null;
  }

  public function productImagesByStock($stock_model_id) {
    $stock_models = DB::select('call PA_productImagesByStock(
      :stock_model_id
    )', [
      'stock_model_id' => $stock_model_id
    ]);

    return $stock_models;
  }

  public function productStockModels($product_id, $color_required = 1) {
    $stock_models = DB::select('call PA_productStockModels(
      :product_id,
      :color_required
    )', [
      'product_id' => $product_id,
      'color_required' => $color_required
    ]);

    return $stock_models;
  }

  public function productSearchPromo($variation_type_id=null, $plan_pre_id=null, $plan_post_id=null, $affiliation_id=null, $contract_id=null, $product_brands='', $pag_total_by_page=20, $pag_actual=1, $sort_by="", $sort_direction="", $product_price_ini=0, $product_price_end=0, $product_string_search="") {
    $products = DB::select('call PA_productSearchPromo(
      :variation_type_id,
      :plan_pre_id,
      :plan_post_id,
      :affiliation_id,
      :contract_id,
      :product_brands,
      :product_price_ini,
      :product_price_end,
      :product_string_search,
      :pag_total_by_page,
      :pag_actual,
      :sort_by,
      :sort_direction
    )', [
      'variation_type_id' => $variation_type_id,
      'plan_pre_id' => $plan_pre_id,
      'plan_post_id' => $plan_post_id,
      'affiliation_id' => $affiliation_id,
      'contract_id' => $contract_id,
      'product_brands' => strval($product_brands),
      'product_price_ini' => $product_price_ini,
      'product_price_end' => $product_price_end,
      'product_string_search' => $product_string_search,
      'pag_total_by_page' => $pag_total_by_page,
      'pag_actual' => $pag_actual,
      'sort_by' => $sort_by,
      'sort_direction' => $sort_direction,
    ]);

    $total = DB::select('call PA_productCountPromo(
      :variation_type_id,
      :plan_pre_id,
      :plan_post_id,
      :affiliation_id,
      :contract_id,
      :product_brands,
      :product_price_ini,
      :product_price_end,
      :product_string_search
    )', [
      'variation_type_id' => $variation_type_id,
      'plan_pre_id' => $plan_pre_id,
      'plan_post_id' => $plan_post_id,
      'affiliation_id' => $affiliation_id,
      'contract_id' => $contract_id,
      'product_brands' => strval($product_brands),
      'product_price_ini' => $product_price_ini,
      'product_price_end' => $product_price_end,
      'product_string_search' => $product_string_search
    ]);

    return ['products' => $products, 'total' => $total[0]->total_promos];
  }

  public function insertStoreOrder (
        $order_id ,
        $idtype_id ,
        $payment_method_id ,
        $branch_id ,
        $tracking_code ,
        $first_name ,
        $last_name,
        $id_number,
        $billing_district,
        $billing_phone,
        $source_operator = null,
        $porting_phone = null,
        $delivery_address ,
        $delivery_district ,
        $contact_email ,
        $contact_phone ,
        $service_type = null,
        $affiliation_type = null,
        $porting_request_id = null,
        $total,
        $total_igv
  ) {
    $result = DB::select('call PA_INS_storeOrder(
        :order_id,
        :idtype_id,
        :payment_method_id,
        :branch_id,
        :tracking_code,
        :first_name,
        :last_name,
        :id_number,
        :billing_district,
        :billing_phone,
        :source_operator,
        :porting_phone,
        :delivery_address,
        :delivery_district,
        :contact_email,
        :contact_phone,
        :service_type,
        :affiliation_type,
        :porting_request_id,
        :total,
        :total_igv
    )', [
        'order_id' => $order_id,
        'idtype_id'=> $idtype_id,
        'payment_method_id' => $payment_method_id,
        'branch_id' => $branch_id,
        'tracking_code' => $tracking_code,
        'first_name'=> $first_name,
        'last_name'=> $last_name,
        'id_number' => $id_number,
        'billing_district' => $billing_district,
        'billing_phone' => $billing_phone,
        'source_operator' => $source_operator,
        'porting_phone' => $porting_phone,
        'delivery_address' => $delivery_address,
        'delivery_district' => $delivery_district,
        'contact_email' => $contact_email,
        'contact_phone' => $contact_phone,
        'service_type' => $service_type,
        'affiliation_type' => $affiliation_type,
        'porting_request_id' => $porting_request_id,
        'total' => $total,
        'total_igv' => $total_igv
    ]);

    return 0;
  }

  public function getMaxStoreOrderID () {

    $result = DB::select('call PA_storeOrderMaxID()');

    return $result[0]->order_id;
  }

  public function getProductPlans($product) {
    $affiliation_id = \Config::get('filter.affiliation_id');
    $contract_id = \Config::get('filter.contract_id');
    
    $result = DB::table('tbl_product_variation')
      ->join('tbl_plan', 'tbl_product_variation.plan_id', '=', 'tbl_plan.plan_id')
      ->join('tbl_affiliation', 'tbl_affiliation.affiliation_id', '=', 'tbl_product_variation.affiliation_id')
      ->join('tbl_contract', 'tbl_contract.contract_id', '=', 'tbl_product_variation.contract_id')
      ->where('tbl_product_variation.variation_type_id', 2)
      ->where('tbl_product_variation.active', 1)
      ->where('tbl_plan.active', 1)
      ->where('tbl_affiliation.active', 1)
      ->where('tbl_contract.active', 1)
      ->where('tbl_product_variation.product_id', $product->product_id)
      /*->where(function ($query) use ($product, $affiliation_id, $contract_id) {
        $query
          ->where(function ($subquery) use ($product) {
            $subquery
              ->where('tbl_product_variation.affiliation_id', $product->affiliation_id)
              ->where('tbl_product_variation.contract_id', $product->contract_id);
          })
          ->orWhere(function ($subquery) use ($affiliation_id, $contract_id) {
            $subquery
              ->where('tbl_product_variation.affiliation_id', $affiliation_id)
              ->where('tbl_product_variation.contract_id', $contract_id);
          })
          ->orWhere(DB::raw('null'));
      })*/
      ->orderBy('tbl_plan.weight')
      ->orderBy('tbl_plan.plan_id')
      ->orderBy('tbl_plan.plan_price')
      ->select(DB::raw('tbl_plan.*, tbl_affiliation.affiliation_id, tbl_affiliation.affiliation_slug, tbl_contract.contract_id, tbl_contract.contract_slug'))
      ->get();
    
    $unique = [];

    foreach ($result as $key => $plan) {
      if (!isset($unique[$plan->plan_id])) {
        $unique[$plan->plan_id] = $plan;
      } else {
        if (($unique[$plan->plan_id]->affiliation_id != $product->affiliation_id || $unique[$plan->plan_id]->contract_id != $product->contract_id) && (($plan->affiliation_id == $product->affiliation_id && $plan->contract_id == $product->contract_id) || ($plan->affiliation_id == $affiliation_id && $plan->contract_id == $contract_id))) {
          $unique[$plan->plan_id] = $plan;
        }
      }
    }

    foreach ($result as $key => $plan) {
      $unique[$plan->plan_id]->affiliations[] = $plan->affiliation_id;
    }

    return array_values($unique);
  }

  public function getProductAffiliations($product) {
    $plan_id = \Config::get('filter.plan_post_id');
    $contract_id = \Config::get('filter.contract_id');
    
    $result = DB::table('tbl_product_variation')
      ->join('tbl_plan', 'tbl_product_variation.plan_id', '=', 'tbl_plan.plan_id')
      ->join('tbl_affiliation', 'tbl_affiliation.affiliation_id', '=', 'tbl_product_variation.affiliation_id')
      ->join('tbl_contract', 'tbl_contract.contract_id', '=', 'tbl_product_variation.contract_id')
      ->where('tbl_product_variation.variation_type_id', 2)
      ->where('tbl_product_variation.active', 1)
      ->where('tbl_plan.active', 1)
      ->where('tbl_affiliation.active', 1)
      ->where('tbl_contract.active', 1)
      ->where('tbl_product_variation.product_id', $product->product_id)
      /*->where(function ($query) use ($product, $plan_id, $contract_id) {
        $query
          ->where(function ($subquery) use ($product) {
            $subquery
              ->where('tbl_product_variation.plan_id', $product->plan_id)
              ->where('tbl_product_variation.contract_id', $product->contract_id);
          })
          ->orWhere(function ($subquery) use ($plan_id, $contract_id) {
            $subquery
              ->where('tbl_product_variation.plan_id', $plan_id)
              ->where('tbl_product_variation.contract_id', $contract_id);
          })
          ->orWhere(DB::raw('null'));
      })*/
      ->orderBy('tbl_affiliation.weight')
      ->orderBy('tbl_affiliation.affiliation_id')
      ->select(DB::raw('tbl_affiliation.*, tbl_plan.plan_id, tbl_plan.plan_slug, tbl_contract.contract_id, tbl_contract.contract_slug'))
      ->get();

    $unique = [];

    foreach ($result as $key => $affiliation) {
      if(!isset($unique[$affiliation->affiliation_id])) {
        $unique[$affiliation->affiliation_id] = $affiliation;
      } else {
        if(($unique[$affiliation->affiliation_id]->plan_id != $product->plan_id || $unique[$affiliation->affiliation_id]->contract_id != $product->contract_id) && (($affiliation->plan_id == $product->plan_id && $affiliation->contract_id == $product->contract_id) || ($affiliation->plan_id == $plan_id && $affiliation->contract_id == $contract_id))) {
          $unique[$affiliation->affiliation_id] = $affiliation;
        }
      }
    }

    return array_values($unique);
  }

  public function statusHistory($order_id = null) {
    $result = DB::select('call PA_orderStatusHistory(
      :order_id
    )', [
      'order_id' => $order_id
    ]);
    return $result;
  }

  public function statusList() {
    $result = DB::table('tbl_order_status')->get();
    return $result;
  }

  public function getFiltersPostpaid() {
    $brand_list = DB::select('call PA_brandList()');
    $plan_list = DB::select('call PA_planList(2)');
    $affiliation_list = DB::select('call PA_affiliationList()');
    return [
      'brand_list' => $brand_list,
      'plan_list' => $plan_list,
      'affiliation_list' => $affiliation_list,
    ];
  }

  public function getFiltersPrepaid() {
    $brand_list = DB::select('call PA_brandList()');
    $plan_list = DB::select('call PA_planList(1)');
    return [
      'brand_list' => $brand_list,
      'plan_list' => $plan_list,
    ];
  }

  public function getFiltersProduct() {
    $brand_list = DB::select('call PA_brandList()');
    return [
      'brand_list' => $brand_list,
    ];
  }

  public function getFiltersPromo() {
    $brand_list = DB::select('call PA_brandList()');
    return [
      'brand_list' => $brand_list,
    ];
  }

  public function orderItems($order_id) {
    $items = DB::select('call PA_orderItems(
      :order_id
    )', [
      'order_id' => $order_id
    ]);
    return $items;
  }

  public function planSlug($plan_id) {
    $slug = DB::select('call PA_planSlug(
      :plan_id
    )', [
      'plan_id' => $plan_id
    ]);
    return count($slug) > 0 ? $slug[0]->plan_slug : null;
  }

  public function affiliationSlug($affiliation_id) {
    $slug = DB::select('call PA_affiliationSlug(
      :affiliation_id
    )', [
      'affiliation_id' => $affiliation_id
    ]);
    return count($slug) > 0 ? $slug[0]->affiliation_slug : null;
  }

  public function contractSlug($contract_id) {
    $slug = DB::select('call PA_contractSlug(
      :contract_id
    )', [
      'contract_id' => $contract_id
    ]);
    return count($slug) > 0 ? $slug[0]->contract_slug : null;
  }

  public function districtsList() {
    $district_list = DB::select('call PA_districtList()');
    return count($district_list) > 0 ? $district_list : null;
  }

  public function branchByDistrict($district_id) {
    $branch = DB::select('call PA_branchByDistrict(:district_id)', ['district_id' => $district_id]);
    return count($branch) > 0 ? $branch[0]->branch_id : null;
  }

  public function operatorList() {
    return [
      '30' => 'Convergia Perú S.A.',
      '37' => 'Americatel Perú S.A.C',
      '32' => 'Fijo - Telefónica del Perú S.A.A.',
      '20' => 'Entel Perú S.A',
      '21' => 'Claro, América Móvil S.A.C',
      '22' => 'Movistar, Telefónica Móviles S.A',
      '24' => 'Viettel Peru S.A.C.',
      '25' => 'Virgin Mobile'
    ];
  }

  public static function setPreviousUrl($url) {
    Session::put('back_button', $url);
  }

  public static function getPreviousUrl() {
    return Session::get('back_button', null);
  }

  public function listImages($type) {
    $image_list = DB::table('tbl_image')
      ->where('tbl_image.image_type', $type)
      ->select('tbl_image.image_id', 'tbl_image.image_name', 'tbl_image.image_description', 'tbl_image.image_url', 'tbl_image.imagem_url', 'tbl_image.image_link', 'active')
      ->get();

    foreach ($image_list as $image) {
      $image->image_url = asset(Storage::url($image->image_url));
      $image->imagem_url = asset(Storage::url($image->imagem_url));  // CLES 23-02-2018
    }

    return $image_list;
  }

  public function getImage($image_id) {
    return DB::table('tbl_image')
      ->where('image_id', $image_id)
      ->first();
  }
}
