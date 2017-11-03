@extends('layouts.master')
@section('content')
    <div class="container">
      <div class="row">
        <div class="col-xs-12">
          <div class="title-page">
            <h2>Equipos</h2>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-xs-12 col-sm-4 col-md-4">
          <form id="search-product" class="form-inline" v-on:submit.prevent="searchProduct">
            <input type="text" placeholder="Busca por nombre" class="form-control" v-model="searchedString">
            <button type="submit" class="btn btn-default btn-search"> <span class="fa fa-search"></span></button>
          </form>
        </div>
        <div class="col-xs-12 col-sm-8 col-md-8">
          <div id="filter-product">
            <div class="row">
              <div class="col-xs-12 col-sm-6 text-right">
                <div class="filter-item"><span>Sort by:</span>
                  <select>
                    <option>Default</option>
                  </select>
                </div>
              </div>
              <div class="col-xs-12 col-sm-6 text-right">
                <div class="filter-item"><span>Show:</span>
                  <select>
                    <option>16</option>
                  </select>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="row">
@include('layouts.search_sidebar')
        <div class="col-xs-12 col-sm-9">
          <div id="list-equipos">
            <div class="row" v-if="isSearching">
              <loader></loader>
            </div>
            <div class="row" v-if="searchResult.length > 0">
              <postpaid v-for="(product, index) in searchResult" :product="product" :key="index"></postpaid>
            </div>
            <div class="row" v-if="!search">
@foreach ($products as $smartphone)
              <div class="col-xs-12 col-sm-6 col-md-4">
                <div data-equipo="1" class="producto">
                {{-- <div data-equipo="1" class="producto active-comparar"> --}}
                  <div class="image-product text-center"><img src="{{asset('images/productos/'.$smartphone->picture_url)}}" alt="equipos"></div>
                  <div class="content-product text-center">
                    <div class="title-product">
                      <h3 class="text-center">{{$smartphone->product_name}}</h3>
                    </div>
                    <div class="price-product"><span>s/{{$smartphone->product_price_prepaid}}</span></div>
                    <div class="plan-product">
                      <p>en plan <span>Megaplus 119</span></p>
                    </div>
                    <div class="btn-product form-inline">
                      <div class="form-group btn-comprar"><a href="#" class="btn btn-default">comprar</a></div>
                      <div class="checkbox btn-comparar">
                        <input type="checkbox" class="checkbox-compare">comparar
                      </div>
                    </div>
                  </div>
                </div>
              </div>
