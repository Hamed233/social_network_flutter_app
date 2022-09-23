import 'package:savior/models/better_decision.dart';
import 'package:savior/models/general_user_info.dart';
import 'package:savior/models/note.dart';
import 'package:savior/models/make_decision.dart';
import 'package:savior/models/user.dart';

class PollModel {
  String? id;
  String? caption;
  String? publishDateTime;
  String? imageUrl;
  int? likes;
  int? shares;
  String? usrId;
  GeneralUserInfoModel generalUserInfoModel;
  List<DecisionOption>? decisionOption;
  List<BetterDecisionOption>? betterDecisionOption;
  List<NoteModel>? notes;
  List<String>? usersIdOfVoted;
  List<String>? usersIdOfLove;
  List<String>? usersIdOfSupportPoll;
  String? country;
  bool isAnonymous = false;

  PollModel({
    required this.id,
    required this.caption,
    required this.publishDateTime,
    required this.imageUrl,
    required this.likes,
    required this.shares,
    required this.usrId,
    required this.generalUserInfoModel,
    required this.decisionOption,
    required this.betterDecisionOption,
    required this.notes,
    required this.usersIdOfVoted,
    required this.usersIdOfLove,
    required this.usersIdOfSupportPoll,
    required this.country,
    this.isAnonymous = false,
  });

  factory PollModel.fromJson(Map<String, dynamic> json) => PollModel(
    id: json['id'],
    caption: json['caption'],
    publishDateTime: json['publishDateTime'],
    imageUrl: json['imageUrl'],
    likes: json['likes'],
    shares: json['shares'],
    usrId: json['usrId'],
    generalUserInfoModel: GeneralUserInfoModel.fromJson(Map<String,dynamic>.from(json['generalUserInfoModel'] ?? {})),
    decisionOption: List<DecisionOption>.from(json['decisionOption']),
    betterDecisionOption: List<BetterDecisionOption>.from(json['betterDecisionOption']),
    notes: List<NoteModel>.from(json['notes']),
    usersIdOfVoted: List<String>.from(json['usersIdOfVoted'] ?? []),
    usersIdOfLove: List<String>.from(json['usersIdOfLove'] ?? []),
    usersIdOfSupportPoll: List<String>.from(json['usersIdOfSupportPoll'] ?? []),
    country: json['country'],
    isAnonymous: json['isAnonymous'],

  );


  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'caption' : caption,
      'publishDateTime' : publishDateTime,
      'imageUrl' : imageUrl,
      'shares' : shares,
      'usrId' : usrId,
      'generalUserInfoModel' : generalUserInfoModel.toMap(),
      'decisionOption' : List.from(decisionOption!.map((e) => e.toMap())),
      'betterDecisionOption' : List.from(betterDecisionOption!.map((e) => e.toMap())),
      // 'notes' : notes,
      'usersIdOfVoted' : List.from(usersIdOfVoted!.map((e) => e)),
      'usersIdOfLove' : List.from(usersIdOfLove!.map((e) => e)),
      'usersIdOfSupportPoll' : List.from(usersIdOfSupportPoll!.map((e) => e)),
      'country' : country,
      'isAnonymous' : isAnonymous,
    };
  }
}