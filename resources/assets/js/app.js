
/**
 * First we will load all of this project's JavaScript dependencies which
 * includes Vue and other libraries. It is a great starting point when
 * building robust, powerful web applications using Vue and Laravel.
 */

require('block-ui');
require('./bootstrap');

window.Vue = require('vue');
window.Velocity = require('velocity-animate');

/**
 * Next, we will create a fresh Vue application instance and attach it to
 * the page. Then, you may begin adding components to this application
 * or customize the JavaScript scaffolding to fit your unique needs.
 */

// Vue.component('example', require('./components/Example.vue'));
Vue.component('loader', require('./components/loader.vue'));
Vue.component('paginatorLinks', require('./components/paginator.vue'));
Vue.component('postpaid', require('./components/postpaid.vue'));
Vue.component('prepaid', require('./components/prepaid.vue'));
Vue.component('products', require('./components/products.vue'));
Vue.component('promos', require('./components/promos.vue'));
Vue.component('comparePostpaid', require('./components/compare-postpaid.vue'));
Vue.component('comparePrepaid', require('./components/compare-prepaid.vue'));
Vue.component('postpaidAvailable', require('./components/postpaid/available.vue'));
Vue.component('postpaidPrice', require('./components/postpaid/price.vue'));
Vue.component('postpaidColor', require('./components/postpaid/color.vue'));
Vue.component('postpaidPlan', require('./components/postpaid/plan.vue'));
Vue.component('plansFiltered', require('./components/postpaid/plans-filtered.vue'));
Vue.component('affiliationsFiltered', require('./components/postpaid/affiliations-filtered.vue'));
Vue.component('provincesFiltered', require('./components/postpaid/provinces-filtered.vue'));
Vue.component('districtsFiltered', require('./components/postpaid/districts-filtered.vue'));
Vue.component('provincesdFiltered', require('./components/postpaid/provincesd-filtered.vue'));
Vue.component('districtsdFiltered', require('./components/postpaid/districtsd-filtered.vue'));

Vue.directive('init', {
  bind: function(el, binding, vnode) {
    vnode.context[binding.arg] = binding.value;
  }
});

var VeeValidate = require('vee-validate');
Vue.use(VeeValidate);

