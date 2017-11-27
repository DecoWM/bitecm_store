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
        $affiliation_id = \Config::get('filter.affiliation');
        $plan_pre_id = \Config::get('filter.plan_prepaid');
        $plan_post_id = \Config::get('filter.plan_postpaid');
        $contract_id = \Config::get('filter.contract');

        $best_seller_smartphone = $this->shared->searchProductPrepaid(1, $plan_pre_id, null, 4);
        $best_seller_smartphone = collect($best_seller_smartphone['products'])->map(function ($item, $key) {
          $item->picture_url = asset('images/productos/'.$item->picture_url);
          if (isset($item->affiliation_id)) {
            $item->route = route('postpaid_detail', [
              'brand'=>$item->brand_slug,
              'product'=>$item->product_slug,
              'affiliation'=>$item->affiliation_slug,
              'plan'=>$item->plan_slug,
              'contract'=>$item->contract_slug
            ]);
          } else {
            $item->route = route('prepaid_detail', [
              'brand'=>$item->brand_slug,
              'product'=>$item->product_slug,
              'plan'=>$item->plan_slug
            ]);
          }
          return $item;
        });
        $best_seller_tablet = $best_seller_smartphone;
        /*$best_seller_tablet = $this->shared->searchProductPrepaid(3, $plan_pre_id, null, 4);
        $best_seller_tablet = collect($best_seller_tablet['products'])->map(function ($item, $key) {
          $item->picture_url = asset('images/productos/'.$item->picture_url);
          if (isset($item->affiliation_id)) {
            $item->route = route('postpaid_detail', [
              'brand'=>$item->brand_slug,
              'product'=>$item->product_slug,
              'affiliation'=>$item->affiliation_slug,
              'plan'=>$item->plan_slug,
              'contract'=>$item->contract_slug
            ]);
          } else {
            $item->route = route('prepaid_detail', [
              'brand'=>$item->brand_slug,
              'product'=>$item->product_slug,
              'plan'=>$item->plan_slug
            ]);
          }
          return $item;
        });*/
        $featured_products = $this->shared->searchProductPostpaid(1, $affiliation_id, $plan_post_id, $contract_id, null, 2);
        $featured_products = collect($featured_products['products'])->map(function ($item, $key) {
          $item->picture_url = asset('images/productos/'.$item->picture_url);
          $item->route = route('postpaid_detail', [
            'brand'=>$item->brand_slug,
            'product'=>$item->product_slug,
            'affiliation'=>$item->affiliation_slug,
            'plan'=>$item->plan_slug,
            'contract'=>$item->contract_slug
          ]);
          return $item;
        });
        $promo_pre = $this->shared->searchProductPrepaid(1, $plan_pre_id, null, 4, 1, 'product_id', 'asc');
        $promo_pre = collect($promo_pre['products'])->map(function ($item, $key) {
          $item->picture_url = asset('images/productos/'.$item->picture_url);
          $item->route = route('prepaid_detail', [
            'brand'=>$item->brand_slug,
            'product'=>$item->product_slug,
            'plan'=>$item->plan_slug
          ]);
          return $item;
        });
        $promo_pos = $this->shared->searchProductPostpaid(1, $affiliation_id, $plan_post_id, $contract_id, null, 4, 1, 'product_id', 'desc');
        $promo_pos = collect($promo_pos['products'])->map(function ($item, $key) {
          $item->picture_url = asset('images/productos/'.$item->picture_url);
          $item->route = route('postpaid_detail', [
            'brand'=>$item->brand_slug,
            'product'=>$item->product_slug,
            'affiliation'=>$item->affiliation_slug,
            'plan'=>$item->plan_slug,
            'contract'=>$item->contract_slug
          ]);
          return $item;
        });
        return view('index', [
            'best_seller_smartphone' => $best_seller_smartphone,
            'best_seller_tablet' => $best_seller_tablet,
            'featured_products' => $featured_products,
            'promo_prepaid' => $promo_pre,
            'promo_postpaid' => $promo_pos,
        ]);
    }
}
