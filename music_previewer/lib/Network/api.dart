import 'package:dio/dio.dart';

class Api {
  Future _getAlbum() async {
    var dio = Dio();
    Response response = await dio.get("https://api.deezer.com/album/119606");

    return response.statusCode == 200 ? response.data : null;
  }

  Future _getmarsh() async {
    var dio = Dio();
    Response response = await dio.get("https://api.deezer.com/album/138472122");

    return response.statusCode == 200 ? response.data : null;
  }

  Future _geRihanna() async {
    var dio = Dio();
    Response response = await dio.get("https://api.deezer.com/album/15319389");
    return response.statusCode == 200 ? response.data : null;
  }

  Future _daftpunk() async {
    var dio = Dio();
    Response response = await dio.get("https://api.deezer.com/album/302127");
    return response.statusCode == 200 ? response.data : null;
  }

  Future _getMartin() async {
    var dio = Dio();
    Response response = await dio.get("https://api.deezer.com/album/97081012");
    return response.statusCode == 200 ? response.data : null;
  }

  Future _getRadio() async {
    var dio = Dio();

    Response response = await dio.get("https://api.deezer.com/radio");
    return response.statusCode == 200 ? response.data : null;
  }

  Future _getCharts() async {
    var dio = Dio();
    Response response = await dio.get("https://api.deezer.com/chart");
    return response.statusCode == 200 ? response.data : null;
  }
}
