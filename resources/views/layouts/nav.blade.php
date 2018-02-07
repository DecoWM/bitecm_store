      <nav id="nav-bitel" class="navbar navbar-default">
        <div class="container">
          <div class="navbar-header">
            <button type="button" data-toggle="collapse" data-target="#navbar" aria-expanded="true" aria-controls="navbar" class="navbar-toggle">
              <span class="sr-only">Toggle navigation</span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
            </button>
            <a href="{{route('show_cart')}}" class="cart-link visible-xs-inline-block"><span class="cart-icon"></span><span class="count-icon">{{count(session('cart'))}}</span></a>
            <a href="{{route('home')}}" class="navbar-brand">
              <h1>TIENDA BITEL</h1>
            </a>
          </div>
          <div id="navbar" class="collapse navbar-collapse">
            <ul class="nav navbar-nav navbar-right">
              <li class="{{Request::is('postpago*') ? 'active' : ''}}"><a href="{{Route('postpaid')}}">Postpago</a></li>
              <li class="{{Request::is('prepago*') ? 'active' : ''}}"><a href="{{Route('prepaid')}}">Prepago</a></li>
              {{--<li class="{{Request::is('accesorios*') ? 'active' : ''}}"><a href="{{Route('accessories')}}">Accesorios</a></li>--}}
              <li class="{{Request::is('promociones*') ? 'active' : ''}}"><a href="{{Route('promociones')}}">Promociones</a></li>
              <li class="nav-mobile item-nav-mobile first-item-nav"><a href="http://bitel.com.pe/">Personas</a></li>
              <li class="nav-mobile item-nav-mobile"><a href="http://empresas.bitel.com.pe/">Empresas</a></li>
              <li class="nav-mobile item-nav-mobile"><a href="">Mi Bitel</a></li>
              <li class="nav-mobile item-nav-mobile search">
                <form id="search">
                  <input type="text" class="form-control">
                  <button type="submit" class="btn btn-default btn-search"><span class="fa fa-search"></span></button>
                </form>
              </li>
            </ul>
          </div>
        </div>
      </nav>
