
/**
 * First we will load all of this project's JavaScript dependencies which
 * includes Vue and other libraries. It is a great starting point when
 * building robust, powerful web applications using Vue and Laravel.
 */

require('./bootstrap');

window.Vue = require('vue');

/**
 * Next, we will create a fresh Vue application instance and attach it to
 * the page. Then, you may begin adding components to this application
 * or customize the JavaScript scaffolding to fit your unique needs.
 */

// Vue.component('example', require('./components/Example.vue'));
Vue.component('loader', require('./components/loader.vue'));
Vue.component('postpaid', require('./components/postpaid.vue'));

const app = new Vue({
    el: '#app',
    data: {
        baseUrl: document.head.querySelector('meta[name="base-url"]').content,
        bestSeller : "smartphone",
        promo: "postpago",
        searchedString: "",
        search: false,
        isSearching: false,
        searchResult: [],
        noResults: false
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
        searchProduct: function () {
            self = this;
            self.isSearching = true;
            self.noResults = false;
            self.search = true;
            self.searchResult = [];
            console.log(self.baseUrl);
            let url = self.baseUrl + '/product/search?searched_string=' + self.searchedString;
            axios.get(url).then((response) => {
              self.searchResult = response.data.data;
              console.log(self.searchResult.length);
              if (self.searchResult.length == 0) {
                  self.noResults = true;
              }
              self.isSearching = false;
            }, (error) => {
              console.log(error);
              self.noResults = true;
              self.isSearching = false;
            });
        }
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
            zoomWindowFadeOut: 750
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

    }
});
