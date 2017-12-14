<?php

namespace App\Http\Controllers;

use DB;
use Illuminate\Http\Request;

class BaseController extends Controller
{
  public function searchProductPrepaid ($category_id=1, $plan_id=null, $product_brands='', $pag_total_by_page=20, $pag_actual=1, $sort_by="", $sort_direction="", $product_price_ini=0, $product_price_end=0, $product_string_search="", $product_tag="", $product_ignore_ids="") {
    $products = DB::select('call PA_productSearchPrepago(
      :category_id,
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
      'category_id' => $category_id,
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
      :category_id,
      :product_brands,
      :plan_id,
      :product_price_ini,
      :product_price_end,
      :product_string_search,
      :product_tag,
      :product_ignore_ids
    )', [
      'category_id' => $category_id,
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

  public function searchProductPostpaid ($category_id=1, $affiliation_id=1, $plan_id=7, $contract_id=1, $product_brands='', $pag_total_by_page=20, $pag_actual=1, $sort_by="", $sort_direction="", $product_price_ini=0, $product_price_end=0, $product_string_search="", $product_ignore_ids = "") {
    $products = DB::select('call PA_productSearchPostpago(
      :category_id,
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
      :product_ignore_ids
    )', [
      'category_id' => $category_id,
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
      'product_ignore_ids' => $product_ignore_ids
    ]);

    $total = DB::select('call PA_productCountPostpago(
      :category_id,
      :product_brands,
      :affiliation_id,
      :plan_id,
      :contract_id,
      :product_price_ini,
      :product_price_end,
      :product_string_search,
      :product_ignore_ids
    )', [
      'category_id' => $category_id,
      'product_brands' => strval($product_brands),
      'affiliation_id' => $affiliation_id,
      'plan_id' => $plan_id,
      'contract_id' => $contract_id,
      'product_price_ini' => $product_price_ini,
      'product_price_end' => $product_price_end,
      'product_string_search' => $product_string_search,
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
      :category_id,
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
      'category_id' => $category_id,
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
      :category_id,
      :product_brands,
      :product_price_ini,
      :product_price_end,
      :product_string_search,
      :product_ignore_ids
    )', [
      'category_id' => $category_id,
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

  public function productImagesByStock($stock_model_id) {
    $stock_models = DB::select('call PA_productImagesByStock(
      :stock_model_id
    )', [
      'stock_model_id' => $stock_model_id
    ]);

    return $stock_models;
  }

  public function productStockModels($product_id) {
    $stock_models = DB::select('call PA_productStockModels(
      :product_id
    )', [
      'product_id' => $product_id
    ]);

    return $stock_models;
  }

  public function productSearchPromo($plan_pre_id=null, $plan_post_id=null, $affiliation_id=null, $contract_id=null, $product_brands='', $pag_total_by_page=20, $pag_actual=1, $sort_by="", $sort_direction="", $product_price_ini=0, $product_price_end=0, $product_string_search="") {
    $products = DB::select('call PA_productSearchPromo(
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
      :plan_pre_id,
      :plan_post_id,
      :affiliation_id,
      :contract_id,
      :product_brands,
      :product_price_ini,
      :product_price_end,
      :product_string_search
    )', [
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

  public function statusHistory($order_id = null) {
    $result = DB::select('call PA_orderStatusHistory(
      :order_id
    )', [
      'order_id' => $order_id
    ]);
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
}
