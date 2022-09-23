import 'package:meta/meta.dart';
import 'package:savior/models/user.dart';

class DecisionOption {
  String? id;
  String? caption;
  String? imageUrl;
  int likes = 0;
  int votes = 0;
  String? publishDateTime;


  DecisionOption({
    this.id,
    this.caption,
    this.imageUrl,
    this.likes = 0,
    this.votes = 0,
    this.publishDateTime,
  });

   DecisionOption.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    caption = json['caption'];
    imageUrl = json['imageUrl'];
    likes = json['likes'];
    votes = json['votes'];
    publishDateTime = json['publishDateTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'caption' : caption,
      'imageUrl' : imageUrl,
      'likes' : likes,
      'votes' : votes,
      'publishDateTime' : publishDateTime,
    };
  }
}