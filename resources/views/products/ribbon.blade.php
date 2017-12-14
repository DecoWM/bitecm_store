@if(!isset($product->stock_model_id))
<div class="ribbon-wrapper"><div class="ribbon ribbon-sold-out">Agotado</div></div>
@elseif(isset($product->promo_id))
<div class="ribbon-wrapper"><div class="ribbon ribbon-promo">Promoción</div></div>
@elseif(($product->product_tag == 'Destacado'))
<div class="ribbon-wrapper"><div class="ribbon ribbon-outstanding">Destacado</div></div>
@elseif(($product->product_tag == 'Nuevo'))
<div class="ribbon-wrapper"><div class="ribbon ribbon-new">Nuevo</div></div>
@endif