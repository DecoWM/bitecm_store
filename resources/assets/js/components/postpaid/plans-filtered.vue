<template lang="html">
  <div id="plans-slick" :class="{'just-3': plans.length <= 3, 'select-plan': true}">
    <label v-for="plan in plans">
      <input type="radio" name="plan" form="purchase-form" :value="plan.plan_id" style="display:none;" :checked="isActive(plan.plan_id)">
      <div :id="'plan'+plan.plan_id" class="plan" :class="{'plan-active': isActive(plan.plan_id)}">
        <div class="content-plan" v-on:click="setPlan(plan.plan_id)">
          <span class="title-plan">{{plan.plan_name}}</span>
          <div class="precio-plan">S/. {{plan.plan_price}}<span>al mes</span></div>
          <ul class="list-unstyled">
            <li v-if="plan.plan_unlimited_calls == 1"><img src="/images/equipo/svg/planes/llamadas.svg" alt="Llamadas">Llamadas ilimitadas (**)</li>
            <li v-else-if="plan.plan_unlimited_calls > 1"><img src="/images/equipo/svg/planes/llamadas.svg" alt="Llamadas">{{plan.plan_unlimited_calls}} min de Llamadas</li>
            <li v-if="plan.plan_unlimited_sms == 1"><img src="/images/equipo/svg/planes/sms.svg" alt="SMS">SMS ilimitado (**)</li>
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
    props: {
      plans: Array,
      product: Object,
      plansChanged: {
        type: Number,
        default: 0
      }
    },
    methods: {
      isActive: function (plan_id) {
        return plan_id == this.product.product.plan_id;
      },
      isActiveUrl: function (url) {
        return this.$parent.isActiveUrl(url);
      },
      setPlan: function (plan_id) {
        this.$parent.setPlan(plan_id);
      },
      slider() {
        $('#plans-slick').slick(this.$parent.getSlickPlansSettings(this.product.selected_plan, this.product.just_3));
        // $('.select-plan').slick('slickGoTo', parseInt(this.product.selected_plan));
        // $('#plan'+this.product.product.plan_id).trigger('click');
      }
    },
    mounted() {
      if (this.plans.length > 0) {
        this.slider();
      }
    },
    beforeUpdate() {
      if (this.plansChanged && $('#plans-slick').hasClass('slick-initialized')) {
        console.log('plans-filtered component: before update');
        $('#plans-slick').slick('unslick');
      }
    },
    updated() {
      if (this.plansChanged && this.plans.length > 0) {
        console.log('plans-filtered component: updated');
        this.slider();
        this.plansChanged = 0;
      }
    },
    watch: {
      plans: function () {
        console.log('plans-filtered component: plans prop updated');
        this.plansChanged = 1;
      }
    }
  }
</script>
