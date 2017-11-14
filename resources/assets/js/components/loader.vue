<template lang="pug">
  .col-xs-12
    .box
      .wrapper
        .loader
        span Buscando...
</template>

<script>
    export default {
        mounted() {
            console.log('Component mounted bitel.')
        }
    }
</script>

<style lang="stylus" scoped>
.box
  margin 50px auto
  display flex
  align-items center
  justify-content center
.wrapper
  position fixed
.loader
  border 7px solid #008c95
  border-radius 50%
  border-top 7px solid #ffe60d
  margin auto
  width 40px
  height 40px
  -webkit-animation spin 2s linear infinite
  animation spin 1s linear infinite

@-webkit-keyframes spin
  0%
    -webkit-transform rotate(0deg)
  100%
    -webkit-transform rotate(360deg)

@keyframes spin
  0%
    transform rotate(0deg)
  100%
    transform rotate(360deg)
</style>
