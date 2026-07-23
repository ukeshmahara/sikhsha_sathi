import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sikhsha_sathi/core/constants/hive_table_constant.dart';
import 'package:sikhsha_sathi/features/auth/data/models/auth_hive_model.dart';
import 'package:sikhsha_sathi/features/favourite/data/models/favourite_hive_model.dart';
import 'package:sikhsha_sathi/features/notification/data/models/notification_hive_model.dart';
import 'package:sikhsha_sathi/features/school/data/models/school_hive_model.dart';


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

    if (!Hive.isAdapterRegistered(
      HiveTableConstant.schoolTypeId,
    )) {

      Hive.registerAdapter(
        SchoolHiveModelAdapter(),
      );
    }

    if (!Hive.isAdapterRegistered(
      HiveTableConstant.categoryCountsTypeId,
    )) {

      Hive.registerAdapter(
        CategoryCountsHiveModelAdapter(),
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

    await Hive.openBox<SchoolHiveModel>(
      HiveTableConstant.schoolTable,
    );

    await Hive.openBox<CategoryCountsHiveModel>(
      HiveTableConstant.categoryCountsTable,
    );
  }

  // ===================================================
  // AUTH QUERIES
  // ===================================================

  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(
        HiveTableConstant.authTable,
      );

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

    try {
      final users = _authBox.values.where(
        (user) =>
            user.email == email &&
            user.password == password,
      );

      return users.isNotEmpty
          ? users.first
          : null;
    } catch (e) {
      return null;
    }
  }

  // ================= GET CURRENT USER =================

  AuthHiveModel? getCurrentUser(
    String userId,
  ) {
    return _authBox.get(userId);
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

  // ================= CLEAR ALL CACHED FAVOURITES =================
  // Called on logout — the favourite box is a single shared table on the
  // device, not scoped per user, so it must be wiped when a session ends
  // or the next user to log in on this device would see the previous
  // user's favourites.

  Future<void> clearFavouriteCache() async {
    await _favouriteBox.clear();
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

  // ===================================================
  // SCHOOL QUERIES (offline cache)
  // ===================================================

  Box<SchoolHiveModel> get _schoolBox =>
      Hive.box<SchoolHiveModel>(
        HiveTableConstant.schoolTable,
      );

  // ================= GET ALL CACHED SCHOOLS =================

  List<SchoolHiveModel> getCachedSchools() {
    return _schoolBox.values.toList();
  }

  // ================= GET CACHED SCHOOL BY ID =================

  SchoolHiveModel? getCachedSchoolById(String id) {
    return _schoolBox.get(id);
  }

  // ================= REPLACE CACHE WITH FRESH DATA =================
  // Called after every successful ONLINE fetch, so offline browsing
  // always shows the most recently seen list rather than something
  // stale from many sessions ago.

  Future<void> replaceCachedSchools(
    List<SchoolHiveModel> models,
  ) async {
    await _schoolBox.clear();

    for (final model in models) {
      if (model.id.isNotEmpty) {
        await _schoolBox.put(model.id, model);
      }
    }
  }

  // ===================================================
  // CATEGORY COUNTS CACHE (single stored entry)
  // ===================================================

  Box<CategoryCountsHiveModel> get _categoryCountsBox =>
      Hive.box<CategoryCountsHiveModel>(
        HiveTableConstant.categoryCountsTable,
      );

  static const String _categoryCountsKey = 'current';

  Map<String, int> getCachedCategoryCounts() {
    final cached = _categoryCountsBox.get(_categoryCountsKey);
    return cached?.counts ?? {};
  }

  Future<void> cacheCategoryCounts(Map<String, int> counts) async {
    await _categoryCountsBox.put(
      _categoryCountsKey,
      CategoryCountsHiveModel(counts: counts),
    );
  }
}