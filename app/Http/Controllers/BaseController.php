<?php

namespace App\Http\Controllers;

use DB;
use Illuminate\Http\Request;

class BaseController extends Controller
{
    public function searchProduct ($product_category_id=1, $pag_total_by_page=20, $pag_actual=1, $sort_by="", $sort_direction="", $product_manufacturer_id='', $product_price_ini=0, $product_price_end=0, $product_string_search="") {
        $products = DB::select('call PA_productSearchPrepago(
            :product_category_id,
            :product_manufacturers,
            :product_price_ini,
            :product_price_end,
            :product_string_search,
            :pag_total_by_page,
            :pag_actual,
            :sort_by,
            :sort_direction
          )', [
            'product_category_id' => $product_category_id,
            'product_manufacturers' => $product_manufacturer_id,
            'product_price_ini' => $product_price_ini,
            'product_price_end' => $product_price_end,
            'product_string_search' => $product_string_search,
            'pag_total_by_page' => $pag_total_by_page,
            'pag_actual' => $pag_actual,
            'sort_by' => $sort_by,
            'sort_direction' => $sort_direction,
          ]);
        // var_dump($products);
        return $products;
    }

    public function searchProductPrepaid ($product_category_id=1, $pag_total_by_page=20, $pag_actual=1, $sort_by="", $sort_direction="", $product_manufacturers='', $product_price_ini=0, $product_price_end=0, $product_string_search="") {
        $products = DB::select('call PA_productSearchPrepago(
            :product_category_id,
            :product_manufacturers,
            :product_price_ini,
            :product_price_end,
            :product_string_search,
            :pag_total_by_page,
            :pag_actual,
            :sort_by,
            :sort_direction
          )', [
            'product_category_id' => $product_category_id,
            'product_manufacturers' => $product_manufacturers,
            'product_price_ini' => $product_price_ini,
            'product_price_end' => $product_price_end,
            'product_string_search' => $product_string_search,
            'pag_total_by_page' => $pag_total_by_page,
            'pag_actual' => $pag_actual,
            'sort_by' => $sort_by,
            'sort_direction' => $sort_direction,
          ]);

        $total = DB::select('call PA_productCountPrepago(
            :product_category_id,
            :product_manufacturers,
            :product_price_ini,
            :product_price_end,
            :product_string_search
          )', [
            'product_category_id' => $product_category_id,
            'product_manufacturers' => $product_manufacturers,
            'product_price_ini' => $product_price_ini,
            'product_price_end' => $product_price_end,
            'product_string_search' => $product_string_search
          ]);

        return ['products' => $products, 'total' => $total[0]->total_products];
    }

    public function searchProductPostpaid ($product_category_id=1, $pag_total_by_page=20, $pag_actual=1, $sort_by="", $sort_direction="", $product_manufacturers='', $product_price_ini=0, $product_price_end=0, $product_string_search="", $affiliation_id=1, $plan_id=6) {
        $products = DB::select('call PA_productSearchPostpago(
            :product_category_id,
            :product_manufacturers,
            :affiliation_id,
            :plan_id,
            :product_price_ini,
            :product_price_end,
            :product_string_search,
            :pag_total_by_page,
            :pag_actual,
            :sort_by,
            :sort_direction
            )', [
            'product_category_id' => $product_category_id,
            'product_manufacturers' => $product_manufacturers,
            'affiliation_id' => $affiliation_id,
            'plan_id' => $plan_id,
            'product_price_ini' => $product_price_ini,
            'product_price_end' => $product_price_end,
            'product_string_search' => $product_string_search,
            'pag_total_by_page' => $pag_total_by_page,
            'pag_actual' => $pag_actual,
            'sort_by' => $sort_by,
            'sort_direction' => $sort_direction,
        ]);

        $total = DB::select('call PA_productCountPostpago(
            :product_category_id,
            :product_manufacturers,
            :affiliation_id,
            :plan_id,
            :product_price_ini,
            :product_price_end,
            :product_string_search
            )', [
            'product_category_id' => $product_category_id,
            'product_manufacturers' => $product_manufacturers,
            'affiliation_id' => $affiliation_id,
            'plan_id' => $plan_id,
            'product_price_ini' => $product_price_ini,
            'product_price_end' => $product_price_end,
            'product_string_search' => $product_string_search
        ]);

        return ['products' => $products, 'total' => $total[0]->total_products];
    }

    public function getFiltersPostpaid () {
        $affiliation_list = DB::select('call PA_affiliationList()');
        $plan_list = DB::select('call PA_planList()');
        $brand_list = DB::select('call PA_brandList()');
        return [
            'affiliation_list' => $affiliation_list,
            'plan_list' => $plan_list,
            'brand_list' => $brand_list,
        ];
    }

    public function getFiltersPrepaid () {
        $brand_list = DB::select('call PA_brandList()');
        return [
            'brand_list' => $brand_list,
        ];
    }

    public function getFiltersAccessories () {
        $brand_list = DB::select('call PA_brandList()');
        return [
            'brand_list' => $brand_list,
        ];
    }
}
