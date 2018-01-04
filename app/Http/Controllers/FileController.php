<?php

namespace App\Http\Controllers;

use DB;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

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
        // return response()->download($path, $name);

        $url = asset('/files/pdf/footer/Aviso-Legal.pdf');
        return redirect($url);
    }

    public function downloadFileConsideraciones (Request $request, $product_id = null) {
        /*$name = $slug = str_slug('Consideraciones-Comerciales');
        $ext = ".pdf";
        $name = $name.$ext;
        $path = public_path('/files/pdf/footer/Consideraciones-Comerciales-Post-Pago-Prepago.pdf');
        return response()->download($path, $name);*/

        /*$filename = DB::table('tbl_product')
            ->where('product_id', $product_id)
            ->select('product_commercial_considerations')
            ->get();

        if (count($filename)) {
            return redirect(asset($filename[0]->product_commercial_considerations));
        } else {
            return abort(404);
        }*/

        return redirect(asset('files/pdf/footer/Consideraciones-Comerciales-Post-Pago-Prepago.pdf'));
    }

    public function downloadFileTerminos (Request $request) {
        $name = $slug = str_slug('Terminos');
        // $path = storage_path('/app/public/'.$filename);
        $ext = ".pdf";
        $name = $name.$ext;
        $path = public_path('/files/pdf/footer/Terminos-Condiciones.pdf');
        // return response()->download($path, $name);

        $url = asset('/files/pdf/footer/Terminos-Condiciones.pdf');
        return redirect($url);
    }

    public function downloadFileFichaTecnica (Request $request, $product_id = null) {
        /*$name = $slug = str_slug('Ficha-Técnica');
        $ext = ".pdf";
        $name = $name.$ext;
        $path = public_path('/files/pdf/productos/e_bitel9501/Ficha-tecnica-para-Ecommerce-BITEL-9501.pdf');
        return response()->download($path, $name);*/

        $filename = DB::table('tbl_product')
            ->where('product_id', $product_id)
            ->select('product_data_sheet')
            ->get();

        if (count($filename)) {
            return redirect(asset(Storage::url($filename[0]->product_data_sheet)));
        } else {
            return abort(404);
        }
    }
}
