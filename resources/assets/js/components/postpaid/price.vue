<template lang="html">
  <div class="col-xs-7 col-sm-6 col-12-mob">
    <div class="detalle-product">
      <div class="price-product">
        <span v-if="product.promo_id">S/.{{product.promo_price}}</span>
        <span :class="{'normal-price': product.promo_id != null}">S/.{{product.product_price}}</span>
      </div>
      <div class="plan-product">
        <p>con <span>{{product.plan_name}}</span></p>
      </div>
      <div class="tiempo-plan">
        <!--p>Contrato de {{product.contract_name}}</p-->
        <p>Sin contrato de permanencia (*)</p>
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
