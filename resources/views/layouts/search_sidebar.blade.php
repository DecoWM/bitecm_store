        <div class="col-xs-12 col-sm-3">
          <div class="sidebar-box">
            <form id="search-product" class="form-inline" v-on:submit.prevent="searchProduct(1)">
              <input type="text" placeholder="Busca por nombre" class="form-control" v-model="searchedString">
              <button type="submit" class="btn btn-default btn-search"> <span class="fa fa-search"></span></button>
            </form>
          </div>
@if (Request::is('postpago') || Request::is('prepago'))
          <div id="plan" class="content-catalogo">
            {{-- <div class="title-select" v-on:click="toggleAccordion(filters.type)"> --}}
            <div class="title-select">
              <div class="btn-acordion"></div><span>Plan</span>
              {{-- <div class="pull-right btl-caret" v-cloak>
                <span class="glyphicon glyphicon-chevron-down" aria-hidden="true" v-show="!filters.type.isOpen"></span>
                <span class="glyphicon glyphicon-chevron-up" aria-hidden="true" v-show="filters.type.isOpen"></span>
              </div> --}}
            </div>
            <transition v-on:enter="transitionEnter" v-on:leave="transitionLeave">
              <div class="select-item" v-show="filters.type.isOpen">
                <div class="item">
                  <input id="prepaid" type="radio" name="type" value="1" {{Request::is('prepago') ? 'checked' : ''}} v-on:change="redirect('prepago')">
                  <label for="prepaid">Prepago</label>
                </div>
                <div class="item">
                  <input id="postpaid" type="radio" name="type" value="2" {{Request::is('postpago') ? 'checked' : ''}} v-on:change="redirect('postpago')">
                  <label for="postpaid">Postpago</label>
                </div>
                {{-- <div class="item">
                  <input id="promotion" type="radio" name="register_webinar_" value="1">
                  <label for="promotion">Promociones</label>
                </div> --}}
              </div>
            </transition>
          </div>
@endif
@if (Request::is('postpago'))
          <div id="lo-quieres" class="content-catalogo">
            {{-- <div class="title-select" v-on:click="toggleAccordion(filters.affiliation)"> --}}
            <div class="title-select">
              <div class="btn-acordion"></div><span>Lo quieres en</span>
              {{-- <div class="pull-right btl-caret" v-cloak>
                <span class="glyphicon glyphicon-chevron-down" aria-hidden="true" v-show="!filters.affiliation.isOpen"></span>
                <span class="glyphicon glyphicon-chevron-up" aria-hidden="true" v-show="filters.affiliation.isOpen"></span>
              </div> --}}
            </div>
            <transition v-on:enter="transitionEnter" v-on:leave="transitionLeave">
              <div class="select-item" v-show="filters.affiliation.isOpen">
@foreach ($filters['affiliation_list'] as $affiliation)
                <div class="item">
                  <input id="type-opt-{{$affiliation->affiliation_id}}" type="radio" name="affiliation" value="{{$affiliation->affiliation_id}}" v-model="filters.affiliation.value" v-on:change="searchProduct(1)">
                  <label for="type-opt-{{$affiliation->affiliation_id}}">{{$affiliation->affiliation_name}}</label>
                </div>
@endforeach
                {{-- <div class="item">
                  <input id="type-opt-1" type="radio" name="affiliation" value="1" v-model="filters.affiliation.value" v-on:change="searchProduct(1)">
                  <label for="type-opt-1">Portabilidad</label>
                </div>
                <div class="item">
                  <input id="type-opt-2" type="radio" name="affiliation" value="2" v-model="filters.affiliation.value" v-on:change="searchProduct(1)">
                  <label for="type-opt-2">Linea nueva</label>
                </div>
                <div class="item">
                  <input id="type-opt-3" type="radio" name="affiliation" value="3" v-model="filters.affiliation.value" v-on:change="searchProduct(1)">
                  <label for="type-opt-3">Renovación</label>
                </div> --}}
              </div>
            </transition>
          </div>
