<!DOCTYPE html>
<html lang="es">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Tienda Bitel</title>
    <link type="text/css" rel="stylesheet" href="{{asset('css/app.css')}}">
  </head>
  <body>
    <div class="container">
      <div class="row">
        <div class="col-xs-12">
          <div class="title-page">
            <h2>Equipos</h2>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-xs-12">
          <a href="{{route('product.create')}}" class="btn btn-primary pull-right">Registrar producto</a>
        </div>
      </div>
      <hr>
      <div class="row">
        <div class="col-xs-12">
          <div id="list-equipos">
            <div class="row">
@foreach ($products as $product)
              <div class="col-xs-12 col-sm-6 col-md-4">
                <div class="producto">
                  <div class="content-product text-center">
                    <div class="title-product">
                      <h3 class="text-center">{{$product->product_name}}</h3>
                    </div>
                    <div class="price-product"><span>S/. {{$product->product_price}}</span></div>
                    <div class="plan-product">
                      <p><span>{{$product->product_brand}}</span></p>
                    </div>
                  </div>
                </div>
              </div>
@endforeach
            </div>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>
