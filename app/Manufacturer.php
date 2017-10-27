<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Manufacturer extends Model
{
    protected $table = 'tbl_manufacturer';

    protected $primaryKey = 'manufacturer_id';

    protected $visible = [
        'manufacturer_id',
        'manufacturer_name',
        'manufacturer_description',
    ];
}
