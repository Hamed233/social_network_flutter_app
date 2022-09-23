abstract class AppStates {}

// --------- MAIN APP --------
class ChangePasswordVisibilityState extends AppStates {}

class AppInitialState extends AppStates {}

class AppChangeModeState extends AppStates {}

class AppChangeBottomNavState extends AppStates {}

class ProfileChangeTabNavState extends AppStates {}

class ChangeTrendTabState extends AppStates {}

class AddDecisionOptionState extends AppStates {}

class RemoveDecisionOptionState extends AppStates {}

class PreviousDataOfPollCleanedSuccessState extends AppStates {}

class TogglePollIsAnonymousState extends AppStates {}

class GetSelectedValueOGender extends AppStates {}

class SelectDateOfBirthSuccessfuly extends AppStates {}

class SelectDateOfBirthAfterNow extends AppStates {}

class GetNotesOfProblemLoadingState extends AppStates {}

class GetNotesOfProblemSuccessState extends AppStates {}

class GetNotesOfProblemErrorState extends AppStates {
  late final String error;
  GetNotesOfProblemErrorState(this.error);
}

class GetAllProblemsDataLoadingState extends AppStates {}

class GetAllProblemsDataSuccessState extends AppStates {}

class GetAllProblemsDataErrorState extends AppStates {
  late final String error;
  GetAllProblemsDataErrorState(this.error);
}

class GetTrendPollsSuccessState extends AppStates {}

class GetTrendPollsLoadingState extends AppStates {}

class GetTrendPollsFailState extends AppStates {
  late final String error;
  GetTrendPollsFailState(this.error);
}

class GetTrendProblemsSuccessState extends AppStates {}

class GetTrendProblemsLoadingState extends AppStates {}

class GetTrendProblemsFailState extends AppStates {
  late final String error;
  GetTrendProblemsFailState(this.error);
}

class GetAllPollsDataForPersonLoadingState extends AppStates {}

class GetAllPollsDataForPersonSuccessState extends AppStates {}

class GetAllPollsDataForPersonErrorState extends AppStates {
  late final String error;
  GetAllPollsDataForPersonErrorState(this.error);
}

class GetAllProblemsForPersonDataLoadingState extends AppStates {}

class GetAllProblemsForPersonDataSuccessState extends AppStates {}

class GetAllProblemsForPersonDataErrorState extends AppStates {
  late final String error;
  GetAllProblemsForPersonDataErrorState(this.error);
}

class GetCurrentInfoAboutUserLoadingState extends AppStates {}

class GetCurrentInfoAboutUserSuccessState extends AppStates {}

class GetCurrentInfoAboutUserErrorState extends AppStates {
  late final String error;
  GetCurrentInfoAboutUserErrorState(this.error);
}

class GetCurrentProblemsReactionsAboutUserLoadingState extends AppStates {}

class GetCurrentProblemsReactionsAboutUserSuccessState extends AppStates {}

class GetCurrentProblemsReactionsAboutUserErrorState extends AppStates {
  late final String error;
  GetCurrentProblemsReactionsAboutUserErrorState(this.error);
}

class SearchInUserTblLoadingState extends AppStates {}

class SearchInUserTblSuccessState extends AppStates {}

class SearchInUserTblErrorState extends AppStates {
  late final String error;
  SearchInUserTblErrorState(this.error);
}

class GetNotificationsLoadingState extends AppStates {}

class GetNotificationsSuccessState extends AppStates {}

class GetNotificationsErrorState extends AppStates {
  late final String error;
  GetNotificationsErrorState(this.error);
}

class GetSingleProblemDataLoadingState extends AppStates {}

class GetSingleProblemDataSuccessState extends AppStates {}

class GetSingleProblemDataErrorState extends AppStates {
  late final String error;
  GetSingleProblemDataErrorState(this.error);
}

class FollowPersonLoadingState extends AppStates {}

class FollowPersonSuccessState extends AppStates {}

class FollowPersonFailedState extends AppStates {
  late final String error;
  FollowPersonFailedState(this.error);
}

class AddPersonToFollowingLoadingState extends AppStates {}

class AddPersonToFollowingSuccessState extends AppStates {}

class AddPersonToFollowingFailedState extends AppStates {
  late final String error;
  AddPersonToFollowingFailedState(this.error);
}

class ToggleIsFollowSuccessState extends AppStates {}
class DeletePersonToFollowingLoadingState extends AppStates {}

class DeletePersonToFollowingSuccessState extends AppStates {}

class DeletePersonToFollowingFailedState extends AppStates {
  late final String error;
  DeletePersonToFollowingFailedState(this.error);
}

class GetAllPollsDataOfSameCountryLoadingState extends AppStates {}

class GetAllPollsDataOfSameCountrySuccessState extends AppStates {}

class GetAllPollsDataOfSameCountryErrorState extends AppStates {
  late final String error;
  GetAllPollsDataOfSameCountryErrorState(this.error);
}

class GetAllPollsDataOfFollowingLoadingState extends AppStates {}

