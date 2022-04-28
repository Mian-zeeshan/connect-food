import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:get/get.dart';

class NotificationApis extends GetConnect{

  Future<Response> sendNotification(to, title, content){
    var data = {
      "to": to,
      "data":{
        "title" : title,
        "content" : content
      },
      "notification": {
        "body": title,
        "title": content
      }
    };
    return post("https://fcm.googleapis.com/fcm/send", data, headers: {"Authorization" : "key=$smsKey", "Content-Type" : "application/json"});
  }

}