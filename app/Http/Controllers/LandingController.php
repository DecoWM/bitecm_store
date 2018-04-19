<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class LandingController extends Controller
{
  public function huawei_p20_pro (Request $request) {
    return view('landings.huawei_p20_pro');
  }
  public function huawei_p20 (Request $request) {
    return view('landings.huawei_p20');
  }
}