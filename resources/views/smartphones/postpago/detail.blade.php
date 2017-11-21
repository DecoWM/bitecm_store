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
                <div class="state"><span>NUEVO</span></div>
              </div>
              <div class="descripcion">
                <p>{{$product->product_description}}</p>
              </div>
            </div>
            <div class="content-section">
              <form form id="purchase-form" action="{{route('add_to_cart')}}" method="POST">
                {{ csrf_field() }}
                <input type="hidden" name="product" value="{{$product->product_id}}">
                <input type="hidden" name="type" value="2">
                <input type="hidden" name="quantity" value="1">
                <div class="content-product">
                  <div class="row">
                    <div class="col-xs-5 col-sm-6">
                      <div class="select-product"><span class="title-select">Lo quieres en</span>
                        <select form="purchase-form" name="affiliation" v-model="filters.affiliation.value">
                          <option value="1" >Portabilidad</option>
                          <option value="2">Linea nueva</option>
                          <option value="3">Renovación</option>
                        </select>
                      </div>
                      <div class="color-product">
                        <fieldset>
                          <legend>Color</legend>
                          <div id="option-select" class="option-select">
                            <div class="radio-inline option-active">
                              <input type="radio" name="color" id="negro" value="1" class="negro" checked>
                            </div>
                            <div class="radio-inline">
                              <input type="radio" name="color" id="blanco" value="2" class="blanco">
                            </div>
                            <div class="radio-inline">
                              <input type="radio" name="color" id="gris" value="3" class="gris">
                            </div>
                          </div>
                        </fieldset>
                      </div>
                    </div>
                    <div class="col-xs-7 col-sm-6">
                      <div class="detalle-product" v-cloak>
                        {{-- <div class="price-product"><span>s/</span>59</div> --}}
                        <div class="price-product" v-if="filters.affiliation.value == 1"><span>S/.</span>@{{selectedPlan.product_variation_price.portability}}</div>
                        <div class="price-product" v-if="filters.affiliation.value != 1"><span>S/.</span>@{{selectedPlan.product_variation_price.new}}</div>
                        <div class="plan-product">
                          <p>con <span>@{{selectedPlan.plan_name}}</span></p>
                        </div>
                        <div class="tiempo-plan">
                          <p>Contrato de 18 meses</p>
                        </div>
                      </div>
                    </div>
                    <div class="col-xs-12 col-sm-offset-6 col-sm-6">
                      {{-- <form action="{{route('add_to_cart')}}" method="post"> --}}
                      {{-- <form id="purchase-form"purchase form action="{{route('carrito', ['product'=>$product->product_id])}}" method="get"> --}}
                        <div class="btn-comprar">
                          <button type="submit" class="btn-default">Comprar Ahora</button>
                        </div>
                      {{-- </form> --}}
                      {{-- <div class="btn-comprar">
                        <a href="{{route('carrito', ['product'=>$product->product_id])}}" class="btn-default">Comprar Ahora</a> --}}
                        {{-- <button type="submit" class="btn-default">Comprar Ahora</button> --}}
                      {{-- </div> --}}
                    </div>
                  </div>
                </div>
                <div class="movil-select-product">
                  <select>
                    <option name="" value="">Lo quieres en</option>
                    <option name="prepago" value="prepago">Portabilidad</option>
                    <option name="linea nueva" value="linea nueva">Linea nueva</option>
                    <option name="renovacion" value="renovacion">Renovación</option>
                  </select>
                </div>
              </form>
            </div>
          </section>
        </div>
      </div>
      <div class="row">
        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-offset-4 col-lg-8">
          <div id="planes" class="planes">
            <h3 class="title-plan">Escoge el plan que prefieras:</h3>
            <div class="select-plan">
@foreach ($plans as $plan)
@php
    $price = [];
    foreach ($plan as $item) {
        $price[$item->affiliation_id == 1 ? 'portability' : 'new'] = $item->product_variation_price;
    }
    $selected = [
        'plan_name' => $plan[0]->plan_name,
        'product_variation_price' => $price
    ];
