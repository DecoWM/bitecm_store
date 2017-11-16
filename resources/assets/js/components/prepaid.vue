<template>
  <div class="col-xs-12 col-sm-6 col-md-4">
    <!-- <div data-equipo="1" class="producto active-comparar"> -->
    <div data-equipo="1" class="producto" v-bind:class="{'active-comparar': isSelected}">
      <div class="image-product text-center"><img v-bind:src="product.picture_url" alt="equipos"></div>
      <div class="content-product text-center">
        <div class="title-product">
          <h3 class="text-center">{{product.product_name}}</h3>
        </div>
        <div class="price-product"><span>s/{{product.product_price_prepaid}}</span></div>
        <div class="plan-product">
          <p>Ver en plan postpago</p>
        </div>
        <div class="btn-product form-inline">
          <div class="form-group btn-comprar"><a v-bind:href="baseUrl + '/smartphones/' +  product.product_id" class="btn btn-default">comprar</a></div>
          <div class="checkbox btn-comparar">
            <label>
              <input type="checkbox" class="checkbox-compare" v-model="isSelected" v-on:change="emitCompare" v-bind:disabled="compare.length==4 && !isSelected">comparar
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
