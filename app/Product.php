<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    protected $table = 'tbl_product';

    protected $primaryKey = 'product_id';

    protected $visible = [
        'product_id',
        'product_category',
        'product_manufacturer',
        'product_name',
        'product_price_prepaid',
        'product_description',
        'product_general_specifications',
        'product_colors',
        'product_data_sheet',
        'product_ram_memory',
        'product_internal_memory',
        'product_screen_size',
        'product_camera_1',
        'product_camera_2',
        'product_camera_3',
        'product_camera_4',
        'product_processor_name',
        'product_processor_value',
        'product_processor_cores',
        'product_band',
    ];
}
