import 'dart:convert';

import 'package:connectsaleorder/AppConstants/Constants.dart';
import 'package:connectsaleorder/GetXController/UserController.dart';
import 'package:connectsaleorder/Models/ChatModel.dart';
import 'package:connectsaleorder/Models/ItemModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class ChatController extends GetxController{
  ChatModel chatModel = ChatModel(uid: "", timestamp: DateTime.now().millisecondsSinceEpoch, name: "N/A", chat: []);
  List<ChatModel> chatModelList = [];
  ChatModel selectedChatModel = ChatModel(uid: "", timestamp: DateTime.now().millisecondsSinceEpoch, name: "N/A", chat: []);
  UserController userController = Get.find();
  List<Chat> currentChat = [];
  var isLoadingChat = false;
  var isTodayMessageDelivered = false;
  var isSend = false;
  @override
  void onInit() {
    super.onInit();
    getChat();
    deleteChat();
    if(userController.user!.type == 0){
      getSupportChat();
    }
  }

  void getChat() {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(chatRef)
        .child(userController.user!.uid)
        .orderByChild("timestamp")
        .limitToLast(100)
        .onValue.listen((event) {
      if(event.snapshot.exists){
        chatModel = ChatModel.fromJson(jsonDecode(jsonEncode(event.snapshot.value)));
        if(chatModel.chat.length == 1){
          if(!isSend) {
            isSend = true;
            sendMessage(
                "Thanks for your concern. We will reply you with in 24 hours and sort out your issues as soon as possible out working hours is 09:00 to 22:00.\nThanks you \n Regards\n Connect sol Team",
                null, null, null, "admin", userController.user!.uid);
          }
        }
        update(["0"]);
        notifyChildrens();
      }else{
        var chatModelTemp = ChatModel(uid: userController.user!.uid, timestamp: DateTime.now().millisecondsSinceEpoch, name: userController.user!.name,image: userController.user!.image, chat: []);
        reference
            .child(chatRef)
            .child(userController.user!.uid)
            .set(chatModelTemp.toJson());
      }
    });
  }

  void deleteChat() {
    DateTime dateTime = DateTime.now().subtract(Duration(days: 15));
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(chatRef)
        .child(userController.user!.uid)
        .child(chatItemRef)
        .endAt(dateTime.millisecondsSinceEpoch)
        .once().then((value){
      if(value.exists){
        value.value.forEach((key,value){
          Chat chat = Chat.fromJson(jsonDecode(jsonEncode(value)));
          if(chat.timeStamp < dateTime.millisecondsSinceEpoch) {
            reference
                .child(chatRef)
                .child(userController.user!.uid)
                .child(chatItemRef)
                .child(key)
                .remove();
          }
        });
      }
    });
  }

  void getSupportChat() {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(chatRef)
        .orderByChild("timestamp")
        .onValue.listen((event) {
      chatModelList = [];
      if(event.snapshot.exists){
        event.snapshot.value.forEach((key,value){
          ChatModel chat = ChatModel.fromJson(jsonDecode(jsonEncode(value)));
          chatModelList.add(chat);
        });
      }
    });
  }

  Future<ChatModel?> getSupportChatById(uid) async {
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    DataSnapshot? snap = await reference
        .child(chatRef)
        .child(uid)
        .once();
    if(snap.exists) {
      return ChatModel.fromJson(jsonDecode(jsonEncode(snap.value)));
    }else{
      return null;
    }
  }

  void getSupportChatCurrent(ChatModel cModel) {
    selectedChatModel = cModel;
    currentChat = [];
    isLoadingChat = true;
    update(["0"]);
    notifyChildrens();
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(chatRef)
        .child(cModel.uid)
        .child(chatItemRef)
        .orderByChild("timestamp")
        .limitToLast(100)
        .onValue.listen((event) {
          currentChat = [];
      if(event.snapshot.exists){
        event.snapshot.value.forEach((key,value){
          Chat chat = Chat.fromJson(jsonDecode(jsonEncode(value)));
          currentChat.add(chat);
        });
        isLoadingChat = false;
        update(["0"]);
        notifyChildrens();
      }
    });
  }

  sendMessage(String? message , ItemModel? itemModel ,String? image , String? audio , senderId , receiverId){
    Chat chat = Chat(senderId: senderId, receiverId: receiverId, timeStamp: DateTime.now().millisecondsSinceEpoch ,enquiryProduct: itemModel, image: image, message: message,audio: audio);
    chatModel.chat.add(chat);
    update(["0"]);
    notifyChildrens();
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(chatRef)
        .child(userController.user!.uid)
        .child(chatItemRef)
    .push().set(chat.toJson());

    reference
        .child(chatRef)
        .child(userController.user!.uid)
        .update({"timestamp" : DateTime.now().millisecondsSinceEpoch});
  }

  sendMessageAdmin(String? message , ItemModel? itemModel ,String? image , String? audio , senderId , receiverId , ChatModel selectedChat){
    Chat chat = Chat(senderId: senderId, receiverId: receiverId, timeStamp: DateTime.now().millisecondsSinceEpoch ,enquiryProduct: itemModel, image: image, message: message,audio: audio);
    chatModel.chat.add(chat);
    update(["0"]);
    notifyChildrens();
    FirebaseDatabase database = FirebaseDatabase(databaseURL: databaseUrl);
    
    if(!GetPlatform.isWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    DatabaseReference reference = database.reference();
    reference
        .child(chatRef)
        .child(selectedChat.uid)
        .child(chatItemRef)
    .push().set(chat.toJson());

    reference
        .child(chatRef)
        .child(selectedChat.uid)
        .update({"timestamp" : DateTime.now().millisecondsSinceEpoch});
  }

}