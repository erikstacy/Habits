import 'services.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


/// Static global state. Immutable services that do not care about build context. 
class Global {
  // App Data
  static final String title = 'Fireship';

  // Services
  static final FirebaseAnalytics analytics = FirebaseAnalytics();

  // Data Models
  static final Map models = {
    UserProfile: (data) => UserProfile.fromMap(data),
  };

  // Firestore References for Writes
  static final UserData<UserProfile> userProfileRef = UserData<UserProfile>(collection: 'users');

}