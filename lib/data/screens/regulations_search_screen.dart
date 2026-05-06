import 'package:flutter/material.dart';
import 'package:my_app/data/screens/docx_viewer_screen.dart';

class RegulationsSearchScreen extends StatefulWidget {
  const RegulationsSearchScreen({super.key});

  @override
  State<RegulationsSearchScreen> createState() =>
      _RegulationsSearchScreenState();
}

class _RegulationsSearchScreenState extends State<RegulationsSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // ===== СПИСОК ДОКУМЕНТОВ С ПУТЯМИ =====
 final List<DocumentNode> _documentTree = [
  DocumentNode(
    title: 'Categories 1',
    isExpanded: true,
    children: [
      DocumentNode(
        title: 'Orders',
        isExpanded: true,
        children: [
          DocumentNode(
            title: 'Rules',
            isFile: true,
            filePath: 'assets/regulations/reg_(2).pdf',
            documentType: 'Ord',
            date: '23.09.2020',
          ),
        ],
      ),
     DocumentNode(
        title: 'Instructions',
        isExpanded: true,
        children: [
          DocumentNode(
            title: 'General instructions',
            isExpanded: true,
            children: [
              DocumentNode(
                title: 'По оказанию первой помощи при несчастных случаях на производстве',
                isFile: true,
                filePath: 'assets/insrtuctions/instruction_1.pdf',
                documentType: 'Ins',
                date: '29.08.2024',
              ),
            ],
          ),
          DocumentNode(
            title: 'Other',
            isExpanded: true,
            children: [
              DocumentNode(
                title: '',
                isFile: true,
                filePath: 'assets/instructions_prof/ins_pro_1.pdf',
                documentType: 'Ins oth',
              ),
            ],
          ),
        ],
      ),
    ],
  ),
 DocumentNode(
    title: 'Categories 2',
    isExpanded: true,
    children: [
      DocumentNode(
        title: 'Order',
        isExpanded: true,
        children: [
          DocumentNode(
            title: 'Order 1',
            isFile: true,
            filePath: 'assets/prikaz_gas/prikaz_(2)',
            documentType: 'Ord',
            date:'28.11.2023',
          ),
        ],
      ),
      DocumentNode(
        title: 'Instruction',
        isExpanded: true,
        children: [
          DocumentNode(
            title: 'Instruction 1',
            isFile: true,
            filePath: 'assets/ins_gas/ins_ (1)',
            documentType: 'Ins',
            date: '20.02.2025',
          ),
        ],
      ),
      DocumentNode(
        title: 'Regulations',
        isExpanded: true,
        children: [
          DocumentNode(
            title: 'Regulation for..',
            isFile: true,
            filePath: 'assets/reg_gas/reg_(1)',
            documentType: 'Reg',
            date: '15.04.2024',
          ),
        ],
      ),
    ],
),
 ];

  @override
  Widget build(BuildContext context) {
    final filteredTree = _filterTree(_documentTree, _searchQuery);

    return Scaffold(
      // ===== FAB =====
      floatingActionButton: FloatingActionButton(
        onPressed: _importDocument,
        backgroundColor: const Color(0xFFC8102E),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: Column(
        children: [
          // ===== ШАПКА =====
          Container(
            color: const Color(0xFFC8102E),
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
            child: Column(
              children: [
                // ===== ВЕРХНЯЯ СТРОКА =====
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: _openMenu,
                    ),
                    const Expanded(
                      child: Text(
                        'ПОИСК',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.white),
                      onPressed: _openFilters,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ===== ПОЛЕ ПОИСКА =====
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Поиск документов...',
                      prefixIcon: const Icon(Icons.search),
                      border: InputBorder.none,
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                  _searchController.clear();
                                });
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                  ),
                ),
              ],
            ),
          ),

          // ===== СПИСОК =====
          Expanded(
            child: filteredTree.isEmpty
                ? _buildEmptyState()
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: filteredTree
                        .map((node) => _buildTreeNode(node))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  // ===== ПУСТОЕ СОСТОЯНИЕ =====
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty
                ? 'Добавьте первый документ'
                : 'По запросу "$_searchQuery" ничего не найдено',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          if (_searchQuery.isNotEmpty)
            TextButton(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _searchController.clear();
                });
              },
              child: const Text('Очистить поиск'),
            ),
        ],
      ),
    );
  }

  // ===== ИМПОРТ ДОКУМЕНТА =====
  void _importDocument() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.file_upload),
              title: const Text('Загрузить DOCX файл'),
              onTap: () async {
                Navigator.pop(context);
                await _pickDocxFile();
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder_open),
              title: const Text('Импорт из папки документов'),
              onTap: () {
                Navigator.pop(context);
                _showStub('Импорт из папки');
              },
            ),
            ListTile(
              leading: const Icon(Icons.cloud_upload),
              title: const Text('Скачать из облачного хранилища'),
              onTap: () {
                Navigator.pop(context);
                _showStub('Облачный импорт');
              },
            ),
          ],
        ),
      ),
    );
  }

  // ===== ВЫБОР DOCX ФАЙЛА =====
  Future<void> _pickDocxFile() async {

    _showStub('Выбор DOCX файла');
  }

  // ===== МЕНЮ =====
  void _openMenu() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Меню / настройки')),
    );
  }

  // ===== ФИЛЬТРЫ =====
  void _openFilters() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Фильтры документов')),
    );
  }

  void _showStub(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: const Color(0xFFC8102E),
      ),
    );
  }

  // ===== ФИЛЬТРАЦИЯ ДЕРЕВА =====
  List<DocumentNode> _filterTree(
      List<DocumentNode> nodes, String query) {
    if (query.isEmpty) return nodes;

    final List<DocumentNode> result = [];

    for (final node in nodes) {
      // Проверяем сам узел
      if (node.title.toLowerCase().contains(query.toLowerCase())) {
        result.add(node);
      }
      // Проверяем детей
      else if (node.children.isNotEmpty) {
        final filteredChildren = _filterTree(node.children, query);
        if (filteredChildren.isNotEmpty) {
          result.add(DocumentNode(
            title: node.title,
            isExpanded: true,
            children: filteredChildren,
          ));
        }
      }
    }

    return result;
  }

  // ===== ПОСТРОЕНИЕ УЗЛА =====
