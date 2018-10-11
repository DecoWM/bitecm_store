<template lang="html">
  <div id="delivery_provinces-select">
    <select id="delivery_province" name="delivery_province" v-model="delivery_province" v-validate="'required'" :class="{'input': true, 'is-danger': errors.has('delivery_province')}" @change="selectProvinced($event)">
      <option value="" selected>Seleccione Provincia</option> 
      <option value="0">Regresar...</option>
      <option v-for="province in delivery_provinces" :value="province.province_id">{{province.province_name}}</option>
   </select>   
  </div>  
</template>

<script>
  export default {
    props: {
      delivery_provinces: Array,
      delivery_provincesChanged: {
        type: Number,
        default: 0
      }
    },
    methods: {
      selectProvinced: function (event) {
        this.$parent.selectProvinced(event);
      }
    },
    mounted() {
      /*
      if (this.setProvinces.length > 0) {
        console.log(this.affiliations[0].affiliation_name);
        console.log('affiliations-filtered component: affiliations prop updated');
      }*/
    },
    beforeUpdate() {
      /*if (this.affiliationsChanged) {
        console.log('affiliations-filtered component: before update');
      }*/
    },
    updated() {
      /*if (this.affiliationsChanged && this.affiliations.length > 0) {
        console.log('affiliations-filtered component: updated');
        this.affiliationsChanged = 0;
      }*/
    },
    watch: {
      delivery_provinces: function () {
        /*
        console.log(this.affiliations[0].affiliation_name);
        console.log('affiliations-filtered component: affiliations prop updated');
        */
        this.delivery_provincesChanged = 1;
      }
    }
  }
</script>