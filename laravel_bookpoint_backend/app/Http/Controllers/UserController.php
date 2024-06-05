<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facade\Hash;

class UserController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
    }

    public function login()
    {
        //validate incoming inputs
        $request->validate([
            'email'=>'required|email',
            'password'=>'required',
        ]);

        //check matching user
        $user= User::where('email',$request->email)->first();

        //check password
        if(!user || !Hash::check($request->password,$user->password)){
            throw ValidationException::withMessage([
                'email'=>['The provided credentials are incorrect'],
            ]);
        }

        //return generated token
        return $user->createToken($request->email)->plainTextToken;
        //
    }

    public function registerUser(Request $request)
    {
        //validate incoming inputs
        $request->validate([
            'name'=>'required|String',
            'email'=>'required|email',
            'password'=>'required',
        ]);

        $user=User::create([
            'name'=>$request->name,
            'email'=>$request->email,
            'type'=>'patient',
            'password'=>Hash::make($request->password),
        
        ]);

        $patientInfo=PatientDetails::create([
            'patient_id'=>$user->id,
            'status'=>'active',
        ]);
        return $user;

        
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
