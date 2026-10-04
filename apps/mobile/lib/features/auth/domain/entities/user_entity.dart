/// Core domain entity representing an authenticated user in NutriAI.
class UserEntity {
  final int id;
  final String name;
  final String email;
  final String? avatar;
  final String? timezone;
  final bool isOnboardingCompleted;
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.timezone,
    this.isOnboardingCompleted = false,
    this.createdAt,
  });

  UserEntity copyWith({
    int? id,
    String? name,
    String? email,
    String? avatar,
    String? timezone,
    bool? isOnboardingCompleted,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      timezone: timezone ?? this.timezone,
      isOnboardingCompleted: isOnboardingCompleted ?? this.isOnboardingCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;

  @override
  String toString() => 'UserEntity(id: $id, name: $name, email: $email)';
}
