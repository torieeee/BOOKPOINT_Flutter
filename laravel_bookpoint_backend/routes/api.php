<?php

use App\Http\Controllers\AppointmentsController;
use App\Http\Controllers\DocsController;
use App\Http\Controllers\UsersController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::middleware('auth:sanctum')->group(function(){
    Route::get('/user',[UsersController::class, 'index']);
    Route::post('/book',[UsersController::class,'store']);
    Route::post('/appointments',[UsersController::class,'index']);
});
Route::post('/login',[UsersController::class,'login']);
Route::post('/register',[UserController::class,'register']);

