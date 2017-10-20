<!DOCTYPE html>
<html lang="{{ app()->getLocale() }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <title>Bitel</title>
        <link type="text/css" rel="stylesheet" href="https://fonts.googleapis.com/css?family=Montserrat:100,300,400,500,600,700">
        <link type="text/css" rel="stylesheet" href="{{asset('css/main.min.css')}}">
    </head>
    <body>
        @include('layouts.header')
        @include('layouts.nav')
        @yield('content')
        @include('layouts.footer')
        <script type="text/javascript" src="{{asset('js/main.min.js')}}"></script>
    </body>
</html>
