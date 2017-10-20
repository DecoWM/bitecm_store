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
          <form class="" action="{{route('product.store')}}" method="post">
              {{ csrf_field() }}
              <div class="form-group">
                <label for="product-name">Nombre</label>
                <input type="text" class="form-control" id="product-name" name="name" placeholder="Ingresa el nombre" value="{{ old('name') }}">
                <!-- <p class="help-block">Help text here.</p> -->
              </div>
              <div class="form-group">
                <label for="product-price">Precio</label>
                <input type="text" class="form-control" id="product-price" name="price" placeholder="Ingresa el precio"  value="{{ old('price') }}">
                <!-- <p class="help-block">Help text here.</p> -->
              </div>
              <div class="form-group">
                <label for="product-brand">Marca</label>
                <input type="text" class="form-control" id="product-brand" name="brand" placeholder="Ingresa la marca"  value="{{ old('brand') }}">
                <!-- <p class="help-block">Help text here.</p> -->
              </div>
              <hr>
@if ($errors->any())
              <div class="alert alert-danger">
                <ul>
@foreach ($errors->all() as $error)
                  <li>{{ $error }}</li>
@endforeach
                </ul>
              </div>
@endif
              <button type="submit" class="btn btn-success pull-right" name="button">Registrar</button>
              <a href="{{route('product.index')}}" class="btn btn-primary">Regresar</a>
          </form>
        </div>
      </div>
    </div>
  </body>
</html>
