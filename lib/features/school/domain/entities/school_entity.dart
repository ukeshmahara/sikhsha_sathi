import 'package:equatable/equatable.dart';

class SchoolEntity extends Equatable {
  final String? id;
  final String name;
  final String location;
  final String category; // "international" | "public" | "private" | "budget_friendly"
  final List<String> streamsOffered; // "science" | "management" | "humanities"
  final double fees;
  final String? image;

  const SchoolEntity({
    this.id,
    required this.name,
    required this.location,
    required this.category,
    required this.streamsOffered,
    required this.fees,
    this.image,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        location,
        category,
        streamsOffered,
        fees,
        image,
      ];
}