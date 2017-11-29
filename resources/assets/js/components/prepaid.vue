<template>
  <div class="col-xs-12 col-sm-6 col-md-4">
    <!-- <div data-equipo="1" class="producto active-comparar"> -->
    <div data-equipo="1" class="producto" v-bind:class="{'active-comparar': isSelected}">
      <div v-if="product.promo_id" class="ribbon-wrapper">
        <div class="ribbon ribbon-promo">Promo</div>
      </div>
      <div class="image-product text-center">
        <a v-bind:href="product.route">
          <img v-bind:src="product.picture_url" :alt="product.product_model">
        </a>
      </div>
      <div class="content-product text-center">
        <div class="title-product">
          <h3 class="text-center"><b>{{product.brand_name}}</b></h3>
          <h3 class="text-center">{{product.product_model}}</h3>
        </div>
        <div class="price-product">
          <span v-if="!product.promo_id">s/{{product.product_price}}</span>
          <span v-if="product.promo_id">s/{{product.promo_price}}</span>
          <span v-if="product.promo_id" class="normal-price">s/{{product.product_price}}</span>
        </div>
        <div class="plan-product" v-if="product.plan_id != 15">
          <p><a v-bind:href="product.route_post">Ver en plan postpago</a></p>
        </div>
        <div class="btn-product form-inline">
          <div class="form-group btn-comprar">
            <a v-bind:href="product.route" class="btn btn-default">comprar</a>
          </div>
          <div class="checkbox btn-comparar">
            <label>
              <input type="checkbox" class="checkbox-compare" v-model="isSelected" v-on:change="emitCompare" v-bind:disabled="compare.length==4 && !isSelected">comparar
              <span class="checkmark"></span>
            </label>
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
