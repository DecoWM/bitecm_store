<?php

namespace App\Http\Controllers;

use DB;

use App\Product;
use App\Http\Controllers\BaseController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class HomeController extends Controller
{
  protected $shared;

  public function __construct (BaseController $shared) {
    $this->shared = $shared;
  }

  public function index(Request $request) {
    $affiliation_id = \Config::get('filter.affiliation_id');
    $plan_pre_id = \Config::get('filter.plan_pre_id');
    $plan_post_id = \Config::get('filter.plan_post_id');
    $contract_id = \Config::get('filter.contract_id');

    $best_seller_smartphone = $this->shared->searchProductPrepaid('1,3', $plan_pre_id, null, 4, 1, null, null, null, null, null, '"Nuevo","Destacado"');
    $best_seller_smartphone = collect($best_seller_smartphone['products'])->map(function ($item, $key) {
      $item->picture_url = asset(Storage::url($item->picture_url));
      $item->route = route('prepaid_detail', [
        'brand'=>$item->brand_slug,
        'product'=>$item->product_slug,
        'plan'=>$item->plan_slug
      ]);
      return $item;
    });
    $best_seller_tablet = $this->shared->searchProductPostpaid('1,3', $affiliation_id, $plan_post_id, $contract_id, null, 4, 1, null, null, null, null, null, '"Nuevo","Destacado"');
    $best_seller_tablet = collect($best_seller_tablet['products'])->map(function ($item, $key) {
      $item->picture_url = asset(Storage::url($item->picture_url));
      $item->route = route('postpaid_detail', [
        'brand'=>$item->brand_slug,
        'product'=>$item->product_slug,
        'affiliation'=>$item->affiliation_slug,
        'plan'=>$item->plan_slug,
        //'contract'=>$item->contract_slug
      ]);
      return $item;
    });
    $featured_products = [];
    $featured_product_1 = $this->shared->productVariationDetail(\Config::get('filter.featured_variation_1'));
    if (isset($featured_product_1)) $featured_products[] = $featured_product_1;
    $featured_product_2 = $this->shared->productVariationDetail(\Config::get('filter.featured_variation_2'));
    if (isset($featured_product_2)) $featured_products[] = $featured_product_2;
    $featured_products = collect($featured_products)->map(function ($item, $key) {
      $item->picture_url = asset(Storage::url($item->picture_url));
      $item->route = route('postpaid_detail', [
        'brand'=>$item->brand_slug,
        'product'=>$item->product_slug,
        'affiliation'=>$item->affiliation_slug,
        'plan'=>$item->plan_slug,
        //'contract'=>$item->contract_slug
      ]);
      return $item;
    });
    $promo_pre = $this->shared->productSearchPromo(1, $plan_pre_id, $plan_post_id, $affiliation_id, $contract_id, null, 8, 1, 'publish_at', 'desc');
    $promo_pre = collect($promo_pre['products'])->map(function ($item, $key) {
      $item->picture_url = asset(Storage::url($item->picture_url));
      $item->route = route('prepaid_detail', [
        'brand'=>$item->brand_slug,
        'product'=>$item->product_slug,
        'plan'=>$item->plan_slug
      ]);
      return $item;
    });
    $promo_pos = $this->shared->productSearchPromo(2, $plan_pre_id, $plan_post_id, $affiliation_id, $contract_id, null, 8, 1, 'publish_at', 'desc');
    $promo_pos = collect($promo_pos['products'])->map(function ($item, $key) {
      $item->picture_url = asset(Storage::url($item->picture_url));
      $item->route = route('postpaid_detail', [
        'brand'=>$item->brand_slug,
        'product'=>$item->product_slug,
        'affiliation'=>$item->affiliation_slug,
        'plan'=>$item->plan_slug,
        //'contract'=>$item->contract_slug
      ]);
      return $item;
    });

    $slider_list = $this->shared->listImages('SLIDER');

    $home_list = $this->shared->listImages('HOME');

    return view('index', [
      'best_seller_smartphone' => $best_seller_smartphone,
      'best_seller_tablet' => $best_seller_tablet,
      'featured_products' => $featured_products,
      'promo_prepaid' => $promo_pre,
      'promo_postpaid' => $promo_pos,
      'slider_images' => $slider_list,
      'home_images' => $home_list,
    ]);
  }
}
