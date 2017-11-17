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
        <div class="col-xs-12">
          <div id="compara-tus-equipos">
            <div class="info-lista">
              <div class="especificaciones">
                <div class="bg-gray"><span>Marca</span></div>
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
                  <div class="image-product text-center"><img src="{{asset('images/productos/'.$product->picture_url)}}" alt="equipos"></div>
                  <div class="content-product text-center">
                    <div class="title-product">
                      <h3 class="text-center">{{$product->product_model}}</h3>
                    </div>
                    {{-- <div class="price-product"><span>S/</span>{{$product->product_price_prepaid + 0}}</div>
                    <div class="plan-product">
                      <p>en plan <span>Megaplus 119</span></p>
                    </div> --}}
                    <div class="btn-product form-inline">
                      <div class="form-group btn-vermas"><a href="{{route('postpaid_detail', ['product'=>$product->product_id])}}" class="btn btn-default">Ver más</a></div>
                    </div>
                  </div>
                </div>
                <div class="especificaciones">
                  <div class="bg-gray"><span>Marca</span>
                    <p>{{$product->brand_name}}</p>
                  </div>
                  <div class="bg-white"><span>Color</span>
                    <p>Plateado</p>
                  </div>
                  <div class="bg-gray"><span>Cámara Principal</span>
                    <p>{{$product->product_camera_1}} MP</p>
                  </div>
                  <div class="bg-white"><span>Cámara Posterior</span>
                    <p>{{$product->product_camera_2}} MP</p>
                  </div>
                  <div class="bg-gray"><span>Radio</span>
                    <p>Sí</p>
                  </div>
                  <div class="bg-white"><span>Pantalla</span>
                    <p>{{$product->product_screen_size}}"</p>
                  </div>
                  <div class="bg-gray"><span>Memoria Externa</span>
                    <p>128GB</p>
                  </div>
                  <div class="bg-white"><span>Memoria Interna</span>
                    <p>{{$product->product_internal_memory}}GB</p>
                  </div>
                  <div class="bg-gray"><span>WLAN</span>
                    <p>Sí</p>
                  </div>
                  <div class="bg-white"><span>Bluetooth</span>
                    <p>Sí</p>
                  </div>
                  <div class="bg-gray"><span>Sistema Operativo</span>
                    <p>Android 6,0</p>
                  </div>
                  <div class="bg-white"><span>GPS</span>
                    <p>Sí</p>
                  </div>
                  <div class="bg-gray"><span>Batería</span>
                    <p>2000mAh</p>
                  </div>
                </div>
              </div>
