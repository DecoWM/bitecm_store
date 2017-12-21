        <div class="col-xs-12 col-sm-3">
          <div class="sidebar-box">
            <form id="search-product" class="form-inline" v-on:submit.prevent="searchProduct(1)">
              <input type="text" placeholder="Busca por modelo" class="form-control" v-model="searchedString">
              <button type="submit" class="btn btn-default btn-search"> <span class="fa fa-search"></span></button>
            </form>
          </div>
          <div id="plan" class="content-catalogo">
            {{-- <div class="title-select" v-on:click="toggleAccordion(filters[type].type)"> --}}
            <div class="title-select">
              <div class="btn-acordion"></div><span>Tipo de Plan</span>
              {{-- <div class="pull-right btl-caret" v-cloak>
                <span class="glyphicon glyphicon-chevron-down" aria-hidden="true" v-show="!filters[type].type.isOpen"></span>
                <span class="glyphicon glyphicon-chevron-up" aria-hidden="true" v-show="filters[type].type.isOpen"></span>
              </div> --}}
            </div>
            <transition v-on:enter="transitionEnter" v-on:leave="transitionLeave">
              <div class="select-item" v-show="filters[type].type.isOpen">
                <div class="item">
                  <input id="prepaid" type="radio" name="type" value="1" {{Request::is('prepago') ? 'checked' : ''}} v-on:change="redirect('prepago')">
                  <label for="prepaid">Prepago</label>
                </div>
                <div class="item">
                  <input id="postpaid" type="radio" name="type" value="2" {{Request::is('postpago') ? 'checked' : ''}} v-on:change="redirect('postpago')">
                  <label for="postpaid">Postpago</label>
                </div>
                <div class="item">
                  <input id="promos" type="radio" name="type" value="3" {{Request::is('promociones') ? 'checked' : ''}} v-on:change="redirect('promociones')">
                  <label for="promos">Promociones</label>
                </div>
              </div>
            </transition>
          </div>
          <div id="precio-equipo" class="content-catalogo">
            <div class="title-select" v-on:click="toggleAccordion(filters[type].price)">
              <div class="btn-acordion"></div><span>Precio de equipo:</span>
              <div class="pull-right btl-caret" v-cloak>
                <span class="glyphicon glyphicon-chevron-down" aria-hidden="true" v-show="!filters[type].price.isOpen"></span>
                <span class="glyphicon glyphicon-chevron-up" aria-hidden="true" v-show="filters[type].price.isOpen"></span>
              </div>
            </div>
            <transition v-on:enter="transitionEnter" v-on:leave="transitionLeave" v-cloak>
              <div class="select-item" v-show="filters[type].price.isOpen">
                <div class="item">
                  <input id="price-opt-0" type="radio" name="price" v-bind:value="{x : 0, y : 0}" v-model="filters[type].price.value" v-on:change="searchProduct(1)">
                  <label for="price-opt-0">Todos</label>
                </div>
                <div class="item">
                  <input id="price-opt-1" type="radio" name="price" v-bind:value="{x : 1, y : 50}" v-model="filters[type].price.value" v-on:change="searchProduct(1)">
                  <label for="price-opt-1">S/. 1 - 50</label>
                </div>
                <div class="item">
                  <input id="price-opt-2" type="radio" name="price" v-bind:value="{x : 51, y : 150}" v-model="filters[type].price.value" v-on:change="searchProduct(1)">
                  <label for="price-opt-2">S/. 51 - 150</label>
                </div>
                <div class="item">
                  <input id="price-opt-3" type="radio" name="price" v-bind:value="{x : 151, y : 300}" v-model="filters[type].price.value" v-on:change="searchProduct(1)">
                  <label for="price-opt-3">S/. 151 - 300</label>
                </div>
                <div class="item">
                  <input id="price-opt-4" type="radio" name="price" v-bind:value="{x : 301, y : 1000}" v-model="filters[type].price.value" v-on:change="searchProduct(1)">
                  <label for="price-opt-4">S/.301 - 1000</label>
                </div>
                <div class="item">
                  <input id="price-opt-5" type="radio" name="price" v-bind:value="{x : 1001, y : 0}" v-model="filters[type].price.value" v-on:change="searchProduct(1)">
                  <label for="price-opt-5">S/. 1001 +</label>
                </div>
              </div>
            </transition>
          </div>
          <div id="precio-plan" class="content-catalogo">
            <div class="title-select" v-on:click="toggleAccordion(filters[type].plan)">
              <div class="btn-acordion"></div><span>Plan</span>
              <div class="pull-right btl-caret" v-cloak>
                <span class="glyphicon glyphicon-chevron-down" aria-hidden="true" v-show="!filters[type].plan.isOpen"></span>
                <span class="glyphicon glyphicon-chevron-up" aria-hidden="true" v-show="filters[type].plan.isOpen"></span>
              </div>
            </div>
            <transition v-on:enter="transitionEnter" v-on:leave="transitionLeave" v-cloak>
              <div class="select-item" v-show="filters[type].plan.isOpen">
                <div class="item">
                  <input id="plan-opt-0" type="radio" name="plan" :checked="filters[type].plan.all" v-on:change="selectAllFilter('plan')">
                  <label for="plan-opt-0">Todos</label>
                </div>
                @foreach ($filters['plan_list'] as $plan)
                <div class="item">
                  <input id="plan-opt-{{$plan->plan_id}}" type="radio" name="plan" value="{{$plan->plan_id}}" v-model="filters[type].plan.value" v-on:change="searchProduct(1)">
                  <label for="plan-opt-{{$plan->plan_id}}">{{$plan->plan_name}}</label>
                </div>
                @endforeach
              </div>
            </transition>
          </div>
          <div id="marca" class="content-catalogo">
            <div class="title-select" v-on:click="toggleAccordion(filters[type].manufacturer)">
              <div class="btn-acordion"></div><span>Filtrar por marca:</span>
              <div class="pull-right btl-caret" v-cloak>
                <span class="glyphicon glyphicon-chevron-down" aria-hidden="true" v-show="!filters[type].manufacturer.isOpen"></span>
                <span class="glyphicon glyphicon-chevron-up" aria-hidden="true" v-show="filters[type].manufacturer.isOpen"></span>
              </div>
            </div>
            <transition v-on:enter="transitionEnter" v-on:leave="transitionLeave" v-cloak>
              <div class="select-item" v-show="filters[type].manufacturer.isOpen">
                <div class="item">
                  <input id="manufacturer-opt-0" type="checkbox" name="manufacturer" v-model="filters[type].manufacturer.all" v-on:change="selectAll()">
                  <label for="manufacturer-opt-0">Todos</label>
                </div>
                @foreach ($filters['brand_list'] as $brand)
                <div class="item">
                  <input id="manufacturer-opt-{{$brand->brand_id}}" type="checkbox" name="manufacturer" v-model="filters[type].manufacturer.value" value="{{$brand->brand_id}}" v-on:change="searchProduct(1)">
                  <label for="manufacturer-opt-{{$brand->brand_id}}">{{$brand->brand_name}}</label>
                </div>
                @endforeach
              </div>
            </transition>
          </div>
        </div>