@endif
          <div id="precio-equipo" class="content-catalogo">
            <div class="title-select" v-on:click="toggleAccordion(filters.price)">
              <div class="btn-acordion"></div><span>Precio de equipo:</span>
              <div class="pull-right btl-caret" v-cloak>
                <span class="glyphicon glyphicon-chevron-down" aria-hidden="true" v-show="!filters.price.isOpen"></span>
                <span class="glyphicon glyphicon-chevron-up" aria-hidden="true" v-show="filters.price.isOpen"></span>
              </div>
            </div>
            <transition v-on:enter="transitionEnter" v-on:leave="transitionLeave" v-cloak>
              <div class="select-item" v-show="filters.price.isOpen">
                <div class="item">
                  <input id="price-opt-0" type="radio" name="price" v-bind:value="{x : 0, y : 0}" v-model="filters.price.value" v-on:change="searchProduct(1)">
                  <label for="price-opt-0">Todos</label>
                </div>
                <div class="item">
                  <input id="price-opt-1" type="radio" name="price" v-bind:value="{x : 1, y : 50}" v-model="filters.price.value" v-on:change="searchProduct(1)">
                  <label for="price-opt-1">S/. 1 - 50</label>
                </div>
                <div class="item">
                  <input id="price-opt-2" type="radio" name="price" v-bind:value="{x : 51, y : 150}" v-model="filters.price.value" v-on:change="searchProduct(1)">
                  <label for="price-opt-2">S/. 51 - 150</label>
                </div>
                <div class="item">
                  <input id="price-opt-3" type="radio" name="price" v-bind:value="{x : 151, y : 300}" v-model="filters.price.value" v-on:change="searchProduct(1)">
                  <label for="price-opt-3">S/. 151 - 300</label>
                </div>
                <div class="item">
                  <input id="price-opt-4" type="radio" name="price" v-bind:value="{x : 301, y : 1000}" v-model="filters.price.value" v-on:change="searchProduct(1)">
                  <label for="price-opt-4">S/.301 - 1000</label>
                </div>
                <div class="item">
                  <input id="price-opt-5" type="radio" name="price" v-bind:value="{x : 1001, y : 0}" v-model="filters.price.value" v-on:change="searchProduct(1)">
                  <label for="price-opt-5">S/. 1001 +</label>
                </div>
              </div>
            </transition>
          </div>
@if (Request::is('postpago'))
          <div id="precio-plan" class="content-catalogo">
            <div class="title-select" v-on:click="toggleAccordion(filters.plan)">
              <div class="btn-acordion"></div><span>Plan</span>
              <div class="pull-right btl-caret" v-cloak>
                <span class="glyphicon glyphicon-chevron-down" aria-hidden="true" v-show="!filters.plan.isOpen"></span>
                <span class="glyphicon glyphicon-chevron-up" aria-hidden="true" v-show="filters.plan.isOpen"></span>
              </div>
            </div>
            <transition v-on:enter="transitionEnter" v-on:leave="transitionLeave" v-cloak>
              <div class="select-item" v-show="filters.plan.isOpen">
@foreach ($filters['plan_list'] as $plan)
                <div class="item">
                  <input id="plan-opt-{{$plan->plan_id}}" type="radio" name="plan" value="{{$plan->plan_id}}" v-model="filters.plan.value" v-on:change="searchProduct(1)">
                  <label for="plan-opt-{{$plan->plan_id}}">{{$plan->plan_name}}</label>
                </div>
@endforeach
                {{-- <div class="item">
                  <input id="plan-opt-1" type="radio" name="plan" value="1" v-model="filters.plan.value" v-on:change="searchProduct(1)">
                  <label for="plan-opt-1">ichip 15</label>
                </div>
                <div class="item">
                  <input id="plan-opt-2" type="radio" name="plan" value="2" v-model="filters.plan.value" v-on:change="searchProduct(1)">
                  <label for="plan-opt-2">ichip 29</label>
                </div>
                <div class="item">
                  <input id="plan-opt-3" type="radio" name="plan" value="3" v-model="filters.plan.value" v-on:change="searchProduct(1)">
                  <label for="plan-opt-3">ichip 49</label>
                </div>
                <div class="item">
                  <input id="plan-opt-4" type="radio" name="plan" value="4" v-model="filters.plan.value" v-on:change="searchProduct(1)">
                  <label for="plan-opt-4">ichip 69</label>
                </div>
                <div class="item">
                  <input id="plan-opt-5" type="radio" name="plan" value="5" v-model="filters.plan.value" v-on:change="searchProduct(1)">
                  <label for="plan-opt-5">ichip 89</label>
                </div>
                <div class="item">
                  <input id="plan-opt-6" type="radio" name="plan" value="6" v-model="filters.plan.value" v-on:change="searchProduct(1)">
                  <label for="plan-opt-6">ichip 99</label>
                </div>
                <div class="item">
                  <input id="plan-opt-7" type="radio" name="plan" value="7" v-model="filters.plan.value" v-on:change="searchProduct(1)">
                  <label for="plan-opt-7">ichip 129</label>
                </div>
                <div class="item">
                  <input id="plan-opt-8" type="radio" name="plan" value="8" v-model="filters.plan.value" v-on:change="searchProduct(1)">
                  <label for="plan-opt-8">ichip 149</label>
                </div>
                <div class="item">
                  <input id="plan-opt-9" type="radio" name="plan" value="9" v-model="filters.plan.value" v-on:change="searchProduct(1)">
                  <label for="plan-opt-9">ichip 169</label>
                </div> --}}
              </div>
            </transition>
          </div>
