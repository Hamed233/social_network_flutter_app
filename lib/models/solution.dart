import 'package:meta/meta.dart';
import 'package:savior/models/make_decision.dart';
import 'package:savior/models/user.dart';
import 'dart:convert';

class SolutionModel {
  String? id;
  String? solution;
  String? image;
  String? problemId;
  String? publishDateTime;
  List<String>? usersIdOfSupportSolution;
  List<String>? usersIdOfInSupportSolution;
  UserModel? author;
  bool? isAnonymous;

  SolutionModel({
    this.id,
    required this.solution,
    required this.image,
    required this.problemId,
    required this.publishDateTime,
    required this.usersIdOfSupportSolution,
    required this.usersIdOfInSupportSolution,
    required this.author,
    required this.isAnonymous,
  });

  factory SolutionModel.fromJson(Map<String, dynamic> json) => SolutionModel(
    id: json['id'],
    solution: json['solution'],
    image: json['image'],
    problemId: json['problemId'],
    usersIdOfSupportSolution: List<String>.from(json['usersIdOfSupportSolution'] ?? []),
    usersIdOfInSupportSolution: List<String>.from(json['usersIdOfInSupportSolution'] ?? []),
    publishDateTime: json['publishDateTime'],
    author: UserModel.fromJson(json['author']),
    isAnonymous: json['isAnonymous'],
  );


  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'solution' : solution,
      'image' : image,
      'problemId' : problemId,
      'usersIdOfSupportSolution' : List.from(usersIdOfSupportSolution!.map((e) => e)),
      'usersIdOfInSupportSolution' : List.from(usersIdOfInSupportSolution!.map((e) => e)),
      'publishDateTime' : publishDateTime,
      'author' : author!.toMap(),
      'isAnonymous' : isAnonymous,
    };
  }
}