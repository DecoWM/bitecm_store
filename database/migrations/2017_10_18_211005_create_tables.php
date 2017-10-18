<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateTables extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::connection('mysql')->create('tbl_customer', function (Blueprint $table) {
            $table->increments('customer_id');
            $table->string('customer_name');
            $table->string('customer_last_name')->nullable();
            $table->string('customer_contact_email');
            // $table->string('customer_contact_email')->unique();
            $table->string('customer_address');
            $table->timestamps();
            $table->softDeletes();
        });

        Schema::connection('mysql')->create('tbl_product', function (Blueprint $table) {
            $table->increments('product_id');
            $table->string('product_name');
            $table->double('product_price');
            $table->string('product_brand');
            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::connection('mysql')->dropIfExists('tbl_product');
        Schema::connection('mysql')->dropIfExists('tbl_customer');
    }
}
