<!DOCTYPE html>
<html lang="{{ app()->getLocale() }}">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <meta name="base-url" content="{{ url('/') }}">
    <meta name="prefix" content="{{ Request::segment(1) ? '/'.Request::segment(1).'/' : '/' }}">
    <meta name="type" content="{{ Request::segment(1) ? Request::segment(1) : '' }}">
    <meta name="robots" content="noindex">
    <title>Bitel</title>

    <meta property="og:description" content='Bitel'>
    <meta property="og:type" content="website">
    <meta property="og:url" content="http://bitel.com.pe">
    <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
    <link rel="manifest" href="/manifest.json">
    <link rel="mask-icon" href="/safari-pinned-tab.svg" color="#5bbad5">
    <meta name="theme-color" content="#ffffff">

    <link type="text/css" rel="stylesheet" href="https://fonts.googleapis.com/css?family=Montserrat:100,300,400,500,600,700,800,900">
    {{-- <link type="text/css" rel="stylesheet" href="https://daneden.github.io/animate.css/animate.min.css"> --}}
    <link type="text/css" rel="stylesheet" href="{{asset('css/main.min.css')}}">
    <link type="text/css" rel="stylesheet" href="{{asset('css/app.css')}}">
    <!-- <link rel="stylesheet" type="text/css" href="{{asset('css/ie-explorer-9.css')}}"/> -->

    <!--[if lte IE 9]>
      <script src="//cdnjs.cloudflare.com/ajax/libs/html5shiv/3.7.3/html5shiv.min.js"></script>
      <link rel="stylesheet" type="text/css" href="{{asset('css/ie-explorer-9.css')}}" />

    <![endif]-->

    <!--[if lte IE 8]>

      <link rel="stylesheet" type="text/css" href="{{asset('css/ie-explorer-8.css')}}" />
      <script src="{{asset('js/css3-mediaqueries.min.js')}}"></script>
     <![endif]-->
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
