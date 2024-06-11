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

//this is the endpoint with prefix /api
Route::post('/login',[UsersController::class,'login']);
Route::post('/register',[UsersController::class,'register']);

//modify this
//this group mean return user's data if authenticated successfully
Route::middleware('auth:sanctum')->group(function(){
    Route::get('/user',[UsersController::class, 'index']);
    Route::post('/fav',[UsersController::class, 'storeFavDoc']);
    Route::post('/logout',[UsersController::class, 'logout']);
    Route::post('/book',[AppointmentsController::class,'store']);
    Route::post('/reviews',[DocsController::class,'store']);
    Route::get('/appointments',[AppointmentsController::class,'index']); //retrive appointments
});


