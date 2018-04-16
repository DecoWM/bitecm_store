<template lang="html">
  <div id="api-plan" class="select-plan">
    <label v-for="plan in plans" :class="{'label-active': isActiveUrl(plan.route)}">
      <input type="radio" name="plan" form="purchase-form" :value="plan.plan_id" style="display:none;" :checked="plan.id == product.plan_id">
      <div class="plan" :class="{'plan-active': isActiveUrl(plan.route)}">
        <div class="content-plan" v-on:click="setUrl(plan.route, plan.api_route)">
          <span class="title-plan">{{plan.plan_name}}</span>
          <div class="precio-plan">S/. {{plan.plan_price}}<span>al mes</span></div>
          <ul class="list-unstyled">
            <li v-if="plan.plan_unlimited_calls == 1"><img src="/images/equipo/svg/planes/llamadas.svg" alt="Llamadas">Llamadas ilimitadas XX(**)</li>
            <li v-else-if="plan.plan_unlimited_calls > 1"><img src="/images/equipo/svg/planes/llamadas.svg" alt="Llamadas">{{plan.plan_unlimited_calls}} min de Llamadas</li>
            <li v-if="plan.plan_unlimited_sms == 1"><img src="/images/equipo/svg/planes/sms.svg" alt="SMS">SMS ilimitado HHHH(**)</li>
            <li v-else-if="plan.plan_unlimited_sms > 1"><img src="/images/equipo/svg/planes/sms.svg" alt="SMS">{{plan.plan_unlimited_calls}} SMS todo operador</li>
            <li v-if="plan.plan_data_cap && plan.plan_data_cap !== ''"><img src="/images/equipo/svg/planes/internet.svg" alt="Internet"><span v-html="plan.plan_data_cap"></span></li>
            <li v-if="plan.plan_unlimited_rpb == 1"><img src="/images/equipo/svg/planes/rpb.svg" alt="RPB">Llamada todo Bitel Gratis</li>
            <li v-if="plan.plan_free_facebook == 1"><img src="/images/equipo/svg/planes/facebook.svg" alt="Facebook">Facebook Flex Gratis</li>
            <li v-if="plan.plan_unlimited_whatsapp == 1"><img src="/images/equipo/svg/planes/whatsapp.svg" alt="WhatsApp">WhatsApp Ilimitado</li>
          </ul>
        </div>
      </div>
    </label>
  </div>
</template>

<script>
    export default {
        props: [
            'plans',
            'product'
        ],
        methods: {
            isActiveUrl: function (url) {
              return this.$parent.isActiveUrl(url);
            },
            setUrl: function (route, api_route) {
              this.$parent.setUrl(route, api_route)
            },
            slider() {
                $('#api-plan').slick({
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
            }
        },
        mounted() {
            if (this.plans.length > 0) {
              this.slider()
            }
            console.log('Component mounted bitel.')
        },
        watch: {
          plans: function () {
            if (this.plans.length > 0) {
              $('#api-plan').slick('unslick');
              this.slider()
            }
          }
        }
    }
</script>

<style lang="css">
</style>
