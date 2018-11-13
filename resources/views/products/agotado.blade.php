@if(!isset($product->stock_model_id))
<a href="{{route('postpaid_detail', [
                      'brand'=>$smartphone->brand_slug,
                      'product'=>$smartphone->product_slug,
                      'affiliation'=>$smartphone->affiliation_slug,
                      'plan'=>$smartphone->plan_slug,
                      'contract'=>$smartphone->contract_slug
                    ])}}" class="btn btn-default disabled" style="background-color: #E0E0E0">solicitalo</a>
@elseif(isset($product->promo_id))
<a href="{{route('postpaid_detail', [
                      'brand'=>$smartphone->brand_slug,
                      'product'=>$smartphone->product_slug,
                      'affiliation'=>$smartphone->affiliation_slug,
                      'plan'=>$smartphone->plan_slug,
                      'contract'=>$smartphone->contract_slug
                    ])}}" class="btn btn-default">solicitalo</a>
@elseif($product->product_tag == 'Destacado')
<a href="{{route('postpaid_detail', [
                      'brand'=>$smartphone->brand_slug,
                      'product'=>$smartphone->product_slug,
                      'affiliation'=>$smartphone->affiliation_slug,
                      'plan'=>$smartphone->plan_slug,
                      'contract'=>$smartphone->contract_slug
                    ])}}" class="btn btn-default">solicitalo</a>
@elseif($product->product_tag == 'Nuevo')
<a href="{{route('postpaid_detail', [
                      'brand'=>$smartphone->brand_slug,
                      'product'=>$smartphone->product_slug,
                      'affiliation'=>$smartphone->affiliation_slug,
                      'plan'=>$smartphone->plan_slug,
                      'contract'=>$smartphone->contract_slug
                    ])}}" class="btn btn-default">solicitalo</a>
@elseif($product->product_sentinel)
<a href="{{route('postpaid_detail', [
                      'brand'=>$smartphone->brand_slug,
                      'product'=>$smartphone->product_slug,
                      'affiliation'=>$smartphone->affiliation_slug,
                      'plan'=>$smartphone->plan_slug,
                      'contract'=>$smartphone->contract_slug
                    ])}}" class="btn btn-default">solicitalo</a>
@else
<a href="{{route('postpaid_detail', [
                      'brand'=>$smartphone->brand_slug,
                      'product'=>$smartphone->product_slug,
                      'affiliation'=>$smartphone->affiliation_slug,
                      'plan'=>$smartphone->plan_slug,
                      'contract'=>$smartphone->contract_slug
                    ])}}" class="btn btn-default">solicitalo</a>                    
@endif