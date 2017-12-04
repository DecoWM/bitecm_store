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

  public function index (Request $request, $order_id = null) {
    $status_history = $this->shared->statusHistory($order_id);dd($status_history);
    return view('tracking', ['status_id' => $status_history[0]->order_status_id]);
  }
}