@endphp
              {{-- <div class="plan" v-on:click="selectPlan({plan_id:{{$plan[0]->plan_id}}, product_variation_price: {{$plan[0]->product_variation_price}}, plan_name: '{{$plan[0]->plan_name}}'})"> --}}
              <label>
              <input type="radio" name="plan" form="purchase-form" value="{{$plan[0]->plan_id}}" style="display:none;" {{$plan[0]->plan_id == 8 ? 'checked' : ''}}>
              <div class="plan" v-on:click="selectPlan({{str_replace('\"', '\'', json_encode($selected))}})">
                <div class="content-plan"><span class="title-plan">{{$plan[0]->plan_name}}</span>
                  <div class="precio-plan">S/. {{$plan[0]->plan_price}}<span>al mes</span></div>
                  <ul class="list-unstyled">
@if ($plan[0]->plan_unlimited_calls == 1)
                    <li><img src="/images/equipo/svg/planes/llamadas.svg" alt="Llamadas">Llamadas ilimitadas</li>
@endif
                    <li><img src="/images/equipo/svg/planes/internet.svg" alt="internet">{{$plan[0]->plan_data_cap}} internet</li>
@if ($plan[0]->plan_unlimited_rpb == 1)
                    <li><img src="/images/equipo/svg/planes/rpb.svg" alt="RPB">RPB ilimitado</li>
@endif
@if ($plan[0]->plan_unlimited_sms == 1)
                    <li><img src="/images/equipo/svg/planes/sms.svg" alt="SMS">SMS ilimitado</li>
@endif
@if ($plan[0]->plan_free_facebook == 1)
                    <li><img src="/images/equipo/svg/planes/facebook.svg" alt="Facebook">Facebook Gratis</li>
@endif
@if ($plan[0]->plan_unlimited_whatsapp == 1)
                    <li><img src="/images/equipo/svg/planes/whatsapp.svg" alt="WhatsApp">WhatsApp Ilimitado</li>
@endif
                  </ul>
                </div>
              </div>
              </label>
