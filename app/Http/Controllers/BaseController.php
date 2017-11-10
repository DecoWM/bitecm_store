<?php

namespace App\Http\Controllers;

use DB;
use Illuminate\Http\Request;

class BaseController extends Controller
{
    public function searchProduct ($product_category_id=1, $pag_total_by_page=20, $pag_actual=1, $sort_by="", $sort_direction="", $product_manufacturer_id='', $product_price_ini=0, $product_price_end=0, $product_string_search="") {
        $products = DB::select('call PA_productSearch(
            :product_category_id,
            :product_manufacturer_id,
            :product_price_ini,
            :product_price_end,
            :product_string_search,
            :pag_total_by_page,
            :pag_actual,
            :sort_by,
            :sort_direction
          )', [
            'product_category_id' => $product_category_id,
            'product_manufacturer_id' => $product_manufacturer_id,
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
}
