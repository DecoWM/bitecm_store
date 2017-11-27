@extends('layouts.master')
@section('content')
    <div class="container">
      <div class="row">
        <div class="col-xs-12">
          <div class="title-page">
            <h2>Equipos Prepago</h2>
          </div>
        </div>
      </div>
{{-- @include('layouts.search_navbar') --}}
      @include('layouts.banner_smartphone', ['filters' => $filters])
      <div class="row">
        @include('layouts.sidebar.sidebar_prepago')
        <div class="col-xs-12 col-sm-9">
          <div id="list-equipos" v-cloak>
            <div class="row" v-if="isSearching">
              <loader></loader>
            </div>
            <div class="row" v-if="noResults">
              <p class="text-center">No se encontraron resultados</p>
            </div>
            <div class="row" v-if="searchResult.length > 0">
              <prepaid v-for="(product, index) in searchResult" :product="product" :base-url="baseUrl" :compare="compare" v-on:additem="addItem" v-on:removeitem="removeItem" :key="index"></prepaid>
            </div>
@if (count($products) == 0)
            <div class="row">
              <p class="text-center">No se encontraron resultados</p>
            </div>
@endif
            <div class="row" v-if="!search">
@foreach ($products as $smartphone)
              <div class="col-xs-12 col-sm-6 col-md-4">
                <div data-equipo="1" class="producto" v-bind:class="{'active-comparar' : _.find(compare, ['product_id', {{$smartphone->product_id}}])}">
                  <div class="image-product text-center">
                    <a href="{{route('prepaid_detail',  [
                      'brand'=>$smartphone->brand_slug,
                      'product'=>$smartphone->product_slug,
                      'plan'=>$smartphone->plan_slug
                    ])}}">
                      <img src="{{asset('images/productos/'.$smartphone->picture_url)}}" alt="{{$smartphone->product_model}}">
                    </a>
                  </div>
                  <div class="content-product text-center">
                    <div class="title-product">
                      <h3 class="text-center">{{$smartphone->product_model}}</h3>
                    </div>
                    <div class="price-product"><span>s/{{$smartphone->product_price}}</span></div>
                    @if($smartphone->plan_id != 15)
                    <div class="plan-product">
                      <p><a href="{{route('postpaid_detail', [
                        'brand'=>$smartphone->brand_slug,
                        'product'=>$smartphone->product_slug,
                        'affiliation'=>$affiliation_slug,
                        'plan'=>$plan_post_slug,
                        'contract'=>$contract_slug
                      ])}}">Ver en plan postpago</a></p>
                    </div>
                    @endif
                    <div class="btn-product form-inline">
                      <div class="form-group btn-comprar">
                        <a href="{{route('prepaid_detail',  [
                          'brand'=>$smartphone->brand_slug,
                          'product'=>$smartphone->product_slug,
                          'plan'=>$smartphone->plan_slug
                        ])}}" class="btn btn-default">comprar</a></div>
                      <div class="checkbox btn-comparar">
                        <label>
                          <input type="checkbox" class="checkbox-compare" v-model="compare" v-bind:value="{product_id: {{$smartphone->product_id}}, picture_url: '{{asset('images/productos/'.$smartphone->picture_url)}}'}" v-bind:disabled="compare.length==4 && !_.find(compare, ['product_id', {{$smartphone->product_id}}])">comparar
                          <span class="checkmark"></span>
                        </label>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
@endforeach
            </div>
            <div class="row" v-if="!isSearching">
              <div class="col-xs-12">

                <nav aria-label="Page navigation" id="pagination-nav">
                  {{ $products->links() }}
                  {{-- <ul class="pagination">
                    <li><a href="#" aria-label="Atras"><span aria-hidden="true">&lt;</span></a></li>
                    <li class="active"><a href="#">1</a></li>
                    <li><a href="#">2</a></li>
                    <li><a href="#">3</a></li>
                    <li><a href="#">4</a></li>
                    <li><a href="#"><span aria-hidden="true">&gt;</span></a></li>
                  </ul> --}}
                </nav>
              </div>
            </div>
            <compare-prepaid v-if="compare.length > 0" v-bind:base-url="baseUrl" v-bind:products="compare" v-on:removeitem="removeItem"></compare-prepaid>
            {{-- <div id="list-equipos-comparar" >
              <div class="equipos-comp">
                <div class="title-equipos"><span>4 Equipos</span>
                  <p>para comparar</p>
                </div>
                <div class="list-equipos">
                  <ul class="list-unstyled">
                    <li><img src="./images/home/celular.jpg" alt="equipos">
                      <button class="btn-eliminar"><span class="fa fa-times"></span></button>
                    </li>
                    <li><img src="./images/home/celular.jpg" alt="equipos">
                      <button class="btn-eliminar"><span class="fa fa-times"></span></button>
                    </li>
                    <li><img src="./images/home/celular.jpg" alt="equipos">
                      <button class="btn-eliminar"><span class="fa fa-times"></span></button>
                    </li>
                    <li><img src="./images/home/celular.jpg" alt="equipos">
                      <button class="last-btn"><span class="fa fa-times"></span></button>
                    </li>
                  </ul>
                </div>
              </div>
              <div class="btn-comparar"><a href="#">COMPARAR</a></div>
            </div> --}}
          </div>
        </div>
      </div>
    </div>
@endsection
