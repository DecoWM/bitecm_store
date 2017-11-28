@extends('layouts.master')
@section('content')
      <div id="banner-principal">
        <div class="slider"><img src="{{asset('images/banner/banner-principal.jpg')}}" alt="banner principal"></div>
        <div class="slider"><img src="{{asset('images/banner/banner-principal.jpg')}}" alt="banner principal"></div>
      </div>
      <section id="equipos-vendidos">
        <div class="container">
          <div class="row">
            <div class="col-xs-12">
              <div class="heading">
                <h2 class="text-center">Equipos</h2>
              </div>
              <div class="sub-heading">
                <h3 class="text-center" v-bind:class="{ opt1: bestSeller!='smartphone', opt2: bestSeller=='smartphone'}"><a href="smartphones" class="text-uppercase" v-on:click.prevent="toggleBestSeller('smartphone')">Smartphones</a></h3>
                <h3 class="text-center" v-bind:class="{ opt1: bestSeller!='tablet', opt2: bestSeller=='tablet'}"><a href="tablets" class="text-uppercase" v-on:click.prevent="toggleBestSeller('tablet')">Tablets</a></h3>
              </div>
              {{-- <transition-group name="fadeOutDown" leave-active-class="animated zoomOut"> --}}
                <div class="content-tab-pro" v-show="bestSeller=='smartphone'" key="smartphone">
                  <div class="producto catalogo"><img src="./images/home/promo-bitel.jpg" alt="bitel">
                    <div class="btn-catalogo">
                      <div class="border-btn"><a href="{{route('postpaid')}}" class="btn btn-default">ver catálogo</a></div>
                    </div>
                  </div>
                  <div class="list-productos">
@foreach ($best_seller_smartphone as $smartphone)
                    <div class="producto">
                      <div class="state-product"><span>NUEVO</span></div>
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
@if (isset($smartphone->affiliation_id))
                        <div class="plan-product">
                          <p>en plan <span>{{$smarthphone->plan_name}}</span></p>
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
                <div class="content-tab-pro" v-show="bestSeller=='tablet'" key="tablet">
                  <div class="producto catalogo"><img src="./images/home/promo-bitel.jpg" alt="bitel">
                    <div class="btn-catalogo">
                      <div class="border-btn"><a href="{{route('postpaid')}}" class="btn btn-default">ver catálogo</a></div>
                    </div>
                  </div>
                  <div class="list-productos">
@foreach ($best_seller_tablet as $tablet)
                    <div class="producto">
                      <div class="state-product"><span>NUEVO</span></div>
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
                        <div class="btn-comprar">
                          <a href="{{$tablet->route}}" class="btn btn-default">COMPRAR</a>
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
      <div id="promociones">
        <div class="container">
          <div class="row">
            <div class="col-xs-12 col-sm-6 no-padding">
              <div class="promociones">
                <img src="./images/home/promo-s8.jpg" alt="promoción galaxy s8">
                <div class="content-product text-center">
                  <div class="btn-comprar">
                    <a href="{{$featured_products[0]->route}}" class="btn btn-default">COMPRAR</a>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-xs-12 col-sm-6 no-padding">
              <div class="promociones">
                <img src="./images/home/promo-note.jpg" alt="promoción note4">
                <div class="content-product text-center">
                  <div class="btn-comprar">
                    <a href="{{$featured_products[1]->route}}" class="btn btn-default">COMPRAR</a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <section id="equipos-promocion">
        <div class="container">
          <div class="row">
            <div class="col-xs-12">
              <div class="heading">
                <h2 class="text-center">Promociones</h2>
              </div>
              <div class="sub-heading">
                <h3 class="text-center" v-bind:class="{ opt1: promo!='postpago', opt2: promo=='postpago' }"><a href="postpago" class="text-uppercase" v-on:click.prevent="togglePromo('postpago')">Postpago</a></h3>
                <h3 class="text-center" v-bind:class="{ opt1: promo!='prepago', opt2: promo=='prepago' }"><a href="prepago" class="text-uppercase" v-on:click.prevent="togglePromo('prepago')">Prepago</a></h3>
              </div>
              <div class="content-tab-pro promociones-tab" v-show="promo=='postpago'" key="postpago">
@foreach ($promo_postpaid as $smartphone)
                <div class="producto">
                  <div class="state-product"><span class="trending">TRENDING</span></div>
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
                  <div class="state-product"><span class="trending">TRENDING</span></div>
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
      </section>
      <section id="garantia">
        <div class="container">
          <div class="row">
            <div class="col-xs-4">
              <div class="text-center">
                <div class="image"><img src="./images/home/svg/garantia.svg" alt="" class="garantia"></div>
                <h2>Garantía</h2>
                <p>Morbi nex leo lucus.Donex or purusa odo<br>consectur tememetum</p>
              </div>
            </div>
            <div class="col-xs-4">
              <div class="text-center">
                <div class="image"><img src="./images/home/svg/delivery.svg" alt="" class="delivery"></div>
                <h2>Delivery Gratis</h2>
                <p>Entrega gratuita en Lima y Provincias*<br>*Mira la lista detallada de la cobertura por delivery </p>
              </div>
            </div>
            <div class="col-xs-4">
              <div class="text-center">
                <div class="image"><img src="./images/home/svg/pago-seguro.svg" alt="" class="pago-seguro"></div>
                <h2>Pago Seguro</h2>
                <p>Morbi nex leo lucus.Donex or purusa odo<br>consectur tememetum</p>
              </div>
            </div>
          </div>
        </div>
      </section>
@endsection
