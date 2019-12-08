
// Database Collections

class UserProfile {
  String uid;

  UserProfile({ this.uid });

  factory UserProfile.fromMap(Map data) {
    return UserProfile(
      uid: data['uid'],
    );
  }
}