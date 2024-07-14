// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:nylo_framework/nylo_framework.dart';

class Report extends Model {
  String? id;
  String? userId;
  String? content;
  DateTime? createdAt;

  Report({
    this.id,
    this.userId,
    this.content,
    this.createdAt,
  });

  Report.fromJson(dynamic data) {
    id = data['id'];
    userId = data['user_id'];
    content = data['content'];
    createdAt =
        data['created_at'] == null ? null : DateTime.parse(data['created_at']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'user_id': userId,
      'content': content,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
