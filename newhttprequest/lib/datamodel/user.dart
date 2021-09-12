import 'package:json_annotation/json_annotation.dart';

import '../inetwork_model.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends INetworkModel<User> {
  final int? userId;
  final int? id;
  final String? title;
  final bool? completed;
  User({
    this.userId,
    this.id,
    this.title,
    this.completed,
  });

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  User fromJson(Map<String, dynamic> json) {
    return _$UserFromJson(json);
  }

  @override
  String toString() {
    return 'User(userId: $userId, id: $id, title: $title, completed: $completed)';
  }
}
