<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Auth;

class DocsController extends Controller
{
    /**
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //get doctors appointment, patients and display on dashboard
        $doctor =Auth::user();
        $appointment = Appointments::where('doc_id',$doctor->id)->where('status', 'upcoming')->get();

        return view('dashboard')->with(['doctor'=>$doctor,'appointment'=>$appointment]);
    }

    /**
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }
}

