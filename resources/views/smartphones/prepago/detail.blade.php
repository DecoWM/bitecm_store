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
              <div class="image-product text-center"><img id="zoom_01" src="{{asset('images/productos/'.$product->picture_url)}}" alt="equipos" data-zoom-image="{{asset('images/productos/'.$product->picture_url)}}"></div>
              <div id="gallery_01" class="galeria-min">
                <a href="#" data-image="/images/home/celular-1.jpg" data-zoom-image="/images/home/celular-12.jpg">
                  <img src="/images/home/celular-1.jpg" alt="">
                </a>
                <a href="#" data-image="/images/home/celular-2.jpg" data-zoom-image="/images/home/celular-22.jpg">
                  <img src="/images/home/celular-2.jpg" alt="">
                </a>
                <a href="#" data-image="/images/home/celular-3.jpg" data-zoom-image="/images/home/celular-33.jpg">
                  <img src="/images/home/celular-3.jpg" alt="">
                </a>
                <a href="#" data-image="/images/home/celular-3.jpg" data-zoom-image="/images/home/celular-33.jpg">
                  <img src="/images/home/celular-3.jpg" alt="">
                </a>
                <div class="clearfix"></div>
              </div>
            </div>
          </div>
        </div>
        <div class="col-xs-12 col-sm-8">
          <section id="descripcion-equipo">
            <div class="header-section">
              <div class="title">
                <h1>{{$product->product_model}}</h1>
                <div class="state"><span>PREPAGO</span></div>
              </div>
              <div class="descripcion">
                <p>{{$product->product_description}}</p>
              </div>
            </div>
            <div class="content-section">
              <form action="">
                <div class="content-product equipo-prepago">
                  <div class="row">
                    <div class="col-xs-12 col-sm-6">
                      <div class="row">
                        <div class="col-xs-7 col-xs-push-5 col-sm-12">
                          <div class="detalle-product">
                            <div class="price-product"><span>S/.</span>{{$product->product_price_prepaid}}</div>
                          </div>
                          <div class="btn-option">
                            <div class="count-input space-bottom"><a href="#" data-action="decrease" class="incr-btn btn-minus">-</a>
                              <input type="text" value="1" name="quantity" class="quantity"><a href="#" data-action="increase" class="incr-btn btn-plus">+</a>
                            </div>
                          </div>
                        </div>
                        <div class="col-xs-5 col-xs-pull-7 col-sm-12">
                          <div class="color-product">
                            <fieldset>
                              <legend>Color</legend>
                              <div id="option-select" class="option-select">
                                <div class="radio-inline option-active">
                                  <input type="radio" name="color" value="1" class="negro">
                                </div>
                                <div class="radio-inline">
                                  <input type="radio" name="color" value="2" class="blanco">
                                </div>
                                <div class="radio-inline">
                                  <input type="radio" name="color" value="3" class="gris">
                                </div>
                              </div>
                            </fieldset>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="col-xs-12 col-sm-6">
                      <div class="btn-carrito">
                        <button type="submit" class="btn-default">AGREGAR AL CARRITO</button>
                      </div>
                      <div class="btn-linea">
                        {{-- <button type="submit" class="btn-default">QUIERO MI LÍNEA EN POSTPAGO</button> --}}
                        <a href="{{route('postpaid_detail', ['product'=>$product->product_id])}}" class="btn-default">QUIERO MI LÍNEA EN POSTPAGO</a>
                      </div>
                      <div class="btn-comprar-prepago">
                        {{-- <button type="submit" class="btn-default">Comprar Ahora</button> --}}
                        <a href="{{route('carrito', ['product'=>$product->product_id])}}" class="btn-default">Comprar Ahora</a>
                      </div>
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
              {{-- <div class="pdf-tecnica"><a href="{{route('download_file', ['filename' => str_slug($product->product_model)])}}">Descargar ficha técnica<span class="fa fa-download"></span></a></div> --}}
            </div>
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
              <h5>PRODUCTOS DISPONIBLES</h5>
            </div>
            <div class="list-producto">
@foreach ($available as $product)
              <div class="producto">
                <div class="image-product text-center"><img src="{{asset('images/productos/'.$product->picture_url)}}" alt="equipos"></div>
                <div class="content-product text-center">
                  <div class="title-product">
                    <h3 class="text-center">{{$product->product_model}}</h3>
                  </div>
                  <div class="price-product"><span>S/.</span>{{$product->product_price_prepaid + 0}}</div>
                  <div class="btn-comprar"><a href="{{route('prepaid_detail', ['product'=>$product->product_id])}}" class="btn btn-default">comprar</a></div>
                </div>
              </div>
@endforeach
              {{-- <div class="producto">
                <div class="image-product text-center"><img src="/images/home/celular.jpg" alt="equipos"></div>
                <div class="content-product text-center">
                  <div class="title-product">
                    <h3 class="text-center">LG Stylus 3</h3>
                  </div>
                  <div class="price-product"><span>s/</span>59</div>
                  <div class="btn-comprar"><a href="#" class="btn btn-default">comprar</a></div>
                </div>
              </div>
              <div class="producto">
                <div class="image-product text-center"><img src="./images/home/celular.jpg" alt="equipos"></div>
                <div class="content-product text-center">
                  <div class="title-product">
                    <h3 class="text-center">LG Stylus 3</h3>
                  </div>
                  <div class="price-product"><span>s/</span>59</div>
                  <div class="btn-comprar"><a href="#" class="btn btn-default">comprar</a></div>
                </div>
              </div> --}}
            </div>
          </div>
        </div>
      </div>
    </div>
@endsection
