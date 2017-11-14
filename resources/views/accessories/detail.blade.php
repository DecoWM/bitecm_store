@extends('layouts.master')
@section('content')
    <div class="container">
      <div class="row">
        <div class="col-xs-12 col-sm-4">
          <div id="content-page">
            <div class="title">
              <h2>{{$product->product_name}}</h2>
            </div>
            <div class="state"><span>NUEVO</span></div>
            <div id="image-equipo">
              <div class="image-product text-center"><img src="./images/productos/accesorios.jpg" alt="accesorios"></div>
            </div>
          </div>
        </div>
        <div class="col-xs-12 col-sm-8">
          <section id="descripcion-equipo">
            <div class="header-section">
              <div class="title">
                <h1>{{$product->product_name}}</h1>
                <div class="state"><span>NUEVO</span></div>
              </div>
              <div class="descripcion">
                <p>{{$product->product_description}}</p>
              </div>
            </div>
            <div class="content-section">
              <form action="">
                <div class="content-product equipo-prepago">
                  <div class="row">
                    <div class="col-xs-12 col-sm-6">
                      <div class="row">
                        <div class="col-xs-7 col-xs-push-5 col-sm-12">
                          <div class="detalle-product">
                            <div class="price-product"><span>s/</span> {{$product->product_price_prepaid}}</div>
                          </div>
                          <div class="btn-option">
                            <div class="count-input space-bottom"><a href="#" data-action="decrease" class="incr-btn btn-minus">-</a>
                              <input type="text" value="1" name="quantity" class="quantity"><a href="#" data-action="increase" class="incr-btn btn-plus">+</a>
                            </div>
                          </div>
                        </div>
                        <div class="col-xs-5 col-xs-pull-7 col-sm-12">
                          <div class="color-product">
                            <fieldset>
                              <legend>Color</legend>
                              <div class="option-select">
                                <div class="radio-inline">
                                  <input type="radio" name="color" value="1" class="negro">
                                </div>
                                <div class="radio-inline">
                                  <input type="radio" name="color" value="2" class="blanco">
                                </div>
                                <div class="radio-inline">
                                  <input type="radio" name="color" value="3" class="gris">
                                </div>
                              </div>
                            </fieldset>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="col-xs-12 col-sm-6">
                      <div class="btn-carrito">
                        <button type="submit" class="btn-default">AGREGAR AL CARRITO</button>
                      </div>
                      <div class="btn-comprar-prepago">
                        <button type="submit" class="btn-default">Comprar Ahora</button>
                      </div>
                    </div>
                  </div>
                </div>
                {{-- <div class="movil-select-product">
                  <select>
                    <option name="" value="">Lo quieres en</option>
                    <option name="prepago" value="prepago">Portabilidad</option>
                    <option name="linea nueva" value="linea nueva">Linea nueva</option>
                    <option name="renovacion" value="renovacion">Renovación</option>
                  </select>
                </div> --}}
              </form>
            </div>
          </section>
        </div>
      </div>
      {{-- <div class="row">
        <div class="col-xs-12">
          <div id="especificaciones-tecnicas">
            <div class="title-detalle">
              <h4>ESPECIFICACIONES TÉCNICAS</h4>
            </div>
            <div class="content-detalle">
              <div class="descripcion-detalle"></div>
              <div class="pdf-tecnica"><a>Descargar ficha técnica<span class="fa fa-download"></span></a></div>
            </div>
          </div>
        </div>
      </div> --}}
      <div class="row">
        <div class="col-xs-12">
          <div class="ver-mas-equipo">
            <div class="title-detalle">
              <div class="btn-vmas"></div>
              <h4>VER DETALLES TÉCNICOS</h4>
            </div>
            <div class="content-detalle">
              <p>
                 Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ipsam possimus magnam, eum nobis explicabo. Molestias
                corporis, minima nam quas obcaecati?
              </p>
            </div>
          </div>
          <div class="ver-mas-equipo">
            <div class="title-detalle">
              <div class="btn-vmas"></div>
              <h4>VER CONSIDERACIONES COMERCIALES</h4>
            </div>
            <div class="content-detalle">
              <p>
                 Lorem ipsum dolor sit amet, consectetur adipisicing elit. Debitis minima ducimus, molestiae cumque a eos.
                Consequuntur et, architecto ipsum molestias.
              </p>
            </div>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-xs-12">
          <div id="producto-disponibles">
            <div class="title-detalle">
              <h5>PRODUCTOS DISPONIBLES</h5>
            </div>
            <div class="list-producto">
              <div class="producto">
                <div class="image-product text-center"><img src="./images/productos/accesorios.jpg" alt="accesorios"></div>
                <div class="content-product text-center">
                  <div class="title-product">
                    <h3 class="text-center">LG Tone + Headphones</h3>
                  </div>
                  <div class="price-product"><span>s/</span>99</div>
                  <div class="btn-comprar"><a href="https://bitel.clientes-forceclose.com/bitel_frontend/dist/equipo_accesorio.html" class="btn btn-default">comprar</a></div>
                </div>
              </div>
              <div class="producto">
                <div class="image-product text-center"><img src="./images/productos/accesorios.jpg" alt="accesorios"></div>
                <div class="content-product text-center">
                  <div class="title-product">
                    <h3 class="text-center">LG Tone + Headphones</h3>
                  </div>
                  <div class="price-product"><span>s/</span>99</div>
                  <div class="btn-comprar"><a href="https://bitel.clientes-forceclose.com/bitel_frontend/dist/equipo_accesorio.html" class="btn btn-default">comprar</a></div>
                </div>
              </div>
              <div class="producto">
                <div class="image-product text-center"><img src="./images/productos/accesorios.jpg" alt="accesorios"></div>
                <div class="content-product text-center">
                  <div class="title-product">
                    <h3 class="text-center">LG Tone + Headphones</h3>
                  </div>
                  <div class="price-product"><span>s/</span>99</div>
                  <div class="btn-comprar"><a href="https://bitel.clientes-forceclose.com/bitel_frontend/dist/equipo_accesorio.html" class="btn btn-default">comprar</a></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
@endsection
