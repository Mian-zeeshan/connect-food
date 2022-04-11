import 'package:connectsaleorder/Models/ItemModel.dart';

class ChatModel {
  String uid = "";
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  String name = '';
  String? image;
  List<Chat> chat = [];

  ChatModel({required this.uid, required this.timestamp, required this.name, this.image, required this.chat});

  ChatModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    timestamp = json['timestamp'];
    name = json['name'];
    image = json['image'];
    if (json['Chat'] != null) {
      chat = [];
      json['Chat'].forEach((k,v) {
        chat.add(new Chat.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['timestamp'] = this.timestamp;
    data['name'] = this.name;
    data['image'] = this.image;
    data['Chat'] = this.chat.map((v) => v.toJson()).toList();
    return data;
  }
}

class Chat {
  String senderId = "";
  String receiverId = "";
  ItemModel? enquiryProduct;
  String? message;
  String? image;
  String? audio;
  int timeStamp = DateTime.now().millisecondsSinceEpoch;

  Chat(
      {required this.senderId,
        required this.receiverId,
        this.enquiryProduct,
        this.message,
        this.image,
        required this.timeStamp,
        this.audio});

  Chat.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    enquiryProduct = json['enquiryProduct'] != null
        ? new ItemModel.fromJson(json['enquiryProduct'])
        : null;
    message = json['message'];
    image = json['image'];
    audio = json['audio'];
    timeStamp = json['timeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['senderId'] = this.senderId;
    data['receiverId'] = this.receiverId;
    if (this.enquiryProduct != null) {
      data['enquiryProduct'] = this.enquiryProduct!.toJson();
    }
    data['message'] = this.message;
    data['image'] = this.image;
    data['audio'] = this.audio;
    data['timeStamp'] = this.timeStamp;
    return data;
  }
}