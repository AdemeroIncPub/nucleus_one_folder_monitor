import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart' as n1;

import '../../application/providers.dart';
import '../util/flutter_icon_custom_icons.dart';
import '../util/style.dart';
import '../widgets/quarter_size_circular_progress_indicator.dart';

class SelectNucleusOneFolderScreen extends ConsumerStatefulWidget {
  const SelectNucleusOneFolderScreen({super.key});

  static const routeName =
      '/MonitoredFolderDetailsScreen/SelectNucleusOneFolderScreen';

  @override
  ConsumerState<SelectNucleusOneFolderScreen> createState() =>
      _SelectNucleusOneFolderScreenState();
}

class _SelectNucleusOneFolderScreenState
    extends ConsumerState<SelectNucleusOneFolderScreen> {
  // final List<AsyncValue<List<n1.DocumentFolder>>> _folderLists = [];
  final _selectedFolderIds = <String?>[];

  int _level = 0;
  var _orgsAsync = const AsyncValue<List<n1.UserOrganization>>.loading();
  var _projectsAsync = const AsyncValue<List<n1.OrganizationProject>>.loading();
  var _folders = const AsyncValue<List<n1.DocumentFolder>>.loading();

  n1.UserOrganization? _selectedOrg;
  n1.OrganizationProject? _selectedProject;
  _N1ProjectType? _selectedProjectType;

  @override
  void initState() {
    super.initState();

    // Explore skipping orgs if there is only one.
    // ref.listenManual(n1UserOrganizationsProvider, (previous, next) {
    //   final orgs = next.valueOrNull;
    //   if (orgs != null) {
    //     if (orgs.length == 1 && _currentLevel == 0) {
    //       setState(() {
    //         _currentLevel = 1;
    //         _orgId = orgs[0].organizationID;
    //         _singleOrg = true;
    //       });
    //     }
    //   }
    // });
  }

  @override
  void dispose() {
    ref.invalidate(n1DocumentFoldersProvider);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // get orgs
    _orgsAsync = ref.watch(n1UserOrganizationsProvider);

    // get projects
    if (_selectedOrg != null) {
      _projectsAsync = ref
          .watch(n1OrganizationProjectsProvider(_selectedOrg!.organizationID));
    }

    // get folders by current level
    if (_folderLevel != null) {
      final folderLevel = _folderLevel!;
      final parentId =
          (folderLevel > 0 && _selectedFolderIds.length > folderLevel - 1)
              ? _selectedFolderIds[folderLevel - 1]
              : null;

      final args = GetProjectDocumentFoldersArgs(
        orgId: _selectedOrg!.organizationID,
        projectId: _selectedProject!.id,
        parentId: parentId,
      );

      _folders = ref.watch(n1DocumentFoldersProvider(args));

      // if (_folderLists.length > folderLevel) {
      //   _folderLists[folderLevel] = ref.watch(n1DocumentFoldersProvider(args));
      // } else {
      //   _folderLists.add(ref.watch(n1DocumentFoldersProvider(args)));
      // }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Nucleus One Destination'),
      ),
      body: _mainContent(),
      bottomNavigationBar: _bottomAppBar(),
    );
  }

  // AsyncValue<List<n1.DocumentFolder>> get _currentFolders {
  //   if (_folderLevel != null && _folderLists.length > _folderLevel!) {
  //     return _folderLists[_folderLevel!];
  //   }
  //   return const AsyncValue.data([]);
  // }

  int? get _folderLevel {
    final folderLevel = _level - _N1LevelType.folders.index;
    if (folderLevel > -1) {
      return folderLevel;
    }
    return null;
  }

  _N1LevelType get _n1LevelType => _N1LevelType.getLevel(_level);

  Widget _mainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _folderPathBar(),
        Expanded(child: _listView()),
      ],
    );
  }

  Row _folderPathBar() {
    return Row(
      children: [
        const SizedBox(width: Insets.compSmall),
        Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: _n1LevelType != _N1LevelType.organizations,
          child: _upButton(),
        ),
      ],
    );
  }

  Widget _upButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          if (_level > 0) {
            _level--;
          }
        });
      },
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.keyboard_arrow_up),
          SizedBox(width: Insets.typeTiny),
          Text('Up'),
          SizedBox(width: Insets.typeTiny),
        ],
      ),
    );
  }

  Widget _listView() {
    switch (_n1LevelType) {
      case _N1LevelType.organizations:
        return _orgListView();
      case _N1LevelType.projectTypes:
        return _projectTypeListView();
      case _N1LevelType.projectNames:
        return _projectListView();
      case _N1LevelType.folders:
        return _folderListView();
    }
  }

  Widget _orgListView() {
    return _orgsAsync.when(
      data: (orgs) {
        return _commonListView(
          itemCount: orgs.length,
          itemBuilder: (context, index) {
            return _orgListTile(org: orgs[index]);
          },
        );
      },
      error: (error, stackTrace) => Text('$error\n$stackTrace'),
      loading: () => const Center(
        child: QuarterSizeCircularProgressIndicator(),
      ),
    );
  }

  Widget _projectTypeListView() {
    return _commonListView(
      itemCount: 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _projectTypeListTile(projectType: _N1ProjectType.projects);
        } else {
          return _projectTypeListTile(projectType: _N1ProjectType.departments);
        }
      },
    );
  }

  Widget _projectListView() {
    return _projectsAsync.when(
      data: (projects) {
        return _commonListView(
          itemCount: projects.length,
          itemBuilder: (context, index) {
            return _projectListTile(project: projects[index]);
          },
        );
      },
      error: (error, stackTrace) => Text('$error\n$stackTrace'),
      loading: () => const Center(
        child: QuarterSizeCircularProgressIndicator(),
      ),
    );
  }

  Widget _folderListView() {
    // return _currentFolders.when(
    return _folders.when(
      data: (folders) {
        return _commonListView(
          itemCount: folders.length,
          itemBuilder: (context, index) {
            return _folderListTile(documentFolder: folders[index]);
          },
        );
      },
      error: (error, stackTrace) => Text('$error\n$stackTrace'),
      loading: () => const Center(
        child: QuarterSizeCircularProgressIndicator(),
      ),
    );
  }

  Widget _commonListView({
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
  }) {
    return Scrollbar(
      thumbVisibility: true,
      child: ListView.separated(
        padding: const EdgeInsets.all(Insets.compSmall)
            .copyWith(top: Insets.compXSmall),
        primary: true,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ),
    );
  }

  Widget _orgListTile({required n1.UserOrganization org}) {
    return _listTile(
      leading: _NavToFolderButton(onPressed: () {
        setState(() {
          _level++;
          _selectedOrg = org;
        });
      }),
      titleIcon: const Icon(Icons.business),
      title: Text(org.organizationName),
    );
  }

  Widget _projectTypeListTile({required _N1ProjectType projectType}) {
    return _listTile(
      leading: _NavToFolderButton(onPressed: () {
        setState(() {
          _level++;
          _selectedProjectType = projectType;
        });
      }),
      titleIcon: (projectType == _N1ProjectType.projects)
          ? const _ProjectIcon()
          : const _DepartmentIcon(),
      title: Text(projectType.str),
    );
  }

  Widget _projectListTile({required n1.OrganizationProject project}) {
    return _listTile(
      leading: _NavToFolderButton(onPressed: () {
        setState(() {
          _level++;
          _selectedProject = project;
        });
      }),
      titleIcon: (_selectedProjectType == _N1ProjectType.projects)
          ? const _ProjectIcon()
          : const _DepartmentIcon(),
      title: Text(project.name),
    );
  }

  Widget _folderListTile({required n1.DocumentFolder documentFolder}) {
    return _listTile(
      leading: _NavToFolderButton(onPressed: () {
        setState(() {
          _level++;
          final index = _folderLevel! - 1;
          if (_selectedFolderIds.length > index) {
            _selectedFolderIds.insert(index, documentFolder.id);
          } else {
            _selectedFolderIds.add(documentFolder.id);
          }
        });
      }),
      titleIcon: const Icon(Icons.folder),
      title: Text(documentFolder.name),
    );
  }

  Widget _listTile({
    required Widget leading,
    required Widget titleIcon,
    required Widget title,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      visualDensity:
          const VisualDensity(vertical: VisualDensity.minimumDensity),
      horizontalTitleGap: Insets.compXSmall,
      leading: leading,
      title: Row(children: [
        titleIcon,
        const SizedBox(width: Insets.compXSmall),
        title,
      ]),
    );
  }

  BottomAppBar _bottomAppBar() {
    return BottomAppBar(
      child: Container(
        constraints: const BoxConstraints(
          minHeight: bottomAppBarMinHeight,
        ),
        padding: const EdgeInsets.symmetric(horizontal: screenPadding),
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavToFolderButton extends StatelessWidget {
  const _NavToFolderButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.keyboard_arrow_right),
      // style: IconButton.styleFrom(
      //   foregroundColor: Theme.of(context).colorScheme.primary,
      // ),
      onPressed: onPressed,
    );
  }
}

class _ProjectIcon extends StatelessWidget {
  const _ProjectIcon();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 4),
      child: Icon(FlutterIconCustomIcons.projects),
    );
  }
}

class _DepartmentIcon extends StatelessWidget {
  const _DepartmentIcon();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 2),
      child: Icon(FlutterIconCustomIcons.departments),
    );
  }
}

enum _N1LevelType {
  organizations,
  projectTypes,
  projectNames,
  folders;

  static _N1LevelType getLevel(int level) {
    if (level < 1) return _N1LevelType.organizations;
    if (level == 1) return _N1LevelType.projectTypes;
    if (level == 2) return _N1LevelType.projectNames;
    return _N1LevelType.folders;
  }
}

enum _N1ProjectType {
  projects('Projects'),
  departments('Departments');

  const _N1ProjectType(this.str);
  final String str;
}
