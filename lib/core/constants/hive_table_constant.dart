class HiveTableConstant {

  HiveTableConstant._();

  // DATABASE NAME
  static const String dbName =
      "sikhsha_sathi_db";

  // AUTH TABLE

  static const int authTypeId = 0;

  static const String authTable =
      "auth_table";

  // FAVOURITE TABLE

  static const int favouriteTypeId = 1;

  static const String favouriteTable =
      "favourite_table";

  // NOTIFICATION TABLE

  static const int notificationTypeId = 2;

  static const String notificationTable =
      "notification_table";

  // SCHOOL TABLE (offline cache)

  static const int schoolTypeId = 3;

  static const String schoolTable =
      "school_table";

  // stores the last-fetched category counts as a single cached entry
  static const int categoryCountsTypeId = 4;

  static const String categoryCountsTable =
      "category_counts_table";
}