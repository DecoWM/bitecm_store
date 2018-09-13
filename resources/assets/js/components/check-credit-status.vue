<template lang="html">
  <div class="popup">
    <div class="popup-layout" v-on:click="close"></div>
    <div class="popup-main">
      <div class="popup-header">
        <h4>Evaluación Crediticia</h4>
        <div class="close" v-on:click="close">x</div>
      </div>
      <div class="popup-content">
        <div class="input">
          <label>DNI</label>
          <input type="text" name="dni" v-model="dni">
        </div>
      </div>
      <div class="popup-footer">
        <a class="btn btn-primary btn-action" v-on:click="checkCreditStatus" :disabled="showContinue && !showBack">Evaluar</a>
        <button class="btn btn-primary" v-if="showContinue" v-on:click="goToCheckout">Continuar</button>
        <button class="btn btn-danger" v-if="showBack" v-on:click="goToCatalog">Regresar</button>
        <button class="btn btn-close" v-on:click="close">Cerrar</button>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    props: [
      'stock_model_code',
      'product_code'
    ],
    data () {
      return {
        dni: '',
        showContinue: false,
        showBack: false
      }
    },
    mounted() {
    },
    methods: {
      checkCreditStatus: function () {
        self = this; 
        const params = '?' + $.param({
          stock_model_code: this.stock_model_code,
          product_code: this.product_code,
          dni: this.dni
        });
        const url = self.$parent.baseUrl + '/api' + self.$parent.prefix + 'check_credit_status' + params;
        axios.get(url).then((response) => {
          var result = response.data;
          if (result.success) {
            if (result.aprobado) {
              this.showContinue = true;
              this.showBack = false;
              $(self.$parent.$refs.initiateCheckout).removeAttr('disabled');
              $(self.$parent.$refs.showCreditStatusPopup).attr('disabled', 'disabled');
              $(self.$parent.$refs.creditStatusResult).show();
            } else {
              this.showContinue = false;
              this.showBack = true;
            }
          }
        });
      },
      show: function() {
        $('.popup').fadeIn(400);
      },
      close: function() {
        $('.popup').fadeOut(400);
      },
      goToCheckout: function() {
        window.location.href = self.$parent.baseUrl + '/envio';
      },
      goToCatalog: function() {
        window.location.href = self.$parent.baseUrl + '/postpago';
      }
    }
  }
</script>

<style lang="scss">
.popup {
  display: none;
  position: fixed;
  z-index: 99999;
  .popup-layout {
    position: fixed;
    width: 100%;
    height: 100%;
    top: 0;
    left: 0;
    background-color: rgba(0,0,0,0.5);
    z-index: 1;
  }
  .popup-main {
    position: fixed;
    width: 40%;
    top: 15%;
    left: 30%;
    background-color: white;
    border-radius: 5px;
    padding: 10px 20px;
    z-index: 2;
    .popup-header {
      padding: 0 20px 5px;
      margin: 0 -20px;
      border-bottom: 1px solid #eee;
      h4 {
        display: inline-block;
      }
      .close {
        float: right;
        margin-top: 10px;
        margin-bottom: 10px;
      }
    }
    .popup-content {
      padding: 15px 0;
      text-align: center;
      label {
        margin-right: 5px;
      }
    }
    .popup-footer {
      padding: 10px 20px 10px;
      margin: 0 -20px -10px;
      border-top: 1px solid #eee;
      text-align: right;
      .btn {
        margin-left: 5px;
      }
      .btn-action {
        background-color: #008c95;
        border-color: #008c95;
      }
      .btn-close {
        border-color: #ddd;
      }
    }
  }
}
</style>
