class Psychologist {
  final String id;
  final String name;
  final String specialty;
  final String phone;
  final String description;
  final String about;
  final List<String> addictions; // Vícios/temas atendidos
  final String formation;
  final int experienceYears;
  final List<String> methods;
  final String location;
  final String gender;
  final String? photoUrl;
  final String testimonial; // Depoimento do profissional

  Psychologist({
    required this.id,
    required this.name,
    required this.specialty,
    required this.phone,
    required this.description,
    required this.about,
    required this.addictions,
    required this.formation,
    required this.experienceYears,
    required this.methods,
    required this.location,
    required this.gender,
    required this.testimonial,
    this.photoUrl,
  });
}
