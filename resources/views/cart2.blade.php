@extends('layouts.master')
@section('content')
      <div class="container">
        <div class="row">
          <div class="col-xs-12 col-sm-10 col-sm-offset-1">
            <div id="nav-carrito">
              <ul class="list-unstyled">
                <li class="col-xs-4 col-sm-4"><span>Carrito de compras </span></li>
                <li class="col-xs-4 col-sm-4 active"><span>Informacion de envío</span></li>
                <li class="col-xs-4 col-sm-4"><span>Pedido completo</span></li>
              </ul>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-xs-12 col-sm-10 col-sm-offset-1">
            <div id="form-cliente">
              <div id="form-vue-validator">
                <form @submit.prevent="validateInfoCliente" action="{{route('finalizado')}}">
                  <input type="hidden" name="product" value="{{$product->product_id}}">
                  <div class="title-page">
                    <h2>INFORMACIÓN DEL CLIENTE</h2>
                  </div>
                  <div class="section-form">
                    <div class="form-group">
                      <label>Nombre</label>
                      <input type="text" name="first_name" v-model="first_name" v-validate="'required|alpha'" :class="{'input': true, 'is-danger': errors.has('first_name')}"><i v-show="errors.has('first_name')" class="fa fa-warning"></i><span v-show="errors.has('first_name')" class="help is-danger">@{{ errors.first('first_name') }}</span>
                    </div>
                    <div class="form-group">
                      <label>Apellido</label>
                      <input type="text" name="last_name" v-model="last_name" v-validate="'required|alpha'" :class="{'input': true, 'is-danger': errors.has('last_name')}"><i v-show="errors.has('last_name')" class="fa fa-warning"></i><span v-show="errors.has('last_name')" class="help is-danger">@{{ errors.first('last_name') }}</span>
                    </div>
                    <div class="form-group form-select">
                      <label>Tipo de documento</label>
                      <select v-model="select_document" v-validate="'required'" :class="{'input': true, 'is-danger': errors.has('select_document') }">
                        <option selected>DNI</option>
                      </select>
                    </div>
                    <div class="form-group">
                      <label for="">Número de documento</label>
                      <input type="text" name="number_document" v-model="number_document" v-validate="'required|numeric'" :class="{'input': true, 'is-danger': errors.has('number_document')}"><i v-show="errors.has('number_document')" class="fa fa-warning"></i><span v-show="errors.has('number_document')" class="help is-danger">@{{ errors.first('number_document') }}</span>
                    </div>
                    <div class="form-group">
                      <label for="">distrito de domicilio</label>
                      <input type="text" name="distrito" v-model="distrito" v-validate="'required|alpha'" :class="{'input': true, 'is-danger': errors.has('distrito')}"><i v-show="errors.has('distrito')" class="fa fa-warning"></i><span v-show="errors.has('distrito')" class="help is-danger">@{{ errors.first('distrito') }}</span>
                    </div>
                    <div class="form-group">
                      <label for="">Número de telefono</label>
                      <input type="text" name="number_phone" v-model="number_phone" v-validate="'required|numeric'" :class="{'input': true, 'is-danger': errors.has('number_phone')}"><i v-show="errors.has('number_phone')" class="fa fa-warning"></i><span v-show="errors.has('number_phone')" class="help is-danger">@{{ errors.first('number_phone') }}</span>
                    </div>
                    <div class="form-group form-select">
                      <label for="">Portabilidad o linea nueva</label>
                      <select>
                        <option>portabilidad</option>
                      </select>
                    </div>
                  </div>
                  <div class="title-page">
                    <h3>INFORMACIÓN DE DELIVERY</h3>
                  </div>
                  <div class="section-form">
                    <div class="form-group">
                      <label for="">DIRECCIÓN DE DELIVERY</label>
                      <input type="text" name="delivery" v-model="delivery" v-validate="'required|alpha'" :class="{'input': true, 'is-danger': errors.has('delivery')}"><i v-show="errors.has('delivery')" class="fa fa-warning"></i><span v-show="errors.has('delivery')" class="help is-danger">@{{ errors.first('delivery') }}</span>
                    </div>
                    <div class="form-group">
                      <label for="">CORREO ELECTRÓNICO</label>
                      <input type="text" name="email" v-model="email" v-validate="'required|email'" :class="{'input': true, 'is-danger': errors.has('email')}"><i v-show="errors.has('email')" class="fa fa-warning"></i><span v-show="errors.has('email')" class="help is-danger">@{{ errors.first('email') }}</span>
                    </div>
                    <div class="form-group form-select">
                      <label for="">DISTRITO DE DELIVERY</label>
                      <select>
                        <option>San Isidro</option>
                      </select>
                    </div>
                    <div class="form-group">
                      <label for="">TELÉFONO DE CONTACTO</label>
                      <input type="text" name="number_contact" v-model="number_contact" v-validate="'required|numeric'" :class="{'input': true, 'is-danger': errors.has('number_contact')}"><i v-show="errors.has('number_contact')" class="fa fa-warning"></i><span v-show="errors.has('number_contact')" class="help is-danger">@{{ errors.first('number_phone') }}</span>
                    </div>
                  </div>
                  <div class="title-page">
                    <h3>SELECCIONA TU MEDIO DE PAGO</h3>
                  </div>
                  <div class="section-form mediosdepago">
                    <div class="form-group">
                      <div class="row">
                        <div class="col-xs-6 col-sm-3">
                          <label>
                            <input type="radio" name="mediopago" v-validate="'required'"><img src="images/informacioncliente/icon_visa.png" alt="">
                          </label>
                        </div>
                        <div class="col-xs-6 col-sm-3">
                          <label>
                            <input type="radio" name="mediopago"><img src="images/informacioncliente/icon_mastercard.png" alt="">
                          </label>
                        </div>
                        <div class="col-xs-6 col-sm-3">
                          <label>
                            <input type="radio" name="mediopago"><img src="images/informacioncliente/icon_america.png" alt="">
                          </label>
                        </div>
                        <div class="col-xs-6 col-sm-3">
                          <label>
                            <input type="radio" name="mediopago">
                            <div class="efectivo">En Efectivo<span class="pop">?
                                <div class="text-pop">
                                  <p>Lorem ipsum dolor sit <br> ipsum dolor sithem f <br> ipsumfhf sit feahafdte</p>
                                </div></span></div>
                          </label>
                        </div>
                        <div class="col-xs-12"><span v-show="errors.has('mediopago')" class="help is-danger">@{{ errors.first('mediopago') }}</span></div>
                      </div>
                    </div>
                  </div>
                  <div class="btn-detalle">
                    <div class="row">
                      <div class="col-xs-12 col-sm-6 col-sm-offset-6">
                        <button type="button" class="btn btn-default regresar">REGRESAR</button>
                        {{-- <button type="submit" href="https://bitel.clientes-forceclose.com/bitel_frontend/dist/pedido_completo.html" class="redirect-href btn btn-default comprar">continuar</button> --}}
                        <button type="submit" class="btn btn-default comprar">continuar</button>
                      </div>
                    </div>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      </div>
@endsection
