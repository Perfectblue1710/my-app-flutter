import 'package:flutter/material.dart';
import '../categories.dart';

class CategoryScreen extends StatelessWidget {
  final Category category;

  const CategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.title),
      ),
      body: ListView.builder(
        itemCount: category.children.length,
        itemBuilder: (context, index) {
          final child = category.children[index];

          return ListTile(
            title: Text(child.title),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              if (child.children.isEmpty) {
                // позже тут будет экран документа
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Open: ${child.title}')),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryScreen(category: child),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
