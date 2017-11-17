<?php

namespace App\Http\Controllers;

use DB;

use App\Product;
use App\Http\Controllers\BaseController;
use Illuminate\Http\Request;

class HomeController extends Controller
{
    protected $shared;

    public function __construct (BaseController $shared) {
        $this->shared = $shared;
    }

    public function index(Request $request) {
        $best_seller_smartphone = $this->shared->searchProduct(1, 3);
        $best_seller_tablet = $this->shared->searchProduct(2, 3);
        $featured_products = $this->shared->searchProduct(1, 2);
        $promo_pre = $this->shared->searchProductPrepaid(1, 4, 1, 'product_id', 'asc');
        $promo_pos = $this->shared->searchProductPostpaid(1 ,4, 1, 'product_id', 'desc');
        return view('index', [
            'best_seller_smartphone' => $best_seller_smartphone,
            'best_seller_tablet' => $best_seller_tablet,
            'featured_products' => $featured_products,
            'promo_prepaid' => $promo_pre['products'],
            'promo_postpaid' => $promo_pos['products'],
        ]);
    }

    private function searchProduct ($product_category_id=1, $pag_total_by_page=20, $pag_actual=1, $sort_by="", $sort_direction="", $product_manufacturer_id='', $product_price_ini=0, $product_price_end=0, $product_string_search="") {
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
}
