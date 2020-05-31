
import 'package:covid_19/network/network_helper.dart';
const api = 'https://api.covid19api.com';

class UrlManager{
  final String country;
  UrlManager({this.country});

  Future<dynamic> makeUrl() async{
    String url;
    if(country == 'World'){
      url = '$api/world/total';
    }else{
      url = '$api/total/country/$country';
    }
    NetworkHelper request = NetworkHelper(url: '$url');
    var covData = await request.getData();
    if(covData != null){
    return covData;
    }
    return '';
  }
}