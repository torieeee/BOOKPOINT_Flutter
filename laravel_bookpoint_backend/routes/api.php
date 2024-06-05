<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::middleware('auth:sanctum')->group(function(){
    Route::get('/user',[UsersController::class, 'index']);
});
Route::post('/login',[UserController::class,'login']);
Route::post('/register',[UserController::class,'register']);

