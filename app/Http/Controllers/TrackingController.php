<?php

namespace App\Http\Controllers;

use DB;
use Illuminate\Http\Request;

class TrackingController extends Controller
{
  protected $shared;

  public function __construct (BaseController $shared) {
    $this->shared = $shared;
  }

  public function index (Request $request) {
    //$order_id = $request->order;
    //$product = $this->shared->orderItems();
    //return view('tracking', ['product' => $product]);
  }
}
