<?php

namespace App\Http\Controllers;

use DB;
use Illuminate\Http\Request;

class BaseController extends Controller
{
  public function searchProductPrepaid ($category_id=1, $plan_id=null, $product_brands='', $pag_total_by_page=20, $pag_actual=1, $sort_by="", $sort_direction="", $product_price_ini=0, $product_price_end=0, $product_string_search="") {
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
      :sort_direction
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
    ]);

    $total = DB::select('call PA_productCountPrepago(
      :category_id,
      :product_brands,
      :plan_id,
      :product_price_ini,
      :product_price_end,
      :product_string_search
    )', [
      'category_id' => $category_id,
      'product_brands' => strval($product_brands),
      'plan_id' => $plan_id,
      'product_price_ini' => $product_price_ini,
      'product_price_end' => $product_price_end,
      'product_string_search' => $product_string_search
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

  public function searchProductPostpaid ($category_id=1, $affiliation_id=1, $plan_id=7, $contract_id=1, $product_brands='', $pag_total_by_page=20, $pag_actual=1, $sort_by="", $sort_direction="", $product_price_ini=0, $product_price_end=0, $product_string_search="") {
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
      :sort_direction
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
    ]);

    $total = DB::select('call PA_productCountPostpago(
      :category_id,
      :product_brands,
      :affiliation_id,
      :plan_id,
      :contract_id,
      :product_price_ini,
      :product_price_end,
      :product_string_search
    )', [
      'category_id' => $category_id,
      'product_brands' => strval($product_brands),
      'affiliation_id' => $affiliation_id,
      'plan_id' => $plan_id,
      'contract_id' => $contract_id,
      'product_price_ini' => $product_price_ini,
      'product_price_end' => $product_price_end,
      'product_string_search' => $product_string_search
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

  public function productPostpaidByStock($stock_model_id,$product_variation_id) {
    $result = DB::select('call PA_productPostpagoByStock(
      :stock_model_id,
      :product_variation_id
    )', [
      'stock_model_id' => $stock_model_id,
      'product_variation_id' => $product_variation_id
    ]);

    return count($result) > 0 ? $result[0] : null;
  }

  public function productSearch($category_id=2, $product_brands='', $pag_total_by_page=20, $pag_actual=1, $sort_by="", $sort_direction="", $product_price_ini=0, $product_price_end=0, $product_string_search="") {
    $products = DB::select('call PA_productSearch(
      :category_id,
      :product_brands,
      :product_price_ini,
      :product_price_end,
      :product_string_search,
      :pag_total_by_page,
      :pag_actual,
      :sort_by,
      :sort_direction
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
    ]);

    $total = DB::select('call PA_productCount(
      :category_id,
      :product_brands,
      :product_price_ini,
      :product_price_end,
      :product_string_search
    )', [
      'category_id' => $category_id,
      'product_brands' => strval($product_brands),
      'product_price_ini' => $product_price_ini,
      'product_price_end' => $product_price_end,
      'product_string_search' => $product_string_search
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
}
