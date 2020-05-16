
class User{
  String userId;
  String email;
  String name;
  bool isAdmin;

  User({this.name, this.userId, this.email, this.isAdmin});

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['name'] = this.name;
    map['userId'] = this.userId;
    map['email'] = this.email;
    map['isAdmin'] = this.isAdmin;
    return map;
  }

}