class Gift {
  final String name;
  final String description;
  final String interest;
  final String gender;
  final String budget;

  Gift({
    required this.name,
    required this.description,
    required this.interest,
    required this.gender,
    required this.budget,
  });

  // Factory constructor to create a Gift object from a Map
  factory Gift.fromMap(Map<String, String> map) {
    return Gift(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      interest: map['interest'] ?? '',
      gender: map['gender'] ?? '',
      budget: map['budget'] ?? '',
    );
  }
}
