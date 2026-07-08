import 'package:equatable/equatable.dart';

class SchoolEntity extends Equatable {
  final String? id;
  final String name;
  final String location;
  final String category; 
  final List<String> streamsOffered; 
  final double fees;
  final String? image;
  final String? description;
  final List<String> facilities;
  final String? contactPhone;
  final String? contactEmail;
  final String? contactWebsite;

  const SchoolEntity({
    this.id,
    required this.name,
    required this.location,
    required this.category,
    required this.streamsOffered,
    required this.fees,
    this.image,
    this.description,
    this.facilities = const [],
    this.contactPhone,
    this.contactEmail,
    this.contactWebsite,
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
        description,
        facilities,
        contactPhone,
        contactEmail,
        contactWebsite,
      ];
}