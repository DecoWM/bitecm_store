<template>
  <div class="col-xs-12 col-sm-6 col-md-4">
    <!-- <div data-equipo="1" class="producto active-comparar"> -->
    <div data-equipo="1" class="producto">
      <div class="image-product text-center"><img v-bind:src="product.picture_url" alt="equipos"></div>
      <div class="content-product text-center">
        <div class="title-product">
          <h3 class="text-center">{{product.product_name}}</h3>
        </div>
        <div class="price-product"><span>s/{{product.product_price_prepaid}}</span></div>
        <div class="plan-product">
          <p>en plan <span>Megaplus 119</span></p>
        </div>
        <div class="btn-product form-inline">
          <div class="form-group btn-comprar"><a href="#" class="btn btn-default">comprar</a></div>
          <div class="checkbox btn-comparar">
            <input type="checkbox" class="checkbox-compare">comparar
          </div>
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
        mounted() {
            console.log('Component mounted bitel.')
        }
    }
</script>
