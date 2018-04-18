@extends('layouts.master')


@section('content')
      <div id="banner-principal">
        <!-- <div class="slider"><img src="{{asset('images/banner/banner-principal.jpg')}}" alt="banner principal"></div> -->
        <!-- <div class="slider"><img src="{{asset('images/banner/BANNER-POSTPAGO.jpg')}}" alt="banner principal"></div> -->
        <!-- <div class="slider"><img src="{{asset('images/banner/banner-PREPAGO.jpg')}}" alt="banner principal"></div> -->

        @foreach ($slider_images as $image)

          @if($image->active == 1 )
            <div class="slider">
                <a href="{{$image->image_link}}">
                  <picture>
                    <source media="(max-width:480px)" srcset="{{$image->imagem_url}}">
                    <img src="{{$image->image_url}}" alt="banner principal">
                  </picture>
                </a>
            </div>
          @endif

        @endforeach
        <!-- <div class="slider"><img src="{{asset('images/banner/BANNER-SAMSUNG-HOME.jpg')}}" alt="banner principal"></div> -->
      </div>
      
      <section id="equipos-vendidos">
        <div class="container">
          <div class="row">
            <div class="col-xs-12">
              <div class="heading">
                <h2 class="text-center">Equipos</h2>
              </div>
              <div class="sub-heading">
                <h3 class="text-center" v-bind:class="{ opt1: bestSeller!='smartphone', opt2: bestSeller=='smartphone'}"><a href="javascript:void(0)" class="text-uppercase" v-on:click.prevent="toggleBestSeller('smartphone')">Postpago</a></h3>
                <h3 class="text-center" v-bind:class="{ opt1: bestSeller!='tablet', opt2: bestSeller=='tablet'}"><a href="javascript:void(0)" class="text-uppercase" v-on:click.prevent="toggleBestSeller('tablet')">Prepago</a></h3>
              </div>
              <div class="content-tab-vendidos">
                {{-- <transition-group name="fadeOutDown" leave-active-class="animated zoomOut"> --}}
                  <div class="content-tab-pro" v-show="bestSeller=='smartphone'" key="smartphone">
                    <div class="producto catalogo"><img src="{{$home_images[0]->image_url}}" alt="bitel">
                      <div class="btn-catalogo">
                        <div class="border-btn"><a href="{{$home_images[0]->image_link}}" class="btn btn-default">ver catálogo</a></div>
                      </div>
                    </div>
                    <div class="list-productos">
                      @foreach ($best_seller_tablet as $tablet)
                      <div class="producto">
                        @include('products.ribbon',['product' => $tablet])
                        <div class="image-product text-center">
                          <a href="{{$tablet->route}}">
                            <img src="{{$tablet->picture_url}}" alt="equipos">
                          </a>
                        </div>
                        <div class="content-product text-center">
                          <div class="title-product">
                            <h4 class="text-center"><b>{{$tablet->brand_name}}</b></h4>
                            <h4 class="text-center">{{$tablet->product_model}}</h4>
                          </div>
                          <div class="price-product">
                            @if($tablet->promo_id)
                            <span>S/.{{$tablet->promo_price}}</span>
                            <span class="normal-price">S/.{{$tablet->product_price}}</span>
                            @else
                            <span>S/.{{$tablet->product_price}}</span>
                            @endif
                          </div>
                          @if (isset($tablet->plan_name))
                          <div class="plan-product">
                            <p>en plan <span>{{$tablet->plan_name}}</span></p>
                          </div>
                          @endif
                          <div class="btn-comprar">
                            <a href="{{$tablet->route}}" class="btn btn-default">COMPRAR</a>
                          </div>
                        </div>
                      </div>
                      @endforeach
                    </div>
                  </div>
                  <div class="content-tab-pro" v-show="bestSeller=='tablet'" key="tablet">
                    <div class="producto catalogo"><img src="{{$home_images[0]->image_url}}" alt="bitel">
                      <div class="btn-catalogo">
                        <div class="border-btn"><a href="{{$home_images[0]->image_link}}" class="btn btn-default">ver catálogo</a></div>
                      </div>
                    </div>
                    <div class="list-productos">
                      @foreach ($best_seller_smartphone as $smartphone)
                      <div class="producto">
                        @include('products.ribbon',['product' => $smartphone])
                        <div class="image-product text-center">
                          <a href="{{$smartphone->route}}">
                            <img src="{{$smartphone->picture_url}}" alt="equipos">
                          </a>
                        </div>
                        <div class="content-product text-center">
                          <div class="title-product">
                            <h4 class="text-center"><b>{{$smartphone->brand_name}}</b></h4>
                            <h4 class="text-center">{{$smartphone->product_model}}</h4>
                          </div>
                          <div class="price-product">
                            @if($smartphone->promo_id)
                            <span>S/.{{$smartphone->promo_price}}</span>
                            <span class="normal-price">S/.{{$smartphone->product_price}}</span>
                            @else
                            <span>S/.{{$smartphone->product_price}}</span>
                            @endif
                          </div>
                          @if (isset($smartphone->plan_name))
                          <div class="plan-product">
                            <p>en plan <span>{{$smartphone->plan_name}}</span></p>
                          </div>
                          @endif
                          <div class="btn-comprar">
                            <a href="{{$smartphone->route}}" class="btn btn-default">COMPRAR</a>
                          </div>
                        </div>
                      </div>
                      @endforeach

                    </div>
                  </div>
              </div>
            </div>
          </div>
        </div>
      </section>
      <div id="promociones">
        <div class="container">
          <div class="row">
            <div class="col-xs-12 col-sm-6 no-padding">
              <div class="promociones">
                <img src="{{$home_images[1]->image_url}}" alt="promoción Huawei p10">
                <div class="content-product text-center">
                  <div class="btn-comprar">

                    <a href="{{$home_images[1]->image_link}}" class="btn btn-default">COMPRAR</a>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-xs-12 col-sm-6 no-padding">
              <div class="promociones">
                <img src="{{$home_images[2]->image_url}}" alt="promoción Lg G6">
                <div class="content-product text-center">
                  <div class="btn-comprar">
                    <a href="{{$home_images[2]->image_link}}" class="btn btn-default">COMPRAR</a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!--
      <section id="equipos-promocion">
        <div class="container">
          <div class="row">
            <div class="col-xs-12">
              <div class="heading">
                <h2 class="text-center">Promociones</h2>
              </div>
              <div class="sub-heading">
                <h3 class="text-center" v-bind:class="{ opt1: promo!='postpago', opt2: promo=='postpago' }"><a href="javascript:void(0)" class="text-uppercase" v-on:click.prevent="togglePromo('postpago')">Postpago</a></h3>
                <h3 class="text-center" v-bind:class="{ opt1: promo!='prepago', opt2: promo=='prepago' }"><a href="javascript:void(0)" class="text-uppercase" v-on:click.prevent="togglePromo('prepago')">Prepago</a></h3>
              </div>


             
              <div class="content-tab-promociones">

                <div class="content-tab-pro promociones-tab" v-show="promo=='postpago'" key="postpago">
                  @foreach ($promo_postpaid as $smartphone)
                  <div class="producto">
                    @include('products.ribbon',['product' => $smartphone])
                    {{--<div class="state-product"><span class="trending">TRENDING</span></div>--}}
                    <div class="image-product text-center">
                      <a href="{{$smartphone->route}}">
                        <img src="{{$smartphone->picture_url}}" alt="equipos">
                      </a>
                    </div>
                    <div class="content-product text-center">
                      <div class="title-product">
                        <h4 class="text-center"><b>{{$smartphone->brand_name}}</b></h4>
                        <h4 class="text-center">{{$smartphone->product_model}}</h4>
                      </div>
                      <div class="price-product">
                        @if($smartphone->promo_id)
                        <span>S/.{{$smartphone->promo_price}}</span>
                        <span class="normal-price">S/.{{$smartphone->product_price}}</span>
                        @else
                        <span>S/.{{$smartphone->product_price}}</span>
                        @endif
                      </div>
                      <div class="plan-product">
                        <p>en plan <span>{{$smartphone->plan_name}}</span></p>
                      </div>
                      <div class="btn-comprar">
                        <a href="{{$smartphone->route}}" class="btn btn-default">VER MÁS</a>
                      </div>
                    </div>
                  </div>
                  @endforeach

        
                </div>
                <div class="content-tab-pro promociones-tab" v-show="promo=='prepago'" key="prepago">
                  @foreach ($promo_prepaid as $smartphone)
                  <div class="producto">
                    @include('products.ribbon',['product' => $smartphone])
                    <div class="image-product text-center">
                      <a href="{{$smartphone->route}}">
                        <img src="{{$smartphone->picture_url}}" alt="equipos">
                      </a>
                    </div>
                    <div class="content-product text-center">
                      <div class="title-product">
                        <h4 class="text-center"><b>{{$smartphone->brand_name}}</b></h4>
                        <h4 class="text-center">{{$smartphone->product_model}}</h4>
                      </div>
                      <div class="price-product">
                        @if($smartphone->promo_id)
                        <span>S/.{{$smartphone->promo_price}}</span>
                        <span class="normal-price">S/.{{$smartphone->product_price}}</span>
                        @else
                        <span>S/.{{$smartphone->product_price}}</span>
                        @endif
                      </div>
                      <div class="plan-product">
                        <p>en plan <span>{{$smartphone->plan_name}}</span></p>
                      </div>
                      <div class="btn-comprar">
                        <a href="{{$smartphone->route}}" class="btn btn-default">VER MÁS</a>
                      </div>
                    </div>
                  </div>
                  @endforeach
                </div>
              </div>

            </div>
          </div>
        </div>
      </section>
      -->
      <section id="garantia" style="display:none;">
        <div class="container">
          <div class="row">
            <div class="col-xs-4">
              <div class="text-center">
                <div class="image">
                  <!--[if lte IE 8]>
                    <img src="./images/home/svg/garantia.png" alt="garantia" class="garantia">
                  <![endif]-->
                  <!--[if gte IE 9]><!-->
                    <img src="./images/home/svg/garantia.svg" alt="garantia" class="garantia">
                  <!--<![endif]-->
                </div>
                <h2>Reserva Online</h2>
                <p>Haz la reserva de tu equipo desde <br>cualquier dispositivo de manera <br>simple, rápida y seguro</p>
              </div>
            </div>
            <div class="col-xs-4">
              <div class="text-center">
                <div class="image">
                  <!--[if lte IE 8]>
                    <img src="./images/home/svg/delivery.png" alt="delivery" class="delivery">
                  <![endif]-->
                  <!--[if gte IE 9]><!-->
                    <img src="./images/home/svg/delivery.svg" alt="delivery" class="delivery">
                  <!--<![endif]-->
                 
                </div>
                <h2>Delivery Gratis</h2>
                <!-- <p>Entrega gratuita en Lima y Provincias*<br>*Mira la lista detallada de la cobertura por delivery </p> -->
                <p>Nuestros productos incluyen <br>delivery todo Lima metropolitana.</p>
              </div>
            </div>
            <div class="col-xs-4">
              <div class="text-center">
                <div class="image">
                  <!--[if lte IE 8]>
                    <img src="./images/home/svg/pago-seguro.png" alt="pago seguro" class="pago-seguro">
                  <![endif]-->
                  <!--[if gte IE 9]><!-->
                    <img src="./images/home/svg/pago-seguro.svg" alt="pago seguro" class="pago-seguro">
                  <!--<![endif]-->
                </div>
                <h2>Pago Seguro</h2>
                <!-- <p>Morbi nex leo lucus.Donex or purusa odo<br>consectur tememetum</p> -->
                <p>Todos los productos tienen <br>Garantía por parte de Bitel.</p>
              </div>
            </div>
          </div>
        </div>
      </section>
@endsection
