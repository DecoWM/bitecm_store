@extends('layouts.master')
@section('content')
      <div class="container">
        <div class="row">
          <div class="col-xs-12 col-sm-10 col-sm-offset-1">
            <div id="nav-carrito">
              <ul class="list-unstyled">
                <li class="col-xs-4 col-sm-4"><span>Carrito de compras </span></li>
                <li class="col-xs-4 col-sm-4"><span>Informacion de envío</span></li>
                <li class="col-xs-4 col-sm-4 active"><span>Pedido completo</span></li>
              </ul>
            </div>
            <div id="title-page">
              <h2>PEDIDO COMPLETO</h2>
            </div>
            <div id="section-pedido">
              <div class="row">
                <div class="title-section-pedido text-center">
                  <h3>¡GRACIAS POR COMPRAR EN BITEL!</h3>
                </div>
{{-- {{dump($products)}} --}}
@foreach ($products as $product)
                <div class="detalle-pedido">
                  <div class="row">
                    <div class="col-xs-12 col-sm-7">
                      <div class="solicitud">
                        <div class="btn-check">
                          <div class="fa fa-check-circle"></div>
                        </div>
                        <div class="info">
                          <p>Tu solicitud ha sido enviada correctamente por:</p>
@if (array_has($product, 'plan'))
                          <p>Plan <span> s/. {{$product['plan']->plan_price}} </span>mensual</p>
                          <p>Precio del equipo: <span>s/. {{$product['plan']->product_variation_price + 0}}</span></p>
@else
                          <p>Precio del equipo: <span>s/. {{$product['product']->product_price_prepaid + 0}}</span></p>
@endif
                        </div>
                      </div>
                    </div>
                    <div class="col-xs-12 col-sm-5">
                      <div class="equipo-seleccionado">
                        <div class="image"><img src="{{asset('images/productos/'.$product['product']->picture_url)}}" alt="equipos"></div>
                        <div class="contenido"><span class="text-uppercase title-contenido">{{$product['product']->product_model}}</span>
@if (array_has($product, 'plan'))
                          <p>{{$product['plan']->affiliation_name}}</p>
                          <p>Contrato 18 meses</p>
@endif
                          <p> <span>Cantidad:</span> {{$product['quantity']}}</p>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
@endforeach
                <div class="rastreo-de-compra">
                  <div class="text-center">
                    <h4>HEMOS ENVIADO UN MENSAJE A SU CORREO PARA EL RASTREO DE SU COMPRA</h4>
                    <p>Un representante se comunicará contigo dentro de las 6 horas posteriores, previa evaluación crediticia y disponibilidad de stock.</p>
                  </div>
                </div>
                <div class="btn-detalle">
                  <div class="col-xs-12 col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3">
                    {{-- <button type="submit" class="btn btn-default regresar">REGRESAR<span><br></span>A LA PÁGINA DE INICIO</button>
                    <button type="submit" href="https://bitel.clientes-forceclose.com/bitel_frontend/dist/rastreo.html" class="redirect-href btn btn-default comprar">continuar</button> --}}
                    <a href="{{route('home')}}" class="btn btn-default regresar">REGRESAR<span><br></span>A LA PÁGINA DE INICIO</a>
                    <a href="{{route('rastreo', ['product' => $product['product']->product_id])}}" class="redirect-href btn btn-default comprar">continuar</a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
@endsection
