
/**
 * First we will load all of this project's JavaScript dependencies which
 * includes Vue and other libraries. It is a great starting point when
 * building robust, powerful web applications using Vue and Laravel.
 */

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
Vue.component('comparePostpaid', require('./components/compare-postpaid.vue'));
Vue.component('comparePrepaid', require('./components/compare-prepaid.vue'));

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
    email:'',
    number_contact:'',
    mediopago:'',
    portabilidad: '',
  },
  methods: {
    validateInfoCliente(){
      this.$validator.validateAll().then((result) => {
        if (result) {
          // eslint-disable-next-line
           // alert('Enviado a ' + this.first_name + '!')
          this.$refs.orderform.submit()
          return;
        }

        // alert('Completar los campos');
      });
    },
    change () {
        console.log(this.portabilidad);
    }
  }
});

const app = new Vue({
    el: '#app',
    data: {
        baseUrl : document.head.querySelector('meta[name="base-url"]').content,
        prefix : document.head.querySelector('meta[name="prefix"]').content,
        bestSeller : "smartphone",
        promo : "postpago",
        itemsPerPage : "12",
        filters : {
            type : {
                value : '',
                isOpen : true
            },
            affiliation : {
                value : '2',
                isOpen : true
            },
            plan : {
                value : '',
                isOpen : false
            },
            price : {
                value : '',
                isOpen : false
            },
            manufacturer : {
                value : [],
                all : true,
                isOpen : false
            }
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
        }
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
            item.isOpen = !item.isOpen
        },
        transitionEnter : function(el, done){
            Velocity(el, 'slideDown', {duration: 300, easing: "easeInBack"},{complete: done})
        },
        transitionLeave : function(el, done){
            Velocity(el, 'slideUp', {duration: 300, easing: "easeInBack"},{complete: done})
        },
        addItem : function (product) {
            self = this;
            self.compare.push(product);
        },
        removeItem: function (product_id) {
            self = this
            item = self.compare.find( function (e) {
                return e.product_id == product_id
            })
            index = self.compare.indexOf(item)
            if (index !== -1) {
                self.compare.splice(index, 1)
            }
        },
        selectAll : function () {
            self = this
            if (self.filters.manufacturer.all) {
                self.filters.manufacturer.value = []
                self.searchProduct()
            }
            self.filters.manufacturer.all = true
        },
        searchProduct: function (currentPage) {
            self = this;
            self.pagination.current_page = currentPage
            self.isSearching = true;
            self.noResults = false;
            self.search = true;
            self.searchResult = [];
            (self.filters.manufacturer.value.length > 0) ? self.filters.manufacturer.all = false : self.filters.manufacturer.all = true
            console.log(self.baseUrl);
            let url = self.baseUrl + '/api' + self.prefix +'buscar';
            let data = {
                params: {
                    searched_string: self.searchedString,
                    items_per_page: self.itemsPerPage,
                    filters : self.filters,
                    pag : self.pagination.current_page
                }
            };
            axios.get(url, data).then((response) => {
              console.log(response.data);
              self.searchResult = response.data.data;
              if (self.searchResult.length == 0) {
                  self.noResults = true;
              }
              self.pagination = response.data
              self.isSearching = false;
            }, (error) => {
              console.log(error);
              self.noResults = true;
              self.isSearching = false;
            });
        },
        redirect: function (str) {
            self = this
            window.location.href = self.baseUrl + '/' + str
        },
        selectPlan : function (plan) {
            this.selectedPlan = plan
        }
    },
    beforeMount : function () {

    },
    mounted: function () {
        $('#banner-principal').slick({
            arrows: true,
            dots: false,
            infinite: true,
            autoplay: true,
            arrows: true,
            speed: 300,
            slidesToShow: 1,
            slidesToScroll: 1
        });

        $('.list-productos').slick({
            arrows: true,
            dots: true,
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
                  breakpoint: 768,
                  settings: {
                      arrows: false,
                      centerMode: false,
                      slidesToShow: 2
                  }
                },
                {
                  breakpoint: 667,
                  settings: {
                      arrows: false,
                      centerMode: false,
                      slidesToShow: 2
                  }
                },
                {
                  breakpoint: 480,
                  settings: {
                      arrows: false,
                      centerMode: false,
                      slidesToShow: 1
                  }
                }
            ]
        });

        $('.promociones-tab').slick({
            arrows: true,
            dots: true,
            infinite: true,
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
                      arrows: false,
                      centerMode: false,
                      slidesToShow: 3
                  }
                },
                {
                  breakpoint: 768,
                  settings: {
                      arrows: false,
                      centerMode: false,
                      slidesToShow: 2
                  }
                },
                {
                  breakpoint: 667,
                  settings: {
                      arrows: false,
                      centerMode: false,
                      slidesToShow: 2
                  }
                },
                {
                  breakpoint: 480,
                  settings: {
                      arrows: false,
                      centerMode: false,
                      slidesToShow: 1
                  }
                }
            ]
        });

        $('.lista-equipos').slick({
            arrows: true,
            dots: true,
            infinite: false,
            autoplay: false,
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
                      arrows: false,
                      centerMode: false,
                      slidesToShow: 3
                  }
                },
                {
                  breakpoint: 768,
                  settings: {
                      arrows: false,
                      centerMode: false,
                      slidesToShow: 3
                  }
                },
                {
                  breakpoint: 667,
                  settings: {
                      arrows: false,
                      centerMode: false,
                      slidesToShow: 2
                  }
                },
                {
                  breakpoint: 480,
                  settings: {
                      arrows: false,
                      centerMode: false,
                      slidesToShow: 2
                  }
                },
            ]
        });

        $('.select-plan').slick({
            arrows: true,
            dots: true,
            infinite: false,
            autoplay: false,
            speed: 500,
            slidesToShow: 3,
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
                      slidesToShow: 3
                  }
                },
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
                  breakpoint: 667,
                  settings: {
                      arrows: true,
                      dots: false,
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
                      slidesToShow: 1
                  }
                },
            ]
        });

        $('.descripcion-detalle ul').slick({
            arrows: true,
            dots: true,
            infinite: false,
            autoplay: false,
            speed: 500,
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
                    slidesToShow: 1
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
            $(this).closest('.main-detalle.equipos').hide(200);
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
            $('.plan').removeClass('plan-active');
            $(this).addClass('plan-active');
        });

        $('#zoom_01').elevateZoom({
            zoomType: "inner",
            cursor: "crosshair",
            zoomWindowFadeIn: 500,
            zoomWindowFadeOut: 750,
            gallery : "gallery_01",
            galleryActiveClass: "active"
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


           var ez =   $('#zoom_01').data('elevateZoom');

          ez.swaptheimage(smallImage, largeImage);

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

        $(".incr-btn").on("click", function (e) {
            var $button = $(this);
            var oldValue = $button.parent().find('.quantity').val();
            $button.parent().find('.incr-btn[data-action="decrease"]').removeClass('inactive');
            if ($button.data('action') == "increase") {
                var newVal = parseFloat(oldValue) + 1;
            } else {
            // Don't allow decrementing below 1
                if (oldValue > 1) {
                    var newVal = parseFloat(oldValue) - 1;
                } else {
                    newVal = 1;
                    $button.addClass('inactive');
                }
            }
            $button.parent().find('.quantity').val(newVal);
            e.preventDefault();
        });

        $('.ver-mas-equipo .content-detalle').slideUp();

        $('.ver-mas-equipo .btn-vmas').on('click', function(j) {
            j.preventDefault();

            $('.ver-mas-equipo .content-detalle').slideUp();

            $(this).closest('.title-detalle').next().slideDown();

        /* Act on the event */
        });

        $(window).scroll(function() {
            var scroll = $(window).scrollTop();
            var contScroll = $('#scroll-compara');
            var contScrollNone = $('#scroll-compara');

            if (scroll > 40) {
              $('#fixed-nav-comp').addClass('fixed-nav')
              $('.slick-active .equipo-comp-1').appendTo(contScroll);
              $('.slick-active .equipo-comp-2').appendTo(contScroll);
              $('.slick-active .equipo-comp-3').appendTo(contScroll);
              $('.slick-active .equipo-comp-4').appendTo(contScroll);
              $('.info-lista').addClass('fixed-lista')
                // $("#header-information").hide();
                // $('#nav-bitel').addClass('nav-fixed');
                console.log('hola');
            } else if(scroll < 40) {
              $('.equipo-comp-1').prependTo('.eselec-1');
              $('.equipo-comp-2').prependTo('.eselec-2');
              $('.equipo-comp-3').prependTo('.eselec-3');
              $('.equipo-comp-4').prependTo('.eselec-4');
              $('.info-lista').removeClass('fixed-lista')

              // $('#scroll-compara').remove();
                // console.log('chau');

                // $('#nav-bitel').removeClass('nav-fixed');
            }
        });
    }
});
