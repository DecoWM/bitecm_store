<?php

namespace App\Http\Controllers;

use DB;
use Validator;
use App\Http\Controllers\BaseController;
use Illuminate\Http\Request;
use Illuminate\Pagination\LengthAwarePaginator as Paginator;

class AccessoriesController extends Controller
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
      //$item->picture_url = asset('images/productos/'.$item->picture_url);
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

    $banner = $this->shared->getImage(12);

    return view('products.index', [
      'title' => 'Accesorios',
      'products' => $paginator,
      'pages' => $pages,
      'filters' => $filterList,
      'banner' => $banner
    ]);
  }

  public function show($brand_slug,$product_slug,$color_slug=null) {
      $inputs = [
          'brand_slug' => $brand_slug,
          'product_slug' => $product_slug,
          'color_slug' => $color_slug
      ];

      $validator = Validator::make($inputs, [
          'brand_slug' => 'required|exists:tbl_brand',
          'product_slug' => 'required|exists:tbl_product',
          'color_slug' => 'nullable|exists:tbl_color'
      ]);

      if ($validator->fails()) {
          abort(404);
      }

    $product = $this->shared->productBySlug($brand_slug,$product_slug,$color_slug);

    if(empty($product)) {
      abort(404);
    }

    $available_products = $this->shared->productSearch(2, null, 4, null, null, null, null, null, null, $product->product_id);

    $available = $available_products['products'];
    foreach($available as $i => $item) {
      //$available[$i]->picture_url = asset('images/productos/'.$item->picture_url);
      $available[$i]->route = route('accessory_detail', [
        'brand'=>$item->brand_slug,
        'product'=>$item->product_slug
      ]);
      $available[$i]->api_route = route('api_accessory_detail', [
        'brand'=>$item->brand_slug,
        'product'=>$item->product_slug
      ]);
    }
    $stock_models = [];
    $product_images = [];
    if($product->stock_model_id) {
      $stock_models = $this->shared->productStockModels($product->product_id);
      foreach($stock_models as $i => $item) {
        $stock_models[$i]->route = route('accessory_detail', [
          'brand'=>$brand_slug,
          'product'=>$product->product_slug,
          'color'=>$item->color_slug
        ]);
        $stock_models[$i]->api_route = route('api_accessory_detail', [
          'brand'=>$brand_slug,
          'product'=>$product->product_slug,
          'color'=>$item->color_slug
        ]);
      }
      $product_images = $this->shared->productImagesByStock($product->stock_model_id);
    }
    $response = [
      'title' => 'Accesorios',
      'product' => $product,
      'product_images' => $product_images,
      'stock_models' => $stock_models,
      'available' => $available
    ];
    return view('products.detail', $response);
  }
}
