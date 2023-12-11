import 'package:filmographia/resultat_recherche.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Filmographia'),
          backgroundColor: Colors.blueGrey,
        ),
        body: MyForm(),
        backgroundColor: Colors.grey,
      ),
      routes: {
        '/second': (context) => RechercheResultat(),
      },
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nom du film';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Nom',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Valide le formulaire avant de soumettre
                if (_formKey.currentState!.validate()) {
                  // Le formulaire est valide, effectuez l'action de soumission ici
                  String name = _nameController.text;

                  // Vous pouvez traiter les données ici (par exemple, les envoyer à un serveur)
                  print('Nom: $name');

                  // Naviguer vers la page des résultats avec le nom du film
                  Navigator.pushNamed(
                    context,
                    '/second',
                    arguments: name,
                  );
                }
              },
              child: Text('Soumettre'),
            ),
            Text(''),
          ],
        ),
      ),
    );
  }
}
