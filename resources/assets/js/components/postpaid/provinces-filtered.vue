<template lang="html">
  <div id="provinces-select">
    <select id="province" name="province" v-model="province" v-validate="'required'" :class="{'input': true, 'is-danger': errors.has('province')}" @change="selectProvince($event)">
      <option value="" selected>Seleccione Provincia</option> 
      <option v-for="province in provinces" :value="province.province_id">{{province.province_name}}</option>
   </select>   
  </div>  
</template>

<script>
  export default {
    props: {
      provinces: Array,
      provincesChanged: {
        type: Number,
        default: 0
      }
    },
    methods: {
      selectProvince: function (event) {
        this.$parent.selectProvince(event);
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
      provinces: function () {
        /*
        console.log(this.affiliations[0].affiliation_name);
        console.log('affiliations-filtered component: affiliations prop updated');
        */
        this.provincesChanged = 1;
      }
    }
  }
</script>