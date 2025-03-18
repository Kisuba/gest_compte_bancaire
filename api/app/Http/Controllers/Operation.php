<?php

namespace App\Http\Controllers;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class TransactionController extends Controller
{
    // Liste des dépôts
    public function listDepot(Request $request)
    {
        $deposits = DB::table('depot')->get();
        return response()->json($deposits);
    }

    // Créer un dépôt
    public function createDepot(Request $request)
    {
        $request->validate([
            'num_compte' => 'required|string',
            'montant' => 'required|numeric|min:0',
        ]);

        DB::table('depot')->insert([
            'num_compte' => $request->num_compte,
            'montant' => $request->montant,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return response()->json(['message' => 'Dépôt créé avec succès'], 201);
    }

    // Liste des retraits
    public function listRetrait(Request $request)
    {
        $retraits = DB::table('retrait')->get();
        return response()->json($retraits);
    }

    // Créer un retrait
    public function createRetrait(Request $request)
    {
        $request->validate([
            'num_compte' => 'required|string',
            'montant' => 'required|numeric|min:0',
        ]);

        DB::table('retrait')->insert([
            'num_compte' => $request->num_compte,
            'montant' => $request->montant,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return response()->json(['message' => 'Retrait créé avec succès'], 201);
    }

    // Mettre à jour un dépôt
    public function editDepot($id, Request $request)
    {
        $request->validate([
            'num_compte' => 'required|string',
            'montant' => 'required|numeric|min:0',
        ]);

        $updated = DB::table('depot')
            ->where('id', $id)
            ->update([
                'num_compte' => $request->num_compte,
                'montant' => $request->montant,
                'updated_at' => now(),
            ]);

        if ($updated) {
            return response()->json(['message' => 'Dépôt mis à jour avec succès']);
        } else {
            return response()->json(['message' => 'Dépôt non trouvé'], 404);
        }
    }

    // Mettre à jour un retrait
    public function editRetrait($id, Request $request)
    {
        $request->validate([
            'num_compte' => 'required|string',
            'montant' => 'required|numeric|min:0',
        ]);

        $updated = DB::table('retrait')
            ->where('id', $id)
            ->update([
                'num_compte' => $request->num_compte,
                'montant' => $request->montant,
                'updated_at' => now(),
            ]);

        if ($updated) {
            return response()->json(['message' => 'Retrait mis à jour avec succès']);
        } else {
            return response()->json(['message' => 'Retrait non trouvé'], 404);
        }
    }

    // Supprimer un dépôt
    public function deleteDepot($id, Request $request)
    {
        $deleted = DB::table('depot')->where('id', $id)->delete();

        if ($deleted) {
            return response()->json(['message' => 'Dépôt supprimé avec succès']);
        } else {
            return response()->json(['message' => 'Dépôt non trouvé'], 404);
        }
    }

    // Supprimer un retrait
    public function deleteRetrait($id, Request $request)
    {
        $deleted = DB::table('retrait')->where('id', $id)->delete();

        if ($deleted) {
            return response()->json(['message' => 'Retrait supprimé avec succès']);
        } else {
            return response()->json(['message' => 'Retrait non trouvé'], 404);
        }
    }
}
