<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class FileController extends Controller
{
    public function downloadFile () {
        $path = storage_path('/app/public/'.$filename);
        return response()->download($path, $name);
    }
}
