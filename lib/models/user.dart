class UserModel
{
  String? uId;
  String? fullName;
  String? email;
  String? password;
  String? phone;
  String? image;
  String? cover;
  String? jobTitle;
  String? bio;
  String? birthDate;
  int? age;
  String? country;
  String? date;
  String? token;
  bool isEmailVerified = false;

  UserModel({
    this.fullName,
    this.email,
    this.password,
    this.phone,
    this.uId,
    this.image,
    this.cover,
    this.jobTitle,
    this.bio,
    this.birthDate,
    this.age,
    this.country,
    this.date,
    this.token,
    this.isEmailVerified = false,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    uId = json['uId'];
    image = json['image'];
    cover = json['cover'];
    jobTitle = json['jobTitle'];
    bio = json['bio'];
    birthDate = json['birthDate'];
    age = json['age'];
    country = json['country'];
    date = json['date'];
    token = json['token'];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName' : fullName,
      'email' : email,
      'password' : password,
      'phone' : phone,
      'image' : image,
      'cover' : cover,
      'jobTitle' : jobTitle,
      'bio' : bio,
      'birthDate' : birthDate,
      'age' : age,
      'country' : country,
      'uId' : uId,
      'date' : date,
      'token' : token,
      'isEmailVerified' : isEmailVerified,
    };
  }
}