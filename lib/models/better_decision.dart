import 'package:meta/meta.dart';
import 'package:savior/models/user.dart';

class BetterDecisionOption {
  String? id;
  String? caption;
  String? imageUrl;
  List<String>? usersIdOfVoted;
  List<String>? usersIdOfLove;
  UserModel? userModel;
  String? publishDateTime;


  BetterDecisionOption({
    this.id,
    this.caption,
    this.imageUrl,
    this.usersIdOfVoted,
    this.usersIdOfLove,
    this.userModel,
    this.publishDateTime,
  });

   BetterDecisionOption.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    caption = json['caption'];
    imageUrl = json['imageUrl'];
    usersIdOfVoted = List<String>.from(json['usersIdOfVoted'] ?? []);
    usersIdOfLove = List<String>.from(json['usersIdOfLove'] ?? []);
    userModel = UserModel.fromJson(Map<String,dynamic>.from(json['userModel'] ?? {}));
    publishDateTime = json['publishDateTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'caption' : caption,
      'imageUrl' : imageUrl,
      'usersIdOfVoted' : List.from(usersIdOfVoted!.map((e) => e)),
      'usersIdOfLove' : List.from(usersIdOfLove!.map((e) => e)),
      'userModel' : userModel!.toMap(),
      'publishDateTime' : publishDateTime,
    };
  }
}