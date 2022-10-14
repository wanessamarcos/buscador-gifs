import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   String _search ='';
   int _offset = 0;

  get json => null;
  Future<Map>_getGifs() async{
    http.Response response;
    if(_search == null)
      response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/translate?api_key=oWhp392RWKfEog5dWgtJIeaci9UfQ14k&s=25"));
     else
       response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/search?api_key=oWhp392RWKfEog5dWgtJIeaci9UfQ14k&q=$_search&limit=19&offset=2$_offset&rating=g&lang=en"));
     return json.decode(response.body);
  }
  @override
  void initState(){
    super.initState();
    _getGifs().then((map){
      print(map);
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            ("https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif")),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children:<Widget> [
            Padding(padding:EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "Pesquise Aqui",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder()
                ),
                style: TextStyle(color: Colors.white, fontSize: 18.0),
                textAlign: TextAlign.center,
                onSubmitted: (text){
                  setState(() {
                    _search = text;
                  });
                },
              )
            ),
          Expanded(
              child: FutureBuilder(
                  future: _getGifs(),
                  builder:(context, snapshot){
                    switch(snapshot.connectionState){
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Container(
                          width: 200.0,
                          height: 200.0,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor:AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 5.0,
                          ),
                        );
                      default:
                        if (snapshot.hasError)return Container();
                        else return _createGifTable(context, snapshot);
                    }
                  }
              )
          )
        ],
      )
    );
  }
  int _getCount(List data){
    if(_search == null){
      return data.length;
    } else {
      return data.length + 1;
    }
  }
  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0
        ),
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (context, index){
            return GestureDetector(
              child: Image.network(snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              height: 300.0,
              fit: BoxFit.cover,),
            );
        }

    );
  }
}
