<template>
  <div class="col-xs-12 col-sm-6 col-md-4">
    <!-- <div data-equipo="1" class="producto active-comparar"> -->
    <div data-equipo="1" class="producto" v-bind:class="{'active-comparar': isSelected}">
      <div class="image-product text-center">
        <a v-bind:href="product.route">
          <img v-bind:src="product.picture_url" :alt="product.product_model">
        </a>
      </div>
      <div class="ribbon-wrapper"><div class="ribbon ribbon-promo">Promoción</div></div>
      <div class="content-product text-center">
        <div class="title-product">
          <h3 class="text-center"><b>{{product.brand_name}}</b></h3>
          <h3 class="text-center">{{product.product_model}}</h3>
        </div>
        <template v-if="product.product_variation_id">
          <template v-if="product.variation_type_id == 1">
          <div class="price-product">
            <span>S/.{{product.promo_price}}</span>
            <span class="normal-price">S/.{{product.product_price}}</span>
          </div>
          <div class="plan-product">
            <p><a :href="product.route_post">Ver en plan postpago</a></p>
          </div>
          </template>
          <template v-else-if="product.variation_type_id == 2">
          <div class="price-product">
            <span>S/.{{product.promo_price}}</span>
            <span class="normal-price">S/.{{product.product_price}}</span>
          </div>
          <div class="plan-product">
            <p>en plan <span>{{product.plan_name}}</span></p>
          </div>
          </template>
        </template>
        <template v-else>
        <div class="price-product">
          <span>S/.{{product.promo_price}}</span>
          <span class="normal-price">S/.{{product.product_price}}</span>
        </div>
        </template>
        <div class="btn-product form-inline" style="text-align: center;">
          <div class="form-group btn-comprar">
            <a v-bind:href="product.route" class="btn btn-default">comprar</a>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
    export default {
        props: [
            'product',
            'baseUrl',
            'compare'
        ],
        data () {
            return {
                isSelected : false,
                compareItem : {
                  product_id: this.product.product_id,
                  picture_url: this.product.picture_url
                }
            }
        },
        methods : {
            emitCompare () {
                self = this
                self.isSelected ?
                this.$emit('additem', self.compareItem)
                :
                self.$emit('removeitem', self.compareItem.product_id)
            }
        },
        beforeMount() {
            self = this
            self.compare.forEach( function (e) {
                if (e.product_id == self.compareItem.product_id) {
                    self.isSelected = true
                }
            })
        },
        mounted() {
            console.log('Component mounted bitel.')
        }
    }
</script>
