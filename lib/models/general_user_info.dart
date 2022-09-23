class GeneralUserInfoModel
{
  String? id;
  String? uId;
  String? followingDocId;
  String? fullName;
  String? image;
  String? jobTitle;
  String? date;
  bool? isFollow;

  GeneralUserInfoModel({
    this.id,
    this.uId,
    this.fullName,
    this.followingDocId,
    this.image,
    this.jobTitle,
    this.date,
    this.isFollow = false,
  });

  GeneralUserInfoModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    followingDocId = json['followingDocId'];
    fullName = json['fullName'];
    image = json['image'];
    jobTitle = json['jobTitle'];
    date = json['date'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uId' : uId,
      'followingDocId' : followingDocId,
      'fullName' : fullName,
      'jobTitle' : jobTitle,
      'image' : image,
      'date' : date,
    };
  }
}