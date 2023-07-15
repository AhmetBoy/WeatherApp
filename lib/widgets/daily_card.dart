import 'package:flutter/material.dart';

class DailyCard extends StatelessWidget {
  final List<String>? iconNameList;
  final List<double>? tempList;
  final List<String>? dateList;
  DailyCard(
      {this.tempList = const [0, 0, 0, 0, 0],
      this.iconNameList = const ["09d", "09d", "09d", "09d", "09d"],
      this.dateList = const [
        "Pazartesi",
        "Pazartesi",
        "Pazartesi",
        "Pazartesi",
        "Pazartesi"
      ]});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.blue],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [.2, .85]),
          ),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Image(
                  image: NetworkImage(
                      "https://openweathermap.org/img/wn/${iconNameList?[index].substring(0, (iconNameList?[index].length)! - 1)}d@2x.png"),
                ),
              ),
              Expanded(
                child: Text("${tempList?[index].round()}C°",
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              Expanded(
                  child: Text("${dateList?[index]}",
                      style: TextStyle(color: Colors.white, fontSize: 20))),
            ],
          ),
        );
      },
    );
  }
}
