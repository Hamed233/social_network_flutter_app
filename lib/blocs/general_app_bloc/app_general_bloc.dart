import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:savior/blocs/general_app_bloc/states.dart';
import 'package:savior/components/constants/constants.dart';
import 'package:savior/components/random_components.dart';
import 'package:savior/layout/auth/login/login_screen.dart';
import 'package:savior/layout/home_screen/problems_screen.dart';
import 'package:savior/layout/layout_of_app.dart';
import 'package:savior/layout/profile_screen/profile_screen.dart';
import 'package:savior/layout/profile_screen/tabs/decisions_tab.dart';
import 'package:savior/layout/profile_screen/tabs/home_tab.dart';
import 'package:savior/layout/profile_screen/tabs/problems_reactions_tab.dart';
import 'package:savior/layout/profile_screen/tabs/voted_supported_poll_tab.dart';
import 'package:savior/layout/profile_screen/tabs/problems_tab.dart';
import 'package:savior/layout/trend_screen/trend_screen.dart';
import 'package:savior/models/better_decision.dart';
import 'package:savior/models/general_user_info.dart';
import 'package:savior/models/note.dart';
import 'package:savior/models/make_decision.dart';
import 'package:savior/models/poll.dart';
import 'package:savior/models/problem.dart';
import 'package:savior/models/solution.dart';

import 'package:savior/models/user.dart';
import 'package:savior/network/local/cache_helper.dart';

import '../../layout/home_screen/polls_screen.dart';
import '../../models/notification_model.dart';

class AppBloc extends Cubit<AppStates> {
  AppBloc() : super(AppInitialState());

  static AppBloc get(context) => BlocProvider.of(context);

  // ---------------- General App -----------------------
  int currentIndex = 0;
  List<Widget> mainScreens = [
    PollsScreen(
      forWhat: "",
      pollWithMore: true,
    ),
    ProblemsScreen(
      forWhat: "",
      problemWithMore: true,
    ),
    TrendScreen(),
    const ProfileScreen(),
  ];

  // change bottom navigation pages
  void changeBottomNav(int index) {
    if (index == 0) {
      getNotifications();
      // loadFollowingPollsAsFirst();
    }

    if (index == 1) {
      // getAllProblems();
    }

    if (index == 2) {
      getProblemsTrend();
      getPollsTrend();
    }

    if (index == 3) {
      getFollowersOfPerson(id: userId).then((value) {
        getFollowingOfPerson(id: userId).then((value) {
          getAllPollsForPerson(userId).then((value) {
            getAllProblemsForPerson(userId).then((value) {
              currentReactionsPollsAboutUser(userId).then((value) {
                currentReactionsProblemsAboutUser(userId);
              });
            });
          });
        });
      });
    }
    currentIndex = index;
    emit(AppChangeBottomNavState());
  }

