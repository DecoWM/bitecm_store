@extends('layouts.master')
@section('content')
    <div class="container">
      <div class="row">
        <div class="col-xs-12 col-sm-4">
          <div id="content-page">
            <div class="title">
              <h2>{{$product->product_model}}</h2>
            </div>
            <div class="state"><span>NUEVO</span></div>
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
                <h1>{{$product->product_model}}</h1>
                <div class="state"><span>NUEVO</span></div>
              </div>
              <div class="descripcion">
                <p>{{$product->product_description}}</p>
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
                            <div class="price-product"><span>s/</span> {{$product->product_price}}</div>
                          </div>
                          <div class="btn-option">
                            <div class="count-input space-bottom"><a href="#" data-action="decrease" class="incr-btn btn-minus">-</a>
                              <input type="text" value="1" name="quantity" class="quantity"><a href="#" data-action="increase" class="incr-btn btn-plus">+</a>
                            </div>
                          </div>
                        </div>
                        <div class="col-xs-5 col-xs-pull-7 col-sm-12">
                          @if($product->stock_model_id)  
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
              </form>
            </div>
          </section>
        </div>
      </div>
      <div class="row">
        <div class="col-xs-12">
          <div class="ver-mas-equipo">
            <div class="title-detalle">
              <div class="btn-vmas"></div>
              <h4>VER DETALLES TÉCNICOS</h4>
            </div>
            <div class="content-detalle">
              <p>
                 Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ipsam possimus magnam, eum nobis explicabo. Molestias
                corporis, minima nam quas obcaecati?
              </p>
            </div>
          </div>
          <div class="ver-mas-equipo">
            <div class="title-detalle">
              <div class="btn-vmas"></div>
              <h4>VER CONSIDERACIONES COMERCIALES</h4>
            </div>
            <div class="content-detalle">
              <p>
                 Lorem ipsum dolor sit amet, consectetur adipisicing elit. Debitis minima ducimus, molestiae cumque a eos.
                Consequuntur et, architecto ipsum molestias.
              </p>
            </div>
          </div>
        </div>
      </div>
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
                    <img src="{{$item->picture_url}}" alt="equipos">
                  </a>
                </div>
                <div class="content-product text-center">
                  <div class="title-product">
                    <h3 class="text-center">{{$item->product_model}}</h3>
                  </div>
                  <div class="price-product"><span>S/.</span><span>{{$item->product_price + 0}}</span></div>
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