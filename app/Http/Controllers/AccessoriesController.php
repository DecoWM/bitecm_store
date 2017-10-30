<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class AccessoriesController extends Controller
{
    public function index (Request $request) {
        return view('accessories.index');
    }
}
