import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hava_durumu2/constants.dart';
import 'package:hava_durumu2/search_page.dart';
import 'package:hava_durumu2/widgets/daily_card.dart';
import 'package:hava_durumu2/widgets/loading_widget.dart';
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
  List<String?> iconNameFiveDay = [];
  List<double?> tempFiveDay = [];
  List<DateTime?> dateFiveDay = [];
  double? toplam = 0;
  double? tempBirinciGun;
  int? sayac = 0;
  int zaman = DateTime.now().hour;

  List<double> tempList = [0, 0, 0, 0, 0];
  List<String> dateList = ["Pazartesi", "Salı", "çarşamba", "Perşembe", "cuma"];
  List<String> iconNameList = ["09d", "09d", "09d", "09d", "09d"];
  List<String> gunler = [
    "Pazartesi",
    "Salı",
    "çarşamba",
    "Perşembe",
    "cuma",
    "cumartesi",
    "Pazar"
  ];
  var locationData;
  int birinciGunIndexSayisi = ((24 - DateTime.now().hour) / 3).round() == 0
      ? 1
      : ((24 - DateTime.now().hour) / 3).round();

  Future<void> getPosition() async {
    devicePosition = await _determinePosition();
    lat = devicePosition!.latitude;
    lon = devicePosition!.longitude;

    print("lat  ${lat},lon  ${lon}");
  }

  Future<void> getPositionTemperature() async {
    print("saat     ${((24 - zaman) / 3).round()}");
    locationData = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lat}&units=metric&appid=c58bb57d87e43610ddde7628f6f8140f"));
    var json = jsonDecode(locationData.body);
    json["cod"] == "404"
        ? print("404404")
        : setState(() {
            temp = json["main"]["temp"];
            secilenSehir = json["name"];
            arkaPlan = "images/${json["weather"][0]["main"]}.jpg";
            iconName = json["weather"][0]["icon"];
          });
  }

  Future<void> getPositionForecast() async {
    locationData = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?lat=${lat}&lon=${lon}&appid=bee0d0175d53df684f463fb8bf6b3828&units=metric"));
    var json = jsonDecode(locationData.body);
    json["cod"] == "404"
        ? print("404404")
        : setState(() {
            tempList.clear();
            dateList.clear();
            iconNameList.clear();
            tempFiveDay.clear();
            iconNameFiveDay.clear();
            dateFiveDay.clear();
            toplam = 0;
            for (int i = 0; i < 40; i++) {
              tempFiveDay.add(json["list"][i]["main"]["temp"]);
              iconNameFiveDay.add(json["list"][i]["weather"][0]["icon"]);
              dateFiveDay.add(DateTime.parse(json["list"][i]["dt_txt"]));
            }
            for (int i = 0; i < birinciGunIndexSayisi; i++) {
              toplam = toplam! + tempFiveDay[i]!;
            }
            tempList.add(toplam! / birinciGunIndexSayisi);

            int? sayac = birinciGunIndexSayisi;
            for (int i = 0;
                i < ((40 - birinciGunIndexSayisi) / 8).round();
                i++) {
              toplam = 0;
              try {
                for (int j = 0; j < 8; j++) {
                  toplam = toplam! + tempFiveDay[sayac!]!;
                  sayac = sayac + 1;
                }
              } catch (value) {
                print("hi");
              }
              tempList.add(toplam! / 8);
            }
            for (int i = 0; i < 40; i = i + 8) {
              iconNameList.add(iconNameFiveDay[i]!);
            }
            for (int i = 0; i < 40; i = i + 8) {
              dateList.add(gunler[(dateFiveDay[i]?.weekday)! - 1]);
            }
          });
  }

  Future<void> getTemperature() async {
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

  Future<void> getForecastData() async {
    var zaman = DateTime.now().hour;

    locationData = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?q=$secilenSehir&appid=bee0d0175d53df684f463fb8bf6b3828&units=metric"));
    var json = jsonDecode(locationData.body);
    json["cod"] == "404"
        ? print("404404")
        : setState(() {
            tempList.clear();
            dateList.clear();
            iconNameList.clear();
            tempFiveDay.clear();
            iconNameFiveDay.clear();
            dateFiveDay.clear();
            toplam = 0;
            for (int i = 0; i < 40; i++) {
              tempFiveDay.add(json["list"][i]["main"]["temp"]);
              iconNameFiveDay.add(json["list"][i]["weather"][0]["icon"]);
              dateFiveDay.add(DateTime.parse(json["list"][i]["dt_txt"]));
            }
            for (int i = 0; i < 40; i = i + 8) {
              iconNameList.add(iconNameFiveDay[i]!);
            }
            for (int i = 0; i < 40; i = i + 8) {
              dateList.add(gunler[(dateFiveDay[i]?.weekday)! - 1]);
            }
            for (int i = 0; i < ((24 - zaman) / 3).round(); i++) {
              toplam = toplam! + tempFiveDay[i]!;
            }
            tempList.add(toplam! / ((24 - zaman) / 3).round());

            tempBirinciGun = toplam! / ((24 - zaman) / 3).round();
            sayac = ((24 - zaman) / 3).round();
            for (int i = 0;
                i < ((40 - ((24 - zaman) / 3).round()) / 8).round();
                i++) {
              toplam = 0;
              try {
                for (int j = 0; j < 8; j++) {
                  toplam = toplam! + tempFiveDay[sayac!]!;
                  sayac = sayac! + 1;
                }
              } catch (value) {}
              tempList.add(toplam! / 8);
            }
          });
  }

  Future<void> begin() async {
    await getPosition();
    await getPositionTemperature();
    await getPositionForecast();
  }

  @override
  void initState() {
    begin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration boxDecorationContainer = BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage(arkaPlan.toString()),
      ),
    );
    return Container(
      decoration: boxDecorationContainer,
      child: locationData == null
          ? loadingWidget()
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
                        await getTemperature();
                        await getForecastData();
                      },
                      child: Text("GET")),
                  Text(
                    temp.toString(),
                    style: TextStyle(
                      fontSize: 70,
                      color: Colors.white,
                      shadows: kTextShadow,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(secilenSehir == null ? "" : secilenSehir.toString(),
                          style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              shadows: kTextShadow)),
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
                  ),
                  SizedBox(height: 100),
                  Expanded(
                    child: DailyCard(
                        tempList: tempList,
                        dateList: dateList,
                        iconNameList: iconNameList),
                  ),
                  SizedBox(height: 100),
                ],
              )),
    );
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  ///
  ///
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
