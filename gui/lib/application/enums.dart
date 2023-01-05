enum NucleusOneProjectType {
  project(
    accessType: projectAccessType,
  ),
  department(
    accessType: departmentAccessType,
  );

  const NucleusOneProjectType({
    required this.accessType,
  });
  final String accessType;

  static const String projectAccessType =
      'GlobalAssignments_MemberContentByDefault';
  static const String departmentAccessType =
      'MembersOnlyAssignments_MemberContentByAssignment';

  static NucleusOneProjectType? fromAccessType(String? accessType) {
    switch (accessType) {
      case null:
        return null;
      case projectAccessType:
        return NucleusOneProjectType.project;
      case departmentAccessType:
        return NucleusOneProjectType.department;
    }
    throw ArgumentError.value(
        accessType, 'accessType', 'Unrecognized access type.');
  }
}
