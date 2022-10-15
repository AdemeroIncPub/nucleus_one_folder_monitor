enum N1ProjectType {
  projects(
    str: 'Projects',
    accessType: projectsAccessType,
  ),
  departments(
    str: 'Departments',
    accessType: departmentsAccessType,
  );

  const N1ProjectType({
    required this.str,
    required this.accessType,
  });
  final String str;
  final String accessType;

  static const String projectsAccessType =
      'GlobalAssignments_MemberContentByDefault';
  static const String departmentsAccessType =
      'MembersOnlyAssignments_MemberContentByAssignment';

  static N1ProjectType? fromAccessType(String? accessType) {
    switch (accessType) {
      case null:
        return null;
      case projectsAccessType:
        return N1ProjectType.projects;
      case departmentsAccessType:
        return N1ProjectType.departments;
    }
    throw ArgumentError.value(
        accessType, 'accessType', 'Unrecognized access type.');
  }
}
