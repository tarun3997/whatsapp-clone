class Message{
  final String? text;
  final DateTime? sendingTime;
  final String? senderId;
  final String? receiverId;

  Message({
    required this.text,
    required this.sendingTime,
    required this.receiverId,
    required this.senderId
});

  factory Message.fromJson(Map<dynamic, dynamic> json){
    return Message(
        text: json['text'],
        receiverId: json['receiverId'],
        senderId: json['senderId'],
        sendingTime: DateTime.parse(json['createdAt'])
    );
  }
}