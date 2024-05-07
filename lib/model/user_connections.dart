class UserModel {
  final int id;
  final String username;
  final String email;
  final String? profileImage;
  final String? profileCoverImage;
  final String phoneNumber;
  final bool isGoogle;
  final List<Connection> connections;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.profileImage,
    this.profileCoverImage,
    required this.phoneNumber,
    required this.isGoogle,
    required this.connections,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    var list = json['connections'] as List;
    List<Connection> connectionList =
        list.map((i) => Connection.fromJson(i)).toList();
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      profileImage: json['profile_image'],
      profileCoverImage: json['profile_cover_image'],
      phoneNumber: json['phone_number'],
      isGoogle: json['is_google'],
      connections: connectionList,
    );
  }
}

class Connection {
  final int id;
  final String username;
  final String email;
  final String? profileImage;
  final String? profileCoverImage;
  final String phoneNumber;
  final bool isGoogle;

  Connection({
    required this.id,
    required this.username,
    required this.email,
    this.profileImage,
    this.profileCoverImage,
    required this.phoneNumber,
    required this.isGoogle,
  });

  factory Connection.fromJson(Map<String, dynamic> json) {
    return Connection(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      profileImage: json['profile_image'],
      profileCoverImage: json['profile_cover_image'],
      phoneNumber: json['phone_number'],
      isGoogle: json['is_google'],
    );
  }
}

class UsersList {
  final List<UserModel> users;

  UsersList({required this.users});

  factory UsersList.fromJson(List<dynamic> parsedJson) {
    List<UserModel> users =
        parsedJson.map((i) => UserModel.fromJson(i)).toList();
    return UsersList(users: users);
  }
}