@endforeach


              {{-- <div class="equipo-seleccionado">
                <div data-equipo="1" class="equipo">
                  <div class="image-product text-center"><img src="./images/home/celular.jpg" alt="equipos"></div>
                  <div class="content-product text-center">
                    <div class="title-product">
                      <h3 class="text-center">LG Stylus 3</h3>
                    </div>
                    <div class="price-product"><span>s/</span>59</div>
                    <div class="plan-product">
                      <p>en plan <span>Megaplus 119</span></p>
                    </div>
                    <div class="btn-product form-inline">
                      <div class="form-group btn-vermas"><a href="https://bitel.clientes-forceclose.com/bitel_frontend/dist/equipo_nuevo.html" class="btn btn-default">Ver más</a></div>
                    </div>
                  </div>
                </div>
                <div class="especificaciones">
                  <div class="bg-gray"><span>Marca</span>
                    <p>LG</p>
                  </div>
                  <div class="bg-white"><span>Color</span>
                    <p>Plateado</p>
                  </div>
                  <div class="bg-gray"><span>Cámara Principal</span>
                    <p>12 MP</p>
                  </div>
                  <div class="bg-white"><span>Cámara Posterior</span>
                    <p>8MP</p>
                  </div>
                  <div class="bg-gray"><span>Radio</span>
                    <p>Sí</p>
                  </div>
                  <div class="bg-white"><span>Pantalla</span>
                    <p>5,2"</p>
                  </div>
                  <div class="bg-gray"><span>Memoria Externa</span>
                    <p>128GB</p>
                  </div>
                  <div class="bg-white"><span>Memoria Interna</span>
                    <p>32GB</p>
                  </div>
                  <div class="bg-gray"><span>WLAN</span>
                    <p>Sí</p>
                  </div>
                  <div class="bg-white"><span>Bluetooth</span>
                    <p>Sí</p>
                  </div>
                  <div class="bg-gray"><span>Sistema Operativo</span>
                    <p>Android 6,0</p>
                  </div>
                  <div class="bg-white"><span>GPS</span>
                    <p>Sí</p>
                  </div>
                  <div class="bg-gray"><span>Batería</span>
                    <p>2000mAh</p>
                  </div>
                </div>
              </div>
              <div class="equipo-seleccionado">
                <div data-equipo="1" class="equipo">
                  <div class="image-product text-center"><img src="./images/home/celular.jpg" alt="equipos"></div>
                  <div class="content-product text-center">
                    <div class="title-product">
                      <h3 class="text-center">LG Stylus 3</h3>
                    </div>
                    <div class="price-product"><span>s/</span>59</div>
                    <div class="plan-product">
                      <p>en plan <span>Megaplus 119</span></p>
                    </div>
                    <div class="btn-product form-inline">
                      <div class="form-group btn-vermas"><a href="https://bitel.clientes-forceclose.com/bitel_frontend/dist/equipo_nuevo.html" class="btn btn-default">Ver más</a></div>
                    </div>
                  </div>
                </div>
                <div class="especificaciones">
                  <div class="bg-gray"><span>Marca</span>
                    <p>LG</p>
                  </div>
                  <div class="bg-white"><span>Color</span>
                    <p>Plateado</p>
                  </div>
                  <div class="bg-gray"><span>Cámara Principal</span>
                    <p>12 MP</p>
                  </div>
                  <div class="bg-white"><span>Cámara Posterior</span>
                    <p>8MP</p>
                  </div>
                  <div class="bg-gray"><span>Radio</span>
                    <p>Sí</p>
                  </div>
                  <div class="bg-white"><span>Pantalla</span>
                    <p>5,2"</p>
                  </div>
                  <div class="bg-gray"><span>Memoria Externa</span>
                    <p>128GB</p>
                  </div>
                  <div class="bg-white"><span>Memoria Interna</span>
                    <p>32GB</p>
                  </div>
                  <div class="bg-gray"><span>WLAN</span>
                    <p>Sí</p>
                  </div>
                  <div class="bg-white"><span>Bluetooth</span>
                    <p>Sí</p>
                  </div>
                  <div class="bg-gray"><span>Sistema Operativo</span>
                    <p>Android 6,0</p>
                  </div>
                  <div class="bg-white"><span>GPS</span>
                    <p>Sí</p>
                  </div>
                  <div class="bg-gray"><span>Batería</span>
                    <p>2000mAh</p>
                  </div>
                </div>
              </div>
              <div class="equipo-seleccionado">
                <div data-equipo="1" class="equipo">
                  <div class="image-product text-center"><img src="./images/home/celular.jpg" alt="equipos"></div>
                  <div class="content-product text-center">
                    <div class="title-product">
                      <h3 class="text-center">LG Stylus 3</h3>
                    </div>
                    <div class="price-product"><span>s/</span>59</div>
                    <div class="plan-product">
                      <p>en plan <span>Megaplus 119</span></p>
                    </div>
                    <div class="btn-product form-inline">
                      <div class="form-group btn-vermas"><a href="https://bitel.clientes-forceclose.com/bitel_frontend/dist/equipo_nuevo.html" class="btn btn-default">Ver más</a></div>
                    </div>
                  </div>
                </div>
                <div class="especificaciones">
                  <div class="bg-gray"><span>Marca</span>
                    <p>LG</p>
                  </div>
                  <div class="bg-white"><span>Color</span>
                    <p>Plateado</p>
                  </div>
                  <div class="bg-gray"><span>Cámara Principal</span>
                    <p>12 MP</p>
                  </div>
                  <div class="bg-white"><span>Cámara Posterior</span>
                    <p>8MP</p>
                  </div>
                  <div class="bg-gray"><span>Radio</span>
                    <p>Sí</p>
                  </div>
                  <div class="bg-white"><span>Pantalla</span>
                    <p>5,2"</p>
                  </div>
                  <div class="bg-gray"><span>Memoria Externa</span>
                    <p>128GB</p>
                  </div>
                  <div class="bg-white"><span>Memoria Interna</span>
                    <p>32GB</p>
                  </div>
                  <div class="bg-gray"><span>WLAN</span>
                    <p>Sí</p>
                  </div>
                  <div class="bg-white"><span>Bluetooth</span>
                    <p>Sí</p>
                  </div>
                  <div class="bg-gray"><span>Sistema Operativo</span>
                    <p>Android 6,0</p>
                  </div>
                  <div class="bg-white"><span>GPS</span>
                    <p>Sí</p>
                  </div>
                  <div class="bg-gray"><span>Batería</span>
                    <p>2000mAh</p>
                  </div>
                </div>
              </div> --}}
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
