@extends('layouts.master')
@section('content')
@if (session('ws_result'))
  @php 
  $ws_result = json_decode(session('ws_result'));
  @endphp
  {{-- @if (session('ws_result') == 2) --}}
  <div class="alert alert-warning alert-ws alert-dismissible" role="alert">
    <div class="alert-header">
      <div class="row">
        <div class="col-xs-12 col-sm-8 col-sm-push-4" >
          <button type="button" class="btn-close close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
          <span><b>BITEL</b> {{$ws_result->title}}</span>
        </div>
      </div>
    </div>
    <div class="alert-body">
      <div class="row">
        <div class="center-flex">
          <div class="col-xs-12 col-sm-4">
            <img class="img-responsive" src="{{asset('images/alerts/img-bitel.png')}}" alt="">
          </div>
          <div class="col-xs-12 col-sm-8">
            <p>{{$ws_result->message}}</p>
              {{-- {{session('msg')}} --}}
          </div>
        </div>
      </div>
    </div>
  </div>
  {{-- @endif --}}
@endif
      <div class="container">
        <div class="row">
          <div class="col-xs-12 col-sm-10 col-sm-offset-1">
            <div id="nav-carrito">
              <ul class="list-unstyled">
                <li class="col-xs-4 col-sm-4 is-completed"><span>Carrito de compras </span></li>
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
                      <label for="first_name">Nombres</label>
                      <input id="first_name" type="text" name="first_name" v-model="first_name" v-validate="'required|alpha_spaces|max:100'" maxlength="100" :class="{'input': true, 'is-danger': errors.has('first_name')}"><i v-cloak v-show="errors.has('first_name')" class="fa fa-warning"></i>
                      {{--<span v-show="errors.has('first_name')" class="help is-danger">@{{ errors.first('first_name') }}</span>--}}
                      <span v-cloak v-show="errors.has('first_name')" class="help is-danger">Sólo se permiten caracteres alfabeticos</span>
                    </div>
                    <div class="form-group">
                      <label for="last_name">Apellidos</label>
                      <input id="last_name" type="text" name="last_name" v-model="last_name" v-validate="'required|alpha_spaces|max:100'" maxlength="100" :class="{'input': true, 'is-danger': errors.has('last_name')}"><i v-cloak v-show="errors.has('last_name')" class="fa fa-warning"></i>
                      {{-- <span v-show="errors.has('last_name')" class="help is-danger">@{{ errors.first('last_name') }}</span> --}}
                      <span v-show="errors.has('last_name')" class="help is-danger" v-cloak>Sólo se permiten caracteres alfabeticos</span>
                    </div>
                    <div class="form-group form-select">
                      <label for="document_type">Tipo de documento</label>
                      <select id="document_type" name="document_type" v-model="select_document" v-validate="'required'" :class="{'input': true, 'is-danger': errors.has('document_type') }"><i v-cloak v-show="errors.has('document_type')" class="fa fa-warning"></i>
                        <option value="" selected>Seleccione tipo de documento</option>
                        <option value="1">DNI</option>
                        <option value="2">CARNÉ DE EXTRANJERÍA</option>
                        <option value="3">PASAPORTE</option>
                      </select>
                    </div>
                    <div class="form-group">
                      <label for="document_number">Número de documento</label>
                      <input id="document_number" type="text" name="document_number" v-bind:maxlength="select_document == 1 ? '8' : '12'" v-model="number_document" v-validate="select_document == 1 ? 'required|numeric|min:8|max:8' : 'required|alpha_num|max:12'" :class="{'input': true, 'is-danger': errors.has('document_number')}"><i v-cloak v-show="errors.has('document_number')" class="fa fa-warning"></i>
                      <span v-show="errors.has('document_number')" class="help is-danger" v-cloak>Sólo se permiten caracteres Alfanuméricos</span>
                    </div>
                    <div class="form-group form-select">
                      <label for="district">Distrito de domicilio</label>
                      <select id="district" name="district" v-validate="'required'" :class="{'input': true, 'is-danger': errors.has('district')}">
                        <option value="" selected="">Seleccione Distrito</option>
                        @foreach ($distritos as $distrito)
                        <option value="{{$distrito->district_id}}">{{$distrito->district_name}}</option>
                        @endforeach
                      </select>
                      {{-- <span v-show="errors.has('distrito')" class="help is-danger">@{{ errors.first('distrito') }}</span> --}}
                    </div>
                    <div class="form-group">
                      <label for="phone_number">Número de telefono</label>
                      <input id="phone_number" type="text" name="phone_number" v-model="number_phone" v-validate="'required|numeric|max:11'"  maxlength="11" :class="{'input': true, 'is-danger': errors.has('phone_number')}"><i v-cloak v-show="errors.has('phone_number')" class="fa fa-warning"></i>
                      <span v-show="errors.has('phone_number')" class="help is-danger" v-cloak>Sólo se permiten caracteres numéricos</span>
                    </div>
                    @if(isset($item))
                    <div class="form-group form-select">
                      <label for="affiliation">Tipo de afiliación</label>
                      @if(isset($item['affiliation_id']))
                      <input type="hidden" name="affiliation" value="{{$item['affiliation_id']}}">
                      <select id="affiliation" disabled="" style="background-color:#e2e2e2">
                        <option value="">Seleccione tipo de afiliación</option>
                        @foreach($affiliation_list as $affiliation)
                        <option value="{{$affiliation->affiliation_id}}" {{$affiliation->affiliation_id == $item['affiliation_id'] ? 'selected' : ''}}>
                          {{$affiliation->affiliation_name}}
                        </option>
                        @endforeach
                      @else
                      <select id="affiliation" name="affiliation" v-model="affiliation" v-validate="'required'" :class="{'input': true, 'is-danger': errors.has('affiliation')}">
                        <option value="" selected>Seleccione tipo de afiliación</option>
                        @foreach($affiliation_list as $affiliation)
                        <option value="{{$affiliation->affiliation_id}}">
                          {{$affiliation->affiliation_name}}
                        </option>
                        @endforeach
                      @endif
                      </select>
                    </div>
                    @if(isset($item['affiliation_id']) && $item['affiliation_id'] == 1)
                    <div class="form-group form-select">
                    @else
                    <div class="form-group form-select" v-if="affiliation == 1">
                    @endif
                      <label for="operator">Operador de procedencia</label>
                      <select id="operator" name="operator" v-validate="'required'" :class="{'input': true, 'is-danger': errors.has('operator') }">
                        <option value="" selected>Seleccione un operador de procedencia</option>
                        @foreach($source_operators as $id => $operator)
                        <option value="{{$id}}">{{$operator}}</option>
                        @endforeach
                      </select>
                    </div>
                    @if(isset($item['affiliation_id']) && $item['affiliation_id'] == 1)
                    <div class="form-group">
                    @else
                    <div class="form-group" v-if="affiliation == 1">
                    @endif
                      <label for="porting_phone">Número a portar</label>
                      <input id="porting_phone" type="text" name="porting_phone" maxlength="11" v-validate="'required|numeric|max:11'" :class="{'input': true, 'is-danger': errors.has('porting_phone')}"><i v-cloak v-show="errors.has('porting_phone')" class="fa fa-warning"></i>
                      {{-- <span v-show="errors.has('number_phone')" class="help is-danger">@{{ errors.first('number_phone') }}</span> --}}
                      <span v-show="errors.has('porting_phone')" class="help is-danger" v-cloak>Sólo se permiten caracteres numéricos</span>
                    </div>
                  </div>
                  @endif
                  <div class="title-page">
                    <h3>INFORMACIÓN DE DELIVERY</h3>
                  </div>
                  <div class="section-form">
                    <div class="form-group">
                      <label for="delivery_address">DIRECCIÓN DE DELIVERY</label>

                      <input id="delivery_address" type="text" name="delivery_address" v-model="delivery" v-validate="{required: true, max: 150, regex: /^([a-zA-Z0-9ñÑ#.\s-]+)$/}" maxlength="150" :class="{'input': true, 'is-danger': errors.has('delivery_address')}"><i v-cloak v-show="errors.has('delivery_address')" class="fa fa-warning"></i>
                      {{-- <span v-show="errors.has('delivery')" class="help is-danger">@{{ errors.first('delivery') }}</span> --}}
                    </div>
                    <div class="form-group">
                      <label for="email">CORREO ELECTRÓNICO</label>
                      <input id="email" type="text" name="email" v-model="email" v-validate="'required|email|max:150'" maxlength="150" :class="{'input': true, 'is-danger': errors.has('email')}"><i v-cloak v-show="errors.has('email')" class="fa fa-warning"></i>
                      {{-- <span v-show="errors.has('email')" class="help is-danger">@{{ errors.first('email') }}</span> --}}
                      <span v-show="errors.has('email')" class="help is-danger" v-cloak>Introduce una dirección de correo electrónico válida</span>
                    </div>
                    <div class="form-group form-select">
                      <label for="delivery_district">DISTRITO DE DELIVERY</label>
                      <select id="delivery_district" name="delivery_district" v-validate data-vv-rules="required" :class="{'input': true, 'is-danger': errors.has('delivery_district')}">
                        <option value="" selected>Seleccione Distrito</option>
                        @foreach ($distritos as $distrito)
                        <option value="{{$distrito->district_id}}">{{$distrito->district_name}}</option>
                        @endforeach
                      </select>
                    </div>
                    <div class="form-group">
                      <label for="contact_phone">TELÉFONO DE CONTACTO</label>
                      <input id="contact_phone" type="text" name="contact_phone" v-model="number_contact" v-validate="'required|numeric|max:11'" maxlength="11" :class="{'input': true, 'is-danger': errors.has('contact_phone')}"><i v-cloak v-show="errors.has('contact_phone')" class="fa fa-warning"></i>
                      {{-- <span v-show="errors.has('number_contact')" class="help is-danger">@{{ errors.first('number_phone') }}</span> --}}
                      <span v-show="errors.has('contact_phone')" class="help is-danger" v-cloak>Sólo se permiten caracteres numéricos</span>
                    </div>
                  </div>
                  <div class="title-page">
                    <h3>SELECCIONA TU MEDIO DE PAGO</h3>
                    <span style="padding-left:15px">Te informamos que tu pago se hará en el delivery</span>
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
                                  <p>Esta opción es cuando usted va a cancelar en efectivo.</p>
                                </div></span></div>
                          </label>
                        </div>
                        {{-- <div class="col-xs-12"><span v-show="errors.has('mediopago')" class="help is-danger">@{{ errors.first('mediopago') }}</span></div> --}}
                      </div>
                    </div>
                    <div class="row">
                      <div class="col-xs-12">
                        <p v-cloak v-show="errors.has('payment_method')"  class="text-danger">
                          Selecciona un método de pago.
                        </p>
                      </div>
                    </div>
                  </div>
                  <div class="btn-detalle">
                    <div class="row">
                      <div class="col-xs-12 col-sm-8 col-sm-push-2">
                        <a href="{{route('show_cart')}}" class="btn btn-default regresar">REGRESAR</a>
                        {{-- <button type="button" class="btn btn-default regresar"></button> --}}
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
