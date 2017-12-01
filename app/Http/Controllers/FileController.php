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

    public function downloadFileAviso (Request $request) {
        $name = $slug = str_slug('Aviso-Legal');
        // $path = storage_path('/app/public/'.$filename);
        $ext = ".pdf";
        $name = $name.$ext;
        $path = public_path('/files/pdf/footer/Aviso-Legal.pdf');
        return response()->download($path, $name);
    }

    public function downloadFileConsideraciones (Request $request) {
        $name = $slug = str_slug('Consideraciones-Comerciales');
        // $path = storage_path('/app/public/'.$filename);
        $ext = ".pdf";
        $name = $name.$ext;
        $path = public_path('/files/pdf/footer/Consideraciones-Comerciales-Post-Pago-Prepago.pdf');
        return response()->download($path, $name);
    }

    public function downloadFileTerminos (Request $request) {
        $name = $slug = str_slug('Terminos');
        // $path = storage_path('/app/public/'.$filename);
        $ext = ".pdf";
        $name = $name.$ext;
        $path = public_path('/files/pdf/footer/Terminos-Condiciones.pdf');
        return response()->download($path, $name);
    }

    public function downloadFileFichaTecnica (Request $request) {
        $name = $slug = str_slug('Ficha-Técnica');
        // $path = storage_path('/app/public/'.$filename);
        $ext = ".pdf";
        $name = $name.$ext;
        $path = public_path('/files/pdf/productos/e_bitel9501/Ficha-tecnica-para-Ecommerce-BITEL-9501.pdf');
        return response()->download($path, $name);
    }
}
