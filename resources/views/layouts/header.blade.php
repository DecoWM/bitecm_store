      <header>
        <div id="site-header">
          <div class="container">
            <div class="select-persona navbar-left">
              <ul class="nav navbar-nav">
                <li><a href="http://bitel.com.pe/">Personas</a></li>
                <li><a href="http://empresas.bitel.com.pe/">Empresas</a></li>
              </ul>
            </div>
            <div class="info-bitel navbar-right">
              <ul class="list-unstyled">
                <li class="telephone"><span>LLámanos al <strong> 0 700 00 555</strong></span></li>
                <li class="cart"><strong>Mi Bitel</strong><a href="{{route('show_cart')}}"><span class="icon-cart"></span><span class="icon-count">{{count(session('cart'))}}</span></a></li>
                <li class="search">
                  <form id="search" action="{{route('postpaid')}}" method="get">
                    <input type="text" class="form-control" name="buscar">
                    <button type="submit" class="btn btn-default btn-search"> <span class="fa fa-search"></span></button>
                  </form>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </header>
