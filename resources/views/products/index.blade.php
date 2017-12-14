@extends('layouts.master')
@section('content')
    <div class="container">
      <div class="row">
        <div class="col-xs-12">
          <div class="title-page">
            <h2>{{$title}}</h2>
          </div>
        </div>
      </div>
{{-- @include('layouts.search_navbar') --}}
      @include('layouts.banner_smartphone', ['filters' => $filters])
      <div class="row">
        @include('layouts.sidebar.sidebar_products')
        <div class="col-xs-12 col-sm-9">
          <div id="list-equipos" v-cloak>
            <div class="row" v-if="isSearching">
              <loader></loader>
            </div>
            <div class="row" v-if="noResults">
              <p class="text-center">No se encontraron resultados</p>
            </div>
            <div class="row" v-if="searchResult.length > 0">
              <products v-for="(product, index) in searchResult" :product="product" :base-url="baseUrl" :compare="compare" v-on:additem="addItem" v-on:removeitem="removeItem" :key="index"></products>
            </div>
            @if (count($products) == 0)
            <div class="row">
              <p class="text-center">No se encontraron resultados</p>
            </div>
            @endif
            <div class="row" v-if="!search">
              @foreach ($products as $product)
              <div class="col-xs-12 col-sm-6 col-md-4">
                <div data-equipo="1" class="producto {{!isset($product->stock_model_id)?'not-stock':''}}" v-bind:class="{'active-comparar' : _.find(compare, ['product_id', {{$product->product_id}}])}">
                  @include('products.ribbon',['product' => $product])
                  <div class="image-product text-center">
                    <a href="{{$product->route}}">
                      <img src="{{$product->picture_url}}" alt="{{$product->product_model}}">
                    </a>
                  </div>
                  <div class="content-product text-center">
                    <div class="title-product">
                      <h3 class="text-center"><b>{{$product->brand_name}}</b></h3>
                      <h3 class="text-center">{{$product->product_model}}</h3>
                    </div>
                    <div class="price-product">
                      @if($product->promo_id)
                      <span>S/.{{$product->promo_price}}</span>
                      <span class="normal-price">S/.{{$product->product_price}}</span>
                      @else
                      <span>S/.{{$product->product_price}}</span>
                      @endif
                    </div>
                    <div class="btn-product form-inline" style="text-align: center;">
                      <div class="form-group btn-comprar">
                        <a href="{{$product->route}}" class="btn btn-default">comprar</a></div>
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
                </nav>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
@endsection
