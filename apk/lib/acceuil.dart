import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _comptes = [];
  List<Map<String, dynamic>> _filtrecomptes = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String? selectedRole = '';

 
  @override
  void initState(){
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/list_comptes'));

    if (response.statusCode == 200) {
      
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _comptes = List<Map<String, dynamic>>.from(data);
        _filtrecomptes = _comptes; 
        _isLoading = false; 
      });
    } else {
      
      setState(() {
        _isLoading = false;
      });
      throw Exception('Impossible de charger les donnnees');
    }
  }

    final TextEditingController _numcompteController = TextEditingController();
  Future<void> _addCompte() async {
  // Créer les données du compte (exemple)
  final Map<String, dynamic> compteData = {
    'num_compte': _numcompteController,    
  };

  
  final String url = 'http://localhost:8000/create_compte';

  try {
    
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json', 
      },
      body: jsonEncode(compteData), 
    );

   
    if (response.statusCode == 200) {
     
      print('Compte créé avec succès : ${response.body}');
    } else {
      
      print('Erreur lors de la création du compte : ${response.statusCode}');
    }
  } catch (e) {
    
    print('Exception : $e');
  }
}

  void _filterData(String query) {
    if (query.isEmpty) {
      setState(() {
        _filtrecomptes = _comptes;
      });
    } else {
      setState(() {
        _filtrecomptes = _comptes.where((item) => (item['num_compte'].toString())
            .toLowerCase()
            .contains(query.toLowerCase())).toList();
      });
    }
  }

  

  
  
  void showBottomSheet (int? id) async{
    if(id!=null){
      final existindData = _comptes.firstWhere((element)=>element['id']==id);
      _numcompteController.text=existindData['nom'];
      
    }

    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context, 
      builder: (_)=>Container(
        padding: EdgeInsets.only(
          top: 30,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom+50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _numcompteController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: "Numero de compte",
                errorText: _numcompteController.text.isEmpty ? 'Ce champ est obligatoire' : null,
              ),
            ),
            const SizedBox(height: 10,),
          
           
            const SizedBox(height: 10,),
           
            DropdownButtonFormField<String>(
            value: selectedRole, // Variable pour stocker le rôle sélectionné
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Choisir un rôle",
              
            ),
            onChanged: (String? newValue) {
              setState(() {
                selectedRole = newValue!;
              });
            },
            items: <String>['Amis', 'Parents', 'Collègues']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),

            const SizedBox(height: 10,),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
              ElevatedButton(
                onPressed:()async{
                  if (_numcompteController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ce champ est obligatoire')),
              );
             
                }else{
                    if(id==null){
                    await _addCompte();
                    }
                   if(id!=null){
                    //await _updateCompte(id);
                   } 
                   _numcompteController.text = "";
                  
                                      
                Navigator.of(context).pop();
                }
                  
                
                }, 
               child: Padding(padding: 
               const EdgeInsets.all(18),
               child: Text(id==null?"Enregistrer":"Modifier",
               style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500,),
               ),
               ),
                ),
                 const SizedBox(width: 10), // Espace entre les deux boutons
     
     
                ]
            )
            )
          ],
        ),
      ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEAF4),
      appBar: AppBar(
        title: const Text("Listes des comptes"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: (value) {
                _searchQuery = value;
                _filterData(_searchQuery);
              },
              decoration: const InputDecoration(
                hintText: 'Rechercher...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body: _isLoading ?const Center(child: CircularProgressIndicator(),)
      :ListView.builder(
        itemCount: _filtrecomptes.length,
        itemBuilder: (context,index)=>Card(
          margin: const EdgeInsets.all(15),
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(_filtrecomptes[index]['num_compte'].toString(),
              style: const TextStyle(
                fontSize: 20,
              ),
              ),

               ),

               // ignore: prefer_interpolation_to_compose_strings
               subtitle: Text("date_creation: ${_filtrecomptes[index]['date_creation']}"),
               
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
               IconButton(
                onPressed: (){
                  
                },
                 icon:const Icon( 
                  Icons.edit,
                  color: Colors.indigo,
                  )
                 
                 ),
                 IconButton(
                onPressed: (){
                  
                 // _deleteData(_comptes[index]['id']);
                  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Confirmation"),
        content: const Text("Voulez-vous vraiment supprimer cet invité ?"),
        actions: <Widget>[
          TextButton(
            child: const Text("Annuler"),
            onPressed: () {
              Navigator.of(context).pop(); // Ferme le dialogue
            },
          ),
          TextButton(
            child: const Text("Supprimer"),
            onPressed: () {
             // Appelle la fonction de suppression
              Navigator.of(context).pop(); // Ferme le dialogue
            },
          ),
        ],
      );
    },
  );
        
                },
                 icon:const Icon( 
                  Icons.delete,
                  color: Colors.redAccent,
                  )
                 
                 ),
            ],
          ),
          ),
        ),
        ),
      
      floatingActionButton:  Stack(
          children: <Widget>[
            Positioned(
              bottom: 16,
              right: 134,
              child: FloatingActionButton(
                onPressed: () {
                  //main1();
                },
                child: const Icon(Icons.picture_as_pdf),
              ),
            ),
           
            Positioned(
              bottom: 16,
              right: 16, // Ajustez cette valeur pour espacer les boutons
              child: FloatingActionButton(
                onPressed: () {
                    _numcompteController.text = "";
                   
                    showBottomSheet(null);
                   
                   },
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
    );
  }
}