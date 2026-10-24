/// ---------------------------------------------------------------------------
/// USER MODEL
/// The logged-in user (name + email). Passwords are NEVER kept on this
/// object - only inside the (demo) auth repository.
/// ---------------------------------------------------------------------------
class AppUser {
  const AppUser({required this.name, required this.email});

  final String name;
  final String email;

  /// Initials for the profile avatar, e.g. "Demo User" -> "DU".
  String get initials {
    final List<String> parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'email': email,
      };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        name: json['name'] as String,
        email: json['email'] as String,
      );
}
