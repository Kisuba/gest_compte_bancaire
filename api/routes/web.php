<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Compte;
use App\Http\Controllers\TransactionController;

//route pour les compte
Route::get('list_comptes', [Compte::class,'list_compte']);
Route::post('create_compte', [Compte::class,'create_compte']);
Route::put('depense/{id}', [Compte::class,'edit_compte']);
Route::delete('depense/{id}', [Compte::class,'delete_compte']); 

//route pour les depots et retraits
Route::get('/depot', [TransactionController::class, 'listDepot']);
Route::post('/depot', [TransactionController::class, 'createDepot']);
Route::put('/depot/{id}', [TransactionController::class, 'editDepot']);
Route::delete('/depot/{id}', [TransactionController::class, 'deleteDepot']);

Route::get('/retrait', [TransactionController::class, 'listRetrait']);
Route::post('/retrait', [TransactionController::class, 'createRetrait']);
Route::put('/retrait/{id}', [TransactionController::class, 'editRetrait']);
Route::delete('/retrait/{id}', [TransactionController::class, 'deleteRetrait']);

/*
Route::get('/', function () {
    return view('welcome');
});*/
