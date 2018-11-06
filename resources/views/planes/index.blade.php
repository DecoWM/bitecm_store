@extends('layouts.master')
@section('content')
    <div class="container">
    <div class="content-box-shadow">
   
    
      <div class="row">
        <div class="col-xs-12 col-sm-12">
          <div class="container-section-new-information">
          
          
          <div id="content-page">
            <!-- @include('products.tag',['product' => $product]) -->
            <div id="image-equipo">
                  <div class="img-loading">
                    <img src="/images/planes/placeholder.png" alt="">
                  </div>    
                  @if(count($product_images)>0)
                     <div class="new-slider">
                        <!-- <div class="image-product text-center">
                          <img id="zoom_01" src="{{asset(Storage::url($product_images[0]->product_image_url))}}" alt="{{$product->product_model}}">{{-- data-zoom-image="{{asset(Storage::url($product_images[0]->product_image_url))}}">--}}
                        </div> -->
                        @if(count($product_images)>0)
                         <ul>
                          @foreach($product_images as $image)
                          <li>
                            <img src="{{asset(Storage::url($product->product_image_url))}}" alt="{{$product->product_model}}">
                          </li>
                          @endforeach
                        </ul>
                        @else
                        @endif
                        </div> 
                      @else
                        <div class="new-slider-one">
                          <img src="{{asset(Storage::url($product->product_image_url))}}" alt="{{$product->product_model}}">
                        </div>
                      @endif
                    
                    <!-- <ul>
                      <li><img src="http://via.placeholder.com/340x320" alt=""></li>
                      <li><img src="http://via.placeholder.com/340x320" alt=""></li>
                      <li><img src="http://via.placeholder.com/340x320" alt=""></li>
                      <li><img src="http://via.placeholder.com/340x320" alt=""></li>
                    </ul> -->


              <!-- @if(count($product_images)>0)
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
              @endif -->
            </div>
          </div>
          <section id="descripcion-equipo">
            <div class="row">
              <div class="col-xs-12 col-sm-12 col-md-11">
                <div class="header-section">
                  <div class="title">
                    <h1>{{$product->product_model}} {{isset($product->color_id) ? $product->color_name : ''}}</h1>
                    @include('products.tag',['product' => $product])
                  </div>
                  <div class="descripcion">
                    <p>{{$product->product_description}}</p>
                  </div>
                </div>
              </div>
            
            </div>
              
              <div class="content-section">
                <form form id="purchase-form" action="{{route('add_to_cart')}}" method="POST">
                  {{ csrf_field() }}
                  <input type="hidden" name="stock_model" value="{{$product->stock_model_id}}">
                  <input type="hidden" name="product_variation" value="{{$product->product_variation_id}}">
                  <input type="hidden" name="affiliation" value="{{$product->affiliation_id}}">
                  <input type="hidden" name="contract" value="{{$product->contract_id}}">
                  <input type="hidden" name="type" value="2">
                  <input type="hidden" name="quantity" value="1">
                  <div class="content-product">
                    <div class="row">

                      <div class="col-xs-12 col-sm-12 col-md-11 col-lg-3">
                        <div id="box-select-cambiate">
                          <div class="select-product">
                            <!-- <span class="title-select">Lo quieres en</span> -->
                            <div class="box-title-select-cambiate">
                              <img src="/images/planes/4g.svg" width="12" alt="">
                              <span class="title-select">Modalidad</span>
                            </div>
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
                      </div>

                    <!-- </div>
                    <div class="row"> -->

                      <div class="col-xs-12 col-sm-12 col-md-11 col-lg-5 col-12-mob" v-if="Object.keys(product).length == 0">
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
                      <postpaid-price-plan v-if="Object.keys(product).length != 0" :product="product.product"></postpaid-price-plan>
                    <div class="col-xs-12 col-sm-12 col-md-11 col-lg-3">
                        <div id="box-button-comprar">
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
                  </div>
                </form>
              </div>
            </section>
              
          </div>
        </div>
        <div class="col-xs-12 col-sm-12">
          
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

                  <!-- <span class="title-plan">{{$plan->plan_name}}</span>
                  <div class="precio-plan">S/. {{$plan->plan_price}}<span>al mes</span></div> -->
                  <div class="box-plan-content-plan">
                      <!-- <span class="title-plan">{{$plan->plan_name}}</span> -->
                      <span class="precio-title-plan color-secundary">Plan {{$plan->plan_name_name}}</span>
                      <div class="precio-plan">
                        <span>S/ </span> 
                        {{$plan->plan_price_integer}}
                        <span>.{{$plan->plan_price_decimal}}</span> 
                      </div>
                      <!--<span class="box-contrato">{{$plan->contract_name}} de permanencia</span>-->
                  </div>

                  <!-- @foreach ($info_comercial as $info)
                  @if($info->plan_id == $plan->plan_id)
                  <ul class="list-unstyled">
                    @if ($info->plan_infocomercial_flag_cantidad == 1)
                    <li><img src="{{$info->plan_infocomercial_img_url}}" alt="Llamadas">{!!$info->plan_infocomercial_descripcion!!}</li>
                    @elseif ($info->plan_infocomercial_flag_cantidad > 1)
                    <li><img src="{{$info->plan_infocomercial_img_url}}" alt="Llamadas">{{$info->plan_infocomercial_flag_cantidad}} {!!$info->plan_infocomercial_descripcion!!}</li>
                    @endif
                  </ul>
                  @endif
                  @endforeach -->
                  <!-- PRIMERA CATEGORIA -->
                  @foreach ($info_comercial as $info)
                      @if($info->plan_id == $plan->plan_id)
                        
                        @if($info->tipo == 2)
                          
                          <div class="box-plan-content-comercial">
                             
                                <div class="box-item-comercial">
                                  <div class=box-column>
                                    <div class="item-comercial">
                                      <img src="{{$info->plan_infocomercial_img_url}}" width="32" alt="">
                                      <span>{!!$info->plan_infocomercial_descripcion!!}</span>
                                    </div>
                                  </div>
                                  <div class="box-column">
                                    <div class="item-comercial-detalle">
                                      <span>{!!$info->plan_infocomercial_informacion_adicional!!}</span>
                                      <span></span>
                                    </div>
                                  </div>
                                  <!--
                                  <div class="box-column">
                                    <div class="item-comercial-icon">
                                      <span class="icon"><img src="/images/planes/icon-info.png" alt=""></span>
                                    </div>
                                  </div>
                                  -->
                                </div>

                          </div>   

                        @endif

                      @endif
                    @endforeach

                    <!-- SEGUNDA CATEGORIA -->
                    <div class="box-plan-content-apps-sociales">
                      <p>Tus apps favoritas <span>ilimitadas</span></p>
                        <ul>
                          
                          @foreach ($info_comercial as $info)
                            @if($info->plan_id == $plan->plan_id)
                            
                              @if($info->tipo == 1)
                                <li><img src="{{$info->plan_infocomercial_img_url}}" alt="" width="32"></li>
                              @endif

                            @endif
                          @endforeach

                        </ul>
                      <!--<span class="color-secundary">Foto</span>-->
                    </div>
                        
                    <!-- TERCERA Y CUARTA CATEGORIA -->
                    <div class="box-plan-content-apps">

                      <!-- TERCERA CATEGORIA -->
                      <div class="items-box-content box-video">
                        <p>Video y Musica</p>
                        <ul>
                          @foreach ($info_comercial as $info)
                            @if($info->plan_id == $plan->plan_id)
                          
                              @if($info->tipo == 3)
                                <li><img src="{{$info->plan_infocomercial_img_url}}" alt="" width="32"></li>
                              @endif  

                            @endif
                          @endforeach    
                        </ul>
                        <span class="color-secundary">{{$plan->plan_bono}}</span>
                      </div>
                      
                      <!-- CUARTA CATEGORIA -->
                      <div class="items-box-content box-juegos">
                        <p>Juegos</p>
                        <ul>
                          @foreach ($info_comercial as $info)
                            @if($info->plan_id == $plan->plan_id)

                              @if($info->tipo == 4)
                                <li><img src="{{$info->plan_infocomercial_img_url}}" alt="" width="32"></li>
                              @endif  

                            @endif
                          @endforeach    
                        </ul>
                      </div>

                    </div>


                  
                </div>
              </div>
              </label>
              @endif
              @endforeach
            </div>
            {{-- <postpaid-plan v-if="Object.keys(product).length != 0" :product="product.product" :plans="product.plans"></postpaid-plan> --}}
          </div>
        </div>
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
        'affiliations' => $affiliations,
        'contracts' => $contracts
      ];
    @endphp
    <input id="product-init" type="hidden" value='@json($product_init)'>
@endsection