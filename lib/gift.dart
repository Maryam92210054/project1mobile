
class Gift {
  final String id;
  final String name;
  final String description;
  final String price;
  final String imageUrl;
  final String budgetId;  // Added budgetId to the Gift class

  Gift({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.budgetId,  // Add budgetId to constructor
  });

  factory Gift.fromJson(Map<String, dynamic> json) {
    return Gift(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      imageUrl: json['image_url'],
      budgetId: json['budget_id'],  // Parse the budgetId
    );
  }
}
