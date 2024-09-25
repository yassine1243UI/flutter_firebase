import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Pour utiliser Clipboard
import 'package:flutter_firebase/service/firebase.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Contrôleur pour le TextField du dialogue
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose(); // Libère les ressources utilisées par le contrôleur
    super.dispose();
  }

  /// Ouvre un dialogue pour ajouter un code
  Future<void> _openDialogCode() async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Code', style: TextStyle(color: Colors.blue)),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Entrez votre code',
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop('Cancel'), // Annule le dialogue
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                FirebaseService().createCode(_controller.text); // Ajoute le code à Firestore
                Navigator.of(context).pop('OK'); // Ferme le dialogue
              },
              child: const Text('OK', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );

    if (result == 'OK') {
      _controller.clear(); // Efface le contenu du TextField après l'ajout
    }
  }

  /// Copie le code dans le presse-papiers et affiche un message de confirmation
  Future<void> _copyCode(String code) async {
    await Clipboard.setData(ClipboardData(text: code)); // Copie le code
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Le code a été copié avec succès !!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Code', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openDialogCode, // Ouvre le dialogue d'ajout de code
        tooltip: 'Add Code',
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: FirebaseService().getCodes(), // Écoute des changements dans Firestore
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Indicateur de chargement
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Affiche une erreur si elle survient
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No codes found')); // Aucun code trouvé
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final document = snapshot.data!.docs[index]; // Document Firestore
              final code = document['code'] as String; // Récupère le code

              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Marges de la carte
                child: ListTile(
                  title: Text(
                    code,
                    style: const TextStyle(fontSize: 18, color: Colors.black87), // Style du texte
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.copy, color: Colors.blue), // Icône de copie
                    onPressed: () => _copyCode(code), // Appel à la méthode pour copier le code
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
