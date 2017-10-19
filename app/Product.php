<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    protected $table = 'tbl_product';

    protected $primaryKey = 'product_id';

    protected $visible = [
        'product_id',
        'product_name',
        'product_brand',
        'product_price'
    ];
}