@endforeach

              {{-- <div class="plan">
                <div class="content-plan"><span class="title-plan">Megaplus 99</span>
                  <div class="precio-plan">S/.99<span>al mes</span></div>
                  <ul class="list-unstyled">
                    <li><img src="/images/equipo/svg/planes/llamadas.svg" alt="Llamadas">Llamadas ilimitadas</li>
                    <li><img src="/images/equipo/svg/planes/internet.svg" alt="internet">15GB internet</li>
                    <li><img src="/images/equipo/svg/planes/rpb.svg" alt="RPB">RPB ilimitado</li>
                    <li><img src="/images/equipo/svg/planes/sms.svg" alt="SMS">SMS ilimitado</li>
                    <li><img src="/images/equipo/svg/planes/facebook.svg" alt="Facebook">Facebook Gratis</li>
                    <li><img src="/images/equipo/svg/planes/whatsapp.svg" alt="WhatsApp">WhatsApp Ilimitado</li>
                  </ul>
                </div>
              </div>
              <div class="plan plan-active">
                <div class="content-plan"><span class="title-plan">Megaplus 119.90</span>
                  <div class="precio-plan">S/.119<span>al mes</span></div>
                  <ul class="list-unstyled">
                    <li><img src="/images/equipo/svg/planes/llamadas.svg" alt="Llamadas">Llamadas ilimitadas</li>
                    <li><img src="/images/equipo/svg/planes/internet.svg" alt="internet">15GB internet</li>
                    <li><img src="/images/equipo/svg/planes/rpb.svg" alt="RPB">RPB ilimitado</li>
                    <li><img src="/images/equipo/svg/planes/sms.svg" alt="SMS">SMS ilimitado</li>
                    <li><img src="/images/equipo/svg/planes/facebook.svg" alt="Facebook">Facebook Gratis</li>
                    <li><img src="/images/equipo/svg/planes/whatsapp.svg" alt="WhatsApp">WhatsApp Ilimitado</li>
                  </ul>
                </div>
              </div>
              <div class="plan">
                <div class="content-plan"><span class="title-plan">Megaplus 149.90</span>
                  <div class="precio-plan">S/.149<span>al mes</span></div>
                  <ul class="list-unstyled">
                    <li><img src="/images/equipo/svg/planes/llamadas.svg" alt="Llamadas">Llamadas ilimitadas</li>
                    <li><img src="/images/equipo/svg/planes/internet.svg" alt="internet">15GB internet</li>
                    <li><img src="/images/equipo/svg/planes/rpb.svg" alt="RPB">RPB ilimitado</li>
                    <li><img src="/images/equipo/svg/planes/sms.svg" alt="SMS">SMS ilimitado</li>
                    <li><img src="/images/equipo/svg/planes/facebook.svg" alt="Facebook">Facebook Gratis</li>
                    <li><img src="/images/equipo/svg/planes/whatsapp.svg" alt="WhatsApp">WhatsApp Ilimitado</li>
                  </ul>
                </div>
              </div>
              <div class="plan">
                <div class="content-plan"><span class="title-plan">Megaplus 189.90</span>
                  <div class="precio-plan">S/.189<span>al mes</span></div>
                  <ul class="list-unstyled">
                    <li><img src="/images/equipo/svg/planes/llamadas.svg" alt="Llamadas">Llamadas ilimitadas</li>
                    <li><img src="/images/equipo/svg/planes/internet.svg" alt="internet">15GB internet</li>
                    <li><img src="/images/equipo/svg/planes/rpb.svg" alt="RPB">RPB ilimitado</li>
                    <li><img src="/images/equipo/svg/planes/sms.svg" alt="SMS">SMS ilimitado</li>
                    <li><img src="/images/equipo/svg/planes/facebook.svg" alt="Facebook">Facebook Gratis</li>
                    <li><img src="/images/equipo/svg/planes/whatsapp.svg" alt="WhatsApp">WhatsApp Ilimitado</li>
                  </ul>
                </div>
              </div> --}}
            </div>
          </div>
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
                 Lorem ipsum dolor sit amet, consectetur adipisicing elit. Debitis minima ducimus, molestiae cumque a eos.
                Consequuntur et, architecto ipsum molestias.
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
                  <div class="price-product"><span>S/.</span><span>{{$product->product_price_prepaid + 0}}</span></div>
                  <div class="plan-product">
                    <p>en plan <span>119</span></p>
                  </div>
                  <div class="btn-comprar"><a href="{{route('postpaid_detail', ['product'=>$product->product_id])}}" class="btn btn-default">comprar</a></div>
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
                  <div class="plan-product">
                    <p>en plan <span>119</span></p>
                  </div>
                  <div class="btn-comprar"><a href="#" class="btn btn-default">comprar</a></div>
                </div>
              </div>
              <div class="producto">
                <div class="image-product text-center"><img src="/images/home/celular.jpg" alt="equipos"></div>
                <div class="content-product text-center">
                  <div class="title-product">
                    <h3 class="text-center">LG Stylus 3</h3>
                  </div>
                  <div class="price-product"><span>s/</span>59</div>
                  <div class="plan-product">
                    <p>en plan <span>119</span></p>
                  </div>
                  <div class="btn-comprar"><a href="#" class="btn btn-default">comprar</a></div>
                </div>
              </div>
              <div class="producto">
                <div class="image-product text-center"><img src="/images/home/celular.jpg" alt="equipos"></div>
                <div class="content-product text-center">
                  <div class="title-product">
                    <h3 class="text-center">LG Stylus 4</h3>
                  </div>
                  <div class="price-product"><span>s/</span>60</div>
                  <div class="plan-product">
                    <p>en plan <span>119</span></p>
                  </div>
                  <div class="btn-comprar"><a href="#" class="btn btn-default">comprar</a></div>
                </div>
              </div> --}}
            </div>
          </div>
        </div>
      </div>
    </div>
@endsection
