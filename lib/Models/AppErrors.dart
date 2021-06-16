class AppError {
  int? statusCode;
  String? error;
  List<Message>? message;

  AppError({this.statusCode, this.error, this.message});

  AppError.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    error = json['error'];
    if (json['message'] != null) {
      message = [];
      json['message'].forEach((v) {
        message?.add(new Message.fromJson(v));
      });
    }
  }
}

class Message {
  List<Messages>? messages;

  Message({this.messages});

  Message.fromJson(Map<String, dynamic> json) {
    if (json['messages'] != null) {
      messages = [];
      json['messages'].forEach((v) {
        messages?.add(new Messages.fromJson(v));
      });
    }
  }
}

class Messages {
  String? id;
  String? message;

  Messages({this.id, this.message});

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    return data;
  }
}
