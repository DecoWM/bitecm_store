<?php

namespace App\Http\Controllers;

use DB;
use App\Http\Controllers\BaseController;
use App\Product;
use Illuminate\Http\Request;
use App\Http\Requests\StoreProductPostRequest;

class ProductController extends Controller
{
  protected $shared;

  public function __construct (BaseController $shared) {
    $this->shared = $shared;
  }
    
  /**
   * Display a listing of the resource.
   *
   * @return \Illuminate\Http\Response
   */
  public function index()
  {
    $products = Product::orderBy('created_at', 'desc')->get();
    return view('products.index', ['products' => $products]);
  }

  /**
   * Show the form for creating a new resource.
   *
   * @return \Illuminate\Http\Response
   */
  public function create()
  {
    return view('products.create');
  }

  /**
   * Store a newly created resource in storage.
   *
   * @param  \Illuminate\Http\Request  $request
   * @return \Illuminate\Http\Response
   */
  public function store(StoreProductPostRequest $request)
  {
    $product = new Product();
    $product->product_name = $request->name;
    $product->product_price = $request->price;
    $product->product_brand = $request->brand;
    $product->save();
    return redirect()->route('product.index');
  }

  /**
   * Display the specified resource.
   *
   * @param  \App\Product  $product
   * @return \Illuminate\Http\Response
   */
  // public function show(Product $product)
  public function show($brand,$product,$color=null) {
    $product = $this->shared->productBySlug($brand,$product,$color);

    if(empty($product)) {
      abort(404);
    }

    $available_products = $this->shared->productSearch(2, $product->brand_id, 4);
    $available = collect($available_products['products'])->map(function ($item, $key) use ($product) {
      $item->picture_url = asset('images/productos/'.$item->picture_url);
      $item->route = route('accessory_detail', [
        'brand'=>$item->brand_slug,
        'product'=>$item->product_slug
      ]);
      return $item;
    });
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
      }
      $product_images = $this->shared->productImagesByStock($product->stock_model_id);
    }
    $response = [
      'product' => $product,
      'available' => $available
    ];
    return view('products.detail', $response);
  }

  /**
   * Show the form for editing the specified resource.
   *
   * @param  \App\Product  $product
   * @return \Illuminate\Http\Response
   */
  public function edit(Product $product)
  {
    //
  }

  /**
   * Update the specified resource in storage.
   *
   * @param  \Illuminate\Http\Request  $request
   * @param  \App\Product  $product
   * @return \Illuminate\Http\Response
   */
  public function update(Request $request, Product $product)
  {
    //
  }

  /**
   * Remove the specified resource from storage.
   *
   * @param  \App\Product  $product
   * @return \Illuminate\Http\Response
   */
  public function destroy(Product $product)
  {
    //
  }
}
