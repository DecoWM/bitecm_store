<?php

namespace App\Http\Controllers;

use DB;
use Validator;
use App\Http\Controllers\BaseController;
use Illuminate\Http\Request;
use Illuminate\Pagination\LengthAwarePaginator as Paginator;

class PostpaidController extends Controller
{
  protected $shared;

  public function __construct (BaseController $shared) {
    $this->shared = $shared;
  }

  public function index(Request $request) {
    $affiliation_id = \Config::get('filter.affiliation_id');
    $plan_post_id = \Config::get('filter.plan_post_id');
    $contract_id = \Config::get('filter.contract_id');

    $items_per_page = 12;
    $current_page = ($request->has('pag')) ? $request->pag : 1 ;
    $search_result = $this->shared->searchProductPostpaid(1, $affiliation_id, $plan_post_id, $contract_id, null, $items_per_page, $current_page, "publish_at", "desc");
    $pages = intval(ceil($search_result['total'] / $items_per_page));
    $paginator = new Paginator(
      $search_result['products'],
      $search_result['total'],
      $items_per_page, $current_page,
      [ 'pageName' => 'pag' ]
    );

    $paginator->withPath('postpago');

    $filterList = $this->shared->getFiltersPostpaid();

    return view('smartphones.postpago.index', ['products' => $paginator, 'pages' => $pages, 'filters' => $filterList]);
  }

  public function show($brand_slug,$product_slug,$affiliation_slug,$plan_slug,$contract_slug,$color_slug=null) {
    $product = $this->shared->productPostpaidBySlug($brand_slug,$product_slug,$affiliation_slug,$plan_slug,$contract_slug,$color_slug);

    if(empty($product)) {
      abort(404);
    }
    
    $available_products = $this->shared->searchProductPostpaid(1, $product->affiliation_id, $product->plan_id, $product->contract_id, $product->brand_id, 4);

    $available = $available_products['products'];
    foreach($available as $i => $item) {
      $available[$i]->route = route('postpaid_detail', [
        'brand'=>$brand_slug,
        'product'=>$item->product_slug,
        'plan'=>$plan_slug,
        'affiliation'=>$affiliation_slug,
        'contract'=>$contract_slug
      ]);
    }

    $stock_models = [];
    $product_images = [];
    if($product->stock_model_id) {
      $stock_models = $this->shared->productStockModels($product->product_id);
      foreach($stock_models as $i => $item) {
        $stock_models[$i]->route = route('postpaid_detail', [
          'brand'=>$brand_slug,
          'product'=>$product->product_slug,
          'plan'=>$plan_slug,
          'affiliation'=>$affiliation_slug,
          'contract'=>$contract_slug,
          'color'=>$item->color_slug
        ]);
      }
      $product_images = $this->shared->productImagesByStock($product->stock_model_id);
    }

    //TODO: Obtener valores de la BD con SP independientes. Cada cambio en el frontend debe ser una request independiente
    // $product_affiliations = $this->shared->productAffiliations($product->product_id);
    // $product_plans = $this->shared->productPlans($product->product_id);
    // $product_contracts = $this->shared->productContracts($product->product_id);

    // TEMPORAL
    $product_plans = DB::select('call PA_planList(2)');
    $product_affiliations = DB::select('call PA_affiliationList()');

    collect($product_plans)->map(function ($item, $key) use ($product) {
      $item->route = route('postpaid_detail', [
        'brand'=>$product->brand_slug,
        'product'=>$product->product_slug,
        'plan'=>$item->plan_slug,
        'affiliation'=>$product->affiliation_slug,
        'contract'=>$product->contract_slug
      ]);
      return $item;
    });

    collect($product_affiliations)->map(function ($item, $key) use ($product) {
      $item->route = route('postpaid_detail', [
        'brand'=>$product->brand_slug,
        'product'=>$product->product_slug,
        'plan'=>$product->plan_slug,
        'affiliation'=>$item->affiliation_slug,
        'contract'=>$product->contract_slug
      ]);
      return $item;
    });

    $response = [
      'product' => $product,
      'product_images' => $product_images,
      'stock_models' => $stock_models,
      'available' => $available,
      'plans' => $product_plans,
      'affiliations' => $product_affiliations,
    ];


    return view('smartphones.postpago.detail', $response);
  }

  public function compare (Request $request) {
    $request->validate([
      'product_id' => 'required|array',
      'product_id.*' => 'required|max:9|regex:/(^[0-9]+$)+/',
    ]);
    // return $request->all();
    $products = [];
    foreach ($request->product_id as $product_id) {
      $product = DB::select('call PA_productDetail(:product_id)', ['product_id' => $product_id]);
      if (isset($product[0])) {
        $plan_post_slug = $this->shared->planSlug(\Config::get('filter.plan_post_id'));
        $affiliation_slug = $this->shared->affiliationSlug(\Config::get('filter.affiliation_id'));
        $contract_slug = $this->shared->contractSlug(\Config::get('filter.contract_id'));

        $product = $product[0];
        $product->route = route('postpaid_detail', [
          'brand'=>$product->brand_slug,
          'product'=>$product->product_slug,
          'affiliation'=>$affiliation_slug,
          'plan'=>$plan_post_slug,
          'contract'=>$contract_slug
        ]);
        array_push($products, $product);
      } else {
        abort(404);
      }
    }
    // return $products;
    return view('smartphones.postpago.compare', ['products' => $products]);
  }
}
