<template lang="html">
  <div class="col-xs-12 col-sm-8 col-md-7  col-12-mob">
    <div id="box-detalle-product">
      <div class="detalle-product">
        <div class="price-product">
          <p>Precio del equipo</p>
          <div class="preci-cant">
            
            <div v-if="product.promo_id" class="preci-cant"><span>S</span><span>product.promo_price}}</span></div>
            <div :class="{'normal-price': product.promo_id != null}" class="preci-cant">
              <span class="moneda">S/</span>
              <span>{{product.product_price}}</span>
            </div>
          
          </div>
        </div>
        <div class="plan-product">

          <p style="color: #9f5ed9">Precio del Plan</p>
          <!-- <p><span class="preci-cant">{{product.plan_name}}</span></p> -->
          <div class="preci-cant"><span class="moneda">S/</span><span >29.90</span></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
    export default {
        props: [
            'product'
        ],
        // data: function () {
        //     return {
        //         product_id : this.product,
        //     }
        // },
        mounted() {
            console.log('Component mounted bitel.')
        }
    }
</script>

<style lang="css">
</style>
