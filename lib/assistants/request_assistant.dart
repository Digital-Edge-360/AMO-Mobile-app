import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestAssistant{
  static Future<dynamic> receiveRequest(String url) async{
    http.Response httpResponse = await http.get(Uri.parse(url));

    try{
      //sucessful
      if(httpResponse.statusCode == 200){
        String resData = httpResponse.body;  //a json response data

        var decodeResponseData = jsonDecode(resData);

        return decodeResponseData;
      }
      else{
        return 'Error Occured.';
      }
    }
    catch(exception){
      return 'Error Occured.';
    }
  }
}