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
            </div>
            <div class="content-section">
              <form form id="purchase-form" action="{{route('add_to_cart')}}" method="POST">
                {{ csrf_field() }}
                <input type="hidden" name="stock_model" value="{{$product->stock_model_id}}">
                <input type="hidden" name="type" value="0">
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
                            <div class="count-input space-bottom">
                              <a href="#" data-action="decrease" data-limit="1" class="incr-btn btn-minus">-</a>
                              <input type="text" value="1" name="quantity" class="quantity"><a href="#" data-action="increase" data-limit="10" class="incr-btn btn-plus">+</a>
                            </div>
                          </div>
                        </div>
                        <div class="col-xs-5 col-xs-pull-7 col-sm-12">
                          @include('products.colors',['product' => $product, 'stock_models' => $stock_models])
                        </div>
                      </div>
                    </div>
                    <div class="col-xs-12 col-sm-6">
                      @if($product->stock_model_id)
                      {{--<div class="btn-carrito">
                        <button type="submit" class="btn-default">AGREGAR AL CARRITO</button>
                      </div>--}}
                      <div class="btn-comprar-prepago">
                        <button id="addToCart" type="submit" class="btn-default btn-buy">Comprar Ahora</button>
                        <script>
                          $('#addToCart').click(function() {
                            fbq('track', 'AddToCart');
                            console.log('fbq add to cart');
                          });
                        </script>
                      </div>
                      @else
                      <div class="stock-exhausted">
                        Agotado
                      </div>
                      @endif
                    </div>
                  </div>
                </div>
              </form>
            </div>
          </section>
          <div class="descripcion" style="margin-top: 20px">
            <p>{{$product->product_description}}</p>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-xs-12">
          <div class="ver-mas-equipo">
            <div class="title-detalle">
              <div class="btn-vmas"></div>
              <h4>VER DETALLES TÉCNICOS</h4>
            </div>
            {{-- <div class="content-detalle">
              <p>
                 Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ipsam possimus magnam, eum nobis explicabo. Molestias
                corporis, minima nam quas obcaecati?
              </p>
            </div> --}}
          </div>
          <div class="ver-mas-equipo">
            <div class="title-detalle">
              <div class="btn-vmas"></div>
              <h4>VER CONSIDERACIONES COMERCIALES</h4>
            </div>
            {{-- <div class="content-detalle">
              <p>
                 Lorem ipsum dolor sit amet, consectetur adipisicing elit. Debitis minima ducimus, molestiae cumque a eos.
                Consequuntur et, architecto ipsum molestias.
              </p>
            </div> --}}
          </div>
        </div>
      </div>
      @if (count($available) > 0)
      <div class="row">
        <div class="col-xs-12">
          <div id="producto-disponibles">
            <div class="title-detalle">
              <h5>{{strtoupper($title)}} DISPONIBLES</h5>
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
