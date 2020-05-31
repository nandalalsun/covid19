import 'package:covid_19/network/url_manager.dart';
import 'package:flutter/material.dart';
import 'package:covid_19/constant.dart';
import 'package:covid_19/widgets/counter.dart';
import 'package:covid_19/widgets/my_header.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
Function mathFunc = (Match match) => '${match[1]},';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Covid 19',
      theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          fontFamily: "Poppins",
          textTheme: TextTheme(
              // body1: TextStyle(color: kBodyTextColor),
              )),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = ScrollController();
  double offset = 0;
  int totalDeaths;
  int totalInfected;
  int totalRecovered;
  int deaths;
  int recovered;
  int infected;
  int active;
  String dropdownValue = "Nepal";
  String dateNow(DateTime date) {
    return '${date.day}/${date.month}/${date.year} Time: ${DateFormat.jm().format(DateTime.now())} ';
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(onScroll);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  Future<void> uiUpdate() async {
    var urlManager = new UrlManager(country: dropdownValue);
    var covData = await urlManager.makeUrl();
    // print("Recovered: ${covData[covData.length-1]['Recovered']}");
    //print("Recovered: ${covData.length}");
    if (dropdownValue == 'World') {
      setState(() {
        totalDeaths = covData['TotalDeaths'];
        totalInfected = covData['TotalConfirmed'];
        totalRecovered = covData['TotalRecovered'];
      });
    } else {
      setState(() {
        totalDeaths = covData[covData.length - 1]['Deaths'];
        totalRecovered = covData[covData.length - 1]['Recovered'];
        totalInfected = covData[covData.length - 1]['Confirmed'];
        active = covData[covData.length - 1]['Active'];
      });

      print('Deaths: $deaths, Recovered: $recovered, confirmed: $infected, Active: $active');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(dropdownValue);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: uiUpdate,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: controller,
          child: Column(
            children: <Widget>[
              MyHeader(
                image: "assets/icons/Drcorona.svg",
                textTop: "All you need",
                textBottom: "is stay at home.",
                offset: offset,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Color(0xFFE5E5E5),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    SvgPicture.asset("assets/icons/maps-and-flags.svg"),
                    SizedBox(width: 20),
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: SizedBox(),
                        icon: SvgPicture.asset("assets/icons/dropdown.svg"),
                        value: dropdownValue,
                        items: [
                          'World',
                          'Brazil',
                          'Russia',
                          'Nepal',
                          'India',
                          'US',
                          'Denmark',
                          'UK',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            dropdownValue = newValue;
                            uiUpdate();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Case Update\n",
                                style: kTitleTextstyle,
                              ),
                              TextSpan(
                                text: "Updated on ${dateNow(DateTime.now())}",
                                style: TextStyle(
                                  color: kTextLightColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Text(
                          "See details",
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 30,
                            color: kShadowColor,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Counter(
                              color: kInfectedColor,
                              number:
                                  "${'$totalInfected'.replaceAllMapped(reg, mathFunc)}",
                              title: "Infected",
                            ),
                          ),
                          Expanded(
                            child: Counter(
                              color: kDeathColor,
                              number:
                                  "${'$totalDeaths'.replaceAllMapped(reg, mathFunc)}",
                              title: "Deaths",
                            ),
                          ),
                          Expanded(
                            child: Counter(
                              color: kRecovercolor,
                              number:
                                  "${'$totalRecovered'.replaceAllMapped(reg, mathFunc)}",
                              title: "Recovered",
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Spread of Virus",
                          style: kTitleTextstyle,
                        ),
                        Text(
                          "See details",
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.all(20),
                      height: 178,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 30,
                            color: kShadowColor,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        "assets/images/map.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
