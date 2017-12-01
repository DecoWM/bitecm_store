@extends('layouts.master')
@section('content')
    <div class="container">
      <div class="row">
        <div class="col-xs-12 col-sm-4">
          <div id="content-page">
            <div class="title">
              <h2>{{$product->brand_name}} {{$product->product_model}}</h2>
            </div>
            @if(isset($product->promo_id))
            <div class="state"><span>PROMOCIÓN</span></div>
            @else
            <div class="state"><span>NUEVO</span></div>
            @endif
            <div id="image-equipo">
              @if(count($product_images)>0)
                <div class="image-product text-center"><img id="zoom_01" src="{{asset('images/productos/'.$product_images[0]->product_image_url)}}" alt="{{$product->product_model}}" data-zoom-image="{{asset('images/productos/'.$product_images[0]->product_image_url)}}">
                </div>
                @if(count($product_images)>1)
                <div id="gallery_01" class="galeria-min">
                  @foreach($product_images as $image)
                  <a href="#" data-image="{{asset('images/productos/'.$image->product_image_url)}}" data-zoom-image="{{asset('images/productos/'.$image->product_image_url)}}">
                    <img src="{{asset('images/productos/'.$image->product_image_url)}}" alt="{{$product->product_model}}">
                  </a>
                  @endforeach
                  <div class="clearfix"></div>
                </div>
                @else
                {{--<div id="gallery_01" class="galeria-min"></div>--}}
                @endif
              @else
              <div class="image-product text-center"><img id="zoom_01" src="{{asset('images/productos/'.$product->product_image_url)}}" alt="{{$product->product_model}}" data-zoom-image="{{asset('images/productos/'.$product->product_image_url)}}">
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
                <h1>{{$product->brand_name}} {{$product->product_model}}</h1>
                @if(isset($product->promo_id))
                <div class="state"><span>PROMOCIÓN</span></div>
                @else
                <div class="state"><span>NUEVO</span></div>
                @endif
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
                          <div class="btn-option">
                            <div class="count-input space-bottom"><a href="#" data-action="decrease" class="incr-btn btn-minus">-</a>
                              <input type="text" value="1" name="quantity" class="quantity"><a href="#" data-action="increase" class="incr-btn btn-plus">+</a>
                            </div>
                          </div>
                        </div>
                        <div class="col-xs-5 col-xs-pull-7 col-sm-12">
                          @if(isset($product->color_id))
                          <div class="color-product">
                            <fieldset>
                              <legend>Color</legend>
                              <div id="option-select" class="option-select">
                                @foreach($stock_models as $stock_model)
                                  @if($stock_model->stock_model_id == $product->stock_model_id)
                                  <div class="radio-inline option-active" style="border: 1px solid #008c95;">
                                    <div class="color-box" style="background-color: #{{$stock_model->color_hexcode}};"></div>
                                  </div>
                                  @else
                                  <a href="{{$stock_model->route}}">
                                    <div class="radio-inline option-active" style="border: none;">
                                      <div class="color-box" style="background-color: #{{$stock_model->color_hexcode}};"></div>
                                    </div>
                                  </a>
                                  @endif
                                @endforeach
                              </div>
                            </fieldset>
                          </div>
                          @endif
                        </div>
                      </div>
                    </div>
                    <div class="col-xs-12 col-sm-6">
                      @if($product->stock_model_id)
                      <div class="btn-carrito">
                        <button type="submit" class="btn-default">AGREGAR AL CARRITO</button>
                      </div>
                      @endif
                      @if($product->plan_id != 15)
                      <div class="btn-linea">
                        {{-- <button type="submit" class="btn-default">QUIERO MI LÍNEA EN POSTPAGO</button> --}}
                        <a href="{{route('postpaid_detail', [
                          'brand'=>$product->brand_slug,
                          'product'=>$product->product_slug,
                          'affiliation'=>$affiliation_slug,
                          'plan'=>$plan_post_slug,
                          'contract'=>$contract_slug
                        ])}}" class="btn-default">QUIERO MI LÍNEA EN POSTPAGO</a>
                      </div>
                      @endif
                      @if($product->stock_model_id)
                      <div class="btn-comprar-prepago">
                        <button type="submit" class="btn-default">Comprar Ahora</button>
                      </div>
                      @else
                      <div class="stock-exhausted">
                        Agotado
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
                  <li> <img src="/images/equipo/svg/android.svg" alt="android"><span class="title-dispositivo">Android 6</span><span class="description-dispositivo">Sistema Operativo</span></li>
                  <li> <img src="/images/equipo/svg/memoria.svg" alt="android"><span class="title-dispositivo">{{$product->product_internal_memory + 0}} GB / {{$product->product_ram_memory + 0}} GB RAM</span><span class="description-dispositivo">Memoria</span></li>
                  <li> <img src="/images/equipo/svg/pantalla.svg" alt="android"><span class="title-dispositivo">{{$product->product_screen_size}}”</span><span class="description-dispositivo">Pantalla</span></li>
                  <li> <img src="/images/equipo/svg/camara.svg" alt="android"><span class="title-dispositivo">{{$product->product_camera_1}} MP / {{$product->product_camera_2}} MP</span><span class="description-dispositivo">Cámara</span></li>
                  <li> <img src="/images/equipo/svg/procesador.svg" alt="android"><span class="title-dispositivo">{{$product->product_processor_value}} GHz {{$product->product_processor_name}}</span><span class="description-dispositivo">Procesador</span></li>
                </ul>
              </div>
              {{--<div class="pdf-tecnica"><a href="{{route('download_file', ['filename' => str_slug($product->product_model)])}}">Descargar ficha técnica<span class="fa fa-download"></span></a></div>--}}
            </div>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-xs-12">
          <a href="{{route('download_FichaTecnica')}}" target="_blank" class="ver-mas-equipo">
            <div class="title-detalle">
              <span  class="btn-vmas"></span>
              <!-- <a class="btn-vmas"></a> -->
              <h4>VER DETALLES TÉCNICOS</h4>
            </div>
          </a>
          <a href="{{route('download_FichaTecnica')}}" target="_blank" class="ver-mas-equipo">
            <div class="title-detalle">
              <span href="{{route('download_Consideraciones')}}" target="_blank" class="btn-vmas"></span>
              <h4>VER CONSIDERACIONES COMERCIALES</h4>
            </div>
          </a>
        </div>
      </div>
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
                    <img src="{{asset('images/productos/'.$item->picture_url)}}" alt="equipos">
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
    </div>
@endsection
