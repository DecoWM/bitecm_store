@extends('layouts.master')
@section('content')
    <div class="container">
      <div class="row">
        <div class="col-xs-12 col-sm-10 col-sm-offset-1">
          <div id="nav-carrito">
            <ul class="list-unstyled">
              <li class="col-xs-4 col-sm-4 active"><span>Carrito de compras </span></li>
              <li class="col-xs-4 col-sm-4"><span>Informacion de envío</span></li>
              <li class="col-xs-4 col-sm-4"><span>Pedido completo</span></li>
            </ul>
          </div>
          <div id="title-page">
            <h2>Carrito de compra</h2>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-xs-12 col-sm-10 col-sm-offset-1">
          <div id="detalle-carrito">
            <div class="nav-detalle">
              <div class="row">
                <div class="col-xs-12 col-sm-4">
                  <p>descripción</p>
                </div>
                <div class="col-xs-12 col-sm-4">
                  <p>último pago</p>
                </div>
                <div class="col-xs-12 col-sm-4">
                  <p>pago mensual</p>
                </div>
              </div>
            </div>
@if (count($products) > 0)
@foreach ($products as $product)
            <div class="main-detalle equipos">
              <div class="row">
                <div class="col-xs-12 col-sm-4">
                  <div class="equipo-seleccionado">
                    <button class="btn-eliminar-equipo"><span class="fa fa-times"></span></button>
                    <div class="imagen-equipo"><img src="{{asset('images/productos/'.$product->product_image_url)}}" alt="equipos"></div>
                    <div class="detalle-equipo">
                      <h2>{{$product->product_model}}</h2>
@if (intval($product->type_id) == 2)
                      <span class="modo">{{$product->affiliation_name}}</span><span class="contrato">Contrato {{$product->contract_name}}</span>
@endif
                      <div class="cantidad">
                        <div class="btn-option">
                          <div class="count-input space-bottom"><a href="#" data-action="decrease" class="incr-btn btn-minus">-</a>
                            <input type="text" value="{{$product->quantity}}" name="quantity" class="quantity"><a href="#" data-action="increase" class="incr-btn btn-plus">+</a>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="col-xs-6 col-sm-4"><span class="title-detalle">ÚLTIMO PAGO</span>
                  <p>S/. {{$product->product_price}}</p>
                </div>
                <div class="col-xs-6 col-sm-4"><span class="title-detalle">PAGO MENSUAL</span>
@if (intval($product->type_id) == 2)
                  <p>S/. {{$product->plan_price}}</p><span class="plan">{{$product->plan_name}}</span>
@else
                  <p> - </p>
@endif
                </div>
              </div>
            </div>
            <div class="main-detalle col-offset">
              <div class="row">
                <div class="col-xs-12 col-sm-4">
                  <p class="version-mobil text-right">PRECIO SIN IGV</p>
                </div>
                <div class="col-xs-6 col-sm-4"><span class="title-detalle">PRECIO SIN IGV</span>
                  <p>S/. {{$product->product_price}}</p>
                </div>
                <div class="col-xs-6 col-sm-4"><span class="title-detalle"> </span>
@if (intval($product->type_id) == 2)
                  <p>S/. {{$product->plan_price}} mensual</p>
@else
                  <p> - </p>
@endif
                </div>
              </div>
            </div>
            <div class="main-detalle col-offset">
              <div class="row">
                <div class="col-xs-12 col-sm-4">
                  <p class="version-mobil text-right">COSTO DE ENVÍO</p>
                </div>
                <div class="col-xs-6 col-sm-4"><span class="title-detalle">COSTO DE ENVÍO</span>
                  <p>GRATIS</p>
                </div>
              </div>
            </div>
            <div class="main-detalle col-offset sinborder">
              <div class="row">
                <div class="col-xs-12 col-sm-4">
                  <p class="version-mobil text-right">TOTAL + IGV</p>
                </div>
                <div class="col-xs-6 col-sm-4"><span class="title-detalle">TOTAL + IGV</span>
                  <p>S/. {{$product->product_price * (1 + $igv)}}</p>
                </div>
              </div>
            </div>
@endforeach
@else
            <div class="main-detalle equipos">
              <div class="row">
                <div class="col-xs-12 col-sm-4">
                  <p>El carrito se encuentra vacío.</p>
                </div>
              </div>
            </div>
@endif
            <div class="btn-detalle">
              <div class="row">
                <div class="col-xs-12 col-sm-6 col-sm-offset-6">
                  {{-- <button type="submit" class="btn btn-default regresar">REGRESAR</button> --}}
@if (count($products) > 0)
                  <a href="{{url()->previous()}}" class="btn btn-default regresar">REGRESAR</a>
                  {{-- <button type="submit" class="btn btn-default regresar">REGRESAR</button> --}}
                  {{-- <button type="submit" href="{{route('envio', ['product'=>$product->product_id])}}" class="redirect-href btn btn-default comprar">comprar</button> --}}

                  <a href="{{route('create_order')}}" class="btn btn-default comprar">comprar</a>
@endif
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-xs-12">
          <div class="ver-mas-equipo">
            <div class="title-detalle">
              <div class="btn-vmas"></div>
              <h4>VER CONSIDERACIONES COMERCIALES</h4>
            </div>
            <div class="content-detalle">
              <p>
                 Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ipsam possimus magnam, eum nobis explicabo. Molestias
                corporis, minima nam quas obcaecati?
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
@endsection
