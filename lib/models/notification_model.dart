class NotificationModel {
  String? id;
  String? postOrAccountId;
  String? title;
  String? body;
  String notificationReaction;
  String notificationType;
  String date;
  String? payload;
  int? isOpen = 0;

  NotificationModel({
    required this.title,
    required this.postOrAccountId,
    required this.body,
    required this.notificationReaction,
    required this.notificationType,
    required this.date,
    required this.payload,
    this.isOpen,
  });

  NotificationModel.withId({
    this.id,
    required this.title,
    required this.postOrAccountId,
    required this.body,
    required this.notificationReaction,
    required this.notificationType,
    required this.date,
    required this.payload,
    this.isOpen,
  });

    Map<String, dynamic> toMap() {
      final map = Map<String, dynamic>();
      map['id'] = id;
      map['title'] = title;
      map['postOrAccountId'] = postOrAccountId;
      map['body'] = body;
      map['notificationReaction'] = notificationReaction;
      map['notificationType'] = notificationType;
      map['date'] = date;
      map['payload'] = payload;
      map['isOpen'] = isOpen;
      return map;
    }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel.withId(
      id: map['id'],
      title: map['title'],
      postOrAccountId: map['postOrAccountId'],
      body: map['body'],
      notificationReaction: map['notificationReaction'],
      notificationType: map['notificationType'],
      date: map['date'],
      payload: map['payload'],
      isOpen: map['isOpen'],
    );
  }

}