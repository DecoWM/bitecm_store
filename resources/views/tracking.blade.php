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
                        <div class="image"><img src="{{asset('images/productos/'.$product['product']->picture_url)}}" alt="equipos"></div>
                        <div class="contenido">
                          <h2 class="text-uppercase title-contenido">{{$product['product']->product_model}}</h2>
                          <p> <span>Cantidad:</span>{{$product['quantity']}}</p>
@if (array_has($product, 'plan'))
                          <p class="precio">S/. {{$product['plan']->product_variation_price + 0}}</p>
@else
                          <p class="precio">S/. {{$product['product']->product_price_prepaid + 0}}</p>
@endif
                          <p class="status"><span>Status:</span>Enviado</p>
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
                          <p>¡Tu pedido ya está en camino!</p>
                        </div>
                      </div>
                    </div>
                    <div class="col-xs-12">
                      <div class="resp-proceso-movil text-center">
                        <p>¡Tu pedido ya está en camino!</p>
                      </div>
                    </div>
                  </div>
                </div>
              </section>
@endforeach
              {{-- <section id="detalle-rastreo">
                <div class="title-section">
                  <h1>Producto comprado el</h1><span>13 de Septiembre del 2017</span>
                </div>
                <div class="content-section">
                  <div class="row">
                    <div class="col-xs-12 col-sm-5">
                      <div class="equipo-seleccionado">
                        <div class="image"><img src="./images/home/celular-1.jpg" alt="equipos"></div>
                        <div class="contenido">
                          <h2 class="text-uppercase title-contenido">GOOGLE PIXEL</h2>
                          <p> <span>Cantidad:</span>1</p>
                          <p class="precio">S/.2,701,78</p>
                          <p class="status"><span>Status:</span>Enviado</p>
                        </div>
                      </div>
                    </div>
                    <div class="col-xs-12 col-sm-7 col-sp">
                      <div class="proceso">
                        <div id="nav-carrito">
                          <ul class="list-unstyled">
                            <li class="col-xs-4 col-sm-4 active">
                              <div class="image-icon"><img src="./images/rastreo/svg/aceptado.svg" alt="" class="aceptado"></div><span>Aceptado</span>
                            </li>
                            <li class="col-xs-4 col-sm-4">
                              <div class="image-icon"><img src="./images/rastreo/svg/enproceso.svg" alt="" class="enproceso"></div><span>En Proceso</span>
                            </li>
                            <li class="col-xs-4 col-sm-4">
                              <div class="image-icon"><img src="./images/rastreo/svg/enviado.svg" alt="" class="enviado"></div><span>Enviado</span>
                            </li>
                          </ul>
                        </div>
                        <div class="resp-proceso text-center">
                          <p>¡Tu pedido ya está en camino!</p>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </section> --}}
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
