<?php

namespace App\Http\Controllers;

use DB;
use Validator;
use App\Http\Controllers\BaseController;
use Illuminate\Http\Request;
use Illuminate\Pagination\LengthAwarePaginator as Paginator;
use Illuminate\Support\Facades\Storage;

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

    $request->validate([
      'buscar' => 'nullable|max:30|regex:/(^[A-Za-z0-9. ]+$)+/'
    ]);

    $searched_string = $request->has('buscar') ? $request->buscar : '';

    $items_per_page = 12;
    $current_page = ($request->has('pag')) ? $request->pag : 1 ;
    $search_result = $this->shared->searchProductPostpaid(1, $affiliation_id, $plan_post_id, $contract_id, null, $items_per_page, $current_page, "publish_at", "desc", 0 , 0, $searched_string);
    $pages = intval(ceil($search_result['total'] / $items_per_page));
    $paginator = new Paginator(
      $search_result['products'],
      $search_result['total'],
      $items_per_page, $current_page,
      [ 'pageName' => 'pag' ]
    );

    $paginator->withPath('postpago');

    $filterList = $this->shared->getFiltersPostpaid();

    return view('smartphones.postpago.index', ['products' => $paginator, 'pages' => $pages, 'filters' => $filterList, 'searched_string' => $searched_string]);
  }

  public function show(Request $request, $brand_slug,$product_slug,$affiliation_slug,$plan_slug,$contract_slug,$color_slug=null) {
      $inputs = [
          'brand_slug' => $brand_slug,
          'product_slug' => $product_slug,
          'affiliation_slug' => $affiliation_slug,
          'plan_slug' => $plan_slug,
          'contract_slug' => $contract_slug,
          'color_slug' => $color_slug
      ];

      $validator = Validator::make($inputs, [
          'brand_slug' => 'required|exists:tbl_brand',
          'product_slug' => 'required|exists:tbl_product',
          'affiliation_slug' => 'required|exists:tbl_affiliation',
          'plan_slug' => 'required|exists:tbl_plan',
          'contract_slug' => 'required|exists:tbl_contract',
          'color_slug' => 'nullable|exists:tbl_color'
      ]);

      if ($validator->fails()) {
          abort(404);
      }

    $product = $this->shared->productPostpaidBySlug($brand_slug,$product_slug,$affiliation_slug,$plan_slug,$contract_slug,$color_slug);

    if(empty($product)) {
      abort(404);
    }

    $available_products = $this->shared->searchProductPostpaid('1,3', $product->affiliation_id, $product->plan_id, $product->contract_id, '', 4, 1, null, null,null, null, null, null, $product->product_id);

    $available = $available_products['products'];
    foreach($available as $i => $item) {
      $available[$i]->route = route('postpaid_detail', [
        'brand'=>$item->brand_slug,
        'product'=>$item->product_slug,
        'plan'=>$plan_slug,
        'affiliation'=>$affiliation_slug,
        'contract'=>$contract_slug
      ]);
      $available[$i]->api_route = route('api_postpaid_detail', [
        'brand'=>$item->brand_slug,
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
        $stock_models[$i]->api_route = route('api_postpaid_detail', [
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
    // $product_affiliations = DB::select('call PA_affiliationList()');

    $product_affiliations = DB::table('tbl_product_variation')
                  ->join('tbl_affiliation', 'tbl_product_variation.affiliation_id', '=', 'tbl_affiliation.affiliation_id')
                  ->where('tbl_product_variation.product_id', $product->product_id)
                  ->select('tbl_affiliation.affiliation_id', 'tbl_affiliation.affiliation_name', 'tbl_affiliation.affiliation_slug')
                  ->groupBy('tbl_affiliation.affiliation_id', 'tbl_affiliation.affiliation_name', 'tbl_affiliation.affiliation_slug')
                  ->get();

    collect($product_plans)->map(function ($item, $key) use ($product, $color_slug) {
      $item->route = route('postpaid_detail', [
        'brand'=>$product->brand_slug,
        'product'=>$product->product_slug,
        'plan'=>$item->plan_slug,
        'affiliation'=>$product->affiliation_slug,
        'contract'=>$product->contract_slug,
        'color' => isset($color_slug) ? $color_slug : null
      ]);
      $item->api_route = route('api_postpaid_detail', [
        'brand'=>$product->brand_slug,
        'product'=>$product->product_slug,
        'plan'=>$item->plan_slug,
        'affiliation'=>$product->affiliation_slug,
        'contract'=>$product->contract_slug,
        'color' => isset($color_slug) ? $color_slug : null
      ]);
      return $item;
    });

    collect($product_affiliations)->map(function ($item, $key) use ($product, $color_slug) {
      $item->route = route('postpaid_detail', [
        'brand'=>$product->brand_slug,
        'product'=>$product->product_slug,
        'plan'=>$product->plan_slug,
        'affiliation'=>$item->affiliation_slug,
        'contract'=>$product->contract_slug,
        'color' => isset($color_slug) ? $color_slug : null
      ]);
      $item->api_route = route('api_postpaid_detail', [
        'brand'=>$product->brand_slug,
        'product'=>$product->product_slug,
        'plan'=>$product->plan_slug,
        'affiliation'=>$item->affiliation_slug,
        'contract'=>$product->contract_slug,
        'color' => isset($color_slug) ? $color_slug : null
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
      'product_variation_id' => 'required|array',
      'product_variation_id.*' => 'required|max:9|regex:/(^[0-9]+$)+/',
    ]);
    // return $request->all();
    $products = [];
    foreach ($request->product_variation_id as $product_variation_id) {
      $product = $this->shared->productVariationDetail($product_variation_id);
      if (isset($product)) {
        $product->route = route('postpaid_detail', [
          'brand'=>$product->brand_slug,
          'product'=>$product->product_slug,
          'affiliation'=>$product->affiliation_slug,
          'plan'=>$product->plan_slug,
          'contract'=>$product->contract_slug
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
