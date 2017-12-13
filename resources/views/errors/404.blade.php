@extends('layouts.master')
@section('content')
    <div class="container-fluid container-404">
      <div class="row">
        <div class="col-xs-12 col-sm-6 col-sm-push-3 text-center">
          <div class="wrapper-404">
            <h2>Error 404</h2>
            <h3>Página no encontrada</h3>
            <p>Lo sentimos pero la página a la que estás intentado
              acceder no existe o ha cambiado. Por favor
              accede a nuestra <b><a href="{{route('home')}}">página principal</a></b> o utiliza el
              buscador para hallar aquello que estás buscando.
            </p>
          </div>
        </div>
      </div>
      <div class="wrapper-404-img">
        <img class="img-404" src="{{asset('/images/404/404.png')}}" alt="404">
      </div>
      <form id="search-404">
        <input type="text" class="form-control" placeholder="Buscar">
        <button type="submit"> <span class="fa fa-search"></span></button>
      </form>
    </div>
@endsection
