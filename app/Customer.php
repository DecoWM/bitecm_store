<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Customer extends Model
{
    protected $table = 'tbl_customer';

    protected $primaryKey = 'customer_id';

    protected $visible = [
        'customer_id',
        'customer_name',
        'customer_last_name',
        'customer_contact_email',
        'customer_address'
    ];
}
