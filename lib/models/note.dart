import 'package:meta/meta.dart';
import 'package:savior/models/general_user_info.dart';
import 'package:savior/models/make_decision.dart';
import 'package:savior/models/user.dart';
import 'dart:convert';

class NoteModel {
  String? id;
  String? note;
  String? postId;
  String? publishDateTime;
  List<NoteModel>? replais = [];
  bool showReplaies = false;
  List<String>? usersIdOfSupportNote;
  GeneralUserInfoModel? author;
  GeneralUserInfoModel? publisher;


  NoteModel({
    this.id,
    required this.note,
    required this.postId,
    required this.usersIdOfSupportNote,
    required this.replais,
    this.showReplaies = false,
    required this.publishDateTime,
    required this.author,
    required this.publisher,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
    id: json['id'],
    note: json['note'],
    postId: json['postId'],
    usersIdOfSupportNote: List<String>.from(json['usersIdOfSupportNote'] ?? []),
    replais: List.from(json['replais']),
    publishDateTime: json['publishDateTime'],
    author: GeneralUserInfoModel.fromJson(json['author']),
    publisher: GeneralUserInfoModel.fromJson(json['publisher']),
  );


  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'note' : note,
      'postId' : postId,
      'usersIdOfSupportNote' : List.from(usersIdOfSupportNote!.map((e) => e)),
      'replais' : List.from(replais!.map((e) => e.toMap())),
      'publishDateTime' : publishDateTime,
      'author' : author!.toMap(),
      'publisher' : publisher!.toMap(),
    };
  }
}