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
                <div id="gallery_01" class="galeria-min"></div>
                @endif
              @else
              <div class="image-product text-center"><img id="zoom_01" src="{{asset('images/productos/'.$product->product_image_url)}}" alt="{{$product->product_model}}" data-zoom-image="{{asset('images/productos/'.$product->product_image_url)}}">
              </div>
              <div id="gallery_01" class="galeria-min"></div>
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
                <input type="hidden" name="type" value="2">
                <input type="hidden" name="quantity" value="1">
                <div class="content-product">
                  <div class="row">
                    <div class="col-xs-5 col-sm-6">
                      <div class="select-product"><span class="title-select">Lo quieres en</span>
                        {{--<select form="purchase-form" name="affiliation" v-model="filters.affiliation.value"--}}
                        <select form="purchase-form" name="affiliation" @change="selectAffiliation({
                          @foreach ($affiliations as $affiliation)
                          '{{$affiliation->affiliation_id}}': '{{$affiliation->route}}',
                          @endforeach
                        },$event)">
                          @foreach ($affiliations as $affiliation)
                          <option value="{{$affiliation->affiliation_id}}" {{$affiliation->affiliation_id == $product->affiliation_id ? 'selected' : ''}}>{{$affiliation->affiliation_name}}</option>
                          @endforeach
                        </select>
                      </div>
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
                    <div class="col-xs-7 col-sm-6">
                      {{--<div class="detalle-product" v-cloak>--}}
                      <div class="detalle-product">
                        {{--<div class="price-product" v-if="filters.affiliation.value == 1"><span>S/.</span>@{{selectedPlan.product_variation_price.portability}}</div>
                        <div class="price-product" v-if="filters.affiliation.value != 1"><span>S/.</span>@{{selectedPlan.product_variation_price.new}}</div>--}}
                        <div class="price-product">
                          @if(isset($product->promo_id))
                          <span>S/.{{$product->promo_price}}</span><span class="normal-price">S/.{{$product->product_price}}</span>
                          @else
                          <span>S/.{{$product->product_price}}</span>
                          @endif
                        </div>
                        <div class="plan-product">
                          <p>con <span>{{$product->plan_name}}</span></p>
                        </div>
                        <div class="tiempo-plan">
                          <p>Contrato de {{$product->contract_name}}</p>
                        </div>
                      </div>
                    </div>
                    <div class="col-xs-12 col-sm-offset-6 col-sm-6">
                      {{-- <form action="{{route('add_to_cart')}}" method="post"> --}}
                      {{-- <form id="purchase-form"purchase form action="{{route('carrito', ['product'=>$product->product_id])}}" method="get"> --}}
                      @if($product->stock_model_id)  
                      <div class="btn-comprar">
                        <button type="submit" class="btn-default">Comprar Ahora</button>
                      </div>
                      @else
                      <div class="stock-exhausted">
                        Agotado
                      </div>
                      @endif
                      {{-- </form> --}}
                      {{-- <div class="btn-comprar">
                        <a href="{{route('carrito', ['product'=>$product->product_id])}}" class="btn-default">Comprar Ahora</a> --}}
                        {{-- <button type="submit" class="btn-default">Comprar Ahora</button> --}}
                      {{-- </div> --}}
                    </div>
                  </div>
                </div>
                <div class="movil-select-product">
                  <select @change="selectAffiliation({
                    @foreach ($affiliations as $affiliation)
                    '{{$affiliation->affiliation_id}}': '{{$affiliation->route}}',
                    @endforeach
                  },$event)">
                    <option name="" value="">Lo quieres en</option>
                    @foreach ($affiliations as $affiliation)
                    <option value="{{$affiliation->affiliation_id}}" {{$affiliation->affiliation_id == $product->affiliation_id ? 'selected' : ''}}>{{$affiliation->affiliation_name}}</option>
                    @endforeach
                  </select>
                </div>
              </form>
            </div>
          </section>
        </div>
      </div>
      <div class="row">
        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-offset-4 col-lg-8">
          @foreach ($plans as $i => $plan)
            @if($plan->plan_id == $product->plan_id)
              @php $selected_plan = $i > 0 ? $i - 1 : $i; @endphp
            @endif
          @endforeach
          <div id="planes" class="planes" data-selected="{{$selected_plan}}">
            <h3 class="title-plan">Escoge el plan que prefieras:</h3>
            <div class="select-plan">
@foreach ($plans as $plan)
              <label>
              <input type="radio" name="plan" form="purchase-form" value="{{$plan->plan_id}}" style="display:none;" {{$plan->plan_id == $product->plan_id ? 'checked' : ''}}>
              <div class="plan {{$plan->plan_id == $product->plan_id ? 'plan-active' : ''}}">
                <div class="content-plan" v-on:click="redirectRel('{{$plan->route}}')">
                  <span class="title-plan">{{$plan->plan_name}}</span>
                  <div class="precio-plan">S/. {{$plan->plan_price}}<span>al mes</span></div>
                  <ul class="list-unstyled">
@if ($plan->plan_unlimited_calls == 1)
                    <li><img src="/images/equipo/svg/planes/llamadas.svg" alt="Llamadas">Llamadas ilimitadas</li>
@endif
                    <li><img src="/images/equipo/svg/planes/internet.svg" alt="internet">{{$plan->plan_data_cap}} internet</li>
@if ($plan->plan_unlimited_rpb == 1)
                    <li><img src="/images/equipo/svg/planes/rpb.svg" alt="RPB">RPB ilimitado</li>
@endif
@if ($plan->plan_unlimited_sms == 1)
                    <li><img src="/images/equipo/svg/planes/sms.svg" alt="SMS">SMS ilimitado</li>
@endif
@if ($plan->plan_free_facebook == 1)
                    <li><img src="/images/equipo/svg/planes/facebook.svg" alt="Facebook">Facebook Gratis</li>
@endif
@if ($plan->plan_unlimited_whatsapp == 1)
                    <li><img src="/images/equipo/svg/planes/whatsapp.svg" alt="WhatsApp">WhatsApp Ilimitado</li>
@endif
                  </ul>
                </div>
              </div>
              </label>
@endforeach
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
              {{--<div class="pdf-tecnica"><a href="{{route('download_file', ['filename' => str_slug($product->product_model)])}}">Descargar ficha técnica<span class="fa fa-download"></span></a></div>--}}
            </div>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-xs-12">
          <div class="ver-mas-equipo">
            <div class="title-detalle">
              <a href="{{route('download_FichaTecnica')}}" target="_blank" class="btn-vmas"></a>
              <!-- <a class="btn-vmas"></a> -->
              <h4>VER DETALLES TÉCNICOS</h4>
            </div>
          </div>
          <div class="ver-mas-equipo">
            <div class="title-detalle">
              <a href="{{route('download_Consideraciones')}}" target="_blank" class="btn-vmas"></a>
              <h4>VER CONSIDERACIONES COMERCIALES</h4>
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
                  <div class="plan-product">
                    <p>en plan <span>{{$item->plan_name}}</span></p>
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
