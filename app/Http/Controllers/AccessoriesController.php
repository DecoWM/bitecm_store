<?php

namespace App\Http\Controllers;

use App\Http\Controllers\BaseController;
use Illuminate\Http\Request;

class AccessoriesController extends Controller
{
    protected $shared;

    public function __construct (BaseController $shared) {
        $this->shared = $shared;
    }

    public function index (Request $request) {
        $filterList = $this->shared->getFiltersAccessories();
        return view('accessories.index', ['filters' => $filterList]);
    }
}
