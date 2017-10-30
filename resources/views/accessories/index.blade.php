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
@include('layouts.search_sidebar')
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
        <div class="col-xs-12 col-sm-3">
          <div id="plan" class="content-catalogo">
            <div class="title-select">
              <div class="btn-acordion"></div><span>Plan</span>
            </div>
            <div class="select-item">
              <div class="item">
                <input id="prepaid" type="radio" name="register_webinar_" value="1">
                <label for="prepaid">Prepago</label>
              </div>
              <div class="item">
                <input id="postpaid" type="radio" name="register_webinar_" value="1">
                <label for="postpaid">Postpago</label>
              </div>
              <div class="item">
                <input id="promotion" type="radio" name="register_webinar_" value="1">
                <label for="promotion">Promociones</label>
              </div>
            </div>
          </div>
          <div id="lo-quieres" class="content-catalogo">
            <div class="title-select">
              <div class="btn-acordion"></div><span>Lo quieres en</span>
            </div>
            <div class="select-item">
              <div class="item">
                <input id="type-opt-1" type="radio" name="register_webinar_" value="1">
                <label for="type-opt-1">Portabilidad</label>
              </div>
              <div class="item">
                <input id="type-opt-2" type="radio" name="register_webinar_" value="1">
                <label for="type-opt-2">Linea nueva</label>
              </div>
              <div class="item">
                <input id="type-opt-3" type="radio" name="register_webinar_" value="1">
                <label for="type-opt-3">Renovación</label>
              </div>
            </div>
          </div>
          <div id="precio-equipo" class="content-catalogo">
            <div class="title-select">
              <div class="btn-acordion"></div><span>Precio de equipo:</span>
            </div>
            <div class="select-item">
              <div class="item">
                <input id="price-opt-1" type="radio" name="register_webinar_" value="1">
                <label for="price-opt-1">S/. 1 - 50</label>
              </div>
              <div class="item">
                <input id="price-opt-2" type="radio" name="register_webinar_" value="1">
                <label for="price-opt-2">S/. 51 - 150</label>
              </div>
              <div class="item">
                <input id="price-opt-3" type="radio" name="register_webinar_" value="1">
                <label for="price-opt-3">S/. 151 - 300</label>
              </div>
              <div class="item">
                <input id="price-opt-4" type="radio" name="register_webinar_" value="1">
                <label for="price-opt-4">S/.301 - 1000</label>
              </div>
              <div class="item">
                <input id="price-opt-5" type="radio" name="register_webinar_" value="1">
                <label for="price-opt-5">S/. 1001 +</label>
              </div>
            </div>
          </div>
          <div id="precio-plan" class="content-catalogo">
            <div class="title-select">
              <div class="btn-acordion"></div><span>Plan</span>
            </div>
            <div class="select-item">
              <div class="item">
                <input id="plan-opt-1" type="radio" name="register_webinar_" value="1">
                <label for="plan-opt-1">S/. 15</label>
              </div>
              <div class="item">
                <input id="plan-opt-2" type="radio" name="register_webinar_" value="1">
                <label for="plan-opt-2">S/. 29</label>
              </div>
              <div class="item">
                <input id="plan-opt-3" type="radio" name="register_webinar_" value="1">
                <label for="plan-opt-3">S/. 49</label>
              </div>
              <div class="item">
                <input id="plan-opt-4" type="radio" name="register_webinar_" value="1">
                <label for="plan-opt-4">S/. 69</label>
              </div>
              <div class="item">
                <input id="plan-opt-5" type="radio" name="register_webinar_" value="1">
                <label for="plan-opt-5">S/. 89</label>
              </div>
              <div class="item">
                <input id="plan-opt-6" type="radio" name="register_webinar_" value="1">
                <label for="plan-opt-6">S/. 99</label>
              </div>
              <div class="item">
                <input id="plan-opt-7" type="radio" name="register_webinar_" value="1">
                <label for="plan-opt-7">S/. 129</label>
              </div>
              <div class="item">
                <input id="plan-opt-8" type="radio" name="register_webinar_" value="1">
                <label for="plan-opt-8">S/. 149</label>
              </div>
              <div class="item">
                <input id="plan-opt-9" type="radio" name="register_webinar_" value="1">
                <label for="plan-opt-9">S/. 169</label>
              </div>
            </div>
          </div>
          <div id="marca" class="content-catalogo">
            <div class="title-select">
              <div class="btn-acordion"></div><span>Filtrar por marca:</span>
            </div>
            <div class="select-item">
              <div class="item">
                <input id="brand-opt-1" type="radio" name="register_webinar_" value="1">
                <label for="brand-opt-1">Samsung</label>
              </div>
              <div class="item">
                <input id="brand-opt-2" type="radio" name="register_webinar_" value="1">
                <label for="brand-opt-2">Huawei</label>
              </div>
              <div class="item">
                <input id="brand-opt-3" type="radio" name="register_webinar_" value="1">
                <label for="brand-opt-3">LG</label>
              </div>
              <div class="item">
                <input id="brand-opt-4" type="radio" name="register_webinar_" value="1">
                <label for="brand-opt-4">Alcatel</label>
              </div>
              <div class="item">
                <input id="brand-opt-5" type="radio" name="register_webinar_" value="1">
                <label for="brand-opt-5">Sky</label>
              </div>
              <div class="item">
                <input id="brand-opt-6" type="radio" name="register_webinar_" value="1">
                <label for="brand-opt-6">Lenovo</label>
              </div>
              <div class="item">
                <input id="brand-opt-7" type="radio" name="register_webinar_" value="1">
                <label for="brand-opt-7">Bitel</label>
              </div>
            </div>
          </div>
        </div>
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
