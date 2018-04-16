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
                <div id="gallery_01" class="galeria-min"></div>
                @endif
              @else
              <div class="image-product text-center"><img src="{{asset(Storage::url($product->product_image_url))}}" alt="{{$product->product_model}}">{{-- data-zoom-image="{{asset(Storage::url($product->product_image_url))}}">--}}
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
                <h1>{{$product->product_model}} {{isset($product->color_id) ? $product->color_name : ''}}</h1>
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
                <input type="hidden" name="affiliation" value="{{$product->affiliation_id}}">
                <input type="hidden" name="type" value="2">
                <input type="hidden" name="quantity" value="1">
                <div class="content-product">
                  <div class="row">
                    <div class="col-xs-5 col-sm-6">
                      <div class="select-product"><span class="title-select">Lo quieres en</span>
                        {{--<select form="purchase-form" name="affiliation" v-model="filters.affiliation.value"--}}
                        {{-- <select form="purchase-form" name="affiliation" @change="selectAffiliation({
                          @foreach ($affiliations as $affiliation)
                            '{{$affiliation->affiliation_id}}': '{{$affiliation->route}},{{$affiliation->api_route}}',
                          @endforeach
                        },$event)"> --}}
                        <select id="affsel" form="purchase-form" name="affiliation" @change="setAffiliation($event)">
                          @foreach ($affiliations as $ix => $affiliation)
                          <option id="aff{{$affiliation->affiliation_id}}" data-ix="{{$ix}}" value="{{$affiliation->affiliation_id}}" {{$affiliation->affiliation_id == $product->affiliation_id ? 'selected' : ''}}>{{$affiliation->affiliation_name}}</option>
                          @endforeach
                        </select>
                      </div>
                     <!--  @include('products.colors',['product' => $product, 'stock_models' => $stock_models]) -->
                    </div>
                    <div class="col-xs-7 col-sm-6 col-12-mob" v-if="Object.keys(product).length == 0">
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
                    <postpaid-price v-if="Object.keys(product).length != 0" :product="product.product"></postpaid-price>
                    <div class="col-xs-12 col-sm-offset-6 col-sm-6">
                      {{-- <form action="{{route('add_to_cart')}}" method="post"> --}}
                      {{-- <form id="purchase-form"purchase form action="{{route('carrito', ['product'=>$product->product_id])}}" method="get"> --}}
                      @if($product->stock_model_id)
                      <div class="btn-comprar">
                        <button id="addToCart" type="submit" class="btn-default btn-buy">Comprar Ahora</button>
                      </div>
                      @else
                      <div class="btn-comprar">
                        <button class="btn-default" disabled>Comprar Ahora</button>
                      </div>
                      {{-- <div class="stock-exhausted">
                        Agotado
                      </div> --}}
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
                  <select id="affsel-mov" @change="selectAffiliation({
                    @foreach ($affiliations as $affiliation)
                    '{{$affiliation->affiliation_id}}': '{{$affiliation->route}},{{$affiliation->api_route}}',
                    @endforeach
                  },$event)">
                    <option name="" value="">Lo quieres en</option>
                    @foreach ($affiliations as $ix => $affiliation)
                    <option id="aff{{$affiliation->affiliation_id}}-mov" data-ix="{{$ix+1}}" value="{{$affiliation->affiliation_id}}" {{$affiliation->affiliation_id == $product->affiliation_id ? 'selected' : ''}}>{{$affiliation->affiliation_name}}</option>
                    @endforeach
                  </select>
                </div>
              </form>
            </div>
          </section>
          <div id="planes" class="planes" data-selected="{{$selected_plan}}">
            <h3 class="title-plan">Escoge el plan que prefieras:</h3>
            {{-- <div v-if="Object.keys(product).length == 0" class="select-plan"> --}}
            <plans-filtered v-if="plans.length > 0" :plans="plans" :product="product"></plans-filtered>
            <div v-if="plans.length == 0" id="plans-slick" class="select-plan {{$just_3 ? 'just-3' : ''}}">
              @foreach ($plans as $plan)
              @if($plan->affiliation_id == $product->affiliation_id)
              <label class="plan-parent {{$plan->plan_id == $product->plan_id ? 'label-active' : ''}} {{$plan->affil_classes}}">
              <input type="radio" name="plan" form="purchase-form" value="{{$plan->plan_id}}" style="display:none;" {{$plan->plan_id == $product->plan_id ? 'checked' : ''}}>
              <div id="plan{{$plan->plan_id}}" class="plan {{$plan->plan_id == $product->plan_id ? 'plan-active' : ''}}">
                {{-- <div class="content-plan" v-on:click="redirectRel('{{$plan->route}}')"> --}}
                <div class="content-plan" v-on:click="setPlan('{{$plan->plan_id}}')">
                  <span class="title-plan">{{$plan->plan_name}}</span>
                  <div class="precio-plan">S/. {{$plan->plan_price}}<span>al mes</span></div>
                  @foreach ($info_comercial as $info)
                  @if($info->plan_id == $plan->plan_id)
                  <ul class="list-unstyled">
                    @if ($info->plan_infocomercial_flag_cantidad == 1)
                    <li><img src="{{$info->plan_infocomercial_img_url}}" alt="Llamadas">{{$info->plan_infocomercial_descripcion}}</li>
                    @elseif ($info->plan_infocomercial_flag_cantidad > 1)
                    <li><img src="{{$info->plan_infocomercial_img_url}}" alt="Llamadas">{{$info->plan_infocomercial_flag_cantidad}} {{$info->plan_infocomercial_descripcion}}</li>
                    @endif

                    <!-- @if ($plan->plan_unlimited_calls == 1)
                    <li><img src="/images/equipo/svg/planes/llamadas.svg" alt="Llamadas">Llamadas ilimitadas (**)</li>
                    @elseif ($plan->plan_unlimited_calls > 1)
                    <li><img src="/images/equipo/svg/planes/llamadas.svg" alt="Llamadas">{{$plan->plan_unlimited_calls}} min de Llamadas</li>
                    @endif
                    @if ($plan->plan_unlimited_sms == 1)
                    <li><img src="/images/equipo/svg/planes/sms.svg" alt="SMS">XXX SMS ilimitado (**)</li>
                    @elseif ($plan->plan_unlimited_sms > 1)
                    <li><img src="/images/equipo/svg/planes/sms.svg" alt="Llamadas">{{$plan->plan_unlimited_calls}} SMS todo operador</li>
                    @endif
                    @if (isset($plan->plan_data_cap) && $plan->plan_data_cap != '')
                    <li><img src="/images/equipo/svg/planes/internet.svg" alt="Internet">{!!$plan->plan_data_cap!!}</li>
                    @endif
                    @if ($plan->plan_unlimited_rpb == 1)
                    <li><img src="/images/equipo/svg/planes/rpb.svg" alt="RPB">AAA Llamada todo Bitel Gratis</li>
                    @endif
                    @if ($plan->plan_free_facebook == 1)
                    <li><img src="/images/equipo/svg/planes/facebook.svg" alt="Facebook">BBB Facebook Flex Gratis</li>
                    @endif
                    @if ($plan->plan_unlimited_whatsapp == 1)
                    <li><img src="/images/equipo/svg/planes/whatsapp.svg" alt="WhatsApp">WhatsApp Ilimitado</li>
                    @endif -->
                  </ul>
                  @endif
                  @endforeach
                </div>
              </div>
              </label>
              @endif
              @endforeach
            </div>
            {{-- <postpaid-plan v-if="Object.keys(product).length != 0" :product="product.product" :plans="product.plans"></postpaid-plan> --}}
          </div>
          <section class="descrip-consideracion">
            <!-- <h1>Consideraciones comerciales</h1> -->
            <p>Nota:</p>
            <p>(*) Más detalles en consideraciones comerciales</p>
          </section>
        </div>
      </div>
      <div class="row">
        <div class="col-xs-12 col-sm-offset-4 col-sm-8">
          <div class="add-select-plan"></div>

        </div>
      </div>
      <div class="row">
        <div class="col-xs-12">
          <a href="{{route('download_Consideraciones')}}" target="_blank" class="ver-mas-equipo">
            <div class="title-detalle">
              <span class="btn-vmas"></span>
              <h4>VER CONSIDERACIONES COMERCIALES</h4>
            </div>
          </a>
        </div>
      </div>
    </div>
    @php
      $product_init = [
        'product' => $product,
        'product_images' => $product_images,
        'stock_models' => $stock_models,
        'available' => $available,
        'plans' => $plans,
        'affiliations' => $affiliations
      ];
    @endphp
    <input id="product-init" type="hidden" value='@json($product_init)'>
@endsection