  bool isDark = false;
  // ------- Toggle app mode -------
  changeAppMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(AppChangeModeState());
    } else {
      isDark = !isDark;
      CacheHelper.putBoolean(
              key: CacheHelperKeys.themeOfAppModeKey, value: isDark)
          .then((value) {
        emit(AppChangeModeState());
      });
    }
  }

  // ------- Get User Data -------
  UserModel? userModel;
  Future getUserData({id}) async {
    emit(GetUserDataLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId != "" ? userId : id)
        .get()
        .then((value) {
      userModel = UserModel.fromJson(value.data()!);
      emit(GetUserDataSuccessState());
    }).catchError((error) {
      emit(GetUserDataErrorState(error.toString()));
      print("err" + error.toString());
    });
  }

  UserModel personProfileModel = UserModel();
  Future getPersonProfileData({id}) async {
    emit(GetPersonProfileDataLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get()
        .then((value) async {
      personProfileModel = UserModel.fromJson(value.data()!);

      getAllPollsForPerson(id);
      getAllProblemsForPerson(id);
      currentReactionsPollsAboutUser(id);
      currentReactionsProblemsAboutUser(id);

      emit(GetPersonProfileDataSuccessState());
    }).catchError((error) {
      emit(GetPersonProfileDataErrorState(error.toString()));
      print("err" + error.toString());
    });
  }

  // ------- Pick Image and store it -------
  File? uploadedImage;
  var picker = ImagePicker();
  var pickedFile;

  Future<void> uploadImage() async {
    emit(ImagePickedLoadingState());

    pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      uploadedImage = File(pickedFile.path);
      emit(ImagePickedSuccessState());
    } else {
      emit(ImagePickedFailedState());
    }
  }

  // Change Trend tabs
  int currentIndexOfTrendTab = 0;
  void changeTrendTabs(int index) {
    currentIndexOfTrendTab = index;
    emit(ChangeTrendTabState());
  }

  // ---------------- Profile Screen -----------------------

  int currentTabIndex = 0;
  List<Widget> tabScreens = <Widget>[
    HomeTab(),
    DecisionsTab(),
    ProblemsTab(),
    PollReactionsTab(),
    ProblemsReactionsTab(),
  ];

  // ------- Change profile tabs -------
  void changeTabNav(int index) {
    currentTabIndex = index;
    emit(ProfileChangeTabNavState());
  }

  // ---------------- Add Poll Screen -----------------------

  // List<int> decisionOptionItems = [0, 1];
  List<DecisionOption> decisionOptionItems = <DecisionOption>[
    DecisionOption(id: getRandomString(10), caption: '', likes: 0, votes: 0),
    DecisionOption(id: getRandomString(11), caption: '', likes: 0, votes: 0)
  ];

  // ------- add new decosion -------
  void addDecisionOption() {
    // decisionOptionItems.add(newNumber);
    decisionOptionItems
        .add(DecisionOption(id: getRandomString(11), likes: 0, votes: 0));
    emit(AddDecisionOptionState());
  }

  // ------- remove new decosion -------
  void removeDecisionOption(index) {
    decisionOptionItems.removeWhere((element) => element.id == index);
    if (decisionOptionPhotos.isNotEmpty) {
      decisionOptionPhotos.removeWhere((key, value) => key == index);
    }
    emit(RemoveDecisionOptionState());
  }

  // toggle poll as "Anonymous" or not
  bool pollIsAnonymous = false;
  void togglePollIsAnonymous(val) {
    pollIsAnonymous = val;
    emit(TogglePollIsAnonymousState());
  }

  // toggle solution as "Anonymous" or not
  bool solutionIsAnonymous = false;
  void toggleSolutionIsAnonymous(val) {
    solutionIsAnonymous = val;
    emit(ToggleSolutionIsAnonymousState());
  }

  // ---------- Pick Decisions Images ----------------

  Map<String, File> decisionOptionPhotos = {}; // for decision Option Photos
  var pickedDecisionImageFile;
  File? uploadedDecisionImage;

  Future<void> pickPollDecisionImage({decisionOptionId}) async {
    emit(PickDecisionsImageLoadingState());

    pickedDecisionImageFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedDecisionImageFile != null) {
      uploadedDecisionImage = File(pickedDecisionImageFile.path);
      if (decisionOptionId != null) {
        decisionOptionPhotos.addAll({decisionOptionId: uploadedDecisionImage!});
        pickedDecisionImageFile = null;
      }
      emit(PickDecisionsImagePickedSuccessState());
    } else {
      emit(PickDecisionsImagePickedFailedState());
    }
  }

  // ------- Store Decisions Images (DB) -------
  Map<int, String> decisionsImagesUrls = {};
  // List decisionsImagesUrls = [];
  Future storeDecisionsImages() async {
    decisionOptionPhotos.entries.forEach((image) async {
      firebase_storage.FirebaseStorage.instance
          .ref()
          .child(
              'polls/decisions/${Uri.file(image.value.path).pathSegments.last}')
          .putFile(image.value)
          .then((p0) async {
        decisionOptionItems.forEach((element) async {
          // decisionsImagesUrls.addAll({int.parse(element.id!): await p0.ref.getDownloadURL()});
          // decisionsImagesUrls.forEach((key, value) async {
          if (element.id == image.key) {
            element.imageUrl = await p0.ref.getDownloadURL();
            print("equal");
          }
          // });
        });

        // decisionsImagesUrls.add(await p0.ref.getDownloadURL());
      });
    });
  }

  // ------- Clear Old Data after poll or leave poll -------
  void cleanPreviousPollPostData({pollImage, index}) {
    if (pollImage != null) {
      pollImage == '';
      uploadedImage = null;
      pickedFile = null;
    } else if (decisionOptionPhotos.isNotEmpty) {
      decisionOptionPhotos = {};
      decisionsImagesUrls = {};
      pickedDecisionImageFile = null;
      uploadedDecisionImage = null;
    }

    decisionOptionItems = [
      DecisionOption(id: getRandomString(10), likes: 0, votes: 0, caption: ''),
      DecisionOption(id: getRandomString(10), likes: 0, votes: 0, caption: ''),
    ];

    pollIsAnonymous = false;

    emit(PreviousDataOfPollCleanedSuccessState());
  }

  // ------- Upload poll With Images (DB) -------
  Future uploadPoll(
    context, {
    required String caption,
    required bool pollHasPhoto,
  }) async {
    emit(UploadPollLoadingState());
    if (caption.isNotEmpty) {
      if (pollHasPhoto) {
        await firebase_storage.FirebaseStorage.instance
            .ref()
            .child('polls/${Uri.file(uploadedImage!.path).pathSegments.last}')
            .putFile(uploadedImage!)
            .then((value) {
          value.ref.getDownloadURL().then((value) {
            if (decisionOptionPhotos.isNotEmpty) {
              storeDecisionsImages().then((val) {
                addDataToPollsTable(context, caption, pollImage: value);
              });
            } else {
              addDataToPollsTable(context, caption, pollImage: value);
            }
            print("object");

            emit(UploadImagePickedSuccessState());
          }).catchError((error) {
            emit(UploadImagePickedErrorState());
            print(error.toString());
          });
        }).catchError((err) {
          emit(UploadImagePickedErrorState());
          print(err.toString());
        });
      } else {
        if (decisionOptionPhotos.isNotEmpty) {
          storeDecisionsImages().then((val) {
            addDataToPollsTable(context, caption);
          });
          print("----------------");
        } else {
          addDataToPollsTable(context, caption);
        }
        print("here");
      }
    } else {
      emit(UploadPollFailedState("Please, fill inputs!"));
    }
  }

  // ------- Add polls to (DB) -------
  Future addDataToPollsTable(context, caption, {pollImage}) async {
    PollModel model = PollModel(
      id: getRandomString(20),
      caption: caption,
      publishDateTime: DateTime.now().toIso8601String(),
      imageUrl: pollImage,
      likes: 0,
      notes: [],
      shares: 0,
      usrId: userModel!.uId,
      generalUserInfoModel: GeneralUserInfoModel(
        fullName: userModel!.fullName,
        uId: userModel!.uId,
        image: userModel!.image,
        jobTitle: userModel!.jobTitle,
      ),
      decisionOption: decisionOptionItems,
      betterDecisionOption: [],
      usersIdOfVoted: [],
      usersIdOfLove: [],
      usersIdOfSupportPoll: [],
      country: userModel!.country,
      isAnonymous: pollIsAnonymous,
    );

    FirebaseFirestore.instance
        .collection('polls')
        .add(model.toMap())
        .then((value) {
      emit(UploadPollSuccessState());

      Navigator.of(context).pop();

      showCustomSnackBar(context,
          content: "Polled Successfully",
          bgColor: Colors.green,
          textColor: Colors.white);
      cleanPreviousPollPostData(pollImage: pollImage);
      getAllPolls();
    }).catchError((error) {
      print("err " + error.toString());
      emit(UploadPollFailedState(error.toString()));
    });
  }

  // ------- Add Problem to (DB) -------
  Future addDataToProblemsTable(context, caption) async {
    emit(UploadProblemLoadingState());

    ProblemModel model = ProblemModel(
      id: getRandomString(20) +
          DateTime.now().microsecondsSinceEpoch.toString(),
      caption: caption,
      publishDateTime: DateTime.now().toIso8601String(),
      imageUrl: '',
      usrId: userModel!.uId,
      generalUserInfoModel: GeneralUserInfoModel(
        fullName: userModel!.fullName,
        uId: userModel!.uId,
        image: userModel!.image,
        jobTitle: userModel!.jobTitle,
      ),
      notes: [],
      peopleSolutions: [],
      peopleSuffer: [],
      peopleShares: [],
      country: userModel!.country,
      isAnonymous: pollIsAnonymous,
    );

    FirebaseFirestore.instance
        .collection('problems')
        .add(model.toMap())
        .then((value) {
      emit(UploadProblemSuccessState());
      // cleanPreviousData(pollImage: '');
      getAllProblems();
      Navigator.of(context).pop();
      showCustomSnackBar(context,
          content: "Problem posted Successfully",
          bgColor: Colors.green,
          textColor: Colors.white);
    }).catchError((error) {
      print("err " + error.toString());
      emit(UploadProblemFailedState(error.toString()));
    });
  }

  List<PollModel> allPollsList = []; // Get all polls
  List<PollModel> followingPollsList = []; // Get following polls
  List<PollModel> pollsOfSameCountry = []; // Get Same Country polls
  List<PollModel> pollsOfDifferentCountry = []; // Get Different Country polls
  List<PollModel> personPollsList = []; // Get person polls
  List<PollModel> trendPollsList = []; // Get trend polls
  List<PollModel> reactionsPollListForCurrentUser =
      []; // Get current reactions polls
  List<ProblemModel> reactionsProblemsListForCurrentUser =
      []; // Get current reactions polls
  List<ProblemModel> trendProblemsList = []; // Get trend polls
  List<ProblemModel> allProblemsList = []; // Get all problems
  List<ProblemModel> personProblemsList = []; // Get person problems
  List<ProblemModel> singleProblem = []; // Get single problem
  List<PollModel> singlePoll = []; // Get single poll
  List<NoteModel> notesList = [];
  List<NoteModel> notesListOfProblem = [];
  List<BetterDecisionOption> betterDecisionsOptionsList = [];
  List<SolutionModel> solutionsList = [];
  List<NotificationModel> notificationsList = [];
  List<GeneralUserInfoModel> followersList = [];
  List<GeneralUserInfoModel> followingList = [];
  List<GeneralUserInfoModel> currentUserFollowersList = [];
  List<GeneralUserInfoModel> currentUserFollowingList = [];

  // ------------------------- Polls Zooooone ----------------------------




  // Get Trend Polls function
  Future getPollsTrend() async {
    emit(GetTrendPollsLoadingState());

    FirebaseFirestore.instance
        .collection('polls')
        // .where("shares", isGreaterThanOrEqualTo: 1000)
        .orderBy('publishDateTime', descending: true)
        .limit(20)
        .get()
        .then((value) {
      List<DecisionOption> allDecisionsOptionsList = [];
      trendPollsList = [];
      value.docs.forEach((element) {
        int betterDecisionOptionLength =
            element.data()['betterDecisionOption'].length;
        int usersIdOfSupportPollLength =
            element.data()['usersIdOfSupportPoll'].length;
        int usersIdOfVotedLength = element.data()['usersIdOfVoted'].length;
        int usersIdOfLoveLength = element.data()['usersIdOfLove'].length;
        int sharesLength = element.data()['shares'];
        DateTime date = DateTime.parse(element.data()['publishDateTime']);
        var differenceDate = DateTime.now().difference(date);

        if (element.data()['decisionOption'] != []) {
          element.data()['decisionOption'].forEach((value) {
            allDecisionsOptionsList.add(DecisionOption.fromJson(value));
          });
        }

        Map<String, dynamic> rowData = {
          "id": element.id,
          "caption": element.data()['caption'],
          'publishDateTime': element.data()['publishDateTime'],
          'imageUrl': element.data()['imageUrl'],
          'notes': notesList,
          'shares': element.data()['shares'],
          'usrId': element.data()['usrId'],
          'generalUserInfoModel': element.data()['generalUserInfoModel'],
          'decisionOption': allDecisionsOptionsList,
          'betterDecisionOption': [],
          'usersIdOfVoted': element.data()['usersIdOfVoted'],
          'usersIdOfLove': element.data()['usersIdOfLove'],
          'isAnonymous': element.data()['isAnonymous'],
          'usersIdOfSupportPoll': element.data()['usersIdOfSupportPoll'],
        };

        trendPollsList.add(PollModel.fromJson(rowData));

        // Get polls in Last 3 days
        if (differenceDate.inDays <= 3) {
          // Level 1
          if (betterDecisionOptionLength <= 9 &&
              betterDecisionOptionLength >= 3 &&
              usersIdOfSupportPollLength <= 250 &&
              usersIdOfSupportPollLength >= 100 &&
              usersIdOfVotedLength <= 80 &&
              usersIdOfVotedLength >= 40 &&
              usersIdOfLoveLength >= 100 &&
              usersIdOfLoveLength <= 200) {
            trendPollsList.add(PollModel.fromJson(element.data()));
            print(trendPollsList);

            // Level 2
          } else if (betterDecisionOptionLength <= 30 &&
              betterDecisionOptionLength >= 10 &&
              usersIdOfSupportPollLength <= 500 &&
              usersIdOfSupportPollLength >= 200 &&
              usersIdOfVotedLength <= 160 &&
              usersIdOfVotedLength >= 80 &&
              usersIdOfLoveLength >= 200 &&
              usersIdOfLoveLength <= 400) {
            // Level 3
          } else if (betterDecisionOptionLength <= 60 &&
              betterDecisionOptionLength >= 30 &&
              usersIdOfSupportPollLength <= 700 &&
              usersIdOfSupportPollLength >= 300 &&
              usersIdOfVotedLength <= 300 &&
              usersIdOfVotedLength >= 160 &&
              usersIdOfLoveLength >= 300 &&
              usersIdOfLoveLength <= 500) {
            // Level 4
          } else if (betterDecisionOptionLength >= 60 &&
              usersIdOfSupportPollLength >= 700 &&
              usersIdOfVotedLength >= 300 &&
              usersIdOfLoveLength >= 500) {}
        }

        allDecisionsOptionsList = [];
      });
      emit(GetTrendPollsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetTrendPollsFailState(error.toString()));
    });
  }

  // ------- Get poll notes (from DB) -------
  Future getNotsOfPoll({pollId}) async {
    emit(GetNotesOfPollLoadingState());
    FirebaseFirestore.instance
        .collection('polls')
        .doc(pollId)
        .collection('notes')
        .orderBy('publishDateTime', descending: true)
        .get()
        .then((notes) {
      notesList = [];
      if (notes.docs.isNotEmpty) {
        notes.docs.forEach((element) {
          // Get replaies of note
          List<NoteModel> replais = [];
          // if (element.data()['replais'] != []) {
          //   element.data()['replais'].forEach((replay) {
          //     print(replay['replais']);
          //     NoteModel model = NoteModel(
          //       id: element.id,
          //       note: element.data()['note'],
          //       postOrAccountId: element.data()['pollId'],
          //       usersIdOfSupportNote: List.from(
          //           element.data()['usersIdOfSupportNote'] != null
          //               ? element.data()['usersIdOfSupportNote'].map((e) => e)
          //               : []),
          //       replais: List.from(element.data()['replais'] != null
          //           ? element
          //               .data()['replais']
          //               .map((e) => NoteModel.fromJson(e))
          //           : []),
          //       publishDateTime: element.data()['publishDateTime'],
          //       author: UserModel.fromJson(element.data()['author'] ?? {}),
          //       publisher: UserModel.fromJson(element.data()['publisher'] ?? {}),
          //     );
          //     replais.add(model);
          //   });
          // }
          NoteModel model = NoteModel(
            id: element.id,
            note: element.data()['note'],
            postId: element.data()['postOrAccountId'],
            usersIdOfSupportNote: List.from(
                element.data()['usersIdOfSupportNote'] != null
                    ? element.data()['usersIdOfSupportNote'].map((e) => e)
                    : []),
            replais: List.from(replais.map((e) => e)),
            publishDateTime: element.data()['publishDateTime'],
            author:
                GeneralUserInfoModel.fromJson(element.data()['author'] ?? {}),
            publisher: GeneralUserInfoModel.fromJson(
                element.data()['publisher'] ?? {}),
          );

          notesList.add(model);
        });

        allPollsList.forEach((poll) {
          if (poll.id == pollId) {
            poll.notes = notesList;
          }
        });
        notesList = [];
      }
      emit(GetNotesOfPollSuccessState());
    }).catchError((error) {
      emit(GetNotesOfPollErrorState(error.toString()));
      print("err " + error.toString());
    });
  }

  // ------- Get better Decosions of poll (from DB) -------
  Future getBetterDecisionsOfPoll({pollId}) async {
    emit(GetBetterDecisionsOfPollLoadingState());
    FirebaseFirestore.instance
        .collection('polls')
        .doc(pollId)
        .get()
        .then((poll) {
      betterDecisionsOptionsList = [];
      if (poll.data()!['betterDecisionOption'].isNotEmpty) {
        poll.data()!['betterDecisionOption'].forEach((value) {
          betterDecisionsOptionsList.add(BetterDecisionOption.fromJson(value));
        });

        allPollsList.forEach((poll) {
          if (poll.id == pollId) {
            poll.betterDecisionOption = betterDecisionsOptionsList;
          }
        });
        print(betterDecisionsOptionsList);
        betterDecisionsOptionsList = [];
      }
      emit(GetBetterDecisionsOfPollSuccessState());
    }).catchError((error) {
      emit(GetBetterDecisionsOfPollErrorState(error.toString()));
      print("err " + error.toString());
    });
  }


  // ------- Get All Polls (from DB) -------
  Future getAllPolls() async {
    emit(GetAllPollsDataLoadingState());
    FirebaseFirestore.instance
        .collection('polls')
        .orderBy('publishDateTime')
        .get()
        .then((polls) {
      List<DecisionOption> allDecisionsOptionsList = [];
      allPollsList = [];

      polls.docs.forEach((element) async {
        if (element.data()['decisionOption'] != []) {
          element.data()['decisionOption'].forEach((value) {
            allDecisionsOptionsList.add(DecisionOption.fromJson(value));
          });
        }

        Map<String, dynamic> rowData = {
          "id": element.id,
          "caption": element.data()['caption'],
          'publishDateTime': element.data()['publishDateTime'],
          'imageUrl': element.data()['imageUrl'],
          'notes': notesList,
          'shares': element.data()['shares'],
          'usrId': element.data()['usrId'],
          'generalUserInfoModel': element.data()['generalUserInfoModel'],
          'decisionOption': allDecisionsOptionsList,
          'betterDecisionOption': [],
          'usersIdOfVoted': element.data()['usersIdOfVoted'],
          'usersIdOfLove': element.data()['usersIdOfLove'],
          'isAnonymous': element.data()['isAnonymous'],
          'usersIdOfSupportPoll': element.data()['usersIdOfSupportPoll'],
        };
        allPollsList.add(PollModel.fromJson(rowData));
        allDecisionsOptionsList = [];
      });
      emit(GetAllPollsDataSuccessState());

      // Get Notes and better decisions after content of main poll get!
      polls.docs.forEach((element) {
        getNotsOfPoll(pollId: element.id);
        getBetterDecisionsOfPoll(pollId: element.id);
      });
    }).catchError((error) {
      emit(GetAllPollsDataErrorState(error.toString()));
      print("err " + error.toString());
    });
  }

  // ------- Get Polls of Same Country (from DB) -------
  Future getPollsOfSameCountry(country) async {
    emit(GetAllPollsDataOfSameCountryLoadingState());
    FirebaseFirestore.instance
        .collection('polls')
        .where("country", isEqualTo: country)
        .get()
        .then((polls) {
      List<DecisionOption> allDecisionsOptionsList = [];
      pollsOfSameCountry = [];
      polls.docs.forEach((element) async {
        if (element.data()['decisionOption'] != []) {
          element.data()['decisionOption'].forEach((value) {
            allDecisionsOptionsList.add(DecisionOption.fromJson(value));
          });
        }

        Map<String, dynamic> rowData = {
          "id": element.id,
          "caption": element.data()['caption'],
          'publishDateTime': element.data()['publishDateTime'],
          'imageUrl': element.data()['imageUrl'],
          'notes': notesList,
          'shares': element.data()['shares'],
          'usrId': element.data()['usrId'],
          'generalUserInfoModel': element.data()['generalUserInfoModel'],
          'decisionOption': allDecisionsOptionsList,
          'betterDecisionOption': [],
          'usersIdOfVoted': element.data()['usersIdOfVoted'],
          'usersIdOfLove': element.data()['usersIdOfLove'],
          'isAnonymous': element.data()['isAnonymous'],
          'usersIdOfSupportPoll': element.data()['usersIdOfSupportPoll'],
        };
        pollsOfSameCountry.add(PollModel.fromJson(rowData));
        allDecisionsOptionsList = [];
      });
      emit(GetAllPollsDataOfSameCountrySuccessState());

      // Get Notes and better decisions after content of main poll get!
      polls.docs.forEach((element) {
        getNotsOfPoll(pollId: element.id);
        getBetterDecisionsOfPoll(pollId: element.id);
      });
    }).catchError((error) {
      emit(GetAllPollsDataOfSameCountryErrorState(error.toString()));
      print("err " + error.toString());
    });
  }

  // ------- Get Polls of Different Country (from DB) -------
  Future getPollsOfDifferentCountry(country) async {
    emit(GetAllPollsDataOfSameCountryLoadingState());
    FirebaseFirestore.instance
        .collection('polls')
        .where("country", isNotEqualTo: country)
        .get()
        .then((polls) {
      List<DecisionOption> allDecisionsOptionsList = [];
      pollsOfDifferentCountry = [];
      polls.docs.forEach((element) async {
        if (element.data()['decisionOption'] != []) {
          element.data()['decisionOption'].forEach((value) {
            allDecisionsOptionsList.add(DecisionOption.fromJson(value));
          });
        }

        Map<String, dynamic> rowData = {
          "id": element.id,
          "caption": element.data()['caption'],
          'publishDateTime': element.data()['publishDateTime'],
          'imageUrl': element.data()['imageUrl'],
          'notes': notesList,
          'shares': element.data()['shares'],
          'usrId': element.data()['usrId'],
          'generalUserInfoModel': element.data()['generalUserInfoModel'],
          'decisionOption': allDecisionsOptionsList,
          'betterDecisionOption': [],
          'usersIdOfVoted': element.data()['usersIdOfVoted'],
          'usersIdOfLove': element.data()['usersIdOfLove'],
          'isAnonymous': element.data()['isAnonymous'],
          'usersIdOfSupportPoll': element.data()['usersIdOfSupportPoll'],
        };
        pollsOfDifferentCountry.add(PollModel.fromJson(rowData));
        allDecisionsOptionsList = [];
      });
      emit(GetAllPollsDataOfSameCountrySuccessState());

      // Get Notes and better decisions after content of main poll get!
      polls.docs.forEach((element) {
        getNotsOfPoll(pollId: element.id);
        getBetterDecisionsOfPoll(pollId: element.id);
      });
    }).catchError((error) {
      emit(GetAllPollsDataOfSameCountryErrorState(error.toString()));
      print("err " + error.toString());
    });
  }

  // ------- Get Polls of following (from DB) -------
  Future getPollsOfFollowing(followingList) async {
    emit(GetAllPollsDataOfFollowingLoadingState());
    followingList.forEach((followingId) async {
      FirebaseFirestore.instance
          .collection('polls')
          .where("usrId", isEqualTo: followingId)
          .get()
          .then((polls) {
        List<DecisionOption> allDecisionsOptionsList = [];
        followingPollsList = [];
        allPollsList = [];
        polls.docs.forEach((element) async {
          if (element.data()['decisionOption'] != []) {
            element.data()['decisionOption'].forEach((value) {
              allDecisionsOptionsList.add(DecisionOption.fromJson(value));
            });
          }

          Map<String, dynamic> rowData = {
            "id": element.id,
            "caption": element.data()['caption'],
            'publishDateTime': element.data()['publishDateTime'],
            'imageUrl': element.data()['imageUrl'],
            'notes': notesList,
            'shares': element.data()['shares'],
            'usrId': element.data()['usrId'],
            'generalUserInfoModel': element.data()['generalUserInfoModel'],
            'decisionOption': allDecisionsOptionsList,
            'betterDecisionOption': [],
            'usersIdOfVoted': element.data()['usersIdOfVoted'],
            'usersIdOfLove': element.data()['usersIdOfLove'],
            'isAnonymous': element.data()['isAnonymous'],
            'usersIdOfSupportPoll': element.data()['usersIdOfSupportPoll'],
          };
          allPollsList.add(PollModel.fromJson(rowData));
          print("test");
          allDecisionsOptionsList = [];
        });

        // Get Notes and better decisions after content of main poll get!
        polls.docs.forEach((element) {
          getNotsOfPoll(pollId: element.id);
          getBetterDecisionsOfPoll(pollId: element.id);
        });
        emit(GetAllPollsDataOfFollowingSuccessState());
      }).catchError((error) {
        emit(GetAllPollsDataOfFollowingErrorState(error.toString()));
        print("err " + error.toString());
      });
    });
  }

  // ------- Get All Polls for person (from DB) -------
  Future getAllPollsForPerson(id) async {
    emit(GetAllPollsDataForPersonLoadingState());
    FirebaseFirestore.instance
        .collection('polls')
        .where("usrId", isEqualTo: id)
        // .orderBy("id", descending: true)
        .get()
        .then((polls) {
      List<DecisionOption> allDecisionsOptionsList = [];
      personPollsList = [];

      polls.docs.forEach((element) async {
        if (element.data()['decisionOption'] != []) {
          element.data()['decisionOption'].forEach((value) {
            allDecisionsOptionsList.add(DecisionOption.fromJson(value));
          });
        }

        Map<String, dynamic> rowData = {
          "id": element.id,
          "caption": element.data()['caption'],
          'publishDateTime': element.data()['publishDateTime'],
          'imageUrl': element.data()['imageUrl'],
          'notes': notesList,
          'shares': element.data()['shares'],
          'usrId': element.data()['usrId'],
          'generalUserInfoModel': element.data()['generalUserInfoModel'],
          'decisionOption': allDecisionsOptionsList,
          'betterDecisionOption': [],
          'usersIdOfVoted': element.data()['usersIdOfVoted'],
          'usersIdOfLove': element.data()['usersIdOfLove'],
          'isAnonymous': element.data()['isAnonymous'],
          'usersIdOfSupportPoll': element.data()['usersIdOfSupportPoll'],
        };
        personPollsList.add(PollModel.fromJson(rowData));
        allDecisionsOptionsList = [];
      });
      emit(GetAllPollsDataForPersonSuccessState());

      // Get Notes and better decisions after content of main poll get!
      polls.docs.forEach((element) {
        getNotsOfPoll(pollId: element.id);
        getBetterDecisionsOfPoll(pollId: element.id);
      });
    }).catchError((error) {
      emit(GetAllPollsDataForPersonErrorState(error.toString()));
      print("err " + error.toString());
    });
  }

  // Get Reactions on polls for current User
  Future currentReactionsPollsAboutUser(id) async {
    emit(GetCurrentInfoAboutUserLoadingState());
    FirebaseFirestore.instance
        .collection('polls')
        .where("usrId", isEqualTo: id)
        .get()
        .then((polls) {
      List<DecisionOption> allDecisionsOptionsList = [];
      reactionsPollListForCurrentUser = [];

      polls.docs.forEach((element) async {
        // Get support & voted polls for Current User
        if (element.data()['usersIdOfSupportPoll'] != [] ||
            element.data()['usersIdOfVoted']) {
          if (element.data()['usersIdOfSupportPoll'].contains(userId) ||
              element.data()['usersIdOfVoted'].contains(userId)) {
            // Add DecisionOption to model
            if (element.data()['decisionOption'] != []) {
              element.data()['decisionOption'].forEach((value) {
                allDecisionsOptionsList.add(DecisionOption.fromJson(value));
              });
            }
            Map<String, dynamic> rowData = {
              "id": element.id,
              "caption": element.data()['caption'],
              'publishDateTime': element.data()['publishDateTime'],
              'imageUrl': element.data()['imageUrl'],
              'notes': notesList,
              'shares': element.data()['shares'],
              'usrId': element.data()['usrId'],
              'generalUserInfoModel': element.data()['generalUserInfoModel'],
              'decisionOption': allDecisionsOptionsList,
              'betterDecisionOption': [],
              'usersIdOfVoted': element.data()['usersIdOfVoted'],
              'usersIdOfLove': element.data()['usersIdOfLove'],
              'isAnonymous': element.data()['isAnonymous'],
              'usersIdOfSupportPoll': element.data()['usersIdOfSupportPoll'],
            };
            reactionsPollListForCurrentUser.add(PollModel.fromJson(rowData));
            allDecisionsOptionsList = [];
          }
        }
      });
      emit(GetCurrentInfoAboutUserSuccessState());

      // Get Notes and better decisions after content of main poll get!
      polls.docs.forEach((element) {
        getNotsOfPoll(pollId: element.id);
        getBetterDecisionsOfPoll(pollId: element.id);
      });
    }).catchError((error) {
      emit(GetCurrentInfoAboutUserErrorState(error.toString()));
      print("err " + error.toString());
    });
  }

  // Get Reactions on Problems for current User
  Future currentReactionsProblemsAboutUser(id) async {
    emit(GetCurrentProblemsReactionsAboutUserLoadingState());
    FirebaseFirestore.instance
        .collection('problems')
        .where("usrId", isEqualTo: id)
        .get()
        .then((problems) {
      reactionsProblemsListForCurrentUser = [];
      List<SolutionModel> allSolutionsList = [];

      problems.docs.forEach((element) async {
        // Get support & voted problems for Current User
        if (element.data()['peopleSuffer'] != []) {
          if (element.data()['peopleSuffer'].contains(userId)) {
            // Add DecisionOption to model
            if (element.data()['peopleSolutions'] != []) {
              element.data()['peopleSolutions'].forEach((value) {
                allSolutionsList.add(SolutionModel.fromJson(value));
              });
            }

            Map<String, dynamic> rowData = {
              "id": element.id,
              "caption": element.data()['caption'],
              'publishDateTime': element.data()['publishDateTime'],
              'imageUrl': element.data()['imageUrl'],
              'generalUserInfoModel': element.data()['generalUserInfoModel'],
              'notes': notesListOfProblem,
              'shares': element.data()['shares'],
              'usrId': element.data()['usrId'],
              'peopleSolutions': allSolutionsList,
              'peopleSuffer': element.data()['peopleSuffer'],
              'peopleShares': element.data()['peopleShares'],
              'isAnonymous': element.data()['isAnonymous'],
            };
            reactionsProblemsListForCurrentUser
                .add(ProblemModel.fromJson(rowData));
            reactionsProblemsListForCurrentUser = [];
          }
        }
      });
      emit(GetCurrentProblemsReactionsAboutUserSuccessState());

      // Get Notes and solutions after content of main poll get!
      problems.docs.forEach((element) {
        getNotsOfProblem(problemId: element.id);
        getSolutionsOfProblem(problemId: element.id);
      });
    }).catchError((error) {
      emit(GetCurrentProblemsReactionsAboutUserErrorState(error.toString()));
      print("err " + error.toString());
    });
  }

  // ----------- (mark a vote) && (mark vote as love) --------------------
  Future updateVoteOption(PollModel poll, reactionType) async {
    FirebaseFirestore.instance
        .collection("polls")
        .doc(poll.id)
        .update(poll.toMap())
        .then((value) {
      emit(VoteMarkedSuccessState());
      // if (poll.userModel.uId != userId) {
      NotificationModel model = NotificationModel.withId(
        id: getRandomString(15).toString() +
            DateTime.now().microsecond.toString(),
        postOrAccountId: poll.id,
        title: "",
        body: userModel!.fullName! +
            (reactionType == "vote" ? " voted" : " Loved") +
            " your poll",
        notificationReaction: reactionType == "vote" ? "vote" : "love",
        notificationType: "poll",
        date: DateTime.now().toIso8601String(),
        payload: "",
        isOpen: 0,
      );
      FirebaseFirestore.instance
          .collection("users")
          .doc(poll.generalUserInfoModel.uId)
          .collection("notifications")
          .add(model.toMap())
          .then((value) {
        print("done");
      }).catchError((err) {
        print(err.toString());
      });
      // }
    }).catchError((err) {
      print(err.toString());
      emit(VoteMarkedFailState(err.toString()));
    });
  }

  // ----------- Fot better decision (mark a vote) && (mark vote as love) --------------------
  Future updateBetterDecision(PollModel poll) async {
    FirebaseFirestore.instance.collection("polls").doc(poll.id).update({
      "betterDecisionOption": FieldValue.arrayUnion(
          List.from(poll.betterDecisionOption!.map((e) => e.toMap())))
    }).then((value) {
      emit(VoteMarkedSuccessState());
    }).catchError((err) {
      print(err.toString());
      emit(VoteMarkedFailState(err.toString()));
    });
  }

  // ----------- Add Share to DB --------------------
  Future recordPollShare(PollModel poll) async {
    FirebaseFirestore.instance
        .collection("polls")
        .doc(poll.id)
        .update({"shares": FieldValue.increment(1)}).then((value) {
      emit(SharePollRecordedSuccessState());
    }).catchError((err) {
      print(err.toString());
      emit(SharePollRecordedFailState(err.toString()));
    });
  }

  // ----------- Toggle Support React (poll) --------------------
  Future toggleSupportReact(PollModel poll, notificationType, reactType) async {
    FirebaseFirestore.instance.collection("polls").doc(poll.id).update({
      "usersIdOfSupportPoll":
          List.from(poll.usersIdOfSupportPoll!.map((e) => e)),
    }).then((value) {
      emit(ToggleSupportReactSuccessState());
      // if (notificationType == "add" && poll.userModel.uId != userId) {
      if (notificationType == "add") {
        NotificationModel model = NotificationModel.withId(
          id: getRandomString(15).toString() +
              DateTime.now().microsecond.toString(),
          postOrAccountId: poll.id,
          title: "",
          body: poll.generalUserInfoModel.fullName! +
              " support your Poll '${poll.caption}'",
          notificationReaction: "support",
          notificationType: "poll",
          date: DateTime.now().toIso8601String(),
          payload: "",
          isOpen: 0,
        );
        FirebaseFirestore.instance
            .collection("users")
            .doc(poll.generalUserInfoModel.uId)
            .collection("notifications")
            .add(model.toMap())
            .then((value) {
          print("done");
        }).catchError((err) {
          print(err.toString());
        });
      }
    }).catchError((err) {
      print(err.toString());
      emit(ToggleSupportReactFailState(err.toString()));
    });
  }

  // ----------- Toggle Support React (NOTE OF POLL) --------------------
  Future toggleSupportReactOnNote(poll, NoteModel note, notificationType,
      {isProblem = false}) async {
    FirebaseFirestore.instance
        .collection(isProblem ? "problems" : "polls")
        .doc(poll.id)
        .collection("notes")
        .doc(note.id)
        .update({
      "usersIdOfSupportNote": FieldValue.arrayUnion(
          List.from(note.usersIdOfSupportNote!.map((e) => e)))
    }).then((value) {
      // if (notificationType == "add" && poll.userModel.uId != userId) {
      if (notificationType == "add") {
        NotificationModel model = NotificationModel.withId(
          id: getRandomString(15).toString() +
              DateTime.now().microsecond.toString(),
          postOrAccountId: poll.id,
          title: "",
          body: "Someone support " +
              note.author!.fullName! +
              " note on your poll '${note.note}'",
          notificationReaction: "support",
          notificationType: isProblem ? "problem" : "poll",
          date: DateTime.now().toIso8601String(),
          payload: "",
          isOpen: 0,
        );
        FirebaseFirestore.instance
            .collection("users")
            .doc(poll.userModel.uId)
            .collection("notifications")
            .add(model.toMap())
            .then((value) {
          print("done");
        }).catchError((err) {
          print(err.toString());
        });
      }
      emit(ToggleSupportReactSuccessState());
    }).catchError((err) {
      print(err.toString());
      emit(ToggleSupportReactFailState(err.toString()));
    });
  }

  // ------- Add Note to (DB) -------
  Future addPollNoteToDBTable(context, note, PollModel poll) async {
    emit(UploadNoteToDBLoadingState());
    NoteModel model = NoteModel(
      note: note,
      postId: poll.id,
      usersIdOfSupportNote: [],
      replais: [],
      publishDateTime: DateTime.now().toIso8601String(),
      author: GeneralUserInfoModel(
        fullName: userModel!.fullName,
        uId: userModel!.uId,
        image: userModel!.image,
        jobTitle: userModel!.jobTitle,
      ),
      publisher: GeneralUserInfoModel(
        fullName: userModel!.fullName,
        uId: userModel!.uId,
        image: userModel!.image,
        jobTitle: userModel!.jobTitle,
      ),
    );
    FirebaseFirestore.instance
        .collection('polls')
        .doc(poll.id)
        .collection('notes')
        .add(model.toMap())
        .then((value) {
      emit(UploadNoteToDBSuccessState());
      // if (poll.userModel.uId != userId) {
      NotificationModel model = NotificationModel.withId(
        id: getRandomString(15).toString() +
            DateTime.now().microsecond.toString(),
        postOrAccountId: poll.id,
        title: "",
        body: poll.generalUserInfoModel.fullName! + " added note on your poll",
        notificationReaction: "note",
        notificationType: "poll",
        date: DateTime.now().toIso8601String(),
        payload: "",
        isOpen: 0,
      );
      FirebaseFirestore.instance
          .collection("users")
          .doc(poll.generalUserInfoModel.uId)
          .collection("notifications")
          .add(model.toMap())
          .then((value) {
        print("done");
      }).catchError((err) {
        print(err.toString());
      });
      // }
      getNotsOfPoll(pollId: poll.id);
    }).catchError((error) {
      print("err " + error.toString());
      emit(UploadNoteToDBFailedState(error.toString()));
    });
  }

  // ------- Add better Decision to (DB) -------
  Future addBetterDecisionToDBTable(context, decision, PollModel poll) async {
    emit(GetBetterDecisionsOfPollLoadingState());
    if (userModel!.uId != null) {
      List<BetterDecisionOption> listModel = [
        BetterDecisionOption(
          id: getRandomString(10),
          caption: decision,
          usersIdOfLove: [],
          usersIdOfVoted: [],
          userModel: userModel,
          publishDateTime: DateTime.now().toIso8601String(),
        ),
      ];

      FirebaseFirestore.instance.collection('polls').doc(poll.id).update({
        "betterDecisionOption":
            FieldValue.arrayUnion(List.from(listModel.map((e) => e.toMap())))
      }).then((value) {
        emit(GetBetterDecisionsOfPollSuccessState());
        // if (poll.userModel.uId != userId) {
        NotificationModel model = NotificationModel.withId(
          id: getRandomString(15).toString() +
              DateTime.now().microsecond.toString(),
          postOrAccountId: poll.id,
          title: "",
          body: poll.generalUserInfoModel.fullName! +
              " added better decision on your poll '${poll.caption}'",
          notificationReaction: "better_decision",
          notificationType: "poll",
          date: DateTime.now().toIso8601String(),
          payload: "",
          isOpen: 0,
        );
        FirebaseFirestore.instance
            .collection("users")
            .doc(poll.generalUserInfoModel.uId)
            .collection("notifications")
            .add(model.toMap())
            .then((value) {
          print("done");
        }).catchError((err) {
          print(err.toString());
        });
        // }
        getBetterDecisionsOfPoll(pollId: poll.id);
        Navigator.of(context).pop();
      }).catchError((error) {
        print("err " + error.toString());
        emit(GetBetterDecisionsOfPollErrorState(error.toString()));
      });
    } else {
      emit(GetBetterDecisionsOfPollErrorState("Not found user model"));
    }
  }

  // ------- Get Single Poll (from DB) -------
  Future getSinglePoll(id) async {
    emit(GetSinglePollDataLoadingState());
    FirebaseFirestore.instance.collection('polls').doc(id).get().then((poll) {
      List<DecisionOption> allDecisionsOptionsList = [];
      singlePoll = [];

      if (poll.data()!['decisionOption'] != []) {
        poll.data()!['decisionOption'].forEach((value) {
          allDecisionsOptionsList.add(DecisionOption.fromJson(value));
        });
      }

      Map<String, dynamic> rowData = {
        "id": poll.id,
        "caption": poll.data()!['caption'],
        'publishDateTime': poll.data()!['publishDateTime'],
        'imageUrl': poll.data()!['imageUrl'],
        'notes': notesList,
        'shares': poll.data()!['shares'],
        'usrId': poll.data()!['usrId'],
        'userModel': poll.data()!['userModel'],
        'decisionOption': allDecisionsOptionsList,
        'betterDecisionOption': [],
        'usersIdOfVoted': poll.data()!['usersIdOfVoted'],
        'usersIdOfLove': poll.data()!['usersIdOfLove'],
        'isAnonymous': poll.data()!['isAnonymous'],
        'usersIdOfSupportPoll': poll.data()!['usersIdOfSupportPoll'],
      };
      singlePoll.add(PollModel.fromJson(rowData));
      allDecisionsOptionsList = [];
      emit(GetSinglePollDataSuccessState());

      // Get Notes and solutions after content of main poll get!
      getNotsOfPoll(pollId: poll.id);
      getBetterDecisionsOfPoll(pollId: poll.id);
    }).catchError((error) {
      emit(GetSinglePollDataErrorState(error.toString()));
      print("err " + error.toString());
    });
  }

  // ------- Get Following Polls As first load in page (from DB) -------
  Future loadFollowingPollsAsFirst() async {
    emit(StartedLoadFollowingPollsAsFirstState());
    getFollowingOfPerson(id: userId);
    print(currentUserfollowingsIdList);
    getPollsOfFollowing(currentUserfollowingsIdList);
    emit(FinishedLoadFollowingPollsAsFirstState());
  }

  bool pollsOfSameCountryLoaded = false;
  Future loadMorePollsFromSameCountry() async {
    emit(StartedLoadMorePollsFromSameCountryState());
    // getPollsOfSameCountry(userModel!.country);
    getPollsOfSameCountry("Andorra (AD)");
    pollsOfSameCountryLoaded = true;
    allPollsList.addAll(pollsOfSameCountry);
    emit(FinishedLoadMorePollsFromSameCountryState());
  }

  bool pollsOfDifferentCountryLoaded = false;
  Future loadMorePollsFromDifferentCountry() async {
    emit(StartedLoadMorePollsFromDifferentCountryState());
    // getPollsOfDifferentCountry(userModel!.country);
    getPollsOfDifferentCountry("Andorra (AD)");
    pollsOfDifferentCountryLoaded = true;
    allPollsList.addAll(pollsOfDifferentCountry);
    emit(FinishedLoadMorePollsFromDifferentCountryState());
  }

  // ------------------------- Profile Zooooone ----------------------------

  GeneralUserInfoModel currentVisitedProfileData =
      GeneralUserInfoModel(isFollow: false);

  // ------- Follow Function -------
  Future addPersonToFollowers(
      {usrId, followingDocId, username, image, jobTitle}) async {
    emit(FollowPersonLoadingState());
    GeneralUserInfoModel model = GeneralUserInfoModel(
        uId: userModel!.uId,
        followingDocId: followingDocId,
        fullName: userModel!.fullName,
        image: userModel!.image,
        jobTitle: userModel!.jobTitle,
        date: DateTime.now().toIso8601String());
    FirebaseFirestore.instance
        .collection('users')
        .doc(usrId)
        .collection('followers')
        .add(model.toMap())
        .then((value) {
      emit(FollowPersonSuccessState());

      currentVisitedProfileData.isFollow = true;

      getFollowersOfPerson(id: usrId);
      getFollowingOfPerson(id: usrId);
      NotificationModel model = NotificationModel.withId(
        id: getRandomString(15).toString() +
            DateTime.now().microsecond.toString(),
        postOrAccountId: userId,
        title: "",
        body: userModel!.fullName! + " started following you!",
        notificationReaction: "follow",
        notificationType: "follow",
        date: DateTime.now().toIso8601String(),
        payload: "",
        isOpen: 0,
      );
      FirebaseFirestore.instance
          .collection("users")
          .doc(usrId)
          .collection("notifications")
          .add(model.toMap())
          .then((value) {
        emit(NotificationSendSuccessState());
      }).catchError((err) {
        emit(NotificationSendFailedState(err.toString()));
      });
    }).catchError((error) {
      print("err " + error.toString());
      emit(FollowPersonFailedState(error.toString()));
    });
  }

  // ------- unFollow Function -------
  Future unfollowPerson(usrId, _currentFollowDocId, followingDocId) async {
    emit(UnfollowPersonLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(usrId)
        .collection('followers')
        .doc(_currentFollowDocId)
        .delete()
        .then((value) {
      currentVisitedProfileData.isFollow = false;
      // -- note: here check first if is current user or not
      currentUserFollowersList.removeWhere((element) => element.uId == userId);
      followersList.removeWhere((element) => element.uId == userId);
      deletePersonToFollowing(usrId: usrId, followingDocId: followingDocId);
      emit(UnfollowPersonSuccessState());
    }).catchError((error) {
      print("err " + error.toString());
      emit(UnfollowPersonFailedState(error.toString()));
    });
  }

  // ------- Following Function -------
  Future addPersonToFollowingThenFollowers(
      {usrId, username, image, jobTitle}) async {
    emit(AddPersonToFollowingLoadingState());
    GeneralUserInfoModel model = GeneralUserInfoModel(
        fullName: username,
        uId: usrId,
        image: image,
        jobTitle: jobTitle,
        date: DateTime.now().toIso8601String());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('following')
        .add(model.toMap())
        .then((value) {
      addPersonToFollowers(
          usrId: usrId,
          followingDocId: value.id,
          username: username,
          image: image,
          jobTitle: jobTitle);
      emit(AddPersonToFollowingSuccessState());
    }).catchError((error) {
      print("err " + error.toString());
      emit(AddPersonToFollowingFailedState(error.toString()));
    });
  }

  // ------- UnFollowing Function -------
  Future deletePersonToFollowing({usrId, followingDocId}) async {
    emit(DeletePersonToFollowingLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('following')
        .doc(followingDocId)
        .delete()
        .then((value) {
      currentVisitedProfileData.isFollow = false;

      followingList.removeWhere((element) => element.uId == usrId);
      currentUserFollowingList.removeWhere((element) => element.uId == usrId);

      emit(DeletePersonToFollowingSuccessState());
    }).catchError((error) {
      print("err " + error.toString());
      emit(DeletePersonToFollowingFailedState(error.toString()));
    });
  }

  // ------- Get followers of person (from DB) -------
  Future getFollowersOfPerson({id}) async {
    emit(GetFollowersOfPersonLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('followers')
        .orderBy('date', descending: true)
        .get()
        .then((followers) {
      // ------- Get followers of current User (from DB) -------

      followers.docs.forEach((element) {
        GeneralUserInfoModel model = GeneralUserInfoModel(
          id: element.id,
          followingDocId: element.data()['followingDocId'],
          fullName: element.data()['fullName'],
          uId: element.data()['uId'],
          image: element.data()['image'],
          jobTitle: element.data()['jobTitle'],
          date: element.data()['date'],
          isFollow: userId == element.data()['uId'] ? true : false,
        );

        if (userId == id) {
          currentUserFollowersList = [];
          currentUserFollowersList.add(model);
        } else {
          followersList = [];
          followersList.add(model);
        }

        if (userId == element.data()['uId']) {
          currentVisitedProfileData = model;
        }
      });

      emit(GetFollowersOfPersonSuccessState());
    }).catchError((error) {
      emit(GetFollowersOfPersonErrorState(error.toString()));
      print("err " + error.toString());
    });
  }

  List currentUserfollowingsIdList = [];

  // ------- Get following of person (from DB) -------
  Future getFollowingOfPerson({id}) async {
    emit(GetFollowingOfPersonLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('following')
        .orderBy('date', descending: true)
        .get()
        .then((followings) {
      // ------- Get following of current user (from DB) -------

      followings.docs.forEach((element) {
        GeneralUserInfoModel model = GeneralUserInfoModel(
          id: element.id,
          followingDocId: element.data()['followingDocId'],
          fullName: element.data()['fullName'],
          uId: element.data()['uId'],
          image: element.data()['image'],
          jobTitle: element.data()['jobTitle'],
          isFollow: true,
        );
        if (id == userId) {
          currentUserFollowingList = [];
          currentUserFollowingList.add(model);
          currentUserfollowingsIdList.add(element.data()['uId']);
        } else {
          followingList = [];
          followingList.add(model);
        }
      });

      emit(GetFollowingOfPersonSuccessState());
    }).catchError((error) {
      emit(GetFollowingOfPersonErrorState(error.toString()));
      print("err " + error.toString());
    });
  }

  // ------- Add Replay Note to (DB) -------
  // Future addReplayNoteToDBTable(context, replayNote, pollId, mainNoteId,
  //     {nestedNoteId}) async {
  //   if (nestedNoteId == null) {
  //     emit(UploadReplayNoteToDBLoadingState());
  //     List<NoteModel> model = [
  //       NoteModel(
  //         id: getRandomString(10) + DateTime.now().microsecond.toString(),
  //         note: replayNote,
  //         pollId: pollId,
  //         usersIdOfSupportNote: [],
  //         replais: [],
  //         publishDateTime: DateTime.now().toIso8601String(),
  //         author: userModel,
  //       )
  //     ];
  //     FirebaseFirestore.instance
  //         .collection('polls')
  //         .doc(pollId)
  //         .collection('notes')
  //         .doc(mainNoteId)
  //         .update({
  //       "replais": FieldValue.arrayUnion(List.from(model.map((e) => e.toMap())))
  //     }).then((value) {
  //       emit(UploadReplayNoteToDBSuccessState());
  //       getNotsOfPoll(pollId: pollId);
  //     }).catchError((error) {
  //       print("err " + error.toString());
  //       emit(UploadReplayNoteToDBFailedState(error.toString()));
  //     });
  //   } else {
  //     emit(UploadNestedReplayNoteToDBLoadingState());
  //     NoteModel model = NoteModel(
  //       id: getRandomString(10) + DateTime.now().microsecond.toString(),
  //       note: replayNote,
  //       pollId: pollId,
  //       usersIdOfSupportNote: [],
  //       replais: [],
  //       publishDateTime: DateTime.now().toIso8601String(),
  //       author: userModel,
  //     );
  //     FirebaseFirestore.instance
  //         .collection('polls')
  //         .doc(pollId)
  //         .collection('notes')
  //         .doc(mainNoteId)
  //         .get()
  //         .then((note) {
  //       List<NoteModel> replaies = [];
  //       if (note.data()!['replais'] != null) {
  //         note.data()!['replais'].forEach((element) {
  //           print(element);
  //           if (element['id'] == nestedNoteId) {
  //             element['replais']!.add(model);
  //           }

  //           replaies.add(NoteModel.fromJson(element));
  //         });
  //       }

  //       FirebaseFirestore.instance
  //           .collection("polls")
  //           .doc(pollId)
  //           .collection("notes")
  //           .doc(mainNoteId)
  //           .update({
  //         "replais":
  //             FieldValue.arrayUnion(List.from(replaies.map((e) => e.toMap())))
  //       }).then((value) {
  //         getNotsOfPoll(pollId: pollId);
  //         emit(UploadNestedReplayNoteToDBSuccessState());
  //       });

  //       print(replaies);
  //     }).catchError((error) {
  //       print("err " + error.toString());
  //       emit(UploadNestedReplayNoteToDBFailedState(error.toString()));
  //     });
  //   }
  // }

  // ------- Add nested Replay Note to (DB) -------
  // Future addNestedReplayNoteToDBTable(
  //     context, replayNote, pollId, mainNoteId, nestedNoteId) async {
  //   emit(UploadNestedReplayNoteToDBLoadingState());
  //   NoteModel model = NoteModel(
  //     note: replayNote,
  //     pollId: pollId,
  //     usersIdOfSupportNote: [],
  //     replais: [],
  //     publishDateTime: DateTime.now().toIso8601String(),
  //     author: userModel,
  //   );
  //   FirebaseFirestore.instance
  //       .collection('polls')
  //       .doc(pollId)
  //       .collection('notes')
  //       .doc(mainNoteId)
  //       .get()
  //       .then((note) {
  //     List replaies = [];
  //     note.data()!['replais'].forEach((NoteModel element) {
  //       if (element.id == nestedNoteId) {
  //         element.replais!.add(model);
  //       }

  //       replaies.add(element);
  //       FirebaseFirestore.instance
  //           .collection("polls")
  //           .doc(pollId)
  //           .collection("notes")
  //           .doc(mainNoteId)
  //           .update({"replais": FieldValue.arrayUnion(replaies)}).then((value) {
  //         emit(UploadNestedReplayNoteToDBSuccessState());
  //         getNotsOfPoll(pollId: pollId);
  //       });
  //     });
  //   }).catchError((error) {
  //     print("err " + error.toString());
  //     emit(UploadNestedReplayNoteToDBFailedState(error.toString()));
  //   });
  // }

  // ------- Toggle replaies Note -------
  // bool showReplaies = false;
  // void toggleNoteReplaies() {
  //   showReplaies = !showReplaies;
  //   emit(ToggleNoteReplaiesState());
  // }

  // ------------------------- Problems Zooooone ----------------------------

  // Get Trend Problems function
  Future getProblemsTrend() async {
    emit(GetTrendProblemsLoadingState());

    FirebaseFirestore.instance
        .collection('problems')
        .orderBy('publishDateTime', descending: true)
        .limit(20)
        .get()
        .then((value) {
      List<SolutionModel> allSolutionsList = [];
      trendProblemsList = [];
      value.docs.forEach((element) {
        int peopleSolutionsLength = element.data()['peopleSolutions'].length;
        int peopleSufferLength = element.data()['peopleSuffer'].length;
        DateTime date = DateTime.parse(element.data()['publishDateTime']);
        var differenceDate = DateTime.now().difference(date);

        if (element.data()['peopleSolutions'] != []) {
          element.data()['peopleSolutions'].forEach((value) {
            allSolutionsList.add(SolutionModel.fromJson(value));
          });
        }

        Map<String, dynamic> rowData = {
          "id": element.id,
          "caption": element.data()['caption'],
          'publishDateTime': element.data()['publishDateTime'],
          'imageUrl': element.data()['imageUrl'],
          'generalUserInfoModel': element.data()['generalUserInfoModel'],
          'notes': notesListOfProblem,
          'shares': element.data()['shares'],
          'usrId': element.data()['usrId'],
          'peopleSolutions': allSolutionsList,
          'peopleSuffer': element.data()['peopleSuffer'],
          'peopleShares': element.data()['peopleShares'],
          'isAnonymous': element.data()['isAnonymous'],
        };
        trendProblemsList.add(ProblemModel.fromJson(rowData));

        // Get polls in Last 3 days
        if (differenceDate.inDays <= 1) {
          // Level 1
          if (peopleSolutionsLength <= 8 &&
              peopleSolutionsLength >= 4 &&
              peopleSufferLength <= 150 &&
              peopleSufferLength >= 100) {
            // Level 2
          } else if (peopleSolutionsLength <= 16 &&
              peopleSolutionsLength >= 8 &&
              peopleSufferLength <= 300 &&
              peopleSufferLength >= 150) {
            // Level 3
          } else if (peopleSolutionsLength <= 32 &&
              peopleSolutionsLength >= 16 &&
              peopleSufferLength <= 450 &&
              peopleSufferLength >= 300) {
            // Level 4
          } else if (peopleSolutionsLength <= 48 &&
              peopleSolutionsLength >= 32 &&
              peopleSufferLength <= 600 &&
              peopleSufferLength >= 450) {}
        } else if (differenceDate.inDays <= 2) {
          // Level 1
          if (peopleSolutionsLength <= 48 &&
              peopleSolutionsLength >= 32 &&
              peopleSufferLength <= 600 &&
              peopleSufferLength >= 450) {
            // Level 2
          } else if (peopleSolutionsLength <= 64 &&
              peopleSolutionsLength >= 48 &&
              peopleSufferLength <= 750 &&
              peopleSufferLength >= 600) {
            // Level 3
          } else if (peopleSolutionsLength <= 80 &&
              peopleSolutionsLength >= 64 &&
              peopleSufferLength <= 900 &&
              peopleSufferLength >= 750) {
            // Level 4
          } else if (peopleSolutionsLength <= 96 &&
              peopleSolutionsLength >= 80 &&
              peopleSufferLength <= 1050 &&
              peopleSufferLength >= 900) {}
        } else if (differenceDate.inDays <= 3) {
          // Level 1
          if (peopleSolutionsLength <= 96 &&
              peopleSolutionsLength >= 80 &&
              peopleSufferLength <= 1050 &&
              peopleSufferLength >= 900) {
            // Level 2
          } else if (peopleSolutionsLength <= 112 &&
              peopleSolutionsLength >= 96 &&
              peopleSufferLength <= 1200 &&
              peopleSufferLength >= 1050) {
            // Level 3
          } else if (peopleSolutionsLength <= 128 &&
              peopleSolutionsLength >= 112 &&
              peopleSufferLength <= 1350 &&
              peopleSufferLength >= 1200) {
            // Level 4
          } else if (peopleSolutionsLength >= 128 &&
              peopleSufferLength >= 1350) {}
        }

        allSolutionsList = [];
      });
      emit(GetTrendProblemsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetTrendProblemsFailState(error.toString()));
    });
  }

  // ------- Get Problem notes (from DB) -------
  Future getNotsOfProblem({problemId}) async {
    emit(GetNotesOfProblemLoadingState());
    FirebaseFirestore.instance
        .collection('problems')
        .doc(problemId)
        .collection('notes')
        .orderBy('publishDateTime', descending: true)
        .get()
        .then((notes) {
      notesListOfProblem = [];
      if (notes.docs.isNotEmpty) {
        notes.docs.forEach((element) {
          NoteModel model = NoteModel(
            id: element.id,
            note: element.data()['note'],
            postId: element.data()['pollId'],
            usersIdOfSupportNote: List.from(
                element.data()['usersIdOfSupportNote'] != null
                    ? element.data()['usersIdOfSupportNote'].map((e) => e)
                    : []),
            replais: [],
            publishDateTime: element.data()['publishDateTime'],
            author:
                GeneralUserInfoModel.fromJson(element.data()['author'] ?? {}),
            publisher: GeneralUserInfoModel.fromJson(
                element.data()['publisher'] ?? {}),
          );

          notesListOfProblem.add(model);
        });

        allProblemsList.forEach((problem) {
          if (problem.id == problemId) {
            problem.notes = notesListOfProblem;
          }
        });
        notesListOfProblem = [];
      }
      emit(GetNotesOfProblemSuccessState());
    }).catchError((error) {
      emit(GetNotesOfProblemErrorState(error.toString()));
      print("err " + error.toString());
    });
  }

  // ------- Get Soltions of problem (from DB) -------
  Future getSolutionsOfProblem({problemId}) async {
    emit(GetSolutionsOfProblemLoadingState());
    FirebaseFirestore.instance
        .collection('problems')
        .doc(problemId)
        .get()
        .then((problem) {
      solutionsList = [];
      if (problem.data()!['peopleSolutions'].isNotEmpty) {
        problem.data()!['peopleSolutions'].forEach((value) {
          solutionsList.add(SolutionModel.fromJson(value));
        });

        allProblemsList.forEach((problem) {
          if (problem.id == problemId) {
            problem.peopleSolutions = solutionsList;
          }
        });
        print(solutionsList);
        solutionsList = [];
      }
      emit(GetSolutionsOfProblemSuccessState());
    }).catchError((error) {
      emit(GetSolutionsOfProblemErrorState(error.toString()));
      print("err " + error.toString());
    });
  }

  // ------- Get All Problems (from DB) -------
  Future getAllProblems() async {
    emit(GetAllProblemsDataLoadingState());
    FirebaseFirestore.instance
        .collection('problems')
        .orderBy('publishDateTime')
        .get()
        .then((problems) {
      List<SolutionModel> allSolutionsList = [];
      allPollsList = [];

      problems.docs.forEach((element) async {
        if (element.data()['peopleSolutions'] != []) {
          element.data()['peopleSolutions'].forEach((value) {
            allSolutionsList.add(SolutionModel.fromJson(value));
          });
        }

        Map<String, dynamic> rowData = {
          "id": element.id,
          "caption": element.data()['caption'],
          'publishDateTime': element.data()['publishDateTime'],
          'imageUrl': element.data()['imageUrl'],
          'generalUserInfoModel': element.data()['generalUserInfoModel'],
          'notes': notesListOfProblem,
          'shares': element.data()['shares'],
          'usrId': element.data()['usrId'],
          'peopleSolutions': allSolutionsList,
          'peopleSuffer': element.data()['peopleSuffer'],
          'peopleShares': element.data()['peopleShares'],
          'isAnonymous': element.data()['isAnonymous'],
        };
        allProblemsList.add(ProblemModel.fromJson(rowData));
        allSolutionsList = [];
      });
      emit(GetAllProblemsDataSuccessState());

      // Get Notes and solutions after content of main poll get!
      problems.docs.forEach((element) {
        getNotsOfProblem(problemId: element.id);
        getSolutionsOfProblem(problemId: element.id);
      });
    }).catchError((error) {
      emit(GetAllProblemsDataErrorState(error.toString()));
      print("err " + error.toString());
    });
  }

  // ------- Get All Problems for person (from DB) -------
  Future getAllProblemsForPerson(id) async {
    emit(GetAllProblemsForPersonDataLoadingState());
    FirebaseFirestore.instance
        .collection('problems')
        .where("usrId", isEqualTo: id)
        // .orderBy('publishDateTime')
        .get()
        .then((problems) {
      List<SolutionModel> allSolutionsList = [];
      personProblemsList = [];

      problems.docs.forEach((element) async {
        if (element.data()['peopleSolutions'] != []) {
          element.data()['peopleSolutions'].forEach((value) {
            allSolutionsList.add(SolutionModel.fromJson(value));
          });
        }

        Map<String, dynamic> rowData = {
          "id": element.id,
          "caption": element.data()['caption'],
          'publishDateTime': element.data()['publishDateTime'],
          'imageUrl': element.data()['imageUrl'],
          'generalUserInfoModel': element.data()['generalUserInfoModel'],
          'notes': notesListOfProblem,
          'shares': element.data()['shares'],
          'usrId': element.data()['usrId'],
          'peopleSolutions': allSolutionsList,
          'peopleSuffer': element.data()['peopleSuffer'],
          'peopleShares': element.data()['peopleShares'],
          'isAnonymous': element.data()['isAnonymous'],
        };
        personProblemsList.add(ProblemModel.fromJson(rowData));
        allSolutionsList = [];
      });
      emit(GetAllProblemsForPersonDataSuccessState());

      // Get Notes and solutions after content of main poll get!
      problems.docs.forEach((element) {
        getNotsOfProblem(problemId: element.id);
        getSolutionsOfProblem(problemId: element.id);
      });
    }).catchError((error) {
      emit(GetAllProblemsForPersonDataErrorState(error.toString()));
      print("err " + error.toString());
    });
  }

  // ------- Get Single Problem (from DB) -------
  Future getSingleProblem(id) async {
    emit(GetSingleProblemDataLoadingState());
    FirebaseFirestore.instance
        .collection('problems')
        .doc(id)
        .get()
        .then((problem) {
      List<SolutionModel> allSolutionsList = [];
      singleProblem = [];

      if (problem.data()!['peopleSolutions'] != []) {
        problem.data()!['peopleSolutions'].forEach((value) {
          allSolutionsList.add(SolutionModel.fromJson(value));
        });
      }

      Map<String, dynamic> rowData = {
        "id": problem.id,
        "caption": problem.data()!['caption'],
        'publishDateTime': problem.data()!['publishDateTime'],
        'imageUrl': problem.data()!['imageUrl'],
        'userModel': problem.data()!['userModel'],
        'notes': notesListOfProblem,
        'shares': problem.data()!['shares'],
        'usrId': problem.data()!['usrId'],
        'peopleSolutions': allSolutionsList,
        'peopleSuffer': problem.data()!['peopleSuffer'],
        'peopleShares': problem.data()!['peopleShares'],
        'isAnonymous': problem.data()!['isAnonymous'],
      };
      singleProblem.add(ProblemModel.fromJson(rowData));
      print(singleProblem);
      allSolutionsList = [];
      emit(GetSingleProblemDataSuccessState());

      // Get Notes and solutions after content of main problem get!
      getNotsOfProblem(problemId: problem.id);
      getSolutionsOfProblem(problemId: problem.id);
    }).catchError((error) {
      emit(GetSingleProblemDataErrorState(error.toString()));
      print("err " + error.toString());
    });
  }

  // ----------- Toggle Suffer React --------------------
  Future toggleSufferReact(ProblemModel problem, addOrRemove) async {
    FirebaseFirestore.instance.collection("problems").doc(problem.id).update({
      "peopleSuffer": List.from(problem.peopleSuffer!.map((e) => e)),
    }).then((value) {
      emit(ToggleSufferReactSuccessState());
      // if (poll.userModel.uId != userId and addOrRemove == "add") {
      if (addOrRemove == "add") {
        NotificationModel model = NotificationModel.withId(
          id: getRandomString(15).toString() +
              DateTime.now().microsecond.toString(),
          postOrAccountId: problem.id,
          title: "",
          body: userModel!.fullName! + " suffer as you '${problem.caption}'",
          notificationReaction: "suffer",
          notificationType: "problem",
          date: DateTime.now().toIso8601String(),
          payload: "",
          isOpen: 0,
        );
        FirebaseFirestore.instance
            .collection("users")
            .doc(problem.generalUserInfoModel!.uId)
            .collection("notifications")
            .add(model.toMap())
            .then((value) {
          print("done");
        }).catchError((err) {
          print(err.toString());
        });
      }
    }).catchError((err) {
      print(err.toString());
      emit(ToggleSufferReactFailState(err.toString()));
    });
  }

  // ----------- Toggle Support Solution React --------------------
  Future toggleSupportAndUnsupportSolutionReact(
      ProblemModel problem, supportOrNot) async {
    FirebaseFirestore.instance.collection("problems").doc(problem.id).update({
      "peopleSolutions":
          List.from(problem.peopleSolutions!.map((e) => e.toMap())),
    }).then((value) {
      emit(ToggleSupportSolutionReactSuccessState());
      // if (poll.userModel.uId != userId && supportOrNot) {
      if (supportOrNot) {
        NotificationModel model = NotificationModel.withId(
          id: getRandomString(15).toString() +
              DateTime.now().microsecond.toString(),
          postOrAccountId: problem.id,
          title: "",
          body: userModel!.fullName! +
              " support solution on problem '${problem.caption}'",
          notificationReaction: "support",
          notificationType: "problem",
          date: DateTime.now().toIso8601String(),
          payload: "",
          isOpen: 0,
        );
        FirebaseFirestore.instance
            .collection("users")
            .doc(problem.generalUserInfoModel!.uId)
            .collection("notifications")
            .add(model.toMap())
            .then((value) {
          print("done");
        }).catchError((err) {
          print(err.toString());
        });
      }
    }).catchError((err) {
      print(err.toString());
      emit(ToggleSupportSolutionReactFailState(err.toString()));
    });
  }

  // ------- Add Problem Note to (DB) -------
  Future addProblemNoteToDBTable(context, note, ProblemModel problem) async {
    emit(UploadProblemNoteToDBLoadingState());
    NoteModel model = NoteModel(
      note: note,
      postId: problem.id,
      usersIdOfSupportNote: [],
      replais: [],
      publishDateTime: DateTime.now().toIso8601String(),
      author: GeneralUserInfoModel(
        fullName: userModel!.fullName,
        uId: userModel!.uId,
        image: userModel!.image,
        jobTitle: userModel!.jobTitle,
      ),
      publisher: GeneralUserInfoModel(
        fullName: problem.generalUserInfoModel!.fullName,
        uId: problem.generalUserInfoModel!.uId,
        image: problem.generalUserInfoModel!.image,
        jobTitle: problem.generalUserInfoModel!.jobTitle,
      ),
    );
    FirebaseFirestore.instance
        .collection('problems')
        .doc(problem.id)
        .collection('notes')
        .add(model.toMap())
        .then((value) {
      emit(UploadProblemNoteToDBSuccessState());
      // if (poll.userModel.uId != userId) {
      NotificationModel model = NotificationModel.withId(
        id: getRandomString(15).toString() +
            DateTime.now().microsecond.toString(),
        postOrAccountId: problem.id,
        title: "",
        body: userModel!.fullName! + " added note '$note'",
        notificationReaction: "note",
        notificationType: "problem",
        date: DateTime.now().toIso8601String(),
        payload: "",
        isOpen: 0,
      );
      FirebaseFirestore.instance
          .collection("users")
          .doc(problem.generalUserInfoModel!.uId)
          .collection("notifications")
          .add(model.toMap())
          .then((value) {
        print("done");
      }).catchError((err) {
        print(err.toString());
      });
      // }
      getNotsOfProblem(problemId: problem.id);
    }).catchError((error) {
      print("err " + error.toString());
      emit(UploadProblemNoteToDBFailedState(error.toString()));
    });
  }

  // ------- Add solution -------
  Future publishSolution(context, solution, ProblemModel problem) async {
    emit(PublishSolutionLoadingState());
    List<SolutionModel> listModel = [
      SolutionModel(
        id: getRandomString(10) + DateTime.now().microsecond.toString(),
        solution: solution,
        image: '',
        problemId: problem.id,
        publishDateTime: DateTime.now().toIso8601String(),
        usersIdOfSupportSolution: [],
        usersIdOfInSupportSolution: [],
        author: userModel,
        isAnonymous: solutionIsAnonymous,
      ),
    ];

    FirebaseFirestore.instance.collection('problems').doc(problem.id).update({
      "peopleSolutions":
          FieldValue.arrayUnion(List.from(listModel.map((e) => e.toMap())))
    }).then((value) {
      emit(PublishSolutionSuccessState());
      solutionIsAnonymous = false;
      // if (poll.userModel.uId != userId) {
      NotificationModel model = NotificationModel.withId(
        id: getRandomString(15).toString() +
            DateTime.now().microsecond.toString(),
        postOrAccountId: problem.id,
        title: "",
        body: userModel!.fullName! +
            " added solution for your problem '$solution'",
        notificationReaction: "solution",
        notificationType: "problem",
        date: DateTime.now().toIso8601String(),
        payload: "",
        isOpen: 0,
      );
      FirebaseFirestore.instance
          .collection("users")
          .doc(problem.generalUserInfoModel!.uId)
          .collection("notifications")
          .add(model.toMap())
          .then((value) {
        print("done");
      }).catchError((err) {
        print(err.toString());
      });
      // }
      getSolutionsOfProblem(problemId: problem.id);
      Navigator.of(context).pop();
    }).catchError((error) {
      print("err " + error.toString());
      emit(PublishSolutionErrorState(error.toString()));
    });
  }

  // ----------- Add Share (Problem) to DB --------------------
  Future recordProblemShare(ProblemModel problem) async {
    FirebaseFirestore.instance
        .collection("problems")
        .doc(problem.id)
        .update({"shares": FieldValue.increment(1)}).then((value) {
      emit(ShareProblemRecordedSuccessState());
    }).catchError((err) {
      print(err.toString());
      emit(ShareProblemRecordedFailState(err.toString()));
    });
  }

  // ----------- For Solution (support & unsupport) --------------------
  Future updateSolution(ProblemModel problem) async {
    FirebaseFirestore.instance.collection("problems").doc(problem.id).update({
      "peopleSolutions": FieldValue.arrayUnion(
          List.from(problem.peopleSolutions!.map((e) => e.toMap())))
    }).then((value) {
      emit(VoteMarkedSuccessState());
    }).catchError((err) {
      print(err.toString());
      emit(VoteMarkedFailState(err.toString()));
    });
  }

  // ------------------------- Search Zooooone ----------------------------

  List<UserModel> searchList = [];
  // ------- Get All Polls for person (from DB) -------
  Future searchInUsersTbl(searchKey) async {
    emit(SearchInUserTblLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .where('fullName', isGreaterThanOrEqualTo: searchKey)
        .where('fullName', isLessThan: searchKey + '\uf8ff')
        .get()
        .then((data) {
      searchList = [];

      data.docs.forEach((element) async {
        searchList.add(UserModel.fromJson(element.data()));
      });
      emit(SearchInUserTblSuccessState());
    }).catchError((error) {
      emit(SearchInUserTblErrorState(error.toString()));
      print("err " + error.toString());
    });
  }

  // ------------------------- Notifications Zooooone ----------------------------

  // ------- Get notifications (from DB) -------
  Future getNotifications() async {
    emit(GetNotificationsLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('date', descending: true)
        .get()
        .then((notifications) {
      notificationsList = [];
      notifications.docs.forEach((element) {
        NotificationModel model = NotificationModel.withId(
          id: element.id,
          postOrAccountId: element.data()['postOrAccountId'],
          title: element.data()['title'],
          body: element.data()['body'],
          notificationReaction: element.data()['notificationReaction'],
          notificationType: element.data()['notificationType'],
          date: element.data()['date'],
          payload: element.data()['payload'],
          isOpen: element.data()['isOpen'],
        );
        notificationsList.add(NotificationModel.fromMap(model.toMap()));
      });
      print(notificationsList);
      emit(GetNotificationsSuccessState());
    }).catchError((error) {
      emit(GetNotificationsErrorState(error.toString()));
      print("err " + error.toString());
    });
  }

  // ----------- Update Notification (Mark Notification As Opened) --------------------
  Future markNotificationAsOpened(notificationId) async {
    emit(MarkNotificationAsOpenedLoadingState());

    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("notifications")
        .doc(notificationId)
        .update({"isOpen": 1}).then((value) {
      emit(MarkNotificationAsOpenedSuccessState());
    }).catchError((err) {
      print(err.toString());
      emit(MarkNotificationAsOpenedFailState(err.toString()));
    });
  }

  // ------------------------- User Zooooone ----------------------------

  // ------------------ login & resgister & signOut -------------------------
  IconData suffix = Icons.visibility_off_outlined;
  bool isPassword = true;
  // ------- Change Password Visibility -------
  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;

    emit(ChangePasswordVisibilityState());
  }

  // ------- User Register -------
  void userRegister({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AppRegisterLoadingState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      createUser(
        uId: value.user!.uid,
        name: name,
        email: email,
        password: password,
      );
    }).catchError((error) {
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          error = "Email already used. Go to login page.";
          print(error);
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          error = "Wrong email/password combination.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          error = "No user found with this email.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          error = "User disabled.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          error = "Too many requests to log into this account.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          error = "Server error, please try again later.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          error = "Email address is invalid.";
          emit(AppRegisterErrorState(error));
          break;
        default:
          error = "Register failed. Please try again.";
          emit(AppRegisterErrorState(error));
          break;
      }
      print(error.toString());
      emit(AppRegisterErrorState(error.toString()));
    });
  }

  // ------- Create New User -------
  Future createUser({
    required String name,
    required String email,
    required String password,
    required String uId,
  }) async {
    //Returns the default FCM token for this device.
    final String? _getToken = await FirebaseMessaging.instance.getToken();

    UserModel model = UserModel(
      fullName: name,
      email: email,
      password: password,
      phone: "",
      uId: uId,
      image: "",
      cover: "",
      jobTitle: "",
      bio: "",
      birthDate: "",
      age: null,
      country: "",
      isEmailVerified: false,
      date: DateTime.now().toIso8601String(),
      token: _getToken,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId.toString())
        .set(model.toMap())
        .then((value) {
      emit(AppRegisterSuccessState(uId.toString()));
    }).catchError((error) {
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          error = "Email already used. Go to login page.";
          print(error);
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          error = "Wrong email/password combination.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          error = "No user found with this email.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          error = "User disabled.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          error = "Too many requests to log into this account.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          error = "Server error, please try again later.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          error = "Email address is invalid.";
          emit(AppRegisterErrorState(error));
          break;
        default:
          error = "Register failed. Please try again.";
          emit(AppRegisterErrorState(error));
          break;
      }
      print(error.toString());
    });
  }

  // ------- User Login -------
  void userLogin({
    required String email,
    required String password,
  }) {
    emit(AppLoginLoadingState());

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.toString());
      emit(AppLoginSuccessState(value.user!.uid));
    }).catchError((error) {
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          error = "Email already used. Go to login page.";
          print(error);
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          error = "Wrong email/password combination.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          error = "No user found with this email.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          error = "User disabled.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          error = "Too many requests to log into this account.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          error = "Server error, please try again later.";
          emit(AppRegisterErrorState(error));
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          error = "Email address is invalid.";
          emit(AppRegisterErrorState(error));
          break;
        default:
          error = "Register failed. Please try again.";
          emit(AppRegisterErrorState(error));
          break;
      }
      print(error.toString());
      emit(AppLoginErrorState(error.toString()));
    });
  }

  // ------- Reset Password -------
  Future resetPassword(email) async {
    emit(ResetPasswordLoading());
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((value) {
      emit(ResetPasswordSuccessful());
    }).catchError((error) {
      emit(ResetPasswordFailed(error.toString()));
    });
  }

  // ------- SignOut -------
  Future signOut(context) async {
    var isSignWith = CacheHelper.getData(key: "isLoginWith");

    emit(SignoutLoading());
    CacheHelper.removeData(
      key: CacheHelperKeys.userIdKey,
    ).then((value) async {
      FirebaseAuth.instance.signOut();
      userModel = null;
      userId = "";
      showCustomSnackBar(context,
          content: "Signout Successfully",
          bgColor: Colors.green,
          textColor: Colors.white);
      navigateTo(
        context,
        LoginScreen(),
      );

      emit(SignoutSuccessful());
    }).catchError((err) {
      print(err.toString());
    });
  }

  // ----------------------- Additional User Info Screen -------------------------

  int selectedValueOfGender = 1; // Default
  void getSelectedValueOfGender(val) {
    selectedValueOfGender = val!;
    emit(GetSelectedValueOGender());
  }

  String birthDate = 'Date of birth';
  int age = -1;
  String userCountry = 'Country';

  selectDateOfBirth(BuildContext context) async {
    DatePicker.showDatePicker(context, locale: LocaleType.en,
        onConfirm: (selectedDate) {
      // selected date from user
      birthDate = DateFormat("yyyy-MM-dd").format(selectedDate);
      DateTime birthDateAsDateTime = DateTime.parse(birthDate);

      // Current date
      DateTime now = DateTime.now();
      var currentDateAsString = DateFormat("yyyy-MM-dd").format(now);
      DateTime currentDateAsDateTime = DateTime.parse(currentDateAsString);

      if (birthDateAsDateTime.isAfter(currentDateAsDateTime)) {
        birthDate = 'Date of birth';
        emit(SelectDateOfBirthAfterNow());
      } else {
        birthDate = DateFormat("yyyy-MM-dd").format(selectedDate);
        calculateAge(selectedDate);
        emit(SelectDateOfBirthSuccessfuly());
      }
    });
  }

  // function to calc age
  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  // country picker
  countryPicker(context) {
    showCountryPicker(
        context: context,
        countryListTheme: CountryListThemeData(
          flagSize: 25,
          backgroundColor: Colors.white,
          textStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
          bottomSheetHeight: 500, // Optional. Country list modal height
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          //Optional. Styles the search field.
          inputDecoration: InputDecoration(
            labelText: 'Search',
            hintText: 'Search about your country ..',
            labelStyle: TextStyle(color: Colors.grey),
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                color: const Color(0xFF8C98A8).withOpacity(0.2),
              ),
            ),
          ),
        ),
        onSelect: (Country country) {
          userCountry = country.displayNameNoCountryCode;
          print('Select country: ${country.displayName}');
          emit(UserCountryPickerSuccessState());
        });
  }

  // Save Additional User Info
  Future saveAdditionalUserInfo(String jobTitle) async {
    emit(SaveAdditionalUserInfoLoadingState());
    if (jobTitle.isNotEmpty &&
        birthDate != "Date of birth" &&
        age > -1 &&
        userCountry != "Country") {
      FirebaseFirestore.instance.collection("users").doc(userId).update({
        "jobTitle": jobTitle,
        "age": age,
        "birthDate": birthDate,
        "country": userCountry,
      }).then((value) {
        emit(SaveAdditionalUserInfoSuccessState());
      }).catchError((error) {
        emit(SaveAdditionalUserInfoErrorState(error.toString()));
        print(error.toString());
      });
    } else {
      emit(SomeInfoNotExistState());
    }
  }

  //sending media files to connection
  Future<String?> uploadMediaToStorage(File filePath,
      {required String reference}) async {
    try {
      String? downLoadUrl;

      final String fileName =
          '${FirebaseAuth.instance.currentUser!.uid}${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}';

      final Reference firebaseStorageRef =
          FirebaseStorage.instance.ref(reference).child(fileName);

      print('Firebase Storage Reference: $firebaseStorageRef');

      final UploadTask uploadTask = firebaseStorageRef.putFile(filePath);

      await uploadTask.whenComplete(() async {
        print("Media Uploaded");
        downLoadUrl = await firebaseStorageRef.getDownloadURL();
        print("Download Url: $downLoadUrl}");
      });

      return downLoadUrl!;
    } catch (e) {
      print("Error: Firebase Storage Exception is: ${e.toString()}");
      return null;
    }
  }

  Future updateUserInfo(userId, {email, username, password, whoIs}) async {
    emit(UpdatetUserDataLoadingState());
    FirebaseFirestore.instance.collection("users").doc(userId).update({
      "username": username,
      "email": email,
      "password": password,
      "whoIs": whoIs,
    }).then((value) {
      // userInfo(userId);
      emit(UpdatetUserDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(UpdatetUserDataErrorState(error.toString()));
    });
  }
}
