// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:sikhsha_sathi/core/services/hive/hive_service.dart';
// import 'package:sikhsha_sathi/core/services/storage/user_session_service.dart';

// import 'package:sikhsha_sathi/features/auth/data/datasources/auth_datasource.dart';
// import 'package:sikhsha_sathi/features/auth/data/models/auth_hive_model.dart';

// // ================= PROVIDER =================

// final authLocalDatasourceProvider =
// Provider<AuthLocalDatasource>((ref) {

// final hiveService =
// ref.read(hiveServiceProvider);

// final userSessionService =
// ref.read(userSessionServiceProvider);

// return AuthLocalDatasource(
// hiveService: hiveService,
// userSessionService:
// userSessionService,
// );
// });

// // ================= DATASOURCE =================

// class AuthLocalDatasource
// implements IAuthLocalDataSource {

// final HiveService _hiveService;

// final UserSessionService
// _userSessionService;

// AuthLocalDatasource({
// required HiveService hiveService,
// required UserSessionService
// userSessionService,
// })  : _hiveService = hiveService,
// _userSessionService =
// userSessionService;

// // ================= REGISTER =================

// @override
// Future<bool> register(
// AuthHiveModel model,
// ) async {

// try {

//   await _hiveService.registerUser(
//     model,
//   );

//   return true;

// } catch (e) {

//   return false;
// }


// }

// // ================= LOGIN =================

// @override
// Future<AuthHiveModel?> login(
// String email,
// String password,
// ) async {


// try {

//   final user =
//       await _hiveService.login(
//     email,
//     password,
//   );

//   if (user != null) {

//     await _userSessionService
//         .saveUserSession(
//       userId: user.userId,
//       email: user.email,
//       fullName: user.fullName,
//       phoneNumber:
//           user.phoneNumber,
//       profilePicture:
//           user.profilePicture,
//     );
//   }

//   return user;

// } catch (e) {

//   return null;
// }

// }

// // ================= GET CURRENT USER =================
// // Two cases:
// //  1. There's an ACTIVE session (isLoggedIn true) — use its userId.
// //     This is the original behaviour, used e.g. when Profile checks
// //     the local cache as a fallback while offline but still logged in.
// //  2. There's NO active session (e.g. right after logout) — fall back
// //     to whichever account fingerprint login is bound to on this
// //     device, if any. This is what makes fingerprint login work again
// //     immediately after logging out of the SAME account, without
// //     depending on the (correctly, deliberately) cleared auth token.

// @override
// Future<AuthHiveModel?> getCurrentUser()
// async {

// try {

//   String? userId;

//   if (_userSessionService.isLoggedIn()) {
//     userId = _userSessionService.getUserId();
//   } else {
//     userId = _userSessionService.getBiometricUserId();
//   }

//   if (userId == null) {
//     return null;
//   }

//   return _hiveService
//       .getCurrentUser(
//     userId,
//   );

// } catch (e) {

//   return null;
// }


// }

// // ================= LOGOUT =================

// @override
// Future<bool> logout() async {

// try {

//   await _userSessionService
//       .clearSession();

//   await _hiveService
//       .logoutUser();

//   return true;

// } catch (e) {

//   return false;
// }


// }

// // ================= CHECK EMAIL =================

// @override
// Future<bool> isEmailExists(
// String email,
// ) async {

// try {

//   final exists =
//       _hiveService.isEmailExists(
//     email,
//   );

//   return exists;

// } catch (e) {

//   return false;
// }


// }
// }