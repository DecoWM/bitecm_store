<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Customer;

class CustomerController extends Controller
{
    public function storeCustomer(Request $request) {
        $customer = new Customer();
        $customer->customer_name = $request->name;
        $customer->customer_last_name = $request->last_name;
        $customer->customer_contact_email = $request->contact_email;
        $customer->customer_address = $request-> $request->address;
        $customer->save();
    }
}
