class UserModel{
  String? name;
  String? id;
  String? phone;
  String? childEmail;
  String? parentEmail;
  String? type;
  String? profilePic;

  UserModel({
    this.name,
    this.id,
    this.childEmail,
    this.parentEmail,
    this.phone,
    this.profilePic,
    this.type,
});

  Map<String,dynamic> toJson() => {
    'name' : name,
    'id' : id,
    'phone' : phone,
    'childEmail' : childEmail,
    'parentEmail' : parentEmail,
    'type': type,
    'profilePic': profilePic
  };
}