<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class ProductPicture extends Model
{
    protected $table = 'tbl_product_picture';

    protected $primaryKey = 'product_picture_id';

    protected $visible = [
        'product_picture_id',
        'product_id',
        'product_picture_url',
    ];
}
