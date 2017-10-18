<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Product;

class ProductController extends Controller
{
    public function getAll (Request $request) {
        $products = Product::get();
        // return $products;
        return view('products.index');
    }
}
