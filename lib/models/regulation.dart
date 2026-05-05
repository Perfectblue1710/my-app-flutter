// Модели данных для работы с JSON

class RegulationCategory {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String color;
  final int count;

  RegulationCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.count,
  });

  factory RegulationCategory.fromJson(Map<String, dynamic> json) {
    return RegulationCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      color: json['color'],
      count: json['count'],
    );
  }
}

class RegulationAttachment {
  final String name;
  final String type; // pdf, docx, xlsx, etc
  final int size; // in bytes
  final String url;

  RegulationAttachment({
    required this.name,
    required this.type,
    required this.size,
    required this.url,
  });

  factory RegulationAttachment.fromJson(Map<String, dynamic> json) {
    return RegulationAttachment(
      name: json['name'],
      type: json['type'],
      size: json['size'],
      url: json['url'],
    );
  }
}

class RegulationMetadata {
  final String author;
  final String createdAt;
  final String updatedAt;
  final int views;
  final int downloads;

  RegulationMetadata({
    required this.author,
    required this.createdAt,
    required this.updatedAt,
    required this.views,
    required this.downloads,
  });

  factory RegulationMetadata.fromJson(Map<String, dynamic> json) {
    return RegulationMetadata(
      author: json['author'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      views: json['views'],
      downloads: json['downloads'],
    );
  }
}

class WorkflowStep {
  final int step;
  final String title;
  final String responsible;
  final String deadline;

  WorkflowStep({
    required this.step,
    required this.title,
    required this.responsible,
    required this.deadline,
  });

  factory WorkflowStep.fromJson(Map<String, dynamic> json) {
    return WorkflowStep(
      step: json['step'],
      title: json['title'],
      responsible: json['responsible'],
      deadline: json['deadline'],
    );
  }
}

class Regulation {
  final String id;
  final String title;
  final String shortTitle;
  final String categoryId;
  final String version;
  final String effectiveDate;
  final String status; // active, draft, archived
  final String priority; // low, medium, high, critical
  
  final String content;
  final String summary;
  final List<String> tags;
  final List<String> keywords;
  
  final List<RegulationAttachment> attachments;
  final List<String> relatedRegulations;
  final RegulationMetadata metadata;
  final List<WorkflowStep> workflow;

  Regulation({
    required this.id,
    required this.title,
    required this.shortTitle,
    required this.categoryId,
    required this.version,
    required this.effectiveDate,
    required this.status,
    required this.priority,
    required this.content,
    required this.summary,
    required this.tags,
    required this.keywords,
    required this.attachments,
    required this.relatedRegulations,
    required this.metadata,
    required this.workflow,
  });

  factory Regulation.fromJson(Map<String, dynamic> json) {
    return Regulation(
      id: json['id'],
      title: json['title'],
      shortTitle: json['shortTitle'],
      categoryId: json['categoryId'],
      version: json['version'],
      effectiveDate: json['effectiveDate'],
      status: json['status'],
      priority: json['priority'],
      content: json['content'],
      summary: json['summary'],
      tags: List<String>.from(json['tags']),
      keywords: List<String>.from(json['keywords']),
      attachments: List<RegulationAttachment>.from(
        json['attachments'].map((x) => RegulationAttachment.fromJson(x))
      ),
      relatedRegulations: List<String>.from(json['relatedRegulations']),
      metadata: RegulationMetadata.fromJson(json['metadata']),
      workflow: json['workflow'] != null
          ? List<WorkflowStep>.from(
              json['workflow'].map((x) => WorkflowStep.fromJson(x))
            )
          : [],
    );
  }

  // Метод для поиска - объединяет все текстовые поля
  String get searchableText {
    return '$title $shortTitle $content $summary ${tags.join(' ')} ${keywords.join(' ')}';
  }

  // Красивое отображение размера файлов
  String get attachmentsSize {
    final totalBytes = attachments.fold<int>(
      0, 
      (sum, attachment) => sum + attachment.size
    );
    
    if (totalBytes < 1024) return '$totalBytes Б';
    if (totalBytes < 1024 * 1024) return '${(totalBytes / 1024).toStringAsFixed(1)} КБ';
    return '${(totalBytes / (1024 * 1024)).toStringAsFixed(1)} МБ';
  }
}
class RegulationsDataset {
  final String version;
  final String lastUpdated;
  final List<RegulationCategory> categories;
  final List<Regulation> regulations;

  RegulationsDataset({
    required this.version,
    required this.lastUpdated,
    required this.categories,
    required this.regulations,
  });

  factory RegulationsDataset.fromJson(Map<String, dynamic> json) {
    return RegulationsDataset(
      version: json['version'],
      lastUpdated: json['lastUpdated'],
      categories: List<RegulationCategory>.from(
        json['categories'].map((x) => RegulationCategory.fromJson(x))
      ),
      regulations: List<Regulation>.from(
        json['regulations'].map((x) => Regulation.fromJson(x))
      ),
    );
  }
}