Widget _buildTreeNode(DocumentNode node) {
  final hasChildren = node.children.isNotEmpty;

  return Card(
    margin: const EdgeInsets.only(bottom: 12),
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: node.isFile
                  ? _getDocumentTypeColor(node.documentType)
                  : const Color(0xFFC8102E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              node.isFile ? Icons.description : Icons.folder,
              color: Colors.white,
              size: 24,
            ),
          ),
          title: Text(
            node.title,
            style: TextStyle(
              fontWeight: node.isFile ? FontWeight.normal : FontWeight.w600,
              fontSize: node.isFile ? 15 : 16,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: node.isFile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Chip(
                          label: Text(
                            node.documentType,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor:
                              _getDocumentTypeColor(node.documentType),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            node.date,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : null,
            trailing: hasChildren
                ? IconButton(
                    icon: Icon(
                      node.isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: const Color(0xFFC8102E),
                    ),
                    onPressed: () {
                      setState(() {
                        node.isExpanded = !node.isExpanded;
                      });
                    },
                  )
                : null,
            onTap: () {
              if (hasChildren) {
                setState(() {
                  node.isExpanded = !node.isExpanded;
                });
              } else if (node.isFile) {
                _openDocument(node);
              }
            },
          ),

          // ДОЧЕРНИЕ УЗЛЫ
          if (hasChildren && node.isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 8),
              child: Column(
                children: node.children
                    .map((child) => _buildTreeNode(child))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  // ===== ОТКРЫТИЕ ДОКУМЕНТА =====
  void _openDocument(DocumentNode node) {
    if (node.filePath.isEmpty) {
      _showStub('Файл не найден: ${node.title}');
      return;
    }

    _openDocxViewer(node);
  }

  // ===== ОТКРЫТИЕ DOCX_VIEWER =====
  void _openDocxViewer(DocumentNode node) {
Navigator.push(
 context,
MaterialPageRoute(
  builder: (context) => DocxViewerScreen(
  documentName: node.title,
 filePath: node.filePath,
     ),
  ),
);
  }

  // ===== ЦВЕТ ДЛЯ ТИПА ДОКУМЕНТА =====
  Color _getDocumentTypeColor(String type) {
    switch (type) {
      case 'Приказ':
        return Colors.red[700]!;
      case 'Инструкция':
        return Colors.blue[700]!;
      case 'Регламент':
        return Colors.green[700]!;
      case 'Руководство':
        return Colors.purple[700]!;
      case 'Прочее':
        return Colors.orange[700]!;
      default:
        return const Color(0xFFC8102E);
    }
  }
}

// ===== МОДЕЛЬ ДОКУМЕНТА =====
class DocumentNode {
  String title;
  bool isExpanded;
  bool isFile;
  String filePath;      
  String documentType;
  String date;
  List<DocumentNode> children;

  DocumentNode({
    required this.title,
    this.isExpanded = false,
    this.isFile = false,
    this.filePath = '',
    this.documentType = 'Document',
    this.date = '',
    this.children = const [],
  }); 
}