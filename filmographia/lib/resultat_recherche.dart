import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'film.dart';

class RechercheResultat extends StatefulWidget {
  @override
  _RechercheResultatState createState() => _RechercheResultatState();
}

class _RechercheResultatState extends State<RechercheResultat> {
  List<Map<String, dynamic>> films = [];
  String nomFilm = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData();
  }

  void fetchData() async {
    nomFilm = ModalRoute.of(context)?.settings.arguments as String ?? '';

    final uri =
        Uri.http('www.omdbapi.com', '', {'s': nomFilm, 'apikey': '589b7cd'});
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      if (data.containsKey('Search')) {
        List<dynamic> searchResults = data['Search'];
        List<Map<String, dynamic>> filmInfoList = searchResults
            .map((film) => {
                  'Title': film['Title'].toString(),
                  'imdbID': film['imdbID'].toString(),
                })
            .toList();

        setState(() {
          films = filmInfoList;
        });
      } else {
        print('Aucun résultat de recherche trouvé');
      }
    } else {
      print('Erreur lors de la récupération des données de l\'API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filmographia'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: films.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FilmDetails(
                            title: 'Détails du Film',
                            imdbID: films[index]['imdbID'],
                            apiKey: '589b7cd',
                            filmTitle: films[index]['Title'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title: Text(
                          films[index]['Title'],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
