<template lang="html">
  <div id="list-equipos-comparar" >
    <div class="equipos-comp">
      <div class="title-equipos"><span>{{products.length}} <span v-if="products.length==1">Equipo</span><span v-else>Equipos</span></span>
        <p>para comparar</p>
      </div>
      <div class="list-equipos">
        <ul class="list-unstyled">
          <compare-item v-for="(product, index) in products" :product="product" v-on:removeItem="removeItem" :key="index"></compare-item>
          <!-- <li><img src="./images/home/celular.jpg" alt="equipos">
            <button class="btn-eliminar"><span class="fa fa-times"></span></button>
          </li>
          <li><img src="./images/home/celular.jpg" alt="equipos">
            <button class="btn-eliminar"><span class="fa fa-times"></span></button>
          </li>
          <li><img src="./images/home/celular.jpg" alt="equipos">
            <button class="btn-eliminar"><span class="fa fa-times"></span></button>
          </li>
          <li><img src="./images/home/celular.jpg" alt="equipos">
            <button class="last-btn"><span class="fa fa-times"></span></button>
          </li> -->
        </ul>
      </div>
    </div>
    <div class="btn-comparar" @click.prevent="compareList"><a v-bind:href="baseUrl + '/product/compare'">COMPARAR</a></div>
  </div>
</template>

<script>
    // import compareItem from './compare-item.vue';
    Vue.component('compare-item', require('./compare-item.vue'));

    export default {
        props: [
            'products',
            'baseUrl'
        ],
        // components: {
        //     'compareItem': compareItem
        // },
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
                    window.location.href = self.baseUrl + '/postpago/comparar?' + url
                })
            }
        }
    }
</script>

<style lang="css">
</style>
