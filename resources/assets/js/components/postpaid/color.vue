<template lang="html">
  <div class="color-product">
    <fieldset>
      <legend>Color</legend>
      <div id="option-select" class="option-select">
          <!-- @if($stock_model->stock_model_id == $product->stock_model_id) -->
          <div v-for="stock_model in stock_models" class="radio-inline option-active" :class="{'is-active': isActiveUrl(stock_model.route)}" @click.prevent="setUrl(stock_model.route, stock_model.api_route)">
            <div class="color-box" :style="{background: '#' + stock_model.color_hexcode}"></div>
          </div>
      </div>
    </fieldset>
  </div>
</template>

<script>
    export default {
        props: [
            'stock_models'
        ],
        // data: function () {
        //     return {
        //         product_id : this.product,
        //     }
        // },
        methods: {
            isActiveUrl: function (url) {
              return this.$parent.isActiveUrl(url);
            },
            setUrl: function (route, api_route) {
              this.$parent.setUrl(route, api_route)
            }
        },
        mounted() {
            console.log('Component mounted bitel.')
        }
    }
</script>

<style lang="css">
</style>
