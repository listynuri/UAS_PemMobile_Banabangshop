class CartItem {
  final String id;
  final String title;
  final String author;
  final int price; // store as integer (rupiah)
  final String imagePath;
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    required this.imagePath,
    this.quantity = 1,
  });
}
