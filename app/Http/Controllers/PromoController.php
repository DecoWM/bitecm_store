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

    $search_result =  $this->shared->productSearch(2, null, $items_per_page, $current_page, "product_model", "desc");
    collect($search_result['products'])->map(function ($item, $key) {
      $item->picture_url = asset('images/productos/'.$item->picture_url);
      $item->route = route('accessory_detail', [
        'brand'=>$item->brand_slug,
        'product'=>$item->product_slug
      ]);
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

    $filterList = $this->shared->getFiltersProduct();

    return view('promo.index', [
      'title' => 'Accesorios',
      'products' => $paginator,
      'pages' => $pages,
      'filters' => $filterList
    ]);
  }

  public function show($brand,$product,$color=null) {
      $product = $this->shared->accessoryBySlug($brand,$product,$color);
      $available_products = $this->shared->searchAccessories(1, $plan, 4);
      $response = [
          'product' => $product[0],
          'available' => $available_products
      ];
      return view('accesories.detail', $response);
  }
}
