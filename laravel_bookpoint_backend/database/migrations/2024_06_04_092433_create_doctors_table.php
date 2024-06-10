<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // Ensure the users table and id column exists and has the correct data type before running this migration

        // Create the doctors table
        Schema::create('doctors', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('doc_id')->unique();
            $table->string('category')->nullable();
            $table->unsignedInteger('patients')->nullable();
            $table->unsignedInteger('experience')->nullable();
            $table->longText('bio_data')->nullable();
            $table->string('status')->nullable();
            $table->timestamps();
        });

        // Add the foreign key constraint in a separate step
        Schema::table('doctors', function (Blueprint $table) {
            $table->foreign('doc_id')->references('id')->on('users')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Drop the foreign key constraint first
        Schema::table('doctors', function (Blueprint $table) {
            $table->dropForeign(['doc_id']);
        });

        // Drop the doctors table
        Schema::dropIfExists('doctors');
    }
};