@endif
          <div id="marca" class="content-catalogo">
            <div class="title-select" v-on:click="toggleAccordion(filters.manufacturer)">
              <div class="btn-acordion"></div><span>Filtrar por marca:</span>
              <div class="pull-right btl-caret" v-cloak>
                <span class="glyphicon glyphicon-chevron-down" aria-hidden="true" v-show="!filters.manufacturer.isOpen"></span>
                <span class="glyphicon glyphicon-chevron-up" aria-hidden="true" v-show="filters.manufacturer.isOpen"></span>
              </div>
            </div>
            <transition v-on:enter="transitionEnter" v-on:leave="transitionLeave" v-cloak>
              <div class="select-item" v-show="filters.manufacturer.isOpen">
                <div class="item">
                  <input id="manufacturer-opt-0" type="checkbox" name="manufacturer" v-model="filters.manufacturer.all" v-on:change="selectAll">
                  <label for="manufacturer-opt-0">Todos</label>
                </div>
@foreach ($filters['brand_list'] as $brand)
                <div class="item">
                  <input id="manufacturer-opt-{{$brand->brand_id}}" type="checkbox" name="manufacturer" v-model="filters.manufacturer.value" value="{{$brand->brand_id}}" v-on:change="searchProduct(1)">
                  <label for="manufacturer-opt-{{$brand->brand_id}}">{{$brand->brand_name}}</label>
                </div>
@endforeach
                {{-- <div class="item">
                  <input id="manufacturer-opt-1" type="checkbox" name="manufacturer" v-model="filters.manufacturer.value" value="1" v-on:change="searchProduct(1)">
                  <label for="manufacturer-opt-1">Samsung</label>
                </div> --}}
                {{-- <div class="item">
                  <input id="manufacturer-opt-2" type="checkbox" name="manufacturer" v-model="filters.manufacturer.value" value="2" v-on:change="searchProduct(1)">
                  <label for="manufacturer-opt-2">Sony</label>
                </div>
                <div class="item">
                  <input id="manufacturer-opt-3" type="checkbox" name="manufacturer" v-model="filters.manufacturer.value" value="3" v-on:change="searchProduct(1)">
                  <label for="manufacturer-opt-3">LG</label>
                </div>
                <div class="item">
                  <input id="manufacturer-opt-4" type="checkbox" name="manufacturer" v-model="filters.manufacturer.value" value="4" v-on:change="searchProduct(1)">
                  <label for="manufacturer-opt-4">Alcatel</label>
                </div>
                <div class="item">
                  <input id="manufacturer-opt-5" type="checkbox" name="manufacturer" v-model="filters.manufacturer.value" value="5" v-on:change="searchProduct(1)">
                  <label for="manufacturer-opt-5">Sky</label>
                </div>
                <div class="item">
                  <input id="manufacturer-opt-6" type="checkbox" name="manufacturer" v-model="filters.manufacturer.value" value="6" v-on:change="searchProduct(1)">
                  <label for="manufacturer-opt-6">Lenovo</label>
                </div>
                <div class="item">
                  <input id="manufacturer-opt-7" type="checkbox" name="manufacturer" v-model="filters.manufacturer.value" value="7" v-on:change="searchProduct(1)">
                  <label for="manufacturer-opt-7">Bitel</label>
                </div> --}}
              </div>
            </transition>
          </div>
        </div>
