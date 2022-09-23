import 'package:savior/models/better_decision.dart';
import 'package:savior/models/general_user_info.dart';
import 'package:savior/models/note.dart';
import 'package:savior/models/make_decision.dart';
import 'package:savior/models/solution.dart';
import 'package:savior/models/user.dart';

class ProblemModel {
  String? id;
  String? caption;
  String? publishDateTime;
  String? imageUrl;
  String? usrId;
  GeneralUserInfoModel? generalUserInfoModel;
  List<NoteModel>? notes;
  List<SolutionModel>? peopleSolutions;
  List<String>? peopleSuffer;
  List<String>? peopleShares;
  String? country;
  bool isAnonymous = false;

  ProblemModel({
    required this.id,
    required this.caption,
    required this.publishDateTime,
    required this.imageUrl,
    required this.usrId,
    required this.generalUserInfoModel,
    required this.notes,
    required this.peopleSolutions,
    required this.peopleSuffer,
    required this.peopleShares,
    required this.country,
    this.isAnonymous = false,
  });

  factory ProblemModel.fromJson(Map<String, dynamic> json) => ProblemModel(
    id: json['id'],
    caption: json['caption'],
    publishDateTime: json['publishDateTime'],
    imageUrl: json['imageUrl'],
    usrId: json['usrId'],
    generalUserInfoModel: GeneralUserInfoModel.fromJson(Map<String,dynamic>.from(json['generalUserInfoModel'] ?? {})),
    notes: List<NoteModel>.from(json['notes']),
    peopleSolutions: List<SolutionModel>.from(json['peopleSolutions']),
    peopleSuffer: List<String>.from(json['peopleSuffer'] ?? []),
    peopleShares: List<String>.from(json['peopleShares'] ?? []),
    country: json['country'],
    isAnonymous: json['isAnonymous'],

  );


  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'caption' : caption,
      'publishDateTime' : publishDateTime,
      'imageUrl' : imageUrl,
      'usrId' : usrId,
      'generalUserInfoModel' : generalUserInfoModel!.toMap(),
      // 'notes' : notes,
      'peopleSolutions' : List.from(peopleSolutions!.map((e) => e.toMap())),
      'peopleSuffer' : List.from(peopleSuffer!.map((e) => e)),
      'peopleShares' : List.from(peopleShares!.map((e) => e)),
      'country' : country,
      'isAnonymous' : isAnonymous,
    };
  }
}