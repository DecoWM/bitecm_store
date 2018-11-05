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
          <div class="col-xs-12 col-sm-12 col-lg-offset-1 col-lg-11">
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
          <div class="col-xs-12 col-sm-12 col-lg-offset-1 col-lg-11">
            <div id="form-cliente">
              <div class="col-xs-12">
                <div class="title-modalidad">
                  @if(isset($item['affiliation_id']) && $item['affiliation_id'] == 1)
                  <p>Portabilidad</p>
                  @endif
                  @if(isset($item['affiliation_id']) && $item['affiliation_id'] == 2)
                  <p>Linea nueva</p>
                  @endif
                  @if(isset($item['affiliation_id']) && $item['affiliation_id'] == 3)
                  <p>Renovación</p>
                  @endif
                </div>
              </div>
              <div id="form-vue-validator">
                <form @submit.prevent="validateInfoCliente" action="{{route('store_order')}}" method="POST" ref="orderform">
                  {{ csrf_field() }}
                  <div class="col-xs-12">
                    <div class="title-page">
                      <h2>INFORMACIÓN DEL CLIENTE</h2>
                    </div>
                  </div>

                  <div class="section-form">

                    <div class="col-xs-12">
                      <div class="form-group">
                        <label for="first_name">Nombres</label>
                        <input id="first_name" type="text" name="first_name" placeholder="Nombres y apellidos del titular" v-model="first_name" v-validate="'required|alpha_spaces|max:150'" maxlength="150" :class="{'input': true, 'is-danger': errors.has('first_name')}"><i v-cloak v-show="errors.has('first_name')" class="fa fa-warning"></i>
                        {{--<span v-show="errors.has('first_name')" class="help is-danger">@{{ errors.first('first_name') }}</span>--}}
                        <span v-cloak v-show="errors.has('first_name')" class="help is-danger">Sólo se permiten caracteres alfabeticos</span>
                      </div>
                    </div>

                    <!--
                    <div class="form-group">
                      <label for="last_name">Apellidos</label>
                      <input id="last_name" type="text" name="last_name" value=" " v-model="last_name" v-validate="'required|alpha_spaces|max:100'" maxlength="100" :class="{'input': true, 'is-danger': errors.has('last_name')}"><i v-cloak v-show="errors.has('last_name')" class="fa fa-warning"></i>
                      {{-- <span v-show="errors.has('last_name')" class="help is-danger">@{{ errors.first('last_name') }}</span> --}}
                      <span v-show="errors.has('last_name')" class="help is-danger" v-cloak>Sólo se permiten caracteres alfabeticos</span>
                    </div>
                    -->
                    <div class="col-xs-12 col-sm-6">
                      <div class="form-group form-select">
                          <label for="document_type">Tipo de documento</label>
                          <select id="document_type" name="document_type" v-model="document_type" v-validate="'required'" :class="{'input': true, 'is-danger': errors.has('document_type') }">
                            <option value="" selected>Tipo de Documento</option>
                            <option value="1">DNI</option>
                            <option value="2">CARNÉ DE EXTRANJERÍA</option>
                            <option value="3">PASAPORTE</option>
                          </select>
                      </div>
                    </div>

                    <div class="col-xs-12 col-sm-6">
                      <div class="form-group">
                      <label for="document_number">Número de documento</label>
                      <input id="document_number" type="text" name="document_number" placeholder="Documento del titular" v-bind:maxlength="document_type == 1 ? '8' : '12'" v-model="number_document" v-validate="document_type == 1 ? 'required|numeric|min:8|max:8' : 'required|alpha_num|min:8|max:12'" :class="{'input': true, 'is-danger': errors.has('document_number')}"><i v-cloak v-show="errors.has('document_number')" class="fa fa-warning"></i>
                      <span v-show="errors.has('document_number')" class="help is-danger" v-cloak>Sólo se permiten caracteres Alfanuméricos</span>
                      </div>
                    </div>

                    <!-- <div class="col-xs-12">
                      <div class="form-group form-select">
                        <label for="district">Lugar de domicilio</label>
                        <select id="district" name="district" v-validate="'required'" :class="{'input': true, 'is-danger': errors.has('district')}">
                          <option value="" selected="">Seleccione Distrito</option>
                          @foreach ($distritosd as $distrito)
                          <option value="{{$distrito->district_id}}">{{$distrito->district_name}}</option>
                          @endforeach
                        </select>
                        {{-- <span v-show="errors.has('distrito')" class="help is-danger">@{{ errors.first('distrito') }}</span> --}}
                      </div>
                    </div> -->

                    <!--  LINEA NUEVA Y RENOVACIÓN -->
                    <div class="col-xs-12">
                      <div class="form-group" v-if="affiliation == 2 || affiliation == 3">
                        @if(isset($item['affiliation_id']) && $item['affiliation_id'] == 3)
                        <label for="phone_number">Número de telefono de Bitel</label>
                        @else
                        <label for="phone_number">Número de telefono</label>
                        @endif
                        <input id="phone_number" type="text" name="phone_number" v-model="number_phone" v-validate="'required|numeric|max:9'" maxlength="9" :class="{'input': true, 'is-danger': errors.has('phone_number')}"><i v-cloak v-show="errors.has('phone_number')" class="fa fa-warning"></i>
                        <span v-show="errors.has('phone_number')" class="help is-danger" v-cloak>Sólo se permiten caracteres numéricos</span>
                      </div>
                    </div>

                    <!--  PORTABILIDAD -->
                    <div class="col-xs-12">
                      <div class="form-group" v-if="affiliation == 1">
                        <input id="phone_number" type="hidden" name="phone_number" value="920654734">
                      </div>
                    </div>
                    <div class="col-xs-12">
                      <div class="separacion-bloque"></div>
                    </div>

                    <div class="col-xs-12">
                      <div class="title-page">
                        <h2>INFORMACIÓN DE AFILIACIÓN</h2>
                      </div>
                    </div>

                    <div class="col-xs-12">
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
                    </div>

                    <div class="col-xs-12 col-sm-6">
                      @if(isset($item['affiliation_id']) && $item['affiliation_id'] == 1)
                      <div class="form-group form-select">
                      @else
                      <div class="form-group form-select" v-if="affiliation == 1">
                      @endif
                        <label for="type_number_carry">Tipo de número a portar:</label>
                        <select id="type_number_carry" name="type_number_carry" v-model="type_number_carry" v-validate="'required'" :class="{'input': true, 'is-danger': errors.has('type_number_carry') }">
                          <option value="" selected>Seleccione un tipo de número a portar</option>
                          <option value="Prepaid">Prepaid</option>
                          <option value="Postpaid">Postpaid</option>
                        </select>
                      </div>
                    </div>

                    <div class="col-xs-12 col-sm-6">
                      @if(isset($item['affiliation_id']) && $item['affiliation_id'] == 1)
                      <div class="form-group form-select">
                      @else
                      <div class="form-group form-select" v-if="affiliation == 1">
                      @endif
                        <label for="operator">Operador de procedencia</label>
                        <select id="operator" name="operator" v-model="operator" v-validate="'required'" :class="{'input': true, 'is-danger': errors.has('operator') }">
                          <option value="" selected>Seleccione un operador de procedencia</option>
                          @foreach($source_operators as $id => $operator)
                          <option value="{{$id}}">{{$operator}}</option>
                          @endforeach
                        </select>
                      </div>
                    </div>

                    <div class="col-xs-12 col-sm-6">
                      @if(isset($item['affiliation_id']) && $item['affiliation_id'] == 1)
                      <div class="form-group">
                      @else
                      <div class="form-group" v-if="affiliation == 1">
                        @endif
                          <label for="porting_phone">Número a portar</label>
                          <input id="porting_phone" type="text" name="porting_phone" maxlength="9" placeholder="Número del titular a portar (ejemplo 985636512)" v-model="porting_phone" v-validate="'required|numeric|max:9'" :class="{'input': true, 'is-danger': errors.has('porting_phone')}"><i v-cloak v-show="errors.has('porting_phone')" class="fa fa-warning"></i>
                          {{-- <span v-show="errors.has('number_phone')" class="help is-danger">@{{ errors.first('number_phone') }}</span> --}}
                          <span v-show="errors.has('porting_phone')" class="help is-danger" v-cloak>Sólo se permiten caracteres numéricos</span>
                      </div>
                      @endif
                    </div>
                    <div class="col-xs-12">
                      <div class="separacion-bloque"></div>
                    </div>

                    <div class="col-xs-12">
                      <div class="title-page">
                        <h2>INFORMACIÓN DE DELIVERY</h3>
                      </div>
                    </div>

                    <div class="col-xs-12 col-sm-6">
                      <!-- DEPARTAMENTO -->
                      <div class="form-group form-select"  id="departamentodelivery">
                         <label for="delivery_departament">Departamento</label>
                         <select id=delivery_departament" name="delivery_departament" v-model="delivery_departament" v-validate="'required'" :class="{'input': true, 'is-danger': errors.has('delivery_departament')}" @change="selectDepartamentd($event)">
                          <option value="" selected>Seleccione Departamento</option>
                          @foreach ($departamentos as $departamento)
                          <option value="{{$departamento->departament_id}}">{{$departamento->departament_name}}</option>
                          @endforeach
                        </select>
                      </div>
                    </div>

                    <div class="col-xs-12 col-sm-6">
                      <!-- PROVINCIA -->
                      <div class="form-group form-select" id="provinciadelivery">
                      <!-- <div class="form-group form-select" id="provinciadelivery" style="display:none;"> -->
                        <label for="delivery_province">Provincia</label>
                        <provincesd-filtered v-if="delivery_provinces.length > 0" :delivery_provinces="delivery_provinces" :deptprovdist="dept_prov_dist_branch_list"></provincesd-filtered>
                          <div v-if="delivery_provinces.length == 0" id="delivery_provinces-select" class="select-delivery_province">
                            <select id="delivery_province" name="delivery_province" v-model="delivery_province" v-validate="'required'" :class="{'input': true, 'is-danger': errors.has('delivery_province')}" @change="selectProvinced($event)">
                              <option value="" selected>Seleccione Provincia</option>
                              @foreach ($provincias as $provincia)
                              <option value="{{$provincia->province_id}}">{{$provincia->province_name}}</option>
                              @endforeach
                            </select>
                          </div>
                      </div>
                    </div>

                    <div class="col-xs-12 col-sm-6">
                      <!-- DISTRITO -->
                      <div class="form-group form-select" id="distritodelivery">
                      <!-- <div class="form-group form-select" id="distritodelivery" style="display:none;"> -->
                        <label for="delivery_district">Distrito</label>
                        <districtsd-filtered v-if="delivery_districts.length > 0" :delivery_districts="delivery_districts" :deptprovdist="dept_prov_dist_branch_list"></districtsd-filtered>
                          <div v-if="delivery_districts.length == 0" id="delivery_districts-select" class="select-delivery_district">
                            <select id="delivery_district_1" name="delivery_district_1" v-model="delivery_district_1" v-validate="'required'" :class="{'input': true, 'is-danger': errors.has('delivery_district_1')}" @change="selectDistrictd($event)">
                              <option value="" selected>Seleccione Distrito</option>
                              @foreach ($distritos as $distrito)
                              <option value="{{$distrito->district_id}}">{{$distrito->district_name}}</option>
                              @endforeach
                            </select>
                          </div>
                      </div>
                    </div>

                    <div class="col-xs-12 col-sm-6">
                      <div class="form-group">
                        <label for="delivery_address">Dirección de delivery</label>
                        <!--input id="delivery_address" type="hidden" name="delivery_address" value="PREVENTA HUAWEI"-->
                        <input id="delivery_address" type="text" name="delivery_address" v-model="delivery" v-init:delivery="{{array_get($order_detail,'delivery_address','')}}" v-validate="{required: true, max: 150, regex: /^([a-zA-Z0-9ñÑ#.,\s-]+)$/}" maxlength="150" :class="{'input': true, 'is-danger': errors.has('delivery_address')}"><i v-cloak v-show="errors.has('delivery_address')" class="fa fa-warning"></i>
                        <!--span v-show="errors.has('delivery')" class="help is-danger">@{{ errors.first('delivery') }}</span-->
                        <span v-show="errors.has('delivery_address')" class="help is-danger">Introduce una dirección válida</span>
                        <p style="color: #8e8e8e;">Nota: Información de delivery sujeta a cobertura. Verificación mediante llamada telefónica.</p>
                      </div>
                    </div>

                    <div class="col-xs-12 col-sm-6">
                      <div class="form-group">
                        <label for="contact_phone">Número de contacto</label>
                        <input id="contact_phone" type="text" name="contact_phone" v-model="number_contact" v-validate="'required|numeric|max:11'" maxlength="11" :class="{'input': true, 'is-danger': errors.has('contact_phone')}"><i v-cloak v-show="errors.has('contact_phone')" class="fa fa-warning"></i>
                        {{-- <span v-show="errors.has('number_contact')" class="help is-danger">@{{ errors.first('number_phone') }}</span> --}}
                        <span v-show="errors.has('contact_phone')" class="help is-danger" v-cloak>Sólo se permiten caracteres numéricos</span>
                      </div>
                    </div>

                    <div class="col-xs-12 col-sm-6">
                      <div class="form-group">
                        <label for="email">Correo electrónico</label>
                        <input id="email" type="text" name="email" v-model="email" v-validate="'required|email|max:150'" maxlength="150" :class="{'input': true, 'is-danger': errors.has('email')}"><i v-cloak v-show="errors.has('email')" class="fa fa-warning"></i>
                        {{-- <span v-show="errors.has('email')" class="help is-danger">@{{ errors.first('email') }}</span> --}}
                        <span v-show="errors.has('email')" class="help is-danger" v-cloak>Introduce una dirección de correo electrónico válida</span>
                      </div>
                    </div>

                  <!-- <div class="section-form"> -->
                  <div class="col-xs-12 col-sm-6">
                    <!-- HORARIO CONTACTO -->
                    <div class="form-group form-select">
                       <label for="delivery_schedule">Horario de Contacto</label>
                       <select id=delivery_schedule" name="delivery_schedule" v-model="delivery_schedule" v-validate="'required'" :class="{'input': true, 'is-danger': errors.has('delivery_schedule')}">
                        <option value="" selected>Seleccione un Horario</option>
                        @foreach ($horarios as $horario)
                        <option value="{{$horario->idschedule_id}}">{{$horario->idschedule_name}}</option>
                        @endforeach
                      </select>
                    </div>
                  </div>

                  <div class="col-xs-12 col-sm-6">
                    <div class="form-group form-checkbox terminos-condiciones">
                        <!-- <label> -->
                          <input id="terminos_condiciones" name="terminos_condiciones" type="checkbox" v-validate="'required'" checked>
                        <!-- </label> -->
                        <a @click="terminoscondiciones($event)">Términos y condiciones</a>
                        <span class="help is-danger" v-show="errors.has('terminos_condiciones')"> (Debe aceptar los términos y condiciones para poder realizar la compra).</span>
                      </div>
                    </div>

                  </div>

                  <div class="col-xs-12">
                    <div class="separacion-bloque"></div>
                  </div>

                  <!-- </div> -->
                    <!-- <div class="title-page" style="display:none;">
                      <h3>SELECCIONA TU MEDIO DE PAGO</h3>
                      <span style="padding-left:15px">Te informamos que tu pago se hará en el delivery</span>
                    </div> -->
                  <!--div class="section-form mediosdepago" style="display:none;">
                    <div class="form-group">
                      <div class="row">
                        <div class="col-xs-6 col-sm-3">
                          <label>
                            <input type="radio" name="payment_method" value="1" v-model="mediopago" v-validate="'required'"><img src="images/informacioncliente/icon_visa.png" alt="">
                          </label>
                        </div>
                        <div class="col-xs-6 col-sm-3">
                          <label>
                            <input type="radio" name="payment_method" value="2" v-model="mediopago"><img src="images/informacioncliente/icon_mastercard.png" alt="">
                          </label>
                        </div>
                        <div class="col-xs-6 col-sm-3">
                          <label>
                            <input type="radio" name="payment_method" value="3" v-model="mediopago"><img src="images/informacioncliente/icon_america.png" alt="">
                          </label>
                        </div>
                        <div class="col-xs-6 col-sm-3">
                          <label>
                            <input type="radio" name="payment_method" value="4" v-model="mediopago">
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
                  </div-->
                  <div class="col-xs-12">
                    <input type="hidden" name="payment_method" value="4">
                    <div class="btn-detalle">
                      <div class="row">
                        <div class="col-xs-6 col-md-3 col-md-offset-3">
                          <a href="{{route('show_cart')}}" class="btn btn-default regresar">REGRESAR</a>
                        </div>
                        <div class="col-xs-6 col-md-3">
                          {{-- <button type="button" class="btn btn-default regresar"></button> --}}
                          {{-- <button type="submit" href="https://bitel.clientes-forceclose.com/bitel_frontend/dist/pedido_completo.html" class="redirect-href btn btn-default comprar">continuar</button> --}}
                          <button id="submitOrder" type="submit" class="btn btn-default comprar">continuar</button>
                        </div>
                        <!-- <div class="col-xs-12 col-sm-8 col-sm-push-2">
                        </div> -->
                      </div>
                    </div>
                  </div>

                </form>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="modal fade" id="myModalTerminosCondiciones" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-dialog-centered" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal">&times;</button>
              <h4 class="modal-title">Términos y Condiciones</h4>
            </div>
            <div class="modal-body">
              “El usuario autoriza expresamente a Bitel a usar y tratar los datos personales que el titular proporciona en la página web y la contratación de servicios, así como en la información que se derive de su uso. El tratamiento de la información tiene como finalidad crear perfiles y enviar ofertas personalizadas de productos y servicios de la empresa y de terceros. El usuario ejercerá conforme a Ley, en cualquier momento, los derechos de información, acceso, actualización, inclusión, rectificación, cancelación y oposición sobre sus datos personales enviando una comunicación escrita a cualquier Centro de Atención Bitel ó llamando al 123.”
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
            </div>
          </div>
        </div>
      </div>

@endsection