const form = new Vue({
  el: '#form-vue-validator',
  data: {
    first_name:'',
    last_name:'',
    select_document:'',
    number_document:'',
    distrito:'',
    number_phone:'',
    delivery:'',
    delivery_district:'',
    email:'',
    number_contact:'',
    mediopago:'',
    affiliation: '',
    disabled: false,
    operator: '',
    porting_phone: '',
    departamento: '',
    provincia: '',
    distrito: '',
    type_number_carry: '',
    provinces: '',
    districts: '',
    delivery_provinces: '',
    delivery_districts: '',
    delivery_province: '',
    delivery_district: ''
  },
  methods: {
    validateInfoCliente() {
      this.$validator.validateAll().then((result) => {
        if (result && !this.disabled) {
          $('#master').block({ message: `
            <div class="spinner">
              <div class="double-bounce1"></div>
              <div class="double-bounce2"></div>
            </div>
            <span>Cargando...</span>`, css: {
              position: 'fixed',
              'z-index': '99999',
              border: 'none',
              padding: '15px',
              'background-color': 'transparent',
              '-webkit-border-radius': '10px',
              '-moz-border-radius': '10px',
              color: '#ffe60d'
            } });
          this.disabled = true;
          this.$refs.orderform.submit();
          return;
        }
      });
    },
    change () {
      // console.log(this.affiliation);
    },

    //-----------------------
    //  LUGAR DE DOMICILIO
    //-----------------------
    selectDepartament: function(event) {
          if(event.target.value.length > 0) {
            route = event.target.value;
            this.getProvincesByDepartament(route);
          }
    },
    getProvincesByDepartament: function(route) {
          self = this; 

          //--------------------
          // PROVINCIAS
          //--------------------
          const provinces_filtered = []; let i = 0;
            self.dept_prov_dist_branch_list.forEach(function(province) {
              if(province.departament_id == route){
                  provinces_filtered.push(province);
              }

              i++;
              if (self.dept_prov_dist_branch_list.length == i) {
                 //self.provinces = provinces_filtered;
              }
          });

          // filtrado de las provincias unicas por departamento
          var aux = provinces_filtered; 
          var aux2 = []; 

          aux2[0] = aux[0];
          var a = 1;
          for(var x = 0; x < aux.length; x++) {
            var p = 0;
            for(var y = 0; y < aux2.length; y++) {
              if(aux[x]['province_id'] == aux2[y]['province_id']){
                p++;
              }
            }
            if(p == 0){
              aux2[a] = aux[x];
              a++;
            }
          }
           
          // carga los valores en el combobox 
          self.provinces = aux2; 

          //--------------------
          // DISTRITOS
          //--------------------
          const districts_filtered = []; let b = 0;
            self.dept_prov_dist_branch_list.forEach(function(district) {
              if(district.province_id == aux2[0]['province_id']) {
                districts_filtered.push(district);
              }

              b++;
              if (self.dept_prov_dist_branch_list.length == b) {
                 self.districts = districts_filtered;
              }
          });

    },
    selectProvince: function(event) {
          if(event.target.value.length > 0) {
            route = event.target.value;
            this.getDistricsByProvince(route);
          }
    },
    getDistricsByProvince: function(route) {
          self = this;
          const districts_filtered = []; let i = 0;
            self.dept_prov_dist_branch_list.forEach(function(district) {
              if(district.province_id == route) {
                districts_filtered.push(district);
              }

              i++;
              if (self.dept_prov_dist_branch_list.length == i) {
                 self.districts = districts_filtered;
              }
          });
    },

    //-----------------------
    //  LUGAR DE RECOJO
    //-----------------------
    selectDepartamentd: function(event) {
          if(event.target.value.length > 0) {
            route = event.target.value;
            this.getProvincesByDepartamentd(route);
          }
    },
    getProvincesByDepartamentd: function(route) {
          self = this; 

          //--------------------
          // PROVINCIAS
          //--------------------
          console.log('entro');
          console.log(delivery_province);
          const provinces_filtered = []; let i = 0;
            self.dept_prov_dist_branch_list.forEach(function(delivery_province) {
              if(delivery_province.departament_id == route){
                  provinces_filtered.push(delivery_province);
              }

              i++;
              if (self.dept_prov_dist_branch_list.length == i) {
                 //self.provinces = provinces_filtered;
              }
          });

          // filtrado de las provincias unicas por departamento
          var aux = provinces_filtered; 
          var aux2 = []; 

          aux2[0] = aux[0];
          var a = 1;
          for(var x = 0; x < aux.length; x++) {
            var p = 0;
            for(var y = 0; y < aux2.length; y++) {
              if(aux[x]['province_id'] == aux2[y]['province_id']){
                p++;
              }
            }
            if(p == 0){
              aux2[a] = aux[x];
              a++;
            }
          }
           
          // carga los valores en el combobox 
          console.log(aux2);
          self.delivery_provinces = aux2; 

          //--------------------
          // DISTRITOS
          //--------------------
          const districts_filtered = []; let b = 0;
            self.dept_prov_dist_branch_list.forEach(function(delivery_district) {
              if(delivery_district.province_id == aux2[0]['province_id']) {
                districts_filtered.push(delivery_district);
              }

              b++;
              if (self.dept_prov_dist_branch_list.length == b) {
                 self.delivery_districts = districts_filtered;
              }
          });

    },
    selectProvinced: function(event) {
          if(event.target.value.length > 0) {
            route = event.target.value;
            this.getDistricsByProvinced(route);
          }
    },
    getDistricsByProvinced: function(route) {
          self = this;
          const districts_filtered = []; let i = 0;
            self.dept_prov_dist_branch_list.forEach(function(delivery_district) {
              if(delivery_district.province_id == route) {
                districts_filtered.push(delivery_district);
              }

              i++;
              if (self.dept_prov_dist_branch_list.length == i) {
                 self.delivery_districts = districts_filtered;
              }
          });
    }

  },
  mounted: function() {
    var order_detail = JSON.parse(document.head.querySelector('meta[name="order_detail"]').content);

    this.first_name = order_detail.first_name;
    //this.last_name = order_detail.last_name;
    this.select_document = order_detail.idtype_id;
    this.number_document = order_detail.id_number;
    this.distrito = order_detail.billing_district;
    this.number_phone = order_detail.billing_phone;
    this.delivery = order_detail.delivery_address;
    this.email = order_detail.contact_email;
    this.delivery_district = order_detail.delivery_district;
    this.number_contact = order_detail.contact_phone;
    this.mediopago = order_detail.payment_method_id;

    if (order_detail.affiliation_id) {
      this.affiliation = order_detail.affiliation_id;
      if (order_detail.affiliation_id === 1) {
        this.operator = order_detail.source_operator_id;
        this.porting_phone = order_detail.porting_phone;
      }
    }

    var depars = JSON.parse(document.head.querySelector('meta[name="dept_prov_dist_branch_list"]').content);

    this.dept_prov_dist_branch_list = depars;

    // phone_number.addEventListener("keypress", soloNumeros, false);
    // porting_phone.addEventListener("keypress", soloNumeros, false);
    // contact_phone.addEventListener("keypress", soloNumeros, false);
    

    // //Solo permite introducir numeros.
    // function soloNumeros(e){
    //   var key = window.event ? e.which : e.keyCode;
    //   if (key < 48 || key > 57) {
    //     e.preventDefault();
    //   }
    // }
  }
});

