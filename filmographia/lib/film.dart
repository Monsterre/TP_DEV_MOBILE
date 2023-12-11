import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class FilmDetails extends StatefulWidget {
  const FilmDetails({
    Key? key,
    required this.title,
    required this.imdbID,
    required this.apiKey,
    required this.filmTitle,
  }) : super(key: key);

  final String title;
  final String imdbID;
  final String apiKey;
  final String filmTitle;

  @override
  _FilmDetailsState createState() => _FilmDetailsState();
}

class _FilmDetailsState extends State<FilmDetails> {
  late Map<String, dynamic> film;
  bool dataOK = false;

  @override
  void initState() {
    recupFilm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.blueGrey[900],
          child: dataOK ? affichage() : attente(),
        ),
      ),
    );
  }

  Future<void> recupFilm() async {
    Uri uri = Uri.http('www.omdbapi.com', '', {
      'i': widget.imdbID,
      'apikey': widget.apiKey,
    });

    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      film = convert.jsonDecode(response.body) as Map<String, dynamic>;
      setState(() {
        dataOK = true;
      });
    }
  }

  Widget attente() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'En attente des données',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          CircularProgressIndicator(
            color: Colors.white,
            strokeCap: StrokeCap.round,
          ),
        ],
      ),
    );
  }

  Widget affichage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '${film['Title']}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${film['Year']}',
            style: const TextStyle(color: Colors.white),
          ),
          const Padding(padding: EdgeInsets.all(15.0)),
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.white,
                offset: Offset(0.0, 7.0),
                spreadRadius: 3.0,
                blurRadius: 15.0,
              )
            ]),
            child: Image.network('${film['Poster']}'),
          ),
          const Padding(padding: EdgeInsets.all(15.0)),
          Text(
            '${film['Plot']}',
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
          const Padding(padding: EdgeInsets.all(15.0)),
          Text(
            '${film['Actors']}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const Padding(padding: EdgeInsets.all(15.0)),
          // Ajouter le bouton de retour
          ElevatedButton(
            onPressed: () {
              // Utiliser le navigateur pour revenir à la page 'main.dart'
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text('Retour à la page principale'),
          ),
        ],
      ),
    );
  }
}
