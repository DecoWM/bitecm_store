@extends('layouts.master')
@section('content')
<div class="container">
  <div class="row">
    <div class="col-xs-12">
      <div class="title-page">
        <h2>Equipos Postpago</h2>
      </div>
    </div>
  </div>
  @include('layouts.banner_top', ['filters' => $filters, 'banner' => $banner])
  <div class="row">
    @include('layouts.sidebar.sidebar_postpago')
    <div class="col-xs-12 col-sm-9">
      <div id="list-equipos" v-cloak>
        <div class="row" v-if="isSearching">
          <loader></loader>
        </div>
        <div class="row" v-if="noResults">
          <p class="text-center">No se encontraron resultados</p>
        </div>
        @if (count($products) == 0)
          <div class="row" v-if="!search">
            <p class="text-center">No se encontraron resultados</p>
          </div>
        @endif
        <div class="row" v-if="searchResult.length > 0">
          <postpaid v-for="(product, index) in searchResult" :product="product" :base-url="baseUrl" :compare="compare" v-on:additem="addItem" v-on:removeitem="removeItem" :key="product.product_id"></postpaid>
        </div>
        <div class="row" v-if="!search">
          @foreach ($products as $smartphone)
          <div class="col-xs-12 col-sm-6 col-md-4">
            <div data-equipo="1" class="producto {{!isset($smartphone->stock_model_id)?'not-stock':''}}" v-bind:class="{'active-comparar' : _.find(compare, ['product_variation_id', {{$smartphone->product_variation_id}}])}">
              @include('products.ribbon',['product' => $smartphone])
              <div class="image-product text-center">
                <a href="{{route('postpaid_detail', [
                  'brand'=>$smartphone->brand_slug,
                  'product'=>$smartphone->product_slug,
                  'affiliation'=>$smartphone->affiliation_slug,
                  'plan'=>$smartphone->plan_slug,
                  //'contract'=>$smartphone->contract_slug
                ])}}">
                  <img src="{{asset(Storage::url($smartphone->picture_url))}}" alt="{{$smartphone->product_model}}">
                </a>
              </div>
              <div class="content-product text-center">
                <div class="title-product">
                  <h3 class="text-center"><b>{{$smartphone->brand_name}}</b></h3>
                  <h3 class="text-center">{{$smartphone->product_model}}</h3>
                </div>
                <div class="price-product">
                  @if(isset($smartphone->promo_id))
                  <span>S/.{{$smartphone->promo_price}}</span>
                  <span class="normal-price">S/.{{$smartphone->product_price}}</span>
                  @else
                  <span>S/.{{$smartphone->product_price}}</span>
                  @endif
                </div>
                <div class="plan-product">
                  <p>en plan <span>{{$smartphone->plan_name}}</span></p>
                </div>
                <div class="btn-product form-inline">
                  <div class="form-group btn-comprar">
                    <a href="{{route('postpaid_detail', [
                      'brand'=>$smartphone->brand_slug,
                      'product'=>$smartphone->product_slug,
                      'affiliation'=>$smartphone->affiliation_slug,
                      'plan'=>$smartphone->plan_slug,
                      //'contract'=>$smartphone->contract_slug
                    ])}}" class="btn btn-default">comprar</a></div>
                  <div class="checkbox btn-comparar">
                    <label>
                      <input type="checkbox" class="checkbox-compare" v-model="compare" v-bind:value="{ product_variation_id: {{$smartphone->product_variation_id}}, picture_url: '{{asset(Storage::url($smartphone->picture_url))}}'}" v-bind:disabled="compare.length==4 && !_.find(compare, ['product_variation_id', {{$smartphone->product_variation_id}}])">comparar
                      <span class="checkmark"></span>
                    </label>
                  </div>
                </div>
              </div>
            </div>
          </div>
          @endforeach
        </div>
        @php
          $paginationData = array_except(json_decode($products->toJson(), true), ['data']);
        @endphp
        <input id="search-init" type="hidden" value="{{$searched_string}}">
        <input id="pagination-init" type="hidden" value='@json($paginationData)'>
        <div class="row" v-if="!isSearching">
          <div class="col-xs-12">
            <nav aria-label="Page navigation" id="pagination-nav">
              <paginator-links v-bind:pagination="pagination" v-on:changepage="searchProduct" :offset="4"></paginator-links>
            </nav>
          </div>
        </div>
        <compare-postpaid v-if="compare.length > 0" v-bind:base-url="baseUrl" v-bind:products="compare" v-on:removeitem="removeItem"></compare-postpaid>
      </div>
    </div>
  </div>
</div>
@endsection
