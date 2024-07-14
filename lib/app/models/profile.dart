import 'package:nylo_framework/nylo_framework.dart';

class Profile extends Model {
  String? id;
  String? username;
  String? fullName;

  Profile({
    this.id,
    this.username,
    this.fullName,
  });

  Profile.fromJson(dynamic data) {
    id = data['id'];
    username = data['username'];
    fullName = data['full_name'];
  }
}
