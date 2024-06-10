<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Reviews;
use App\Models\Appointments;
use Illuminate\Http\Request;
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
        $reviews = Reviews::where('doc_id',$doctor->id)->where('status', 'active')->get();

        return view('dashboard')->with(['doctor'=>$doctor,'appointment'=>$appointment, 'reviews'=>$reviews]);
    }

    /**
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }
    
    /**
     * Store a newly created resource in storage.
     * @param \Illuminate\Http\Response $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request){
        //this controller is us ed to store booking details post froom mobile app
        $reviews = new Reviews();
        //this is to update the appointment status from "upcoming" to "completed"
        $appointment = Appointments::where('id',$request->get('appointment_id')->first());

        //save the ratings and reviews from user
        $reviews->user_id = Auth::user()->id;
        $reviews->doc_id = $request->get('doctor_id');
        $reviews->ratings = $request->get('ratings');
        $reviews->reviews = $request->get('reviews');
        $reviews->reviewed_by = Auth::user()->name;
        $reviews->status = 'active';
        $reviews->save();

        //change appointment status
        $appointment->status = 'complete';
        $appointment->save();

        return response()->json([
            'success'=>'The appointment has been complete'
        ], 200);
    
    }

    /**
     * @param int $id
     * @return \Illuminate\Http\Response
     */
    public function show($id){
        //
    }

    /**
     * @param int $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id){
        //
    }
    
    /**
     * Update the specified resource in storage.
     * @param \Illuminate\Http\Response $request
     * @param int $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id){
        //
    }


}

