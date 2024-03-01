import 'package:flutter/material.dart';
import 'package:buscador_gifs_flutter/repositories/repository.dart';
import 'package:buscador_gifs_flutter/pages/gif_page.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Repository repo = Repository();

  late Future<Map> mapGifs;
  TextEditingController buscaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    mapGifs = repo.buscarTranding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset("images/powered_by_giphy.gif"),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: "Pesquise por GIFs",
            ),
            controller: buscaController,
            onSubmitted: (texto) {
              setState(() {
                if (texto.isEmpty) {
                  mapGifs = repo.buscarTranding();
                } else {
                  mapGifs = repo.buscarGifs(texto);
                }
              });
            },
          ),
          Expanded(
              child: FutureBuilder(
            future: mapGifs,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Container(
                    width: 200.0,
                    height: 200.0,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      strokeWidth: 5.0,
                    ),
                  );
                default:
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        "Erro na Conexão!!!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    return GridView.builder(
                        padding: EdgeInsets.all(10.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0),
                        itemCount: 10, //_getCount(snapshot.data["data"]),
                        itemBuilder: (context, index) {
                          if (true) {
                            //(buscaController.text != "" && index < snapshot.data?["data"].length)
                            return GestureDetector(
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: snapshot.data?["data"][index]["images"]
                                    ["fixed_height_downsampled"]["url"],
                                height: 300,
                              ),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: ((context) {
                                  return GifPage(snapshot.data?["data"][index]);
                                })));
                              },
                              onLongPress: () {
                                Share.share(snapshot.data?["data"][index]
                                        ["images"]["fixed_height_downsampled"]
                                    ["url"]);
                              },
                            );
                          }
                        });
                  }
              }
            },
          )),
        ],
      ),
    );
  }
}
