// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sikhsha_sathi/core/services/hive/hive_service.dart';
// import 'package:sikhsha_sathi/features/profile/data/datasources/profile_datasource.dart';

// final profileLocalDatasourceProvider =
//     Provider<ProfileLocalDatasource>(
//   (ref) {
//     final hiveService =
//         ref.read(hiveServiceProvider);

//     return ProfileLocalDatasource(
//       hiveService: hiveService,
//     );
//   },
// );

// class ProfileLocalDatasource
//     implements IProfileLocalDataSource {
//   final HiveService _hiveService;

//   ProfileLocalDatasource({
//     required HiveService hiveService,
//   }) : _hiveService = hiveService;

//   @override
//   Future<void> saveProfilePicture(
//     String profilePicture,
//   ) async {
//     try {
//       await _hiveService
//           .updateProfilePicture(
//         profilePicture,
//       );
//     } catch (e) {
//       rethrow;
//     }
//   }

//   @override
//   Future<String?> getProfilePicture()
//       async {
//     try {
//       return _hiveService
//           .getProfilePicture();
//     } catch (e) {
//       return null;
//     }
//   }

//   @override
//   Future<void> clearProfilePicture()
//       async {
//     try {
//       await _hiveService
//           .updateProfilePicture("");
//     } catch (e) {
//       rethrow;
//     }
//   }
// }