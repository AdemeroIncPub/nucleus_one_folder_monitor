enum N1ProjectType {
  project(
    accessType: projectAccessType,
  ),
  department(
    accessType: departmentAccessType,
  );

  const N1ProjectType({
    required this.accessType,
  });
  final String accessType;

  static const String projectAccessType =
      'GlobalAssignments_MemberContentByDefault';
  static const String departmentAccessType =
      'MembersOnlyAssignments_MemberContentByAssignment';

  static N1ProjectType? fromAccessType(String? accessType) {
    switch (accessType) {
      case null:
        return null;
      case projectAccessType:
        return N1ProjectType.project;
      case departmentAccessType:
        return N1ProjectType.department;
    }
    throw ArgumentError.value(
        accessType, 'accessType', 'Unrecognized access type.');
  }
}
