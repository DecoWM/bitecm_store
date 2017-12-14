<?php

namespace App\Http\Controllers;

use DB;
use App\Http\Controllers\BaseController;
use Illuminate\Http\Request;
use Illuminate\Pagination\LengthAwarePaginator as Paginator;

class PrepaidController extends Controller
{
  protected $shared;

  public function __construct (BaseController $shared) {
    $this->shared = $shared;
  }

  public function index(Request $request) {
    $plan_pre_id = \Config::get('filter.plan_pre_id');

    $plan_post_slug = $this->shared->planSlug(\Config::get('filter.plan_post_id'));
    $affiliation_slug = $this->shared->affiliationSlug(\Config::get('filter.affiliation_id'));
    $contract_slug = $this->shared->contractSlug(\Config::get('filter.contract_id'));

    $items_per_page = 12;
    $current_page = ($request->has('pag')) ? $request->pag : 1 ;
    
    $search_result =  $this->shared->searchProductPrepaid(1, $plan_pre_id, null, $items_per_page, $current_page, "publish_at", "desc");

    $pages = intval(ceil($search_result['total'] / $items_per_page));
    $paginator = new Paginator(
      $search_result['products'],
      $search_result['total'],
      $items_per_page, $current_page,
      [ 'pageName' => 'pag' ]
    );
    $paginator->withPath('prepago');

    $filterList = $this->shared->getFiltersPrepaid();

    return view('smartphones.prepago.index', ['products' => $paginator, 'pages' => $pages, 'filters' => $filterList, 'affiliation_slug' => $affiliation_slug, 'plan_post_slug' => $plan_post_slug, 'contract_slug' => $contract_slug]);
  }

  public function show($brand_slug,$product_slug,$plan_slug,$color_slug=null) {
    $product = $this->shared->productPrepaidBySlug($brand_slug,$product_slug,$plan_slug,$color_slug);

    if(empty($product)) {
      abort(404);
    }
    
    $available_products = $this->shared->searchProductPrepaid(1, $product->plan_id, $product->brand_id, 4, 1, null, null, null, null, null, null, $product->product_id);



    $available = $available_products['products'];
    foreach($available as $i => $item) {
      $available[$i]->route = route('prepaid_detail', [
        'brand'=>$brand_slug,
        'product'=>$item->product_slug,
        'plan'=>$plan_slug,
      ]);
    }

    $stock_models = [];
    $product_images = [];
    if($product->stock_model_id) {
      $stock_models = $this->shared->productStockModels($product->product_id);
      foreach($stock_models as $i => $item) {
        $stock_models[$i]->route = route('prepaid_detail', [
          'brand'=>$brand_slug,
          'product'=>$product->product_slug,
          'plan'=>$plan_slug,
          'color'=>$item->color_slug
        ]);
      }
      $product_images = $this->shared->productImagesByStock($product->stock_model_id);
    }

    $plan_post_slug = $this->shared->planSlug(\Config::get('filter.plan_post_id'));
    $affiliation_slug = $this->shared->affiliationSlug(\Config::get('filter.affiliation_id'));
    $contract_slug = $this->shared->contractSlug(\Config::get('filter.contract_id'));

    $response = [
      'product' => $product,
      'product_images' => $product_images,
      'stock_models' => $stock_models,
      'available' => $available,
      'affiliation_slug' => $affiliation_slug,
      'plan_post_slug' => $plan_post_slug,
      'contract_slug' => $contract_slug
    ];
    return view('smartphones.prepago.detail', $response);
  }

  public function compare (Request $request) {
    $request->validate([
      'product_id' => 'required|array',
      'product_id.*' => 'required|max:9|regex:/(^[0-9]+$)+/',
    ]);

    $products = [];
    foreach ($request->product_id as $product_id) {
      $product = DB::select('call PA_productDetail(:product_id)', ['product_id' => $product_id]);
      if (isset($product[0])) {
        $plan_pre_slug = $this->shared->planSlug(\Config::get('filter.plan_pre_id'));

        $product = $product[0];
        $product->route = route('prepaid_detail', [
          'brand'=>$product->brand_slug,
          'product'=>$product->product_slug,
          'plan'=>$plan_pre_slug,
        ]);
        array_push($products, $product);
      } else {
        abort(404);
      }
    }
    // return $products;
    return view('smartphones.prepago.compare', ['products' => $products]);
  }
}
