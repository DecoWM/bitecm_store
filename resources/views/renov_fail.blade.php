@extends('layouts.master')
@section('content')
      <script>
        //fbq('track', 'CompleteRegistration');
        console.log('renovación no aplicable');
      </script>
      <div class="container">
        <div class="row">
          <div class="col-xs-12 col-sm-10 col-sm-offset-1">
            <div id="title-page">
              <h2>RENOVACIÓN NO APLICABLE</h2>
            </div>
            <div id="section-pedido">
              <div class="row">
                <div class="title-section-pedido text-center">
                  <h3>RENOVACIÓN NO APLICABLE</h3>
                  <h4>Tu pedido no pudo ser completado</h4>
                </div>
                <div class="rastreo-de-compra">
                  <div class="text-center">
                    <p>No puede continuar con el proceso de compra por renovación si su línea pertenece a otro operador. Elimine el equipo del carrito y seleccione otro tipo de afiliación.</p>
                  </div>
                </div>
                <div class="btn-detalle">
                  <div class="col-xs-12 col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3">
                    <a href="{{route('retry_create_order')}}" class="btn btn-default regresar">REGRESAR<span><br></span>AL FORMULARIO</a>
                    @if($postpago)
                    <a href="{{route('change_affil_to', ['affiliation_id' => 1])}}" class="redirect-href btn btn-default comprar">CAMBIAR A<span><br></span>PORTABILIDAD</a>
                    <a href="{{route('change_affil_to', ['affiliation_id' => 2])}}" class="redirect-href btn btn-default comprar">CAMBIAR A<span><br></span>LINEA NUEVA</a>
                    @endif
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
@endsection
