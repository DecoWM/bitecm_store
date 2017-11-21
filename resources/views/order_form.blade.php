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
                <form @submit.prevent="validateInfoCliente" action="{{route('store_order')}}" method="POST" ref="orderform">
                  {{ csrf_field() }}
                  <div class="title-page">
                    <h2>INFORMACIÓN DEL CLIENTE</h2>
                  </div>
                  <div class="section-form">
                    <div class="form-group">
                      <label>Nombres</label>
                      <input type="text" name="first_name" v-model="first_name" v-validate="'required'" :class="{'input': true, 'is-danger': errors.has('first_name')}"><i v-show="errors.has('first_name')" class="fa fa-warning"></i>
                      {{-- <span v-show="errors.has('first_name')" class="help is-danger">@{{ errors.first('first_name') }}</span> --}}
                    </div>
                    <div class="form-group">
                      <label>Apellidos</label>
                      <input type="text" name="last_name" v-model="last_name" v-validate="'required'" :class="{'input': true, 'is-danger': errors.has('last_name')}"><i v-show="errors.has('last_name')" class="fa fa-warning"></i>
                      {{-- <span v-show="errors.has('last_name')" class="help is-danger">@{{ errors.first('last_name') }}</span> --}}
                    </div>
                    <div class="form-group form-select">
                      <label>Tipo de documento</label>
                      <select name="document_type" v-model="select_document" v-validate="'required'" :class="{'input': true, 'is-danger': errors.has('document_type') }"><i v-show="errors.has('document_type')" class="fa fa-warning"></i>
                        <option value="1" selected>DNI</option>
                        <option value="2">CARNÉ DE EXTRANJERÍA</option>
                        <option value="3">PASAPORTE</option>
                      </select>
                    </div>
                    <div class="form-group">
                      <label for="">Número de documento</label>
                      <input type="text" name="document_number" v-model="number_document" v-validate="'required|numeric'" :class="{'input': true, 'is-danger': errors.has('document_number')}"><i v-show="errors.has('document_number')" class="fa fa-warning"></i>
                      {{-- <span v-show="errors.has('number_document')" class="help is-danger">@{{ errors.first('number_document') }}</span> --}}
                    </div>
                    <div class="form-group">
                      <label for="">distrito de domicilio</label>
                      <input type="text" name="district" v-model="distrito" v-validate="'required'" :class="{'input': true, 'is-danger': errors.has('district')}"><i v-show="errors.has('district')" class="fa fa-warning"></i>
                      {{-- <span v-show="errors.has('distrito')" class="help is-danger">@{{ errors.first('distrito') }}</span> --}}
                    </div>
                    <div class="form-group">
                      <label for="">Número de telefono</label>
                      <input type="text" name="phone_number" v-model="number_phone" v-validate="'required|numeric'" :class="{'input': true, 'is-danger': errors.has('phone_number')}"><i v-show="errors.has('phone_number')" class="fa fa-warning"></i>
                      {{-- <span v-show="errors.has('number_phone')" class="help is-danger">@{{ errors.first('number_phone') }}</span> --}}
                    </div>
                    <div class="form-group form-select">
                      <label for="">Portabilidad o linea nueva</label>
                      <select name="affiliation" v-model="portabilidad">
                        <option value="portabilidad">Portabilidad</option>
                        <option value="nueva">Linea nueva</option>
                      </select>
                    </div>
                    <div class="form-group form-select" v-if="portabilidad == 'portabilidad'">
                      <label for="">Operador de procedencia</label>
                      <select name="operator">
                        <option value="Movistar">Movistar</option>
                        <option value="Claro">Claro</option>
                        <option value="Entel">Entel</option>
                      </select>
                    </div>
                  </div>
                  <div class="title-page">
                    <h3>INFORMACIÓN DE DELIVERY</h3>
                  </div>
                  <div class="section-form">
                    <div class="form-group">
                      <label for="">DIRECCIÓN DE DELIVERY</label>
                      <input type="text" name="delivery_address" v-model="delivery" v-validate="'required'" :class="{'input': true, 'is-danger': errors.has('delivery_address')}"><i v-show="errors.has('delivery_address')" class="fa fa-warning"></i>
                      {{-- <span v-show="errors.has('delivery')" class="help is-danger">@{{ errors.first('delivery') }}</span> --}}
                    </div>
                    <div class="form-group">
                      <label for="">CORREO ELECTRÓNICO</label>
                      <input type="text" name="email" v-model="email" v-validate="'required|email'" :class="{'input': true, 'is-danger': errors.has('email')}"><i v-show="errors.has('email')" class="fa fa-warning"></i>
                      {{-- <span v-show="errors.has('email')" class="help is-danger">@{{ errors.first('email') }}</span> --}}
                    </div>
                    <div class="form-group form-select">
                      <label for="">DISTRITO DE DELIVERY</label>
                      <select name="delivery_distric">
@foreach ($distritos as $distrito)
                        <option value="{{$distrito}}">{{$distrito}}</option>
@endforeach
                      </select>
                    </div>
                    <div class="form-group">
                      <label for="">TELÉFONO DE CONTACTO</label>
                      <input type="text" name="contact_phone" v-model="number_contact" v-validate="'required|numeric'" :class="{'input': true, 'is-danger': errors.has('contact_phone')}"><i v-show="errors.has('contact_phone')" class="fa fa-warning"></i>
                      {{-- <span v-show="errors.has('number_contact')" class="help is-danger">@{{ errors.first('number_phone') }}</span> --}}
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
                            <input type="radio" name="payment_method" value="1" v-validate="'required'"><img src="images/informacioncliente/icon_visa.png" alt="">
                          </label>
                        </div>
                        <div class="col-xs-6 col-sm-3">
                          <label>
                            <input type="radio" name="payment_method" value="2"><img src="images/informacioncliente/icon_mastercard.png" alt="">
                          </label>
                        </div>
                        <div class="col-xs-6 col-sm-3">
                          <label>
                            <input type="radio" name="payment_method" value="3"><img src="images/informacioncliente/icon_america.png" alt="">
                          </label>
                        </div>
                        <div class="col-xs-6 col-sm-3">
                          <label>
                            <input type="radio" name="payment_method" value="4">
                            <div class="efectivo">En Efectivo<span class="pop">?
                                <div class="text-pop">
                                  <p>Lorem ipsum dolor sit <br> ipsum dolor sithem f <br> ipsumfhf sit feahafdte</p>
                                </div></span></div>
                          </label>
                        </div>
                        {{-- <div class="col-xs-12"><span v-show="errors.has('mediopago')" class="help is-danger">@{{ errors.first('mediopago') }}</span></div> --}}
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