const app = new Vue({
    el: '#app',
    data: {
        baseUrl : document.head.querySelector('meta[name="base-url"]').content,
        prefix : document.head.querySelector('meta[name="prefix"]').content,
        type : document.head.querySelector('meta[name="type"]').content,
        isMobile: false,
        bestSeller : "smartphone",
        promo : "postpago",
        itemsPerPage : "12",
        filters: {
          accesorios : {
            price : {
                value : {x: 0, y: 0},
                isOpen : true
            },
            manufacturer : {
                value : [],
                all : true,
                isOpen : true
            }
          },
          promociones : {
            type : {
                value : '',
                isOpen : true
            },
            contract : {
                value : '2',
                isOpen : true
            },
            price : {
                value : {x: 0, y: 0},
                isOpen : true
            },
            manufacturer : {
                value : [],
                all : true,
                isOpen : true
            }
          },
          prepago : {
              type : {
                  value : '',
                  isOpen : true
              },
              plan : {
                  value : '',
                  all: true,
                  isOpen : false
              },
              price : {
                  value : {x: 0, y: 0},
                  isOpen : true
              },
              manufacturer : {
                  value : [],
                  all : true,
                  isOpen : false
              }
          },
          postpago : {
              type : {
                  value : '',
                  isOpen : true
              },
              contract : {
                  value : '2',
                  isOpen : true
              },
              affiliation : {
                  value : document.head.querySelector('meta[name="affiliation_id"]').content,
                  isOpen : true
              },
              plan : {
                  value : document.head.querySelector('meta[name="plan_post_id"]').content,
                  isOpen : false
              },
              price : {
                  value : {x: 0, y: 0},
                  isOpen : false
              },
              manufacturer : {
                  value : [],
                  all : true,
                  isOpen : false
              }
          },
        },
        compare: [],
        searchedString : "",
        search : false,
        isSearching : false,
        searchResult : [],
        noResults : false,
        pagination: {
            total: 20,
            per_page: 12,
            from: 1,
            to: 12,
            current_page: 1,
            last_page: 2
        },
        offset : 4,
        //DETALLE DEL PRODUCTO
        selectedPlan : {
            plan_id : 8,
            plan_name : 'iChip 129,90',
            product_variation_price : {
              portability : 59,
              new : 299
            }
        },
        plans: [],
        affiliations: [],
        contracts: [],
        provinces: [],
        districts: [],
        delivery_provinces: [],
        delivery_districts: [],
        deptprovdist: [],
        //AJAX
        product: {},
        current_url: "",
        initial_url: ""
    },
    methods: {
        toggleBestSeller: function (str) {
            self = this;
            self.bestSeller=str;
            this.$nextTick(function(){
                $('.list-productos').slick('setPosition');
                // $('#banner-principal').get(0).slick.setPosition();
            });
        },
        togglePromo: function (str) {
            self = this;
            self.promo = str;
            this.$nextTick(function(){
                $('.promociones-tab').slick('setPosition');
                // $('#banner-principal').get(0).slick.setPosition();
            });
        },
        toggleAccordion : function (item) {
          item.isOpen = !item.isOpen;
        },
        toggleAccordionMobile : function (item) {
          self = this;
          if (self.isMobile) {
            item.isOpen = !item.isOpen;
          }
        },
        transitionEnter : function(el, done){
          Velocity(el, 'slideDown', {duration: 300, easing: "easeInBack"},{complete: done});
        },
        transitionLeave : function(el, done){
          Velocity(el, 'slideUp', {duration: 300, easing: "easeInBack"},{complete: done});
        },
        addItem : function (product) {
            self = this;
            self.compare.push(product);
        },
        removeItem: function (product_variation_id) {
            self = this;
            item = self.compare.find( function (e) {
                return e.product_variation_id == product_variation_id;
            });
            index = self.compare.indexOf(item);
            if (index !== -1) {
                self.compare.splice(index, 1);
            }
        },
        selectAllFilter: function (filter) {
            self = this;
            if (!self.filters[self.type][filter].all) {
                self.filters[self.type][filter].value = '';
                self.searchProduct(1);
            }
            self.filters[self.type][filter].all = true;
        },
        selectAll : function () {
            self = this;
            if (self.filters[self.type].manufacturer.all) {
                self.filters[self.type].manufacturer.value = [];
                self.searchProduct(1);
            }
            self.filters[self.type].manufacturer.all = true;
        },
        searchProduct: function (currentPage) {
            self = this;
            self.pagination.current_page = currentPage;
            self.isSearching = true;
            self.noResults = false;
            self.search = true;
            self.searchResult = [];
            (self.filters[self.type].manufacturer.value.length > 0) ? self.filters[self.type].manufacturer.all = false : self.filters[self.type].manufacturer.all = true;
            if (self.type != 'accesorios' && self.type != 'promociones') {
              (self.filters[self.type].plan.value != '') ? self.filters[self.type].plan.all = false : self.filters[self.type].plan.all = true;
            }
            //console.log(self.baseUrl);
            let url = self.baseUrl + '/api' + self.prefix +'buscar';
            let data = {
              params: {
                searched_string: self.searchedString,
                items_per_page: self.itemsPerPage,
                filters : self.filters[self.type],
                pag : self.pagination.current_page
              }
            };
            axios.get(url, data).then((response) => {
              //console.log(response.data);
              let result = response.data.data;
              if (result.length == 0) {
                self.noResults = true;
              } /* else {
                self.searchResult = result;
                self.pagination = response.data;
                result.forEach(function(prod, ix) {
                  const prod_full_name = (prod.brand_name + ' ' + prod.product_model).toLowerCase();
                  const prod_model_name = prod.product_model.toLowerCase();
                  const searched_string = self.searchedString.trim().toLowerCase();
                  if (searched_string === prod_full_name || searched_string === prod_model_name) {
                    self.searchResult = [prod];
                    self.pagination.last_page_url = self.pagination.first_page_url;
                    self.pagination.last_page = 1;
                    self.pagination.next_page_url = null;
                    self.pagination.prev_page_url = null;
                    self.pagination.to = 1;
                    self.pagination.total = 1;
                  }
                  if (result.length === (ix + 1) && self.searchResult.length == 0) {
                    self.searchResult = result;
                  }
                });
              }*/
              self.searchResult = result;
              self.pagination = response.data;
              self.isSearching = false;
            }, (error) => {
              console.log(error);
              self.noResults = true;
              self.isSearching = false;
            });
        },
        redirect: function (str) {
            self = this;
            window.location.href = self.baseUrl + '/' + str;
        },
        redirectRel: function(loc) {
          window.location.href = loc;
        },
        selectPlan : function (plan) {
          this.selectedPlan = plan;
        },
        selectContract: function(contract_routes,event) {
          if(event.target.value.length > 0) {
            // document.location = affiliation_routes[event.target.value];
            route = contract_routes[event.target.value].split(",");
            this.getProductByContract(route[0], route[1]);
          }
        },
        selectAffiliation: function(affiliation_routes,event) {
          if(event.target.value.length > 0) {
            // document.location = affiliation_routes[event.target.value];
            route = affiliation_routes[event.target.value].split(",");
            this.getProductByAffiliation(route[0], route[1]);
            //console.log(route[0]);
            //console.log(route[1]);
          }
        },
        setUrl: function (history_url) {
            this.current_url = history_url;
            window.history.replaceState("", "", history_url);
        },
        setContract: function(event) {
            self = this;
            contract_id = event.target.value;
            current_contract = self.product.contracts.find(item => item.contract_id == contract_id)
            if (self.current_url != current_contract.route) {
              this.getProductByContract(current_contract.route, current_contract.api_route);
            }
        },
        setAffiliation: function(event) {
            self = this;
            affiliation_id = event.target.value;
            current_affiliation = self.product.affiliations.find(item => item.affiliation_id == affiliation_id)
            if (self.current_url != current_affiliation.route) {
              this.getProductByAffiliation(current_affiliation.route, current_affiliation.api_route);
            }
        },
        setPlan: function(plan_id) {
            self = this;
            var current_plan = self.product.plans.find(item => item.plan_id == plan_id);
            $('.plan').removeClass('plan-active');
            $('#plan'+plan_id).addClass('plan-active');
            if (self.current_url != current_plan.route) {
              this.getProductByPlan(current_plan.route, current_plan.api_route);
            }
        },
        setColor: function (stock_model_id) {
            self = this;
            current_color = self.product.stock_models.find(item => item.stock_model_id == stock_model_id);
            if (self.current_url != current_color.route) {
              this.getProductByStockModel(current_color.route, current_color.api_route);
            }
        },
        isActiveUrl: function (url) {
            if (url == this.current_url) {
                return true;
            }
            return false;
        },
        getProductByPlan: function(history_url, request_url) {
          self = this;
          axios.get(request_url).then((response) => {
            self.product = response.data;
            //console.log(self.product);
            $('input[name="product_variation"]').val(self.product.product.product_variation_id);
            //document.getElementById('affsel').selectedIndex = $('#aff'+self.product.product.affiliation_id).data('ix');
            //document.getElementById('affsel-mov').selectedIndex = $('#aff'+self.product.product.affiliation_id+'-mov').data('ix');
            //$('#plans-slick').slick('slickGoTo', parseInt(self.product.selected_plan));
            //$('#plans-slick').slick('setPosition');
            this.setUrl(history_url);
          }, (error) => {
            console.log(error);
          });
        },
        getProductByContract: function(history_url, request_url) {
          self = this;
          axios.get(request_url).then((response) => {
            self.product = response.data;  // AQUI HACE EL CAMBIO DEL COMBO AFILIACION
       
            $('input[name="product_variation"]').val(self.product.product.product_variation_id);
            $('input[name="affiliation"]').val(self.product.product.affiliation_id);
            $('input[name="contract"]').val(self.product.product.contract_id);

            //----------------
            // AFILIACIONES
            //----------------
            const affiliations_filtered = []; let i = 0;
            self.product.affiliations.forEach(function(affiliation, ix) {
              if(affiliation.contract_id == self.product.product.contract_id) {
                affiliations_filtered.push(affiliation);
              }

              i++;
              if (self.product.affiliations.length == i) {
                 self.affiliations = affiliations_filtered;
              }
            });

            //----------------
            // PLANES
            //----------------
            const plans_filtered = []; let p = 0;
            self.product.plans.forEach(function(plan, ix) {
              if(plan.affiliation_id == self.product.product.affiliation_id) {
                plans_filtered.push(plan);
              }

              p++;
              // x++;
              if (self.product.plans.length == p) {
                 self.plans = plans_filtered;
              }
            });

            document.getElementById('contsel').selectedIndex = $('#cont'+self.product.product.contract_id).data('ix');
            document.getElementById('affsel').selectedIndex = $('#aff'+self.product.product.affiliation_id).data('ix');
        
            this.setUrl(history_url);
          }, (error) => {
            console.log(error);
          });
        },
        getProductByAffiliation: function(history_url, request_url) {
          self = this;
          axios.get(request_url).then((response) => {
            self.product = response.data;

            $('input[name="product_variation"]').val(self.product.product.product_variation_id);
            $('input[name="affiliation"]').val(self.product.product.affiliation_id);
      
            const plans_filtered = []; let i = 0;
            self.product.plans.forEach(function(plan, ix) {
              if(plan.affiliation_id == self.product.product.affiliation_id) {
                plans_filtered.push(plan);
              }

              i++;
              if (self.product.plans.length == i) {
                 self.plans = plans_filtered;
              }
            });
            
            document.getElementById('contsel').selectedIndex = $('#cont'+self.product.product.contract_id).data('ix');
            document.getElementById('affsel').selectedIndex = $('#aff'+self.product.product.affiliation_id).data('ix');
      
            this.setUrl(history_url);
          }, (error) => {
            console.log(error);
          });
        },
        getProductByStockModel: function(history_url, request_url) {
          self = this;
          axios.get(request_url).then((response) => {
            self.product = response.data;
            //console.log(self.product);
            //console.log('selected plan: '+self.product.selected_plan);
            title = self.product.product.brand_name + ' ' + self.product.product.product_model + (self.product.product.color_id ? ' ' + self.product.product.color_name : '')
            $('.title h1').text(title);
            $('.title h2').text(title);
            $('input[name="stock_model"]').val(self.product.product.stock_model_id);
            self.replaceProductImages();
            this.setUrl(history_url);
          }, (error) => {
            console.log(error);
          });
        },
        replaceProductImages: function () {
            images = "";

            if (self.product.product_images.length > 0) {
                image_src = self.baseUrl + '/storage/' + self.product.product_images[0].product_image_url;
                $('#zoom_01').attr('src', image_src);
                $('#gallery_01').html("");
                if (self.product.product_images.length > 1) {
                  for (image of self.product.product_images) {
                    images += '<a href="javascript:void(0)" data-image="' + self.baseUrl + '/storage/' + image.product_image_url + '"><img src="' + self.baseUrl + '/storage/' + image.product_image_url + '" alt="' + self.product.product.product_model + '"></a>';
                  }
                  $('#gallery_01').html(images);

                  $('.galeria-min a').click(function(){
                    var src = $(this).data('image');
                    $('#zoom_01').attr('src', src);
                  });
                  
                  /*$('#zoom_01').elevateZoom({
                    zoomType: "inner",
                    cursor: "default",
                    zoomWindowFadeIn: 500,
                    zoomWindowFadeOut: 750,
                    gallery : "gallery_01",
                    galleryActiveClass: "active",
                  });*/
                }

            } else {
                image_src = self.baseUrl + '/storage/' + self.product.product.product_image_url;
                $('#zoom_01').attr('src', image_src);
            }
        },
        getSlickPlansSettings: function(selectedPlan, just_3) {
          let options = {
            initialSlide: selectedPlan,
            arrows: true,
            dots: false,
            autoplay: false,
            speed: 500,
            slidesToShow: 3,
            slidesToScroll: 1,
            centerPadding: '0px',
            //infinite: false,
            //centerMode: true,
            //variableWidth: true,
            responsive: [
              {
                breakpoint: 1200,
                settings: {
                  arrows: true,
                  dots: false,
                  centerMode: false,
                  infinite: false,
                  slidesToShow: 2
                }
              },
              {
                breakpoint: 996,
                settings: {
                  arrows: true,
                  dots: false,
                  centerMode: false,
                  infinite: false,
                  slidesToShow: 1
                }
              },
              {
                breakpoint: 768,
                settings: {
                  arrows: true,
                  dots: false,
                  //centerMode: true,
                  //infinite: false,
                  slidesToShow: 3
                }
              },
              {
                breakpoint: 667,
                settings: {
                  arrows: true,
                  dots: false,
                  centerMode: false,
                  infinite: false,
                  slidesToShow: 2
                }
              },
              {
                breakpoint: 480,
                settings: {
                  arrows: true,
                  dots: false,
                  centerMode: false,
                  infinite: false,
                  slidesToShow: 1
                }
              },
            ]
          };

          if (just_3 && just_3 === true) {
            options.infinite = false;
            options.centerMode = false;
            options.responsive[2].settings.infinite = false;
            options.responsive[2].settings.centerMode = false;
          } else {
            options.infinite = false;
            options.centerMode = false;
            options.responsive[2].settings.infinite = false;
            options.responsive[2].settings.centerMode = false;
          }

          return options;
        }
    },
    beforeMount: function () {
        self = this;
        if($('#pagination-init').length) {
          paginationData = $('#pagination-init').val();
          self.pagination = JSON.parse(paginationData);
        }
        if($('#search-init').length) {
          searchedString = $('#search-init').val();
          self.searchedString  = searchedString;
        }
        if($('#product-init').length) {
          product = $('#product-init').val();
          self.product = JSON.parse(product);
        }
    },
    mounted: function () {
        self = this;

        $('#addToCart').click(function() {
          fbq('track', 'AddToCart');
          console.log('fbq add to cart');
        });

        $('#initiateCheckout').click(function() {
          fbq('track', 'InitiateCheckout');
          console.log('fbq initiate checkout');
        });

        $('#banner-principal').slick({
          arrows: true,
          dots: true,
          infinite: true,
          autoplay: true,
          arrows: true,
          speed: 300,
          slidesToShow: 1,
          slidesToScroll: 1
        });

        $('.list-productos').slick({
            arrows: true,
            dots: false,
            infinite: true,
            autoplay: true,
            arrows: true,
            speed: 300,
            slidesToShow: 3,
            slidesToScroll: 1,
       	    // centerMode: true,
       	    // variableWidth: true,
            responsive: [
                {
                  breakpoint: 1040,
                  settings: {
                      arrows: false,
                      centerMode: false,
                      slidesToShow: 3
                  }
                },
                {
                  breakpoint: 995,
                  settings: {
                      arrows: true,
                      centerMode: false,
                      slidesToShow: 2
                  }
                },
                {
                  breakpoint: 768,
                  settings: {
                      arrows: true,
                      centerMode: false,
                      slidesToShow: 2
                  }
                },
                {
                  breakpoint: 667,
                  settings: {
                      arrows: true,
                      centerMode: false,
                      slidesToShow: 2
                  }
                },
                {
                  breakpoint: 480,
                  settings: {
                      arrows: true,
                      centerMode: false,
                      slidesToShow: 1
                  }
                }
            ]
        });

        $('.promociones-tab').slick({
            arrows: true,
            dots: false,
            infinite: false,
            autoplay: true,
            arrows: true,
            speed: 300,
            slidesToShow: 4,
            slidesToScroll: 1,
            // centerMode: true,
            // variableWidth: true,
            responsive: [
                {
                  breakpoint: 1040,
                  settings: {
                      arrows: true,
                      centerMode: false,
                      slidesToShow: 3
                  }
                },
                {
                  breakpoint: 768,
                  settings: {
                      arrows: true,
                      centerMode: false,
                      slidesToShow: 2
                  }
                },
                {
                  breakpoint: 667,
                  settings: {
                      arrows: true,
                      centerMode: false,
                      slidesToShow: 2
                  }
                }
                //,
                // {
                //   breakpoint: 480,
                //   settings: {
                //       arrows: true,
                //       centerMode: false,
                //       slidesToShow: 1
                //   }
                // }
            ]
        });

        $('.nav-compara').slick({
          arrows: true,
          dots: false,
          infinite: false,
          autoplay: false,
          arrows: true,
          speed: 300,
          slidesToShow: 4,
          slidesToScroll: 1,
          asNavFor: '.lista-equipos',
          responsive: [
          {
              breakpoint: 1040,
              settings: {
                arrows: true,
                centerMode: false,
                slidesToShow: 3
              }
            },
            {
              breakpoint: 768,
              settings: {
                arrows: true,
                centerMode: false,
                slidesToShow: 3
              }
            },
            {
              breakpoint: 667,
              settings: {
                arrows: true,
                centerMode: false,
                slidesToShow: 2
              }
            },
            {
              breakpoint: 480,
              settings: {
                arrows: true,
                centerMode: false,
                slidesToShow: 2
              }
            }
            //,
            // {
            //   breakpoint: 375,
            //   settings: {
            //     arrows: true,
            //     centerMode: false,
            //     slidesToShow: 1
            //   }
            // }
          ]
        });

        $('.lista-equipos').slick({
          arrows: false,
          dots: false,
          infinite: false,
          autoplay: false,
          arrows: true,
          speed: 300,
          slidesToShow: 4,
          slidesToScroll: 1,
          asNavFor: '.nav-compara',
          // centerMode: true,
          // variableWidth: true,
          responsive: [
          {
              breakpoint: 1040,
              settings: {
                arrows: false,
                dots: false,
                centerMode: false,
                slidesToShow: 3
              }
            },
            {
              breakpoint: 768,
              settings: {
                arrows: false,
                dots: false,
                centerMode: false,
                slidesToShow: 3
              }
            },
            {
              breakpoint: 667,
              settings: {
                centerMode: false,
                slidesToShow: 2
              }
            },
            {
              breakpoint: 480,
              settings: {
                arrows: true,
                dots: false,
                centerMode: false,
                slidesToShow: 2
              }
            }
            //,
            // {
            //   breakpoint: 375,
            //   settings: {
            //     arrows: true,
            //     dots: false,
            //     centerMode: false,
            //     slidesToShow: 1
            //   }
            // }
          ]
        });

        $('.select-plan').slick(self.getSlickPlansSettings($('#planes').data('selected'), $('#plans-slick').hasClass('just-3')));

        // $('.select-plan').slick('setPosition');

        // function resizeSelectPlan() {

        //   // body...
        //   var WindoWSelect = $(window).width();

        //   if (WindoWSelect < 480) {
        //     console.log('hola');
        //     $('.select-plan').on('setPosition', function(event, slick, currentSlide, nextSlide){
        //       console.log($(this));
        //     });
        //   } 

        //   // else {}

        // }

        // resizeSelectPlan();

        // $(window).resize(resizeSelectPlan);

        $('.descripcion-detalle ul').slick({
            arrows: true,
            dots: false,
            infinite: true,
            autoplay: false,
            slidesToShow: 5,
            slidesToScroll: 1,
        // centerMode: true,
        // variableWidth: true,
            responsive: [
            {
              breakpoint: 1040,
              settings: {
                  arrows: true,
                  dots: false,
                  centerMode: false,
                  slidesToShow: 4
            }
            },
            {
              breakpoint: 768,
              settings: {
                  arrows: true,
                  dots: false,
                  centerMode: false,
                  slidesToShow: 4
              }
            },
            {
              breakpoint: 480,
              settings: {
                  dots: false,
                  arrows: true,
                  centerMode: false,
                  slidesToShow: 2
              }
            },

            ]
        });

        $('#producto-disponibles .list-producto').slick({
            arrows: true,
            dots: true,
            infinite: false,
            autoplay: false,
            draggable: false,
            speed: 500,
            slidesToShow: 3,
            slidesToScroll: 1,
            // centerMode: true,
            // variableWidth: true,
            responsive: [
              {
                breakpoint: 768,
                settings: {
                    arrows: true,
                    dots: false,
                    centerMode: false,
                    slidesToShow: 3
                }
              },
              {
                breakpoint: 480,
                settings: {
                    arrows: true,
                    dots: false,
                    centerMode: false,
                    slidesToShow: 1,
                    draggable: false
                }
              },
            ]
        });

        $(window).scroll(function() {
            var scroll = $(window).scrollTop();
            if (scroll >= 200) {
                // $("#header-information").hide();
                $('#list-equipos-comparar').css('top', '55px');
            } else if(scroll < 200) {
                $('#list-equipos-comparar').css('top', '247px');
            }
        });

        $(window).scroll(function() {
            var scroll = $(window).scrollTop();
            if (scroll >= 55) {
            // $("#header-information").hide();
                $('#nav-bitel').addClass('nav-fixed');
            } else if(scroll < 55) {
                $('#nav-bitel').removeClass('nav-fixed');
            }
        });

        $('button.btn-eliminar').on('click', function(event) {
            event.preventDefault();
            /* Act on the event */
            $(this).closest('li').hide(200);
        });

        $('button.btn-eliminar-equipo').on('click', function(event) {
            event.preventDefault();
            /* Act on the event */
            var self = this;
            $(this).closest('.main-detalle.equipos').hide(200,function(){
              $(self).parent('form').submit();
            });
        });

        $('button.last-btn').on('click', function(event) {
            event.preventDefault();
            /* Act on the event */
            $(this).closest('#list-equipos-comparar').css('opacity', '0').hide(400);
        });

        $('.btn-acordion').click(function(event) {
            /* Act on the event */
            event.preventDefault();

            $(this).closest('.title-select').next().slideToggle();
        });

        $('.option-select input').on('click', function() {
            $('.radio-inline').removeClass('option-active');
            $(this).closest('.radio-inline').addClass('option-active');
        });

        $('.select-plan .plan').on('click', function() {
            $('.select-plan label').removeClass('label-active');
            $(this).parent().addClass('label-active');
            $('.plan').removeClass('plan-active');
            $(this).addClass('plan-active');
        });

        $('.option-select .radio-inline').on('click', function() {
            $('.option-select .radio-inline').removeClass('is-active');
            $(this).addClass('is-active');
        });

        /*$('#zoom_01').elevateZoom({
            zoomType: "inner",
            cursor: "default",
            zoomWindowFadeIn: 500,
            zoomWindowFadeOut: 750,
            gallery : "gallery_01",
            galleryActiveClass: "active",
        });*/

        $('.galeria-min a').click(function(){
          var src = $(this).data('image');
          $('#zoom_01').attr('src', src);
        });

        $(".option-select input").change(function(e){
           // var defColor = $(this).attr('id');
           var currentValue = $(".option-select input:checked").val();
           // console.log('Select val ' + currentValue + defColor);
              if(currentValue == 1){
              smallImage = '/images/home/celular-1.jpg';
              largeImage = '/images/home/celular-12.jpg';
              }
              if(currentValue == 2){
              smallImage = '/images/home/celular-2.jpg';
              largeImage = '/images/home/celular-22.jpg';
              }
              if(currentValue == 3){
              smallImage = '/images/home/celular-3.jpg';
              largeImage = '/images/home/celular-33.jpg';
              }
           // if(currentValue == 4){
           // smallImage = 'http://www.elevateweb.co.uk/wp-content/themes/radial/zoom/images/small/image4.png';
           // largeImage = 'http://www.elevateweb.co.uk/wp-content/themes/radial/zoom/images/large/image4.jpg';
           // }
          // Example of using Active Gallery
          $('#gallery_01 a').removeClass('active').eq(currentValue-1).addClass('active');


          /* var ez = $('#zoom_01').data('elevateZoom');

          ez.swaptheimage(smallImage, largeImage); */

        });
        // $("#zoom_03").elevateZoom({
        //   gallery:'gallery_01',
        //  cursor: 'pointer',
        //  galleryActiveClass: 'active',
        //  imageCrossfade: true,
        //  loadingIcon: 'http://www.elevateweb.co.uk/spinner.gif'}
        //  );

        // //pass the images to Fancybox
        // $("#zoom_03").bind("click", function(e) {
        //   var ez =   $('#zoom_03').data('elevateZoom');
        //   $.fancybox(ez.getGalleryList());
        //   return false;
        // });

        $(".incr-btn").each(function(elem){
          var $button = $(this);
          var $action = $button.data('action');
          var $limit = parseInt($button.data('limit'));
          var value = parseInt($button.parent().find('.quantity').val());
          switch($action) {
            case 'increase':
              if (value >= $limit) {
                $button.addClass('inactive');
              }
              break;
            case 'decrease':
              if (value <= $limit) {
                $button.addClass('inactive');
              }
              break;
          }
        });

        $(".incr-btn").on("click", function (e) {
          e.preventDefault();
          var $button = $(this);
          var $action = $button.data('action');
          var $limit = parseInt($button.data('limit'));
          var oldValue = parseInt($button.parent().find('.quantity').val());
          var newVal;
          switch($action) {
            case 'increase':
              var $decButton = $button.parent().find('.incr-btn[data-action="decrease"]');
              var $decAction = $decButton.data('action');
              var $decLimit = parseInt($decButton.data('limit'));
              if (oldValue < $limit) {
                newVal = oldValue + 1;
                $button.parent().find('.quantity').val(newVal);
                if (newVal >= $limit) {
                  $button.addClass('inactive');
                }
                if (newVal > $decLimit) {
                  $decButton.removeClass('inactive');
                }
                $button.parent('form').submit();
              } else {
                $button.addClass('inactive');
              }
              break;
            case 'decrease':
              var $incButton = $button.parent().find('.incr-btn[data-action="increase"]');
              var $incAction = $incButton.data('action');
              var $incLimit = parseInt($incButton.data('limit'));
              if (oldValue > $limit) {
                newVal = oldValue - 1;
                $button.parent().find('.quantity').val(newVal);
                if (newVal <= $limit) {
                  $button.addClass('inactive');
                }
                if (newVal < $incLimit) {
                  $incButton.removeClass('inactive');
                }
                $button.parent('form').submit();
              } else {
                $button.addClass('inactive');
              }
              break;
          }
        });

        $('.ver-mas-equipo .content-detalle').slideUp();

        // $('.ver-mas-equipo .btn-vmas').on('click', function(j) {
        //     j.preventDefault();

        //     $('.ver-mas-equipo .content-detalle').slideUp();

        //     $(this).closest('.title-detalle').next().slideDown();

        // /* Act on the event */
        // });

        $(window).scroll(function() {
            var scroll = $(window).scrollTop();
            if (scroll > 350) {
                $('#fixed-nav-comp').addClass('fixed-nav');

            }else {
                $('#fixed-nav-comp').removeClass('fixed-nav');
            }
        });


      //FILTROS DESPLEGABLES EN RESPONSIVE
      if ($(window).width() < 767) {
          $('.content-catalogo').show();
          self.isMobile = true
          for (var variable in this.filters[this.type]) {
              if (this.filters[this.type][variable].hasOwnProperty('isOpen')) {
                  this.filters[this.type][variable].isOpen = false
              }
          }
          $('.responsive-sidebar-item').append($('.content-catalogo'));
      } else {
          $('.sidebarbox').append($('.content-catalogo')).next();
      }

      $(window).on('resize', function() {
          var contentCatalogo = $('.content-catalogo');
          var win = $(this);

          if (win.width() < 767) {
              $('.content-catalogo').show();
              self.isMobile = true
              for (var variable in self.filters[self.type]) {
                  if (self.filters[self.type][variable].hasOwnProperty('isOpen')) {
                      self.filters[self.type][variable].isOpen = false
                  }
              }
              $('.responsive-sidebar-item').append(contentCatalogo);
          } else {
              self.isMobile = false
              self.filters.accesorios.price.isOpen = true
              self.filters.accesorios.manufacturer.isOpen = true
              self.filters.promociones.type.isOpen = true
              self.filters.promociones.price.isOpen = true
              self.filters.promociones.manufacturer.isOpen = true
              self.filters.prepago.type.isOpen = true
              self.filters.prepago.price.isOpen = true
              self.filters.prepago.price.isOpen = true
              self.filters.postpago.type.isOpen = true
              self.filters.postpago.affiliation.isOpen = true
              $('.sidebarbox').append(contentCatalogo).next();
          }
      });

      $('.responsive-sidebar-title').on('click', function(event) {
          event.preventDefault();
          $('.responsive-sidebar-item').slideToggle(300);
          $(this).children('.btl-caret ').children('.glyphicon').toggleClass('glyphicon-chevron-down glyphicon-chevron-up');
      });

    }
});
