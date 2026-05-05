import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:my_app/models/regulation.dart';

class DataLoader {
  // Загрузка JSON из assets
  static Future<RegulationsDataset> loadFromAssets() async {
    try {
      final jsonString = await rootBundle.loadString('assets/regulations.json');
      final jsonData = jsonDecode(jsonString);
      return RegulationsDataset.fromJson(jsonData);
    } catch (e) {
      print('Error loading JSON: $e');
      // Возвращаем пустой датасет в случае ошибки
      return RegulationsDataset(
        version: '1.0',
        lastUpdated: DateTime.now().toIso8601String(),
        categories: [],
        regulations: [],
      );
    }
  }

  // Загрузка из локального файла (для десктопа/тестирования)
  static Future<RegulationsDataset> loadFromFile(String path) async {
    // Реализация для чтения с файловой системы
    return RegulationsDataset(
      version: '1.0',
      lastUpdated: '',
      categories: [],
      regulations: [],
    );
  }

  // Поиск по всем полям
  static List<Regulation> searchRegulations(
    List<Regulation> regulations, 
    String query
  ) {
    if (query.isEmpty) return regulations;
    
    final lowercaseQuery = query.toLowerCase();
    
    return regulations.where((regulation) {
      return regulation.searchableText.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Фильтрация по категории
  static List<Regulation> filterByCategory(
    List<Regulation> regulations,
    String categoryId
  ) {
    return regulations
        .where((regulation) => regulation.categoryId == categoryId)
        .toList();
  }

  // Получение категории по ID
  static RegulationCategory? getCategoryById(
    RegulationsDataset dataset,
    String categoryId
  ) {
    return dataset.categories.firstWhere(
      (category) => category.id == categoryId,
      orElse: () => RegulationCategory(
        id: 'unknown',
        name: 'Неизвестно',
        description: '',
        icon: 'help',
        color: '#9E9E9E',
        count: 0,
      ),
    );
  }

  // Статистика
  static Map<String, dynamic> getStatistics(RegulationsDataset dataset) {
    final totalRegulations = dataset.regulations.length;
    final activeRegulations = dataset.regulations
        .where((r) => r.status == 'active')
        .length;
    
    final totalAttachments = dataset.regulations.fold<int>(
      0, (sum, r) => sum + r.attachments.length
    );
    
    return {
      'totalRegulations': totalRegulations,
      'activeRegulations': activeRegulations,
      'totalCategories': dataset.categories.length,
      'totalAttachments': totalAttachments,
      'lastUpdated': dataset.lastUpdated,
    };
  }
}