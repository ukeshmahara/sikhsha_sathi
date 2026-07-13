import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sikhsha_sathi/core/constants/hive_table_constant.dart';
import 'package:sikhsha_sathi/features/auth/data/models/auth_hive_model.dart';
import 'package:sikhsha_sathi/features/favourite/data/models/favourite_hive_model.dart';
import 'package:sikhsha_sathi/features/notification/data/models/notification_hive_model.dart';


final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {

  // ================= INIT DATABASE =================

  Future<void> init() async {

    final directory =
        await getApplicationDocumentsDirectory();

    final path =
        '${directory.path}/${HiveTableConstant.dbName}';

    Hive.init(path);

    _registerAdapters();

    await openBoxes();
  }

  // ================= REGISTER ADAPTER =================

  void _registerAdapters() {

    if (!Hive.isAdapterRegistered(
      HiveTableConstant.authTypeId,
    )) {

      Hive.registerAdapter(
        AuthHiveModelAdapter(),
      );
    }

    if (!Hive.isAdapterRegistered(
      HiveTableConstant.favouriteTypeId,
    )) {

      Hive.registerAdapter(
        FavouriteHiveModelAdapter(),
      );
    }

    if (!Hive.isAdapterRegistered(
      HiveTableConstant.notificationTypeId,
    )) {

      Hive.registerAdapter(
        NotificationHiveModelAdapter(),
      );
    }
  }

  // ================= OPEN BOXES =================

  Future<void> openBoxes() async {

    await Hive.openBox<AuthHiveModel>(
      HiveTableConstant.authTable,
    );

    await Hive.openBox<FavouriteHiveModel>(
      HiveTableConstant.favouriteTable,
    );

    await Hive.openBox<NotificationHiveModel>(
      HiveTableConstant.notificationTable,
    );
  }

  // ================= CLOSE DATABASE =================

  Future<void> close() async {

    await Hive.close();
  }

  // ===================================================
  // AUTH QUERIES
  // ===================================================

  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(
        HiveTableConstant.authTable,
      );

  // ================= REGISTER =================

  Future<AuthHiveModel> registerUser(
    AuthHiveModel model,
  ) async {

    await _authBox.put(
      model.userId,
      model,
    );

    return model;
  }

  // ================= LOGIN =================

  Future<AuthHiveModel?> login(
    String email,
    String password,
  ) async {

    final users = _authBox.values.where(
      (user) =>
          user.email == email &&
          user.password == password,
    );

    if (users.isNotEmpty) {
      return users.first;
    }

    return null;
  }

  // ================= GET CURRENT USER =================

  AuthHiveModel? getCurrentUser(
    String authId,
  ) {

    return _authBox.get(authId);
  }

  // ================= CHECK EMAIL =================

  bool isEmailExists(
    String email,
  ) {

    final users = _authBox.values.where(
      (user) => user.email == email,
    );

    return users.isNotEmpty;
  }

  // ================= LOGOUT =================

  Future<void> logoutUser() async {

    // later use shared preferences / token remove
  }

  // ===================================================
  // FAVOURITE QUERIES
  // ===================================================

  Box<FavouriteHiveModel> get _favouriteBox =>
      Hive.box<FavouriteHiveModel>(
        HiveTableConstant.favouriteTable,
      );

  // ================= GET ALL CACHED FAVOURITES =================

  List<FavouriteHiveModel> getCachedFavourites() {
    return _favouriteBox.values.toList();
  }

  // ================= REPLACE CACHE WITH FRESH DATA =================

  Future<void> replaceCachedFavourites(
    List<FavouriteHiveModel> models,
  ) async {
    await _favouriteBox.clear();

    for (final model in models) {
      await _favouriteBox.put(model.schoolId, model);
    }
  }

  // ================= CACHE SINGLE FAVOURITE =================

  Future<void> cacheFavourite(
    FavouriteHiveModel model,
  ) async {
    await _favouriteBox.put(model.schoolId, model);
  }

  // ================= REMOVE CACHED FAVOURITE =================

  Future<void> removeCachedFavourite(
    String schoolId,
  ) async {
    await _favouriteBox.delete(schoolId);
  }

  // ================= CHECK IF FAVOURITED =================

  bool isFavouriteCached(
    String schoolId,
  ) {
    return _favouriteBox.containsKey(schoolId);
  }

  // ===================================================
  // NOTIFICATION QUERIES
  // ===================================================

  Box<NotificationHiveModel> get _notificationBox =>
      Hive.box<NotificationHiveModel>(
        HiveTableConstant.notificationTable,
      );

  // ================= GET ALL CACHED NOTIFICATIONS =================

  List<NotificationHiveModel> getCachedNotifications() {
    return _notificationBox.values.toList();
  }

  // ================= REPLACE CACHE WITH FRESH DATA =================

  Future<void> replaceCachedNotifications(
    List<NotificationHiveModel> models,
  ) async {
    await _notificationBox.clear();

    for (final model in models) {
      await _notificationBox.put(model.id, model);
    }
  }
}