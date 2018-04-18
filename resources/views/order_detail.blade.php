@extends('layouts.master')
@section('content')
      <script>
        fbq('track', 'CompleteRegistration');
        console.log('fbq complete registration');
      </script>
      <div class="container">
        <div class="row">
          <div class="col-xs-12 col-sm-10 col-sm-offset-1">
            <div id="nav-carrito">
              <ul class="list-unstyled">
                <li class="col-xs-4 col-sm-4 is-completed"><span>Carrito de compras </span></li>
                <li class="col-xs-4 col-sm-4 is-completed"><span>Informacion de envío</span></li>
                <li class="col-xs-4 col-sm-4 active"><span>Pedido completo</span></li>
              </ul>
            </div>
            <div id="title-page">
              <h2>PEDIDO COMPLETO</h2>
            </div>
            <div id="section-pedido">
              <div class="row">
                <div class="title-section-pedido text-center">
                  {{--<h3>¡GRACIAS POR COMPRAR EN BITEL !</h3>--}}
                  <h3>¡Gracias por reservar en Bitel !</h3>
                  <h4>TU NÚMERO DE PEDIDO ES # {{$order_id}}</h4>
                </div>
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
                          @if(isset($product->variation_type_id))
                            @if($product->variation_type_id == 2)
                            <p>Plan <span> s/. {{$product->plan_price}} </span>mensual</p>
                            @else
                            <p>Plan Prepago <span>{{$product->plan_name}}</span></p>
                            @endif
                          @endif
                          @if(isset($product->promo_id))
                          <p>
                            Precio del equipo: <span>s/. {{$product->promo_price}}</span> <span class="normal-price">{{$product->product_price}}</span>
                          </p>
                          @else
                          <p>
                            Precio del equipo: <span>s/. {{$product->product_price}}</span>
                          </p>
                          @endif
                        </div>
                      </div>
                    </div>
                    <div class="col-xs-12 col-sm-5">
                      <div class="equipo-seleccionado">
                        <div class="image"><img src="{{asset(Storage::url($product->product_image_url))}}" alt="equipos"></div>
                        <div class="contenido">
                          <span class="text-uppercase title-contenido">
                            {{$product->brand_name}} {{$product->product_model}} {{isset($product->color_name) ? $product->color_name : ''}}
                          </span>
                          @if(isset($product->variation_type_id))
                            <p>{{$order['affiliation_type']}}</p>
                            @if($product->variation_type_id == 2)
                            <p>Contrato 18 meses</p>
                            @endif
                          @endif
                          <p> <span>Cantidad:</span> {{$product->quantity}}</p>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                @endforeach
                <div class="rastreo-de-compra">
                  <div class="text-center">
                    {{--<h4>HEMOS ENVIADO UN MENSAJE A SU CORREO PARA EL TRACKEO DE SU COMPRA</h4>--}}
                    <h4>Hemos enviado un mensaje para el trackeo de su reserva</h4>
                    {{--<p>Un representante se comunicará contigo dentro de las 6 horas posteriores, previa evaluación crediticia y disponibilidad de stock.</p>--}}
                    <p>Un representante se comunicará contigo dentro de las 6 horas posteriores, dependiendo disponibilidad de stock.</p>
                  </div>
                </div>
                <div class="btn-detalle">
                  <div class="col-xs-12 col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3">
                    <a href="{{route('home')}}" class="btn btn-default regresar">REGRESAR<span><br></span>A LA PÁGINA DE INICIO</a>
                    <a href="{{route('track_order', ['order_id' => $order_id])}}" class="redirect-href btn btn-default comprar">Visualizar el estado<span><br></span>de tu pedido</a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
@endsection
