<template lang="html">
  <div id="list-equipos-comparar">
    <div class="equipos-comp" :class="{'is-mobile': products.length==1}">
      <div class="title-equipos" v-if="products.length==1"><span>Añade otro equipo</span>
        <p>para comparar</p>
      </div>
      <div class="title-equipos" v-else><span>{{products.length}} Equipos</span>
        <p>para comparar</p>
      </div>
      <div class="list-equipos">
        <ul class="list-unstyled">
          <compare-item v-for="(product, index) in products" :product="product" v-on:removeItem="removeItem" :key="index"></compare-item>
        </ul>
      </div>
    </div>
    <div v-if="products.length!=1" class="btn-comparar" @click.prevent="compareList"><a v-bind:href="baseUrl + '/product/compare'">COMPARAR</a></div>
  </div>
</template>

<script>
    Vue.component('compare-item', require('./compare-item.vue'));

    export default {
        props: [
            'products',
            'baseUrl'
        ],
        mounted() {
            console.log('Component mounted bitel.')
        },
        methods : {
            removeItem (product) {
                this.$emit('removeitem', product)
            },
            compareList () {
                self = this
                let subSet = []
                new Promise((resolve, reject) => {
                    self.products.forEach( e => {
                        subSet.push({name: "product_id[]", value: e.product_id})
                    })
                    resolve()
                }).then( () => {
                    let url = $.param(subSet)
                    window.location.href = self.baseUrl + '/prepago/comparar?' + url
                })
            }
        }
    }
</script>

<style lang="css">
  #list-equipos-comparar {
    width: 110px;
  }
  .is-mobile {
    width: 100% !important;
    margin-bottom: 10px !important;
  }
</style>
