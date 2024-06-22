<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PatientDetails extends Model
{
    use HasFactory;
    protected $table = 'patient_details';
    protected $fillable =[
        'patient_id',
        'bio_data',
        'fav',
        'status',
    ];

    public function user(){
        return $this->belongsTo(User::class);
    }
}
