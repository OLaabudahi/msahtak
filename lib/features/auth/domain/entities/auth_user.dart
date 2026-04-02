class AuthUser {
  final String id;
  final String email;
  final String fullName;
  final String role;
  final List<String> assignedSpaceIds;

  const AuthUser({
    required this.id,
    required this.email,
    required this.fullName,
     required this.role,
    required this.assignedSpaceIds,
  });
}
