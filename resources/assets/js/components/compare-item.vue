<template lang="html">
  <li>
    <img v-bind:src="product.picture_url" alt="equipos">
    <button class="btn-eliminar" v-on:click="removeItem"><span class="fa fa-times"></span></button>
  </li>
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
        },
        methods: {
            removeItem : function () {
                this.$emit('removeItem', this.product.product_id)
            }
        }
    }
</script>

<style lang="css">
</style>
