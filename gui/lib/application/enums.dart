enum N1ProjectType {
  projects(
    str: 'Projects',
    accessType: 'GlobalAssignments_MemberContentByDefault',
  ),
  departments(
    str: 'Departments',
    accessType: 'MembersOnlyAssignments_MemberContentByAssignment',
  );

  const N1ProjectType({
    required this.str,
    required this.accessType,
  });
  final String str;
  final String accessType;
}
