import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? secilenSehir;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("images/search.jpg"),
        ),
      ),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 70),
                child: TextField(
                    onChanged: (value) {
                      setState(() {
                        secilenSehir = value;
                      });
                      print(secilenSehir.toString());
                    },
                    decoration: InputDecoration(hintText: "SEHİR SECİNİZ..."),
                    style: TextStyle(fontSize: 30, color: Colors.white)),
              ),
              Text(secilenSehir.toString()),
              FilledButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context, secilenSehir);
                    });
                    print(secilenSehir.toString());
                  },
                  child: Text("Geri Dön"))
            ],
          )),
    );
  }
}
