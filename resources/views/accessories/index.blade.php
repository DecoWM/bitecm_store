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
          <form id="search-product" class="form-inline">
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
            <div class="row">
              <div class="col-xs-12 col-sm-6 col-md-4">
                <div data-equipo="1" class="producto accesorio">
                  <div class="image-product text-center"><img src="./images/productos/accesorios.jpg" alt="equipos"></div>
                  <div class="content-product text-center">
                    <div class="title-product">
                      <h3 class="text-center">LG Tone+<br>Headphones</h3>
                    </div>
                    <div class="price-product"><span>s/</span>99</div>
                    <div class="btn-product form-inline">
                      <div class="form-group btn-comprar"><a href="https://bitel.clientes-forceclose.com/bitel_frontend/dist/equipo_accesorio.html" class="btn btn-default">comprar</a></div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-xs-12 col-sm-6 col-md-4">
                <div data-equipo="2" class="producto accesorio">
                  <div class="image-product text-center"><img src="./images/productos/accesorios.jpg" alt="equipos"></div>
                  <div class="content-product text-center">
                    <div class="title-product">
                      <h3 class="text-center">LG Tone+<br>Headphones</h3>
                    </div>
                    <div class="price-product"><span>s/</span>99</div>
                    <div class="btn-product form-inline">
                      <div class="form-group btn-comprar"><a href="https://bitel.clientes-forceclose.com/bitel_frontend/dist/equipo_accesorio.html" class="btn btn-default">comprar</a></div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-xs-12 col-sm-6 col-md-4">
                <div data-equipo="3" class="producto accesorio">
                  <div class="image-product text-center"><img src="./images/productos/accesorios.jpg" alt="equipos"></div>
                  <div class="content-product text-center">
                    <div class="title-product">
                      <h3 class="text-center">LG Tone+<br>Headphones</h3>
                    </div>
                    <div class="price-product"><span>s/</span>99</div>
                    <div class="btn-product form-inline">
                      <div class="form-group btn-comprar"><a href="https://bitel.clientes-forceclose.com/bitel_frontend/dist/equipo_accesorio.html" class="btn btn-default">comprar</a></div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-xs-12 col-sm-6 col-md-4">
                <div data-equipo="4" class="producto accesorio">
                  <div class="image-product text-center"><img src="./images/productos/accesorios.jpg" alt="equipos"></div>
                  <div class="content-product text-center">
                    <div class="title-product">
                      <h3 class="text-center">LG Tone+<br>Headphones</h3>
                    </div>
                    <div class="price-product"><span>s/</span>99</div>
                    <div class="btn-product form-inline">
                      <div class="form-group btn-comprar"><a href="https://bitel.clientes-forceclose.com/bitel_frontend/dist/equipo_accesorio.html" class="btn btn-default">comprar</a></div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-xs-12 col-sm-6 col-md-4">
                <div data-equipo="5" class="producto accesorio">
                  <div class="image-product text-center"><img src="./images/productos/accesorios.jpg" alt="equipos"></div>
                  <div class="content-product text-center">
                    <div class="title-product">
                      <h3 class="text-center">LG Tone+<br>Headphones</h3>
                    </div>
                    <div class="price-product"><span>s/</span>99</div>
                    <div class="btn-product form-inline">
                      <div class="form-group btn-comprar"><a href="https://bitel.clientes-forceclose.com/bitel_frontend/dist/equipo_accesorio.html" class="btn btn-default">comprar</a></div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-xs-12 col-sm-6 col-md-4">
                <div data-equipo="6" class="producto accesorio">
                  <div class="image-product text-center"><img src="./images/productos/accesorios.jpg" alt="equipos"></div>
                  <div class="content-product text-center">
                    <div class="title-product">
                      <h3 class="text-center">LG Tone+<br>Headphones</h3>
                    </div>
                    <div class="price-product"><span>s/</span>99</div>
                    <div class="btn-product form-inline">
                      <div class="form-group btn-comprar"><a href="https://bitel.clientes-forceclose.com/bitel_frontend/dist/equipo_accesorio.html" class="btn btn-default">comprar</a></div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-xs-12 col-sm-6 col-md-4">
                <div data-equipo="7" class="producto accesorio">
                  <div class="image-product text-center"><img src="./images/productos/accesorios.jpg" alt="equipos"></div>
                  <div class="content-product text-center">
                    <div class="title-product">
                      <h3 class="text-center">LG Tone+<br>Headphones</h3>
                    </div>
                    <div class="price-product"><span>s/</span>99</div>
                    <div class="btn-product form-inline">
                      <div class="form-group btn-comprar"><a href="https://bitel.clientes-forceclose.com/bitel_frontend/dist/equipo_accesorio.html" class="btn btn-default">comprar</a></div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-xs-12 col-sm-6 col-md-4">
                <div data-equipo="8" class="producto accesorio">
                  <div class="image-product text-center"><img src="./images/productos/accesorios.jpg" alt="equipos"></div>
                  <div class="content-product text-center">
                    <div class="title-product">
                      <h3 class="text-center">LG Tone+<br>Headphones</h3>
                    </div>
                    <div class="price-product"><span>s/</span>99</div>
                    <div class="btn-product form-inline">
                      <div class="form-group btn-comprar"><a href="https://bitel.clientes-forceclose.com/bitel_frontend/dist/equipo_accesorio.html" class="btn btn-default">comprar</a></div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-xs-12 col-sm-6 col-md-4">
                <div data-equipo="9" class="producto accesorio">
                  <div class="image-product text-center"><img src="./images/productos/accesorios.jpg" alt="equipos"></div>
                  <div class="content-product text-center">
                    <div class="title-product">
                      <h3 class="text-center">LG Tone+<br>Headphones</h3>
                    </div>
                    <div class="price-product"><span>s/</span>99</div>
                    <div class="btn-product form-inline">
                      <div class="form-group btn-comprar"><a href="https://bitel.clientes-forceclose.com/bitel_frontend/dist/equipo_accesorio.html" class="btn btn-default">comprar</a></div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="row">
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
            </div>
          </div>
        </div>
      </div>
    </div>
@endsection
