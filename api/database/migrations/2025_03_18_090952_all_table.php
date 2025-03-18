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
        Schema::create('compte', function (Blueprint $table) {
            $table->id(); // Cela crée un champ 'id' auto-incrémenté et clé primaire
            $table->string('num_compte')->unique();            
            $table->timestamps(); // Cela crée les colonnes 'created_at' et 'updated_at'
        });

        Schema::create('depot', function (Blueprint $table) {
            $table->id(); // Cela crée un champ 'id' auto-incrémenté et clé primaire
            $table->string('num_compte');
            $table->decimal('montant', 10, 2);           
            $table->timestamps(); // Cela crée les colonnes 'created_at' et 'updated_at'
        });

        Schema::create('retrait', function (Blueprint $table) {
            $table->id(); // Cela crée un champ 'id' auto-incrémenté et clé primaire
            $table->string('num_compte'); 
            $table->decimal('montant', 10, 2);          
            $table->timestamps(); // Cela crée les colonnes 'created_at' et 'updated_at'
        });
    }
    

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        //
        Schema::dropIfExists('compte');
    }
};
