<html>
<head></head>
<body>
  <h1>PEDIDO COMPLETADO</h1>
  <h2>Detalle de la orden</h2>
  @foreach ($order['order_detail'] as $key => $value)
    <p>{{$key}} : {{$value}}</p>
  @endforeach
  <h2>Detalle de productos</h2>
  @foreach ($order['order_items'] as $item)
    @foreach ($item as $key => $value)
      <p>{{$key}} : {{$value}}</p>
    @endforeach
  @endforeach
  <p>URL: <a href="{{route('track_order', ['order_id' => $order['order_id']])}}">Seguimiento de pedido</a> </p>
  {{-- <p>{{$order['email']}}</p> --}}
  <p>Mensaje de prueba</p>
</body>
</html>
