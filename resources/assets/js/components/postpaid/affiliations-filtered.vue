<template lang="html">
  <div id="affiliations-select" class="affiliations-select">
    <select id="affsel" form="purchase-form" name="affiliation" @change="setAffiliation($event)">
      <option v-for="(affiliation, ix) in affiliations" :id="'aff'+affiliation.affiliation_id" :data-ix="ix" :value="affiliation.affiliation_id">{{affiliation.affiliation_name}}</option>
    </select>   
  </div>  
</template>

<script>
  export default {
    props: {
      affiliations: Array,
      product: Object,
      affiliationsChanged: {
        type: Number,
        default: 0
      }
    },
    methods: {
      isActive: function (plan_id) {
        return plan_id == this.product.product.plan_id;
      },
      isActiveUrl: function (url) {
        return this.$parent.isActiveUrl(url);
      },
      setAffiliation: function (event) {
        this.$parent.setAffiliation(event);
      }
    },
    mounted() {
      if (this.affiliations.length > 0) {
        /*
        console.log(this.affiliations[0].affiliation_name);
        console.log('affiliations-filtered component: affiliations prop updated');
        */
      }
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
      affiliations: function () {
        /*
        console.log(this.affiliations[0].affiliation_name);
        console.log('affiliations-filtered component: affiliations prop updated');
        */
        this.affiliationsChanged = 1;
      }
    }
  }
</script>