@endforeach
              {{-- <div class="col-xs-12 col-sm-6 col-md-4">
                <div data-equipo="2" class="producto active-comparar">
                  <div class="image-product text-center"><img src="./images/home/celular.jpg" alt="equipos"></div>
                  <div class="content-product text-center">
                    <div class="title-product">
                      <h3 class="text-center">LG Stylus 3</h3>
                    </div>
                    <div class="price-product"><span>s/59</span></div>
                    <div class="plan-product">
                      <p>en plan <span>Megaplus 119</span></p>
                    </div>
                    <div class="btn-product form-inline">
                      <div class="form-group btn-comprar"><a href="#" class="btn btn-default">comprar</a></div>
                      <div class="checkbox btn-comparar">
                        <input type="checkbox" class="checkbox-compare">comparar
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-xs-12 col-sm-6 col-md-4">
                <div data-equipo="3" class="producto active-comparar">
                  <div class="image-product text-center"><img src="./images/home/celular.jpg" alt="equipos"></div>
                  <div class="content-product text-center">
                    <div class="title-product">
                      <h3 class="text-center">LG Stylus 3</h3>
                    </div>
                    <div class="price-product"><span>s/59</span></div>
                    <div class="plan-product">
                      <p>en plan <span>Megaplus 119</span></p>
                    </div>
                    <div class="btn-product form-inline">
                      <div class="form-group btn-comprar"><a href="#" class="btn btn-default">comprar</a></div>
                      <div class="checkbox btn-comparar">
                        <input type="checkbox" class="checkbox-compare">comparar
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-xs-12 col-sm-6 col-md-4">
                <div data-equipo="4" class="producto active-comparar">
                  <div class="image-product text-center"><img src="./images/home/celular.jpg" alt="equipos"></div>
                  <div class="content-product text-center">
                    <div class="title-product">
                      <h3 class="text-center">LG Stylus 3</h3>
                    </div>
                    <div class="price-product"><span>s/59</span></div>
                    <div class="plan-product">
                      <p>en plan <span>Megaplus 119</span></p>
                    </div>
                    <div class="btn-product form-inline">
                      <div class="form-group btn-comprar"><a href="#" class="btn btn-default">comprar</a></div>
                      <div class="checkbox btn-comparar">
                        <input type="checkbox" class="checkbox-compare">comparar
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-xs-12 col-sm-6 col-md-4">
                <div data-equipo="5" class="producto">
                  <div class="image-product text-center"><img src="./images/home/celular.jpg" alt="equipos"></div>
                  <div class="content-product text-center">
                    <div class="title-product">
                      <h3 class="text-center">LG Stylus 3</h3>
                    </div>
                    <div class="price-product"><span>s/59</span></div>
                    <div class="plan-product">
                      <p>en plan <span>Megaplus 119</span></p>
                    </div>
                    <div class="btn-product form-inline">
                      <div class="form-group btn-comprar"><a href="#" class="btn btn-default">comprar</a></div>
                      <div class="checkbox btn-comparar">
                        <input type="checkbox" class="checkbox-compare">comparar
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-xs-12 col-sm-6 col-md-4">
                <div data-equipo="6" class="producto">
                  <div class="image-product text-center"><img src="./images/home/celular.jpg" alt="equipos"></div>
                  <div class="content-product text-center">
                    <div class="title-product">
                      <h3 class="text-center">LG Stylus 3</h3>
                    </div>
                    <div class="price-product"><span>s/59</span></div>
                    <div class="plan-product">
                      <p>en plan <span>Megaplus 119</span></p>
                    </div>
                    <div class="btn-product form-inline">
                      <div class="form-group btn-comprar"><a href="#" class="btn btn-default">comprar</a></div>
                      <div class="checkbox btn-comparar">
                        <input type="checkbox" class="checkbox-compare">comparar
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-xs-12 col-sm-6 col-md-4">
                <div data-equipo="7" class="producto">
                  <div class="image-product text-center"><img src="./images/home/celular.jpg" alt="equipos"></div>
                  <div class="content-product text-center">
                    <div class="title-product">
                      <h3 class="text-center">LG Stylus 3</h3>
                    </div>
                    <div class="price-product"><span>s/59</span></div>
                    <div class="plan-product">
                      <p>en plan <span>Megaplus 119</span></p>
                    </div>
                    <div class="btn-product form-inline">
                      <div class="form-group btn-comprar"><a href="#" class="btn btn-default">comprar</a></div>
                      <div class="checkbox btn-comparar">
                        <input type="checkbox" class="checkbox-compare">comparar
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-xs-12 col-sm-6 col-md-4">
                <div data-equipo="8" class="producto">
                  <div class="image-product text-center"><img src="./images/home/celular.jpg" alt="equipos"></div>
                  <div class="content-product text-center">
                    <div class="title-product">
                      <h3 class="text-center">LG Stylus 3</h3>
                    </div>
                    <div class="price-product"><span>s/59</span></div>
                    <div class="plan-product">
                      <p>en plan <span>Megaplus 119</span></p>
                    </div>
                    <div class="btn-product form-inline">
                      <div class="form-group btn-comprar"><a href="#" class="btn btn-default">comprar</a></div>
                      <div class="checkbox btn-comparar">
                        <input type="checkbox" class="checkbox-compare">comparar
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-xs-12 col-sm-6 col-md-4">
                <div data-equipo="9" class="producto">
                  <div class="image-product text-center"><img src="./images/home/celular.jpg" alt="equipos"></div>
                  <div class="content-product text-center">
                    <div class="title-product">
                      <h3 class="text-center">LG Stylus 3</h3>
                    </div>
                    <div class="price-product"><span>s/59</span></div>
                    <div class="plan-product">
                      <p>en plan <span>Megaplus 119</span></p>
                    </div>
                    <div class="btn-product form-inline">
                      <div class="form-group btn-comprar"><a href="#" class="btn btn-default">comprar</a></div>
                      <div class="checkbox btn-comparar">
                        <input type="checkbox" class="checkbox-compare">comparar
                      </div>
                    </div>
                  </div>
                </div>
              </div> --}}
            </div>
            {{-- <div class="row" v-if="!isSearching">
              <div class="col-xs-12">
                <nav aria-label="Page navigation" id="pagination-nav">
                  <ul class="pagination">
                    <li><a href="#" aria-label="Atras"><span aria-hidden="true">&lt;</span></a></li>
                    <li class="active"><a href="#">1</a></li>
                    <li><a href="#">2</a></li>
                    <li><a href="#">3</a></li>
                    <li><a href="#">4</a></li>
                    <li><a href="#"><span aria-hidden="true">&gt;</span></a></li>
                  </ul>
                </nav>
              </div>
            </div> --}}
            <div id="list-equipos-comparar">
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
            </div>
          </div>
        </div>
      </div>
    </div>
@endsection
