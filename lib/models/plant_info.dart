import 'package:cloud_firestore/cloud_firestore.dart';

class PlantInfo {
  final String id;
  final String name;
  final String species;
  final String potColor;
  final Timestamp startDate;

  PlantInfo({
    required this.id,
    required this.name,
    required this.species,
    required this.potColor,
    required this.startDate,
  });

  factory PlantInfo.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PlantInfo(
      id: doc.id,
      name: data['name'] ?? '',
      species: data['species'] ?? '',
      potColor: data['pot_color'] ?? '',
      startDate: data['start_date'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'species': species,
      'pot_color': potColor,
      'start_date': startDate,
    };
  }
}