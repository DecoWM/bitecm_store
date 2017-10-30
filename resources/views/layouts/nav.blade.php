      <nav id="nav-bitel" class="navbar navbar-default">
        <div class="container">
          <div class="navbar-header">
            <button type="button" data-toggle="collapse" data-target="#navbar" aria-expanded="true" aria-controls="navbar" class="navbar-toggle">
              <span class="sr-only">Toggle navigation</span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
            </button>
            <a href="{{route('home')}}" class="navbar-brand">
              <h1>TIENDA BITEL</h1>
            </a>
          </div>
          <div id="navbar" class="collapse navbar-collapse">
            <ul class="nav navbar-nav navbar-right">
              <li class="{{Request::is('postpago') ? 'active' : ''}}"><a href="{{Route('postpaid')}}">Postpago</a></li>
              <li class="{{Request::is('prepago') ? 'active' : ''}}"><a href="{{Route('prepaid')}}">Prepago</a></li>
              <li class="{{Request::is('accesorios') ? 'active' : ''}}"><a href="{{Route('accessories')}}">Accesorios</a></li>
            </ul>
          </div>
        </div>
      </nav>
