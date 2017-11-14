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

    public function index (Request $request) {
        $current_page = ($request->has('pag')) ? $request->pag : 1 ;
        $items_per_page = 12;
        $search_result =  $this->shared->searchProductPrepaid(1, $items_per_page, $current_page);
        $pages = intval(ceil($search_result['total'] / $items_per_page));
        $paginator = new Paginator($search_result['products'], $search_result['total'], $items_per_page, $current_page, [
          'pageName' => 'pag'
        ]);
        $paginator->withPath('prepago');
        return view('smartphones.prepago.index', ['products' => $paginator, 'pages' => $pages]);
    }

    public function show($product_id) {
        $product = DB::select('call PA_productDetail(:product_id)', ['product_id' => $product_id]);
        $available_products = $this->shared->searchProduct(1, 4);
        $response = [
            'product' => $product[0],
            'available' => $available_products
        ];
        return view('smartphones.prepago.detail', $response);
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
              array_push($products, $product[0]);
            } else {
              abort(404);
            }
        }
        // return $products;
        return view('smartphones.prepago.compare', ['products' => $products]);
    }
}