class GetAllPollsDataOfFollowingSuccessState extends AppStates {}


class StartedLoadFollowingPollsAsFirstState extends AppStates {}

class FinishedLoadFollowingPollsAsFirstState extends AppStates {}


class StartedLoadMorePollsFromSameCountryState extends AppStates {}

class FinishedLoadMorePollsFromSameCountryState extends AppStates {}

class StartedLoadMorePollsFromDifferentCountryState extends AppStates {}

class FinishedLoadMorePollsFromDifferentCountryState extends AppStates {}

class GetAllPollsDataOfFollowingErrorState extends AppStates {
  late final String error;
  GetAllPollsDataOfFollowingErrorState(this.error);
}

class SharePollRecordedSuccessState extends AppStates {}

class SharePollRecordedFailState extends AppStates {
  late final String error;
  SharePollRecordedFailState(this.error);
}

class ShareProblemRecordedSuccessState extends AppStates {}

class ShareProblemRecordedFailState extends AppStates {
  late final String error;
  ShareProblemRecordedFailState(this.error);
}

class GetFollowersOfPersonLoadingState extends AppStates {}

class GetFollowersOfPersonSuccessState extends AppStates {}

class GetFollowersOfPersonErrorState extends AppStates {
  late final String error;
  GetFollowersOfPersonErrorState(this.error);
}

class GetFollowersOfCurrentUserLoadingState extends AppStates {}


class GetFollowingOfPersonLoadingState extends AppStates {}

class GetFollowingOfPersonSuccessState extends AppStates {}

class GetFollowingOfPersonErrorState extends AppStates {
  late final String error;
  GetFollowingOfPersonErrorState(this.error);
}

class NotificationSendSuccessState extends AppStates {}

class NotificationSendFailedState extends AppStates {
  late final String error;
  NotificationSendFailedState(this.error);
}

class GetPersonProfileDataLoadingState extends AppStates {}

class GetPersonProfileDataSuccessState extends AppStates {}

class GetPersonProfileDataErrorState extends AppStates {
  late final String error;
  GetPersonProfileDataErrorState(this.error);
}

class UnfollowPersonLoadingState extends AppStates {}

class UnfollowPersonSuccessState extends AppStates {}

class UnfollowPersonFailedState extends AppStates {
  late final String error;
  UnfollowPersonFailedState(this.error);
}

class GetSinglePollDataLoadingState extends AppStates {}

class GetSinglePollDataSuccessState extends AppStates {}

class GetSinglePollDataErrorState extends AppStates {
  late final String error;
  GetSinglePollDataErrorState(this.error);
}

class MarkNotificationAsOpenedLoadingState extends AppStates {}

class MarkNotificationAsOpenedSuccessState extends AppStates {}

class MarkNotificationAsOpenedFailState extends AppStates {
  late final String error;
  MarkNotificationAsOpenedFailState(this.error);
}

class GetSolutionsOfProblemLoadingState extends AppStates {}

class GetSolutionsOfProblemSuccessState extends AppStates {}

class GetSolutionsOfProblemErrorState extends AppStates {
  late final String error;
  GetSolutionsOfProblemErrorState(this.error);
}

class BottomNavigationIsVisible extends AppStates {}

class SaveAdditionalUserInfoLoadingState extends AppStates {}

class SaveAdditionalUserInfoSuccessState extends AppStates {}

class SomeInfoNotExistState extends AppStates {}

class SaveAdditionalUserInfoErrorState extends AppStates {
  late final String error;
  SaveAdditionalUserInfoErrorState(this.error);
}

class GettingNotificationsLoading extends AppStates {}

class GettingNotificationsDone extends AppStates {}

class NotificationsOpendIsLoading extends AppStates {}

class NotificationsIsOpend extends AppStates {}

// Login & Register & User Data
class AppLoginSuccessState extends AppStates {
  final String uId;
  AppLoginSuccessState(this.uId);
}

class AppLoginLoadingState extends AppStates {}

class AppLangChangedState extends AppStates {}

class AppLoginErrorState extends AppStates {
  late final String error;
  AppLoginErrorState(this.error);
}

class SignInWithGoogleLoading extends AppStates {}

class SignInWithGoogleSuccessful extends AppStates {}

class SignInWithGoogleFailed extends AppStates {
  final String error;
  SignInWithGoogleFailed(this.error);
}

class SignInWithFBLoading extends AppStates {}

class SignInWithFBSuccessful extends AppStates {}

class SignInWithFBFailed extends AppStates {
  final String error;
  SignInWithFBFailed(this.error);
}

class ResetPasswordLoading extends AppStates {}

class ResetPasswordSuccessful extends AppStates {}

class ResetPasswordFailed extends AppStates {
  final String error;
  ResetPasswordFailed(this.error);
}

class SignInWithTwitterLoading extends AppStates {}

class SignInWithTwitterSuccessful extends AppStates {}

class SignInWithTwitterFailed extends AppStates {
  final String error;
  SignInWithTwitterFailed(this.error);
}

