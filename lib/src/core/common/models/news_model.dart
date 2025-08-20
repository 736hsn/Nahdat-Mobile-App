class NewsModel {
  final int id;
  final String date;
  final String dateGmt;
  final Guid guid;
  final String modified;
  final String modifiedGmt;
  final String slug;
  final String status;
  final String type;
  final String link;
  final Title title;
  final Content content;
  final Excerpt excerpt;
  final int author;
  final int featuredMedia;
  final String commentStatus;
  final String pingStatus;
  final bool sticky;
  final int views;
  final String template;
  final String format;
  final List<int> categories;
  final List<dynamic> tags;
  final List<String> classList;
  final Map<String, dynamic>? yoast_head_json;

  NewsModel({
    required this.id,
    required this.date,
    required this.dateGmt,
    required this.guid,
    required this.modified,
    required this.modifiedGmt,
    required this.slug,
    required this.views,
    required this.status,
    required this.type,
    required this.link,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.author,
    required this.featuredMedia,
    required this.commentStatus,
    required this.pingStatus,
    required this.sticky,
    required this.template,
    required this.format,
    required this.categories,
    required this.tags,
    required this.classList,
    this.yoast_head_json,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] ?? 0,
      date: json['date'] ?? '',
      dateGmt: json['date_gmt'] ?? '',
      guid: Guid.fromJson(json['guid'] ?? {}),
      modified: json['modified'] ?? '',
      modifiedGmt: json['modified_gmt'] ?? '',
      slug: json['slug'] ?? '',
      status: json['status'] ?? '',
      type: json['type'] ?? '',
      link: json['link'] ?? '',
      views: json['views'] ?? 0,
      title: Title.fromJson(json['title'] ?? {}),
      content: Content.fromJson(json['content'] ?? {}),
      excerpt: Excerpt.fromJson(json['excerpt'] ?? {}),
      author: json['author'] ?? 0,
      featuredMedia: json['featured_media'] ?? 0,
      commentStatus: json['comment_status'] ?? '',
      pingStatus: json['ping_status'] ?? '',
      sticky: json['sticky'] ?? false,
      template: json['template'] ?? '',
      format: json['format'] ?? '',
      categories: List<int>.from(json['categories'] ?? []),
      tags: json['tags'] ?? [],
      classList: List<String>.from(json['class_list'] ?? []),
      yoast_head_json: json['yoast_head_json'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'date_gmt': dateGmt,
      'guid': guid.toJson(),
      'modified': modified,
      'modified_gmt': modifiedGmt,
      'slug': slug,
      'status': status,
      'type': type,
      'views': views,
      'link': link,
      'title': title.toJson(),
      'content': content.toJson(),
      'excerpt': excerpt.toJson(),
      'author': author,
      'featured_media': featuredMedia,
      'comment_status': commentStatus,
      'ping_status': pingStatus,
      'sticky': sticky,
      'template': template,
      'format': format,
      'categories': categories,
      'tags': tags,
      'class_list': classList,
      'yoast_head_json': yoast_head_json,
    };
  }

  static List<NewsModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => NewsModel.fromJson(json)).toList();
  }
}

class Guid {
  final String rendered;

  Guid({required this.rendered});

  factory Guid.fromJson(Map<String, dynamic> json) {
    return Guid(rendered: json['rendered'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'rendered': rendered};
  }
}

class Title {
  final String rendered;

  Title({required this.rendered});

  factory Title.fromJson(Map<String, dynamic> json) {
    return Title(rendered: json['rendered'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'rendered': rendered};
  }
}

class Content {
  final String rendered;
  final bool protected;

  Content({required this.rendered, required this.protected});

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      rendered: json['rendered'] ?? '',
      protected: json['protected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'rendered': rendered, 'protected': protected};
  }
}

class Excerpt {
  final String rendered;
  final bool protected;

  Excerpt({required this.rendered, required this.protected});

  factory Excerpt.fromJson(Map<String, dynamic> json) {
    return Excerpt(
      rendered: json['rendered'] ?? '',
      protected: json['protected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'rendered': rendered, 'protected': protected};
  }
}
