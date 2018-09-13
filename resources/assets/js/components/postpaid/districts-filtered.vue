<template lang="html">
  <div id="districts-select">
    <select id="district" name="district" v-model="district" v-validate="'required'" :class="{'input': true, 'is-danger': errors.has('district')}">
      <option value="" selected>Seleccione Distrito</option>
      <option v-for="district in districts" :value="district.district_id">{{district.district_name}}</option>
   </select>   
  </div>  
</template>

<script>
  export default {
    props: {
      districts: Array,
      districtsChanged: {
        type: Number,
        default: 0
      }
    },
    methods: {

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
      districts: function () {
        /*
        console.log(this.affiliations[0].affiliation_name);
        console.log('affiliations-filtered component: affiliations prop updated');
        */
        this.districtsChanged = 1;
      }
    }
  }
</script>