class ToggleSufferReactFailState extends AppStates {
  final String error;
  ToggleSufferReactFailState(this.error);
}

class ToggleSufferReactSuccessState extends AppStates {}

class UploadProblemLoadingState extends AppStates {}

class UploadProblemSuccessState extends AppStates {}

class UploadProblemFailedState extends AppStates {
  final String error;
  UploadProblemFailedState(this.error);
}

class UploadPollLoadingState extends AppStates {}

class UploadPollSuccessState extends AppStates {}

class UploadPollFailedState extends AppStates {
  final String error;
  UploadPollFailedState(this.error);
}

class UploadProblemNoteToDBLoadingState extends AppStates {}

class UploadProblemNoteToDBSuccessState extends AppStates {}

class UploadProblemNoteToDBFailedState extends AppStates {
  final String error;
  UploadProblemNoteToDBFailedState(this.error);
}

class PublishSolutionLoadingState extends AppStates {}

class PublishSolutionSuccessState extends AppStates {}

class PublishSolutionErrorState extends AppStates {
  final String error;
  PublishSolutionErrorState(this.error);
}

class ToggleSupportSolutionReactSuccessState extends AppStates {}

class ToggleSupportSolutionReactFailState extends AppStates {
  final String error;
  ToggleSupportSolutionReactFailState(this.error);
}



class ToggleSolutionIsAnonymousState extends AppStates {}
class UploadReplayNoteToDBLoadingState extends AppStates {}

class UploadReplayNoteToDBSuccessState extends AppStates {}

class UploadReplayNoteToDBFailedState extends AppStates {
  final String error;
  UploadReplayNoteToDBFailedState(this.error);
}

class UploadNestedReplayNoteToDBLoadingState extends AppStates {}

class UploadNestedReplayNoteToDBSuccessState extends AppStates {}

class UploadNestedReplayNoteToDBFailedState extends AppStates {
  final String error;
  UploadNestedReplayNoteToDBFailedState(this.error);
}

class GetNotesOfPollLoadingState extends AppStates {}

class GetNotesOfPollSuccessState extends AppStates {}

class GetNotesOfPollErrorState extends AppStates {
  final String error;
  GetNotesOfPollErrorState(this.error);
}

class GetBetterDecisionsOfPollLoadingState extends AppStates {}

class GetBetterDecisionsOfPollSuccessState extends AppStates {}

class GetBetterDecisionsOfPollErrorState extends AppStates {
  final String error;
  GetBetterDecisionsOfPollErrorState(this.error);
}

class ToggleNoteReplaiesState extends AppStates {}

class SignoutLoading extends AppStates {}

class SignoutSuccessful extends AppStates {}

class UploadImagePickedLoadingState extends AppStates {}

class UploadImagePickedSuccessState extends AppStates {}

class UploadImagePickedErrorState extends AppStates {}

class ImagePickedSuccessState extends AppStates {}

class ImagePickedLoadingState extends AppStates {}

class ImagePickedFailedState extends AppStates {}

// Get User Data
class GetUserDataSuccessState extends AppStates {}

class GetUserDataLoadingState extends AppStates {}

class GetUserDataErrorState extends AppStates {
  late final String error;
  GetUserDataErrorState(this.error);
}

class PickDecisionsImageLoadingState extends AppStates {}

class PickDecisionsImagePickedSuccessState extends AppStates {}

class PickDecisionsImagePickedFailedState extends AppStates {}

class GetAllPollsDataLoadingState extends AppStates {}

class GetAllPollsDataSuccessState extends AppStates {}

class GetAllPollsDataErrorState extends AppStates {
  late final String error;
  GetAllPollsDataErrorState(this.error);
}

class VoteMarkedSuccessState extends AppStates {}

class VoteMarkedFailState extends AppStates {
  late final String error;
  VoteMarkedFailState(this.error);
}

class ToggleSupportReactSuccessState extends AppStates {}

class ToggleSupportReactFailState extends AppStates {
  late final String error;
  ToggleSupportReactFailState(this.error);
}

class UploadNoteToDBLoadingState extends AppStates {}

class UploadNoteToDBSuccessState extends AppStates {}

class UploadNoteToDBFailedState extends AppStates {
  late final String error;
  UploadNoteToDBFailedState(this.error);
}

class UpdatetUserDataLoadingState extends AppStates {}

class UpdatetUserDataSuccessState extends AppStates {}

class UpdatetUserDataErrorState extends AppStates {
  late final String error;
  UpdatetUserDataErrorState(this.error);
}

// Register
class AppRegisterSuccessState extends AppStates {
  final String uId;
  AppRegisterSuccessState(this.uId);
}

class AppRegisterLoadingState extends AppStates {}

class AppRegisterErrorState extends AppStates {
  late final String error;
  AppRegisterErrorState(this.error);
}

class GettingGeneralDataLoading extends AppStates {}

class RetrieveGeneralDataFromDatabase extends AppStates {}

class UserCountryPickerSuccessState extends AppStates {}
