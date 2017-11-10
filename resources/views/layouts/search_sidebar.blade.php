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
                <input id="type-opt-1" type="radio" name="type" value="1">
                <label for="type-opt-1">Portabilidad</label>
              </div>
              <div class="item">
                <input id="type-opt-2" type="radio" name="type" value="1">
                <label for="type-opt-2">Linea nueva</label>
              </div>
              <div class="item">
                <input id="type-opt-3" type="radio" name="type" value="1">
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
                <input id="price-opt-1" type="radio" name="price" v-bind:value="{x : 1, y : 50}" v-model="filters.price" v-on:change="searchProduct">
                <label for="price-opt-1">S/. 1 - 50</label>
              </div>
              <div class="item">
                <input id="price-opt-2" type="radio" name="price" v-bind:value="{x : 51, y : 150}" v-model="filters.price" v-on:change="searchProduct">
                <label for="price-opt-2">S/. 51 - 150</label>
              </div>
              <div class="item">
                <input id="price-opt-3" type="radio" name="price" v-bind:value="{x : 151, y : 300}" v-model="filters.price" v-on:change="searchProduct">
                <label for="price-opt-3">S/. 151 - 300</label>
              </div>
              <div class="item">
                <input id="price-opt-4" type="radio" name="price" v-bind:value="{x : 301, y : 1000}" v-model="filters.price" v-on:change="searchProduct">
                <label for="price-opt-4">S/.301 - 1000</label>
              </div>
              <div class="item">
                <input id="price-opt-5" type="radio" name="price" v-bind:value="{x : 1001, y : 0}" v-model="filters.price" v-on:change="searchProduct">
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
                <input id="plan-opt-1" type="radio" name="plan" value="1">
                <label for="plan-opt-1">ichip 15</label>
              </div>
              <div class="item">
                <input id="plan-opt-2" type="radio" name="plan" value="1">
                <label for="plan-opt-2">ichip 29</label>
              </div>
              <div class="item">
                <input id="plan-opt-3" type="radio" name="plan" value="1">
                <label for="plan-opt-3">ichip 49</label>
              </div>
              <div class="item">
                <input id="plan-opt-4" type="radio" name="plan" value="1">
                <label for="plan-opt-4">ichip 69</label>
              </div>
              <div class="item">
                <input id="plan-opt-5" type="radio" name="plan" value="1">
                <label for="plan-opt-5">ichip 89</label>
              </div>
              <div class="item">
                <input id="plan-opt-6" type="radio" name="plan" value="1">
                <label for="plan-opt-6">ichip 99</label>
              </div>
              <div class="item">
                <input id="plan-opt-7" type="radio" name="plan" value="1">
                <label for="plan-opt-7">ichip 129</label>
              </div>
              <div class="item">
                <input id="plan-opt-8" type="radio" name="plan" value="1">
                <label for="plan-opt-8">ichip 149</label>
              </div>
              <div class="item">
                <input id="plan-opt-9" type="radio" name="plan" value="1">
                <label for="plan-opt-9">ichip 169</label>
              </div>
            </div>
          </div>
          <div id="marca" class="content-catalogo">
            <div class="title-select">
              <div class="btn-acordion"></div><span>Filtrar por marca:</span>
            </div>
            <div class="select-item">
              <div class="item">
                <input id="brand-opt-1" type="checkbox" name="brand" v-model="filters.manufacturer" value="1" v-on:change="searchProduct">
                <label for="brand-opt-1">Samsung</label>
              </div>
              <div class="item">
                <input id="brand-opt-2" type="checkbox" name="brand" v-model="filters.manufacturer" value="2" v-on:change="searchProduct">
                <label for="brand-opt-2">Sony</label>
              </div>
              <div class="item">
                <input id="brand-opt-3" type="checkbox" name="brand" v-model="filters.manufacturer" value="3" v-on:change="searchProduct">
                <label for="brand-opt-3">LG</label>
              </div>
              <div class="item">
                <input id="brand-opt-4" type="checkbox" name="brand" v-model="filters.manufacturer" value="4" v-on:change="searchProduct">
                <label for="brand-opt-4">Alcatel</label>
              </div>
              <div class="item">
                <input id="brand-opt-5" type="checkbox" name="brand" v-model="filters.manufacturer" value="5" v-on:change="searchProduct">
                <label for="brand-opt-5">Sky</label>
              </div>
              <div class="item">
                <input id="brand-opt-6" type="checkbox" name="brand" v-model="filters.manufacturer" value="6" v-on:change="searchProduct">
                <label for="brand-opt-6">Lenovo</label>
              </div>
              <div class="item">
                <input id="brand-opt-7" type="checkbox" name="brand" v-model="filters.manufacturer" value="7" v-on:change="searchProduct">
                <label for="brand-opt-7">Bitel</label>
              </div>
            </div>
          </div>
        </div>
