<template>
  <div class="col-xs-12 col-sm-6 col-md-4">
    <!-- <div data-equipo="1" class="producto active-comparar"> -->
    <div data-equipo="1" class="producto" v-bind:class="{'active-comparar': isSelected, 'not-stock': !product.stock_model_id}">
      <div v-if="!product.stock_model_id" class="ribbon-wrapper">
        <div class="ribbon ribbon-sold-out">Agotado</div>
      </div>
      <div v-else-if="product.promo_id" class="ribbon-wrapper">
        <div class="ribbon ribbon-promo">Promoción</div>
      </div>
      <div v-else-if="product.product_tag == 'Destacado'" class="ribbon-wrapper">
        <div class="ribbon ribbon-outstanding">Destacado</div>
      </div>
      <div v-else-if="product.product_tag == 'Nuevo'" class="ribbon-wrapper">
        <div class="ribbon ribbon-new">Nuevo</div>
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
          <span v-if="!product.promo_id">s/.{{product.product_price}}</span>
          <span v-if="product.promo_id">s/.{{product.promo_price}}</span>
          <span v-if="product.promo_id" class="normal-price">s/.{{product.product_price}}</span>
        </div>
        <div class="plan-product">
          <p>en plan <span>{{product.plan_name}}</span></p>
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
                  product_variation_id: this.product.product_variation_id,
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
                self.$emit('removeitem', self.compareItem.product_variation_id)
            }
        },
        beforeMount() {
            self = this
            self.compare.forEach( function (e) {
                if (e.product_variation_id == self.compareItem.product_variation_id) {
                    self.isSelected = true
                }
            })
        },
        mounted() {
            console.log('Component mounted bitel.')
        },
        watch: {
          compare: function() {
            self = this
            var item = self.compare.find( function (e) {
                return e.product_variation_id == self.compareItem.product_variation_id;
            });
            if (item) {
                self.isSelected = true
            } else {
                self.isSelected = false
            }
          }
        }
    }
</script>
