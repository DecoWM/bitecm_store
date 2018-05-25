@extends('layouts.master')
@section('content')
@if (session('msg'))
    <div class="alert alert-warning alert-dismissible" role="alert">
      <button type="button" class="btn-close close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      <div class="alert-body">
        <div class="row">
          <div class="center-flex">
            <div class="col-xs-12 col-sm-4">
              <img class="img-responsive" src="{{asset('images/alerts/img-left.png')}}" alt="">
            </div>
            <div class="col-xs-12 col-sm-8">
              <div class="text-center">
                {{-- {{session('msg')}} --}}
                Al momento solo está disponible
                hacer la compra de <b>un solo producto</b>
                por pedido, si deseas comprar
                un producto adicional, termina el
                pedido seleccionado o borra el
                producto elegido.
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
@endif
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
                  <p>Único pago</p>
                </div>
                <div class="col-xs-12 col-sm-4">
                  <p>Pago plan mensual</p>
                </div>
              </div>
            </div>
            @if (count($products) > 0)
            @foreach ($products as $product)
            <div class="main-detalle equipos">
              <div class="row">
                <div class="col-xs-12 col-sm-4">
                  <div class="equipo-seleccionado">
                    <div class="imagen-equipo">
                      <form action="{{route('remove_from_cart')}}" method="POST">
                        {{ csrf_field() }}
                        <input type="hidden" name="stock_model" value="{{$product->stock_model_id}}">
                        @if(isset($product->product_variation_id))
                        <input type="hidden" name="product_variation" value="{{$product->product_variation_id}}">
                        @endif
                        <button class="btn-eliminar-equipo btn-cart-delete"><i class="fa fa-times"></i></button>
                        <input type="submit" style="display: none">
                      </form>
                      <img src="{{asset(Storage::url($product->product_image_url))}}" alt="equipos">
                    </div>
                    <div class="detalle-equipo">
                      <h2>{{$product->brand_name}} {{$product->product_model}} {{isset($product->color_name) ? $product->color_name : ''}}</h2>
                      @if (intval($product->type_id) == 2)
                      <span class="modo">{{$product->affiliation_name}}</span>
                      <!--span class="contrato">Contrato {{--$product->contract_name--}}</span-->
                      <span class="contrato">Sin contrato de permanencia (*)</span>
                      @elseif (intval($product->type_id) == 1)
                      <span class="modo">Prepago {{$product->plan_name}}</span>
                      @endif
                      @if (!isset($product->variation_type_id))
                      <div class="cantidad">
                        <div class="btn-option">
                          <div class="count-input space-bottom">
                            <form action="{{route('update_cart')}}" method="POST">
                              {{ csrf_field() }}
                              <input type="hidden" name="stock_model" value="{{$product->stock_model_id}}">
                              {{--@if(isset($product->product_variation_id))
                              <input type="hidden" name="product_variation" value="{{$product->product_variation_id}}">
                              @endif--}}
                              <a href="#" data-action="decrease" data-limit="1" class="incr-btn btn-minus">-</a>
                              <a href="#" data-action="increase" data-limit="10" class="incr-btn btn-plus">+</a>
                              <input type="text" value="{{$product->quantity}}" name="quantity" class="quantity">
                              <input type="submit" style="display: none">
                            </form>
                          </div>
                        </div>
                      </div>
                      @endif
                    </div>
                  </div>
                </div>
                <div class="col-xs-6 col-sm-4"><span class="title-detalle">ÚLTIMO PAGO</span>
                  @if(isset($product->promo_id))
                  <span>S/. {{$product->promo_price}}<span>
                  <span class="normal-price">S/. {{$product->product_price}}<span>
                  @else
                  <span>S/. {{$product->product_price}}<span>
                  @endif
                </div>
                <div class="col-xs-6 col-sm-4">
                  <span class="title-detalle">PAGO MENSUAL</span>
                  @if (intval($product->type_id) == 2)
                  <p>S/. {{$product->plan_price}}</p>
                  <span class="plan">{{$product->plan_name}}</span>
                  @else
                  <p> - </p>
                  @endif
                </div>
              </div>
            </div>
            @endforeach
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
            <div class="main-detalle col-offset">
              <div class="row">
                <div class="col-xs-12 col-sm-4">
                  <p class="version-mobil text-right">TOTAL + IGV</p>
                </div>
                <div class="col-xs-6 col-sm-4"><span class="title-detalle">TOTAL + IGV</span>
                  <p>
                    <span>S/. {{$total}}<span>
                  </p>
                </div>
                <div class="col-xs-6 col-sm-4"><span class="title-detalle"> </span>
                  @if (isset($equipo) && intval($equipo->type_id) == 2)
                  <p>S/. {{$equipo->plan_price}} mensual</p>
                  @else
                  <p> - </p>
                  @endif
                </div>
              </div>
            </div>
            <div class="cons-cart">
              <p>* Al hacer click en “comprar” aceptas las condiciones comerciales de ventas de equipos de Bitel, basado en la aplicación de rentas adelantadas de acuerdo al plan contratado posteriormente.</p>
            </div>
            {{--<div class="main-detalle col-offset sinborder">
              <div class="row">
                <div class="col-xs-12 col-sm-4">
                  <p class="version-mobil text-right">TOTAL + IGV</p>
                </div>
                <div class="col-xs-6 col-sm-4">
                  <span class="title-detalle">TOTAL + IGV</span>
                  <p>S/. {{$total_igv}}</p>
                </div>
              </div>
            </div>--}}
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
                  @if (count($products) > 0)
                  <a href="{{session('back_button')}}" class="btn btn-default regresar">REGRESAR</a>
                  {{-- <button type="submit" class="btn btn-default regresar">REGRESAR</button> --}}
                  {{-- <button type="submit" href="{{route('envio', ['product'=>$product->product_id])}}" class="redirect-href btn btn-default comprar">comprar</button> --}}
                  <a id="initiateCheckout" href="{{route('create_order')}}" class="btn btn-default comprar">comprar</a>
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
            <a href="{{route('download_Consideraciones')}}" target="_blank" class="ver-mas-equipo">
              <div class="title-detalle">
                <span class="btn-vmas"></span>
                <h4>VER CONSIDERACIONES COMERCIALES</h4>
              </div>
            </a>
            {{-- <div class="content-detalle">
              <p>
                 Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ipsam possimus magnam, eum nobis explicabo. Molestias
                corporis, minima nam quas obcaecati?
              </p>
            </div> --}}
          </div>
        </div>
      </div>
    </div>
@endsection
