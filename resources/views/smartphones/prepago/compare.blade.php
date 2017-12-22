@extends('layouts.master')
@section('content')
    <div class="container">
      <div class="row">
        <div class="col-xs-12">
          <div class="title-page">
            <h2>Compara tus equipos</h2>
          </div>
        </div>
      </div>
      @if (!$errors->any())
      <div class="row">
        <div class="col-xs-12 list-compare">
          <div id="fixed-nav-comp">
            <div class="container">
              <div id="scroll-compara">
                <div class="nav-compara">
                    @foreach ($products as $product)
                        <div class="equipo-seleccionado eselec-{{$loop->index + 1}}">
                          <div data-equipo="1" class="equipo equipo-comp-{{$loop->index  + 1}}">
                            <div class="image-product text-center"><img src="{{asset('images/productos/'.$product->picture_url)}}" alt="equipos"></div>
                            <div class="content-product text-center">
                              <div class="title-product">
                                <h3 class="text-center"><b>{{$product->brand_name}}</b></h3>
                                <h3 class="text-center">{{$product->product_model}}</h3>
                              </div>
                              <div class="price-product">
                                <span>S/.{{$product->product_price}}</span>
                              </div>
                              <div class="btn-product form-inline">
                                <div class="form-group btn-vermas"><a href="{{$product->route}}" class="btn btn-default">Ver más</a></div>
                              </div>
                            </div>
                          </div>
                        </div>
                      @endforeach 
                  </div>
              </div>
            </div>
          </div>
          <div id="compara-tus-equipos">
            <div class="info-lista">
              <div class="especificaciones">
                <!-- <div class="bg-gray"><span>Marca</span></div> -->
                <div class="bg-white"><span>Color</span></div>
                <div class="bg-gray"><span>Cámara Principal</span></div>
                <div class="bg-white"><span>Cámara Posterior</span></div>
                <div class="bg-gray"><span>Radio</span></div>
                <div class="bg-white"><span>Pantalla</span></div>
                <div class="bg-gray"><span>Memoria Externa</span></div>
                <div class="bg-white"><span>Memoria Interna</span></div>
                <div class="bg-gray"><span>WLAN</span></div>
                <div class="bg-white"><span>Bluetooth</span></div>
                <div class="bg-gray"><span>Sistema Operativo</span></div>
                <div class="bg-white"><span>GPS</span></div>
                <div class="bg-gray"><span>Batería</span></div>
              </div>
            </div>
            <div class="lista-equipos">
              @foreach ($products as $product)
              <div class="equipo-seleccionado">
                <div data-equipo="1" class="equipo">
                  <div class="image-product text-center"><img class="image-prepago" src="{{asset('images/productos/'.$product->picture_url)}}" alt="equipos"></div>
                  <div class="content-product text-center">
                    <div class="title-product">
                      <h3 class="text-center"><b>{{$product->brand_name}}</b></h3>
                      <h3 class="text-center">{{$product->product_model}}</h3>
                    </div>
                    <div class="price-product">
                      <span>S/.{{$product->product_price}}</span>
                    </div>
                    <div class="btn-product form-inline">
                      <div class="form-group btn-vermas"><a href="{{$product->route}}" class="btn btn-default">Ver más</a></div>
                    </div>
                  </div>
                </div>
                <div class="especificaciones">
                  <!-- <div class="bg-gray"><span>Marca</span>
                    <p>{{$product->brand_name}}</p>
                  </div> -->
                  <div class="bg-white"><span>Color</span>
                    <p>{{isset($product->color_id) ? $product->color_name : 'Ninguno'}}</p>
                  </div>
                  <div class="bg-gray"><span>Cámara Principal</span>
                    <p>{{$product->product_camera_1}} MP</p>
                  </div>
                  <div class="bg-white"><span>Cámara Posterior</span>
                    <p>{{$product->product_camera_2}} MP</p>
                  </div>
                  <div class="bg-gray"><span>Radio</span>
                    <p>{{$product->product_radio}}</p>
                  </div>
                  <div class="bg-white"><span>Pantalla</span>
                    <p>{{$product->product_screen_size}}"</p>
                  </div>
                  <div class="bg-gray"><span>Memoria Externa</span>
                    <p>{{$product->product_external_memory}}</p>
                  </div>
                  <div class="bg-white"><span>Memoria Interna</span>
                    <p>{{$product->product_internal_memory}}GB</p>
                  </div>
                  <div class="bg-gray"><span>WLAN</span>
                    <p>{{$product->product_wlan}}</p>
                  </div>
                  <div class="bg-white"><span>Bluetooth</span>
                    <p>{{$product->product_bluetooth}}</p>
                  </div>
                  <div class="bg-gray"><span>Sistema Operativo</span>
                    <p>{{$product->product_os}}</p>
                  </div>
                  <div class="bg-white"><span>GPS</span>
                    <p>{{$product->product_gps}}</p>
                  </div>
                  <div class="bg-gray"><span>Batería</span>
                    <p>{{$product->product_battery}}</p>
                  </div>
                </div>
              </div>
              @endforeach
            </div>
          </div>
        </div>
      </div>
      @else
      <div class="row">
        <div class="col-xs-12">
          No se encontraron resultados
          {{-- @if ($errors->any())
          <div class="alert alert-danger">
            <ul>
              @foreach ($errors->all() as $error)
              <li>{{ $error }}</li>
              @endforeach
            </ul>
          </div>
          @endif --}}
        </div>
      </div>
      @endif
    </div>
@endsection
