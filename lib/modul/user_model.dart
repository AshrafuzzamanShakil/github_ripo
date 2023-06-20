class User {
  final String login;
  final String avatarUrl;
  final String name;
  final String bio;
  final int followers;
  final int following;
  final int publicRepos;

  User({
    required this.login,
    required this.avatarUrl,
    required this.name,
    required this.bio,
    required this.followers,
    required this.following,
    required this.publicRepos,
  });
}

class Repository {
  final String name;
  final String description;
  final int stars;
  final String language;
  final String createdAt;
  final String htmlUrl;

  Repository({
    required this.name,
    required this.description,
    required this.stars,
    required this.language,
    required this.createdAt,
    required this.htmlUrl,
  });
}
