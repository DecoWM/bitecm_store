<template lang="html">
  <div id="plans-slick" :class="{'just-3': plans.length <= 3, 'select-plan': true}">
    <label v-for="plan in plans">
      <input type="radio" name="plan" form="purchase-form" :value="plan.plan_id" style="display:none;" :checked="isActive(plan.plan_id)">
      <div :id="'plan'+plan.plan_id" class="plan" :class="{'plan-active': isActive(plan.plan_id)}">
        <div class="content-plan" v-on:click="setPlan(plan.plan_id)">
          
          <div class="box-plan-content-plan">
            <span class="precio-title-plan color-secundary">Precio del plan</span>
            <div class="precio-plan hola">S/ {{plan.plan_price}}</div>
            <span class="box-contrato">Sin contrato de permanencia</span>
          </div>
          <div class="box-plan-content-comercial">
            <div class="box-item-comercial">
              <div class=box-column>
                <div class="item-comercial">
                  <img src="/images/planes/icon.png" alt="">
                  <span>Internet</span>
                </div>
              </div>
              <div class="box-column">
                <div class="item-comercial-detalle">
                  <span>4gb + Ilimitado <br><strong> + 4GB x 12 meses</strong></span>
                  <span></span>
                </div>
              </div>
              <div class="box-column">
                <div class="item-comercial-icon">
                  <span class="icon"><img src="/images/planes/icon-info.png" alt=""></span>
                </div>
              </div>
            </div>
            <div class="box-item-comercial">
              <div class=box-column>
                <div class="item-comercial">
                  <img src="/images/planes/icon.png" alt="">
                  <span>Llamadas</span>
                </div>
              </div>
              <div class="box-column">
                <div class="item-comercial-detalle">
                  <span>Ilimitado</span>
                </div>
              </div>
              
            </div>
          </div>
           <div class="box-plan-content-apps-sociales">
              <p>Tus apps favoritas <span>ilimitadas</span></p>
              <ul>
                <li v-for="item in plan.info_comercial" >
                  <span v-if="item.plan_infocomercial_flag_cantidad == 1">
                    <img :src="item.plan_infocomercial_img_url" alt="iconos"></span>
                  <span v-else-if="item.plan_infocomercial_flag_cantidad > 1"><img :src="item.plan_infocomercial_img_url" alt="iconos"></span>
                </li>
              </ul>
              
              <!-- <ul>
                <li><img src="/images/planes/app1.png" alt="" width="32"></li>
                <li><img src="/images/planes/app2.png" alt="" width="32"></li>
                <li><img src="/images/planes/app3.png" alt="" width="32"></li>
                <li><img src="/images/planes/app4.png" alt="" width="32"></li>
                <li><img src="/images/planes/app5.png" alt="" width="32"></li>
                <li><img src="/images/planes/app6.png" alt="" width="32"></li>
              </ul> -->
              <span class="color-secundary">Foto</span>
            </div>
            <div class="box-plan-content-apps">
              <div class="items-box-content box-video">
                <p>Video y Musica</p>
                <ul>
                  <li><img src="/images/planes/video1.png" alt="" width="32"></li>
                  <li><img src="/images/planes/video2.png" alt="" width="32"></li>
                  <li><img src="/images/planes/video3.png" alt="" width="32"></li>
                </ul>
                <span class="color-secundary">Bono 1GB</span>
              </div>
              <div class="items-box-content box-juegos">
                <p>Juegos</p>
                <ul>
                  <li><img src="/images/planes/juego1.png" alt="" width="32"></li>
                  <li><img src="/images/planes/juego2.png" alt="" width="32"></li>
                </ul>
              </div>
            </div>
            




          <!-- <span class="title-plan">{{plan.plan_name}}</span> -->
          <!-- <div class="precio-plan hola">S/. {{plan.plan_price}}<span>al mes</span></div> -->
            <!-- <ul v-for="item in plan.info_comercial" class="list-unstyled">
              <li v-if="item.plan_infocomercial_flag_cantidad == 1"><img :src="item.plan_infocomercial_img_url" alt="Llamadas"><span v-html="item.plan_infocomercial_descripcion"></span></li>
              <li v-else-if="item.plan_infocomercial_flag_cantidad > 1"><img :src="item.plan_infocomercial_img_url" alt="Llamadas">{{item.plan_infocomercial_flag_cantidad}} <span v-html="item.plan_infocomercial_descripcion"></span></li>
            </ul> -->
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
