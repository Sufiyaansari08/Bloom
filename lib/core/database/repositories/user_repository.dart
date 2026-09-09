import '../app_database.dart';

class UserRepository {
  final AppDatabase _db;

  UserRepository(this._db);

  Future<UserProfile?> getUserProfile() async {
    return (_db.select(_db.userProfiles)
          ..where((t) => t.isDeleted.equals(false))
          ..limit(1))
        .getSingleOrNull();
  }

  Stream<UserProfile?> watchUserProfile() {
    return (_db.select(_db.userProfiles)
          ..where((t) => t.isDeleted.equals(false))
          ..limit(1))
        .watchSingleOrNull();
  }

  Future<void> saveUserProfile(UserProfilesCompanion profile) async {
    await _db.into(_db.userProfiles).insertOnConflictUpdate(profile);
  }
}
