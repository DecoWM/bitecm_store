<!DOCTYPE html>
<html lang="{{ app()->getLocale() }}">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <meta name="base-url" content="{{ url('/') }}">
    <meta name="prefix" content="{{ Request::segment(1) ? '/'.Request::segment(1).'/' : '/' }}">
    <meta name="type" content="{{ Request::segment(1) ? Request::segment(1) : '' }}">
    <meta name="robots" content="noindex">
    <title>Bitel</title>
    <link type="text/css" rel="stylesheet" href="https://fonts.googleapis.com/css?family=Montserrat:100,300,400,500,600,700,800,900">
    {{-- <link type="text/css" rel="stylesheet" href="https://daneden.github.io/animate.css/animate.min.css"> --}}
    <link type="text/css" rel="stylesheet" href="{{asset('css/main.min.css')}}">
    <link type="text/css" rel="stylesheet" href="{{asset('css/app.css')}}">
  </head>
  <body>
@if (Request::segment(1) == 'envio')
  <div>
@else
  <div id="app">
@endif
      @include('layouts.header')
      @include('layouts.nav')
@yield('content')
      @include('layouts.footer')
    </div>
    {{-- <script type="text/javascript" src="{{asset('js/main.min.js')}}"></script> --}}
    <script type="text/javascript" src="{{asset('js/app.js')}}"></script>
  </body>
</html>
