<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreProductPostRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        // return false;
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'name' => 'required|max:30|regex:/(^[A-Za-z0-9 ]+$)+/',
            'price' => 'required|numeric|between:0.00,9999.99|regex:/^\d*(\.\d{1,2})?$/',
            'brand' => 'required|max:30|regex:/(^[A-Za-z0-9 ]+$)+/',
        ];
    }

    /**
     * Get the error messages for the defined validation rules.
     *
     * @return array
     */
    public function messages()
    {
        return [
            'name.required' => 'El nombre es requerido.',
            'name.max' => 'El nombre no puede contener más de :max caracteres.',
            'name.regex' => 'El nombre solo puede contener números y letras.',
            'price.required'  => 'El precio es requerido.',
            'price.between'  => 'El precio debe ser mayor a :min y menor a :max.',
            'price.numeric'  => 'El precio debe ser un número.',
            'price.regex'  => 'El precio debe contener como máximo 2 dígitos en la parte decimal.',
            'brand.required'  => 'La marca es requerida.',
            'brand.regex' => 'La marca solo puede contener números y letras.',
            'brand.max' => 'La marca no puede contener más de :max caracteres.',
        ];
    }
}
