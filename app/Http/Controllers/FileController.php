<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class FileController extends Controller
{
    public function downloadFile (Request $request, $filename) {
        $name = $slug = str_slug('Ficha técnica '.$filename, '-');
        // $path = storage_path('/app/public/'.$filename);
        $ext = ".pdf";
        $name = $name.$ext;
        $path = storage_path('/app/public/Bitel.pdf');
        return response()->download($path, $name);
    }
}
