<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class ProductCategory extends Model
{
    protected $table = 'tbl_product_category';

    protected $primaryKey = 'product_category_id';

    protected $visible = [
        'product_category_id',
        'product_category_name',
        'product_category_description',
    ];
}
