<div class="row">
  <div class="col-xs-12">
    <div class="top-banner">
      <a href="{{$banner->image_link}}">
      	<picture>
          <source media="(max-width:480px)" srcset="{{asset(Storage::url($banner->imagem_url))}}">
          <img src="{{asset(Storage::url($banner->image_url))}}" alt="banner">
        </picture>  
      </a>
    </div>
  </div>
</div>
