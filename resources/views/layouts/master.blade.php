<!DOCTYPE html>
<html lang="{{ app()->getLocale() }}">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>Bitel</title>
    <link type="text/css" rel="stylesheet" href="https://fonts.googleapis.com/css?family=Montserrat:100,300,400,500,600,700">
    <link type="text/css" rel="stylesheet" href="https://daneden.github.io/animate.css/animate.min.css">
    <link type="text/css" rel="stylesheet" href="{{asset('css/main.min.css')}}">
  </head>
  <body>
    <div id="app">
      @include('layouts.header')
      @include('layouts.nav')
@yield('content')
      @include('layouts.footer')
    </div>
    {{-- <script type="text/javascript" src="{{asset('js/main.min.js')}}"></script> --}}
    <script type="text/javascript" src="{{asset('js/app.js')}}"></script>
  </body>
</html>
