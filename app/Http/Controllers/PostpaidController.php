<?php

namespace App\Http\Controllers;

use DB;
use App\Http\Controllers\BaseController;
use Illuminate\Http\Request;

class PostpaidController extends Controller
{
    protected $shared;

    public function __construct (BaseController $shared) {
        $this->shared = $shared;
    }

    public function index () {
        $search_result =  $this->shared->searchProduct(1, 9);
        return view('smartphones.postpago.index', ['products' => $search_result]);
    }

    public function search (Request $request) {
        $this->validate($request, [
          'searched_string' => 'required|max:30|regex:/(^[A-Za-z0-9 ]+$)+/'
        ]);

        $search_result = $this->shared->searchProduct(1, 9, 1, "product_name", "desc", 0, 0, 0, $request->searched_string);

        $data = collect($search_result)->map(function ($item, $key) {
            $item->picture_url = asset('images/productos/'.$item->picture_url);
            return $item;
        });

        $response = [
            'data' => $data
        ];

        return response()->json($response);
    }
}
