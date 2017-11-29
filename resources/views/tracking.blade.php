@extends('layouts.master')
@section('content')
    <div class="container">
      <div class="row">
        <div class="col-xs-12 col-sm-10 col-sm-offset-1">
          <div id="page-rastreo">
            <div class="title-page-rastreo">
              <h2>RASTREO</h2>
              <h3>Revisa el estado de tu pedido.</h3>
            </div>
            <div id="content-rastreo">
@foreach ($products as $product)
              <section id="detalle-rastreo">
                <div class="title-section">
                  <h1>Producto comprado el:</h1><span>{{$order->create_at}}</span>
                </div>
                <div class="content-section">
                  <div class="row">
                    <div class="col-xs-6 col-sm-12 col-md-12 col-lg-4">
                      <div class="equipo-seleccionado">
                        <div class="image"><img src="{{asset('images/productos/'.$product->product_image_url)}}" alt="equipos"></div>
                        <div class="contenido">
                          <h2 class="text-uppercase title-contenido">
                            <b>{{$product->brand_name}}</b> {{$product->product_model}}
                          </h2>
                          <p> <span>Cantidad:</span>{{$product->quantity}}</p>
                          @if(isset($product->variation_type_id) && $product->variation_type_id == 2)
                          <p>
                            <span>Plan:</span>
                            {{$product->plan_name}}
                          </p>
                          @endif
                          @if(isset($product->product_variation_id))
                            @php 
                            $product->product_price = $product->product_variation_price;
                            @endphp
                          @endif
                          @if(isset($product->promo_id))
                          <p>
                            <span>Precio del equipo:</span>
                            <p>S/. {{$product->promo_price}} <span class="normal-price">S/. {{$product->product_price}}</span>
                          </p>
                          @else
                          <p>
                            <span>Precio del equipo:</span>
                            <p>S/. {{$product->product_price}}</P>
                          </p>
                          @endif
                          <p class="status"><span>Status:</span>Pendiente</p>
                        </div>
                      </div>
                    </div>
                    <div class="col-xs-6 col-sm-12 col-md-12 col-lg-8">
                      <div class="proceso">
                        <div id="nav-carrito" class="nav-carrito">
                          <ul class="list-unstyled">
                            <li class="col-xs-4 col-sm-4 active">
                              <div class="image-icon"><img src="./images/rastreo/svg/estado_pendiente.svg" alt=""></div><span>Pendiente</span>
                            </li>
                            <li class="col-xs-4 col-sm-4">
                              <div class="image-icon"><img src="./images/rastreo/svg/estado_procesado.svg" alt=""></div><span>Procesado</span>
                            </li>
                            <li class="col-xs-4 col-sm-4">
                              <div class="image-icon"><img src="./images/rastreo/svg/estado_cancelado.svg" alt=""></div><span>Cancelado</span>
                            </li>
                            <li class="col-xs-4 col-sm-4">
                              <div class="image-icon"><img src="./images/rastreo/svg/estado_entregado.svg" alt=""></div><span>Entregado</span>
                            </li>
                            <li class="col-xs-4 col-sm-4">
                              <div class="image-icon"><img src="./images/rastreo/svg/estado_completado.svg" alt=""></div><span>Completado</span>
                            </li>
                          </ul>
                        </div>
                        <div class="resp-proceso-web text-center">
                          <p>¡Tu pedido está siendo evaluado!</p>
                        </div>
                      </div>
                    </div>
                    <div class="col-xs-12">
                      <div class="resp-proceso-movil text-center">
                        <p>¡Tu pedido está siendo evaluado!</p>
                      </div>
                    </div>
                  </div>
                </div>
              </section>
            @endforeach
            </div>
            <div class="ver-mas-ratreo">
              <p>¿Quieres comprar más?</p>
              <div class="btn btn-default btn-rastreo"><a href="{{route('postpaid')}}">VER CATÁLOGO</a></div>
            </div>
          </div>
        </div>
      </div>
    </div>
@endsection
