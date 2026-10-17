import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:bloom/core/database/app_database.dart';
import 'package:bloom/core/database/database_providers.dart';
import 'package:bloom/core/database/repositories/user_repository.dart';
import 'package:bloom/features/profile/presentation/pages/profile_page.dart';
import 'package:bloom/features/profile/presentation/pages/edit_profile_page.dart';

void main() {
  UserProfile createTestUser({
    String name = 'Zoya Patel',
    double? height = 165.0,
    double? weight = 58.0,
    String? bloodGroup = 'B+',
  }) {
    return UserProfile(
      id: 'test_user_id',
      name: name,
      email: 'zoya@example.com',
      dateOfBirth: DateTime(2000, 5, 15),
      heightCm: height,
      weightKg: weight,
      bloodGroup: bloodGroup,
      avgCycleLength: 28,
      avgPeriodLength: 5,
      periodPredictionEnabled: true,
      ovulationPredictionEnabled: true,
      fertileWindowEnabled: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isSynced: false,
      isDeleted: false,
    );
  }

  group('Edit Profile Health Details Tests', () {
    testWidgets('ProfilePage retains clean original layout with My Profile settings tile', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final testUser = createTestUser(
        height: 165.0,
        weight: 58.0,
        bloodGroup: 'B+',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProfileStreamProvider.overrideWith((ref) => Stream.value(testUser)),
          ],
          child: const MaterialApp(
            home: ProfilePage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Zoya Patel'), findsOneWidget);
      expect(find.text('zoya@example.com'), findsOneWidget);
      expect(find.text('My Profile'), findsOneWidget);
      expect(find.text('App Settings'), findsOneWidget);
      expect(find.text('Log out'), findsOneWidget);
    });

    testWidgets('EditProfilePage renders Name, DOB, Email, Phone, Height, Weight, and Blood Group edit options', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final testUser = createTestUser(
        height: 168.0,
        weight: 62.0,
        bloodGroup: 'O+',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProfileStreamProvider.overrideWith((ref) => Stream.value(testUser)),
          ],
          child: const MaterialApp(
            home: EditProfilePage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Date of Birth'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);

      expect(find.text('Height'), findsOneWidget);
      expect(find.text('168'), findsOneWidget);
      expect(find.text('cm'), findsOneWidget);

      expect(find.text('Weight'), findsOneWidget);
      expect(find.text('62'), findsOneWidget);
      expect(find.text('kg'), findsOneWidget);

      expect(find.text('Blood Group'), findsOneWidget);
      expect(find.text('O+'), findsOneWidget);
      expect(find.text('Save Changes'), findsOneWidget);
    });

    test('UserRepository.saveUserProfile updates all profile fields directly in SQLite', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(() => db.close());
      final userRepo = UserRepository(db);

      // 1. Initial insert
      final initialUser = createTestUser(
        name: 'Initial User',
        height: 160.0,
        weight: 52.0,
        bloodGroup: 'A+',
      );
      await userRepo.saveUserProfile(initialUser.toCompanion(true));

      final fetchedInitial = await userRepo.getUserProfile();
      expect(fetchedInitial, isNotNull);
      expect(fetchedInitial!.name, 'Initial User');
      expect(fetchedInitial.heightCm, 160.0);
      expect(fetchedInitial.weightKg, 52.0);
      expect(fetchedInitial.bloodGroup, 'A+');

      // 2. Perform update with new values
      final updatedCompanion = initialUser.toCompanion(true).copyWith(
        name: const drift.Value('Updated User'),
        heightCm: const drift.Value(172.0),
        weightKg: const drift.Value(64.0),
        bloodGroup: const drift.Value('B-'),
      );
      await userRepo.saveUserProfile(updatedCompanion);

      // 3. Verify in database
      final fetchedUpdated = await userRepo.getUserProfile();
      expect(fetchedUpdated, isNotNull);
      expect(fetchedUpdated!.name, 'Updated User');
      expect(fetchedUpdated.heightCm, 172.0);
      expect(fetchedUpdated.weightKg, 64.0);
      expect(fetchedUpdated.bloodGroup, 'B-');
    });
  });
}
