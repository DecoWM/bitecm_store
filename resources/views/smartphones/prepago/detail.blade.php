@extends('layouts.master')
@section('content')
    <div class="container">
      <div class="row">
        <div class="col-xs-12 col-sm-4">
          <div id="content-page">
            <div class="title">
              <h2>{{$product->brand_name}} {{$product->product_model}} {{isset($product->color_id) ? $product->color_name : ''}}</h2>
            </div>
            @include('products.tag',['product' => $product])
            <div id="image-equipo">
              @if(count($product_images)>0)
                <div class="image-product text-center"><img id="zoom_01" src="{{asset(Storage::url($product_images[0]->product_image_url))}}" alt="{{$product->product_model}}">{{-- data-zoom-image="{{asset(Storage::url($product_images[0]->product_image_url))}}">--}}
                </div>
                @if(count($product_images)>1)
                <div id="gallery_01" class="galeria-min">
                  @foreach($product_images as $image)
                  <a href="javascript:void(0)" data-image="{{asset(Storage::url($image->product_image_url))}}">{{-- data-zoom-image="{{asset(Storage::url($image->product_image_url))}}">--}}
                    <img src="{{asset(Storage::url($image->product_image_url))}}" alt="{{$product->product_model}}">
                  </a>
                  @endforeach
                  <div class="clearfix"></div>
                </div>
                @else
                {{--<div id="gallery_01" class="galeria-min"></div>--}}
                @endif
              @else
              <div class="image-product text-center"><img src="{{asset(Storage::url($product->product_image_url))}}" alt="{{$product->product_model}}">{{-- data-zoom-image="{{asset(Storage::url($product->product_image_url))}}">--}}
              </div>
              {{--<div id="gallery_01" class="galeria-min"></div>--}}
              @endif
            </div>
          </div>
        </div>
        <div class="col-xs-12 col-sm-8">
          <section id="descripcion-equipo">
            <div class="header-section">
              <div class="title">
                <h1>{{$product->brand_name}} {{$product->product_model}} {{isset($product->color_id) ? $product->color_name : ''}}</h1>
                @include('products.tag',['product' => $product])
              </div>
              <div class="descripcion">
                <p>{{$product->product_description}}</p>
              </div>
            </div>
            <div class="content-section">
              <form form id="purchase-form" action="{{route('add_to_cart')}}" method="POST">
                {{ csrf_field() }}
                <input type="hidden" name="stock_model" value="{{$product->stock_model_id}}">
                <input type="hidden" name="product_variation" value="{{$product->product_variation_id}}">
                <input type="hidden" name="type" value="1">
                <input type="hidden" name="quantity" value="1">
                <input type="hidden" name="sentinel" value="{{isset($product->product_sentinel) ? $product->product_sentinel : 0 }}">
                <div class="content-product equipo-prepago">
                  <div class="row">
                    <div class="col-xs-12 col-sm-6">
                      <div class="row">
                        <div class="col-xs-7 col-xs-push-5 col-sm-12">
                          <div class="detalle-product">
                            <div class="price-product">
                              @if(isset($product->promo_id))
                              <span>S/.{{$product->promo_price}}</span><span class="normal-price">S/.{{$product->product_price}}</span>
                              @else
                              <span>S/.{{$product->product_price}}</span>
                              @endif
                            </div>
                          </div>
                        </div>
                        <div class="col-xs-5 col-xs-pull-7 col-sm-12">
                          @include('products.colors',['product' => $product, 'stock_models' => $stock_models])
                        </div>
                      </div>
                    </div>
                    <div class="col-xs-12 col-sm-6">
                      {{--@if($product->stock_model_id)
                      <div class="btn-carrito">
                        <button type="submit" class="btn-default">AGREGAR AL CARRITO</button>
                      </div>
                      @endif--}}
                      <div class="btn-linea">
                        @if(isset($product->route_postpago))
                        <a href="{{$product->route_postpago}}" class="btn-default">QUIERO MI LÍNEA EN POSTPAGO</a>
                        @endif
                      </div>
                      @if($product->stock_model_id)
                      <div class="btn-comprar-prepago">
                        <button id="addToCart" type="submit" class="btn-default btn-buy">Comprar Ahora</button>
                      </div>
                      @else
                        <div class="btn-comprar-prepago">
                          <button class="btn-disabled" disabled>Agotado</button>
                        </div>
                      @endif
                    </div>
                  </div>
                </div>
                {{-- <div class="movil-select-product">
                  <select>
                    <option name="" value="">Lo quieres en</option>
                    <option name="prepago" value="prepago">Portabilidad</option>
                    <option name="linea nueva" value="linea nueva">Linea nueva</option>
                    <option name="renovacion" value="renovacion">Renovación</option>
                  </select>
                </div> --}}
              </form>
            </div>
          </section>
          <div id="planes" class="planes-prepago">
            <h3 class="title-plan">Recarga y disfruta de estos beneficios</h3><br/>
            <div class="select-plan just-3">
                <label for="">
                  <div class="plan">
                    <div class="content-plan">
                      <div class="precio-plan"><span class="recarga">Recarga</span> s/3</div>
                      <ul class="list-unstyled">
                        <li><img class="images-prepago-left" src="/images/equipo/svg/planes/llamadas.svg" alt="Llamadas"><span>Llamadas ilimitadas</span></li>
                        <li><img class="images-prepago-left" src="/images/equipo/svg/planes/internet.svg" alt="Internet"><span>100MB Alta disponible </span></li>
                        <li><img class="images-prepago-left" src="/images/equipo/svg/planes/rpb.svg" alt="RPB"><span>RPB ilimitado </span></li>
                        <li><img class="images-prepago-left" src="/images/equipo/svg/planes/sms.svg" alt="SMS"><span>SMS ilimitado (**) </span></li>
                        <li><img class="images-prepago-left" src="/images/equipo/svg/planes/facebook.svg" alt="Facebook"><span>Facebook Gratis </span></li>
                        <li><img src="/images/equipo/svg/planes/whatsapp-line.svg" alt="WhatsApp"><span>WhatsApp & Line Ilimitado </span></li>
                        <li><img src="/images/equipo/svg/planes/video.svg" alt="Youtube"><span>Youtube & Viki gratis desde las 00:00hrs a las 05:00hrs </span></li>
                        <li class="text-center">Apps gratis Hasta 23 hrs 59:59 del día de recarga</span></li>
                      </ul>
                    </div>
                  </div>
                </label>
                <label for="">
                  <div class="plan plan-active">
                    <div class="content-plan">
                      <div class="precio-plan"><span class="recarga">Recarga</span> s/5</div>
                      <ul class="list-unstyled">
                        <li><img class="images-prepago-left" src="/images/equipo/svg/planes/llamadas.svg" alt="Llamadas"><span>Llamadas ilimitadas</span> </span></li>
                        <li><img class="images-prepago-left" src="/images/equipo/svg/planes/internet.svg" alt="Internet"><span>100MB Alta disponible </span></li>
                        <li><img class="images-prepago-left" src="/images/equipo/svg/planes/rpb.svg" alt="RPB"><span>RPB ilimitado </span></li>
                        <li><img class="images-prepago-left" src="/images/equipo/svg/planes/sms.svg" alt="SMS"><span>SMS ilimitado (**) </span></li>
                        <li><img class="images-prepago-left" src="/images/equipo/svg/planes/facebook.svg" alt="Facebook"><span>Facebook Gratis </span></li>
                        <li><img src="/images/equipo/svg/planes/whatsapp-line.svg" alt="WhatsApp"><span>WhatsApp & Line Ilimitado </span></li>
                        <li><img src="/images/equipo/svg/planes/video.svg" alt="Youtube"><span>Youtube & Viki gratis desde las 00:00hrs a las 05:00hrs </span></li>
                        <li class="text-center">Apps gratis Hasta 23 hrs 59:59 del 3er día de recarga</span></li>
                      </ul>
                    </div>
                  </div>
                </label>
                <label for="">
                  <div class="plan">
                    <div class="content-plan"> 
                      <div class="precio-plan"><span class="recarga">Recarga</span> s/10</div>
                      <ul class="list-unstyled">
                        <li><img class="images-prepago-left" src="/images/equipo/svg/planes/llamadas.svg" alt="Llamadas"><span>Llamadas ilimitadas</span> </span></li>
                        <li><img class="images-prepago-left" src="/images/equipo/svg/planes/internet.svg" alt="Internet"><span>100MB Alta disponible </span></li>
                        <li><img class="images-prepago-left" src="/images/equipo/svg/planes/rpb.svg" alt="RPB"><span>RPB ilimitado </span></li>
                        <li><img class="images-prepago-left" src="/images/equipo/svg/planes/sms.svg" alt="SMS"><span>SMS ilimitado (**) </span></li>
                        <li><img class="images-prepago-left" src="/images/equipo/svg/planes/facebook.svg" alt="Facebook"><span>Facebook Gratis </span></li>
                        <li><img src="/images/equipo/svg/planes/whatsapp-line.svg" alt="WhatsApp"><span>WhatsApp & Line Ilimitado </span></li>
                        <li><img src="/images/equipo/svg/planes/video.svg" alt="Youtube">Youtube & Viki gratis desde las 00:00hrs a las 05:00hrs </span></li>
                        <li class="text-center">Apps gratis Hasta 23 hrs 59:59 del 7mo día de recarga</span></li>
                      </ul>
                    </div>
                  </div>
                </label>
            </div>
          </div>
          <section class="descrip-consideracion">
            <!-- <h1>Consideraciones comerciales</h1> -->
            <p>Nota:</p>
            <p>Acceso a app gratuita Cineplanet, Tu ruta, Aló bodega, Mi Media Manzana, También recibirá sin condición y valido mientras que la línea este activa Facebook Flex o Facebook en Modo Gratuito</p>
          </section>
        </div>
      </div>
      <div class="row">
        <div class="col-xs-12">
          <div id="especificaciones-tecnicas">
            <div class="title-detalle">
              <h4>ESPECIFICACIONES TÉCNICAS</h4>
            </div>
            <div class="content-detalle">
              <div class="descripcion-detalle">
                <ul class="list-unstyled">
                  <li> <img src="/images/equipo/svg/android.svg" alt="android"><span class="title-dispositivo">{{$product->product_os}}</span><span class="description-dispositivo">Sistema Operativo</span></li>
                  <li> <img src="/images/equipo/svg/memoria.svg" alt="android"><span class="title-dispositivo">Memoria Interna  {{$product->product_internal_memory}} GB</span><span class="description-dispositivo">Memoria RAM {{$product->product_memory_ram}} GB</span></li>
                  <li> <img src="/images/equipo/svg/pantalla.svg" alt="android"><span class="title-dispositivo">{{$product->product_screen_size}}”</span><span class="description-dispositivo">Pantalla</span></li>
                  <li> <img src="/images/equipo/svg/camara.svg" alt="android"><span class="title-dispositivo">{{$product->product_camera_1}} MP / {{$product->product_camera_2}} MP</span><span class="description-dispositivo">Cámara</span></li>
                  <li> <img src="/images/equipo/svg/procesador.svg" alt="android"><span class="title-dispositivo">{{$product->product_processor_power}} GHz {{$product->product_processor_name}}</span><span class="description-dispositivo">Procesador</span></li>
                </ul>
              </div>
              {{--<div class="pdf-tecnica"><a href="{{route('download_file', ['filename' => str_slug($product->product_model)])}}">Descargar ficha técnica<span class="fa fa-download"></span></a></div>--}}
            </div>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-xs-12">
          <a href="{{route('download_FichaTecnica',[$product->product_id])}}" target="_blank" class="ver-mas-equipo">
            <div class="title-detalle">
              <span  class="btn-vmas"></span>
              <!-- <a class="btn-vmas"></a> -->
              <h4>VER DETALLES TÉCNICOS</h4>
            </div>
          </a>
          <a href="{{route('download_Consideraciones')}}" target="_blank" class="ver-mas-equipo">
            <div class="title-detalle">
              <span class="btn-vmas"></span>
              <h4>VER CONSIDERACIONES COMERCIALES</h4>
            </div>
          </a>
        </div>
      </div>
      @if (count($available) > 0)
      <div class="row">
        <div class="col-xs-12">
          <div id="producto-disponibles">
            <div class="title-detalle">
              <h5>PRODUCTOS DISPONIBLES</h5>
            </div>
            <div class="list-producto">
              @foreach ($available as $item)
              <div class="producto">
                <div class="image-product text-center">
                  <a href="{{$item->route}}">
                    <img src="{{asset(Storage::url($item->picture_url))}}" alt="equipos">
                  </a>
                </div>
                <div class="content-product text-center">
                  <div class="title-product">
                    <h3 class="text-center"><b>{{$item->brand_name}}</b></h3>
                    <h3 class="text-center">{{$item->product_model}}</h3>
                  </div>
                  <div class="price-product">
                    @if($item->promo_id)
                    <span>S/.{{$item->promo_price}}</span>
                    <span class="normal-price">S/.{{$item->product_price}}</span>
                    @else
                    <span>S/.{{$item->product_price}}</span>
                    @endif
                  </div>
                  <div class="btn-comprar"><a href="{{$item->route}}" class="btn btn-default">comprar</a></div>
                </div>
              </div>
              @endforeach
            </div>
          </div>
        </div>
      </div>
      @endif
    </div>
    @php
      $product_init = [
          'product' => $product,
          'product_images' => $product_images,
          'stock_models' => $stock_models,
          'available' => $available
      ];
    @endphp
    <input id="product-init" type="hidden" value='@json($product_init)'>
@endsection
