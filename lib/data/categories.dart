class Category {
  final String title;
  final List<Category> children;

  Category({
    required this.title,
    this.children = const [],
  });
}
final categories = [
  Category(
    title: 'Categories 1',
    children: [
      Category(title: 'Instructions'),
      Category(title: 'Regulations'),
      Category(title: 'Orders'),
    ],
  ),

  Category(
    title: 'Categories 3',
    children: [
      Category(
        title: 'Other',
        children: [
      Category(title: 'Instructions'),
      Category(title: 'Regulations'),
      Category(title: 'Orders'),
        ],
      ),
      Category(
        title: 'Categories 4',
        children: [
      Category(title: 'Instructions'),
      Category(title: 'Regulations'),
      Category(title: 'Orders'),
        ],
      ),
    ],
  ),
    ];
