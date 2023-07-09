import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hava_durumu2/search_page.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String arkaPlan = "images/home.jpg";
  String? iconName;
  double? lat;
  double? lon;
  double? temp;
  String? secilenSehir;
  Position? devicePosition;
  var locationData;

  Future<void> getTempeture() async {
    locationData = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$secilenSehir&units=metric&appid=c58bb57d87e43610ddde7628f6f8140f"));
    var json = jsonDecode(locationData.body);
    json["cod"] == "404"
        ? print("404404")
        : setState(() {
            temp = json["main"]["temp"];
            var havaDurumu = json["weather"][0]["main"];
            arkaPlan = "images/$havaDurumu.jpg";
            iconName = json["weather"][0]["icon"];
          });
  }

  Future<void> getDevicePosition() async {
    devicePosition = await _determinePosition();
    lat = devicePosition!.latitude;
    lon = devicePosition!.longitude;
    print("lat={$lat}&lon={$lon}");
    locationData = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=c58bb57d87e43610ddde7628f6f8140f"));
    var json = jsonDecode(locationData.body);
    json["cod"] == "404"
        ? print("404404")
        : setState(() {
            temp = json["main"]["temp"];
            var havaDurumu = json["weather"][0]["main"];
            secilenSehir = json["name"];
            arkaPlan = "images/$havaDurumu.jpg";
            iconName = json["weather"][0]["icon"];
          });
  }

  @override
  void initState() {
    getDevicePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(arkaPlan.toString()),
        ),
      ),
      child: locationData == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Image(
                      image: NetworkImage(
                        "https://openweathermap.org/img/wn/${iconName}@2x.png",
                      ),
                    ),
                  ),
                  FilledButton(
                      onPressed: () async {
                        await getTempeture();
                        print(locationData.body);
                      },
                      child: Text("GET")),
                  Text(temp.toString(),
                      style: TextStyle(fontSize: 70, color: Colors.white)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(secilenSehir.toString(),
                          style: TextStyle(fontSize: 40, color: Colors.white)),
                      IconButton(
                        onPressed: () async {
                          final secilenSehir1 = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchPage(),
                            ),
                          );
                          setState(() {
                            secilenSehir = secilenSehir1;
                          });
                        },
                        icon: Icon(Icons.search),
                      )
                    ],
                  )
                ],
              )),
    );
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
