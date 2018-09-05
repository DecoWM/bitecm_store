<?php

namespace App\Http\Controllers;

use DB;
use App\Http\Controllers\BaseController;
use Illuminate\Http\Request;
use Illuminate\Pagination\LengthAwarePaginator as Paginator;

class PromoController extends Controller
{
  protected $shared;

  public function __construct (BaseController $shared) {
    $this->shared = $shared;
  }

  public function index (Request $request) {
    $items_per_page = 12;
    $current_page = ($request->has('pag')) ? $request->pag : 1;

    $affiliation_id = \Config::get('filter.affiliation_id');
    $plan_pre_id = \Config::get('filter.plan_pre_id');
    $plan_post_id = \Config::get('filter.plan_post_id');
    $contract_id = \Config::get('filter.contract_id');

    $search_result =  $this->shared->productSearchPromo(null, $plan_pre_id, $plan_post_id, $affiliation_id, $contract_id, null, $items_per_page, $current_page, "publish_at", "desc");
    collect($search_result['products'])->map(function ($item, $key) {
      //$item->picture_url = asset('images/productos/'.$item->picture_url);

      if (isset($item->product_variation_id)) {
        $item->product_price = $item->product_variation_price;
        switch ($item->variation_type_id) {
          case 1:
            $item->route = route('prepaid_detail', [
              'brand' => $item->brand_slug,
              'product' => $item->product_slug,
              'plan' => $item->plan_slug
            ]);
            break;
          case 2:
            $item->route = route('postpaid_detail', [
              'brand' => $item->brand_slug,
              'product' => $item->product_slug,
              'plan' => $item->plan_slug,
              'affiliation'=>$item->affiliation_slug,
              'contract'=>$item->contract_slug
            ]);
            break;
        }
      } else {
        if ($item->category_id == \Config::get('filter.accessory_cat_id')) {
          $item->route = route('accessory_detail', [
            'brand'=>$item->brand_slug,
            'product'=>$item->product_slug
          ]);
        }
      }
      return $item;
    });
    $pages = intval(ceil($search_result['total'] / $items_per_page));
    $paginator = new Paginator(
      $search_result['products'],
      $search_result['total'],
      $items_per_page, $current_page,
      [ 'pageName' => 'pag' ]
    );
    $paginator->withPath('accesorios');

    $filterList = $this->shared->getFiltersPromo();

    $banner = $this->shared->getImage(13);

    return view('promo.index', [
      'title' => 'Promociones',
      'products' => $paginator,
      'pages' => $pages,
      'filters' => $filterList,
      'banner' => $banner
    ]);
  }
}
