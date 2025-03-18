<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Redirect;
use Illuminate\View\View;
use Illuminate\Support\Facades\DB;

class Compte extends Controller
{
    public function list_compte(Request $request)
    {
        $comptes = DB::table('compte')->get();
        return response()->json($comptes);
    }

    public function create_compte(Request $request)
    {
        $request->validate([
            'num_compte' => 'required|string|unique:compte',
        ]);

        
        DB::table('compte')->insert([
            
            'num_compte' => $request->num_compte,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return response()->json(['message' => 'Compte créé avec succès'], 201);
    }

    public function edit_compte($id, Request $request)
    {
        $request->validate([
            'num_compte' => 'required|string|unique:compte,num_compte,' . $id,
        ]);

        $updated = DB::table('compte')
            ->where('id', $id)
            ->update([
                'num_compte' => $request->num_compte,
                'updated_at' => now(),
            ]);

        if ($updated) {
            return response()->json(['message' => 'Compte mis à jour avec succès']);
        } else {
            return response()->json(['message' => 'Compte non trouvé'], 404);
        }
    }

    public function delete_compte($id, Request $request)
    {
        $deleted = DB::table('compte')->where('id', $id)->delete();

        if ($deleted) {
            return response()->json(['message' => 'Compte supprimé avec succès']);
        } else {
            return response()->json(['message' => 'Compte non trouvé'], 404);
        }
    }
}