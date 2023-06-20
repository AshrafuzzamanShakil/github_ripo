class GitHubRepository {
  final String name;
  final String description;
  final int stars;
  final String language;
  final String createdAt;
  final String htmlUrl;

  GitHubRepository({
    required this.name,
    required this.description,
    required this.stars,
    required this.language,
    required this.createdAt,
    required this.htmlUrl, required forked,
  });

  factory GitHubRepository.fromJson(Map<String, dynamic> json) {
    return GitHubRepository(
      name: json['name'],
      description: json['description'] ?? '',
      stars: json['stargazers_count'],
      language: json['language'] ?? '',
      createdAt: json['created_at'],
      htmlUrl: json['html_url'],
      forked: json['fork']
    );
  }

  get forked => null;
}