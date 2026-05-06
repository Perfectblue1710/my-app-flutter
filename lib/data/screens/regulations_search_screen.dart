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
                title: 'instructions 2',
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
                title: 'Instruction other',
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
        backgroundColor: const Color.fromARGB(255, 16, 200, 102),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: Column(
        children: [
          // ===== ШАПКА =====
          Container(
            color: const Color.fromARGB(255, 16, 200, 74),
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
                      hintText: 'Search documents',
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
                ? 'Add first document'
                : 'Undefined "$_searchQuery"',
            style: const TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 176, 218, 186),
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
              child: const Text('Delete'),
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
              title: const Text('Download DOCX file'),
              onTap: () async {
                Navigator.pop(context);
                await _pickDocxFile();
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder_open),
              title: const Text('Import from folder'),
              onTap: () {
                Navigator.pop(context);
                _showStub('Import from folder');
              },
            ),
            ListTile(
              leading: const Icon(Icons.cloud_upload),
              title: const Text('Download from cloud server'),
              onTap: () {
                Navigator.pop(context);
                _showStub('Cloud server');
              },
            ),
          ],
        ),
      ),
    );
  }

  // ===== ВЫБОР DOCX ФАЙЛА =====
  Future<void> _pickDocxFile() async {

    _showStub('Choose DOCX-file');
  }

  // ===== МЕНЮ =====
  void _openMenu() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Menu/settings')),
    );
  }

  // ===== ФИЛЬТРЫ =====
  void _openFilters() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filters documents')),
    );
  }

  void _showStub(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: const Color.fromARGB(255, 16, 200, 93),
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
                  : const Color.fromARGB(255, 16, 200, 53),
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
                              color: const Color.fromARGB(255, 209, 255, 203),
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
                      color: const Color.fromARGB(255, 130, 212, 89),
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
      _showStub('File undefined: ${node.title}');
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
      case 'Order':
        return const Color.fromARGB(255, 47, 211, 211)!;
      case 'Instructions':
        return Colors.blue[700]!;
      case 'Regulations':
        return Colors.green[700]!;
      case 'Other':
        return const Color.fromARGB(255, 126, 140, 245)!;
      default:
        return const Color.fromARGB(255, 31, 200, 16);
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