@if(isset($product->color_id))
  <div class="color-product">
  <fieldset>
    <legend>Color</legend>
    <div id="option-select" class="option-select">
      @foreach($stock_models as $stock_model)
        @if($stock_model->stock_model_id == $product->stock_model_id)
        <div class="radio-inline option-active" style="border: 1px solid #008c95;">
          <div class="color-box" style="background-color: #{{$stock_model->color_hexcode}};"></div>
        </div>
        @else
        <a href="{{$stock_model->route}}">
          <div class="radio-inline option-active" style="border: none;">
            <div class="color-box" style="background-color: #{{$stock_model->color_hexcode}};"></div>
          </div>
        </a>
        @endif
      @endforeach
    </div>
  </fieldset>
</div>
@endif
