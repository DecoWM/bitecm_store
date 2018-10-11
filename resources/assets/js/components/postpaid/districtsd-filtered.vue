<template lang="html">
  <div id="delivery_districts-select">
    <select id="delivery_district" name="delivery_district" v-model="delivery_district" v-validate data-vv-rules="required" :class="{'input': true, 'is-danger': errors.has('delivery_district')}" @change="selectDistrictd($event)">
      <option value="" selected>Seleccione Distrito</option>
      <option value="0">Regresar...</option>
      <option v-for="districtd in delivery_districts" :value="districtd.district_id">{{districtd.district_name}}</option>
   </select>   
  </div>  
</template>

<script>
  export default {
    props: {
      delivery_districts: Array,
      delivery_districtsChanged: {
        type: Number,
        default: 0
      }
    },
    methods: {
      selectDistrictd: function (event) {
        this.$parent.selectDistrictd(event);
      }
    },
    mounted() {
      /*
      if (this.districts.length > 0) {
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
      delivery_districts: function () {
        /*
        console.log(this.affiliations[0].affiliation_name);
        console.log('affiliations-filtered component: affiliations prop updated');
        */
        this.delivery_districtsChanged = 1;
      }
    }
  }
</script>