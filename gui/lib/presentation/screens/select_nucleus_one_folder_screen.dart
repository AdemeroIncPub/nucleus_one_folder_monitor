import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart' as n1;

import '../../application/enums.dart';
import '../../application/monitored_folder.dart';
import '../../application/providers.dart';
import '../util/flutter_icon_custom_icons_icons.dart';
import '../util/style.dart';
import '../widgets/nucleus_one_path.dart';
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
  final _navigatedFolders = <n1.DocumentFolder>[];

  var _folders = const AsyncValue<List<n1.DocumentFolder>>.loading();
  int _level = 0;
  var _orgsAsync = const AsyncValue<List<n1.UserOrganization>>.loading();
  var _projectsAsync = const AsyncValue<List<n1.OrganizationProject>>.loading();

  n1.UserOrganization? _navigatedOrg;
  n1.OrganizationProject? _navigatedProject;
  N1ProjectType? _navigatedProjectType;
  n1.DocumentFolder? _selectedFolder;
  n1.OrganizationProject? _selectedProject;

  @override
  void dispose() {
    // todo(apn): this doesn't work yet, but dispose of family is in Riverpod
    // source, but not yet released (soon).
    ref.invalidate(n1DocumentFoldersCachedProvider);
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    _watchProviders();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Nucleus One Destination'),
      ),
      body: _mainContent(context),
      bottomNavigationBar: _bottomAppBar(context),
    );
  }

  int? get _folderLevel {
    final folderLevel = _level - _N1LevelType.folders.index;
    if (folderLevel > -1) {
      return folderLevel;
    }
    return null;
  }

  _N1LevelType get _n1LevelType => _N1LevelType.getLevel(_level);

  void _watchProviders() {
    // get orgs
    _orgsAsync = ref.watch(n1UserOrganizationsProvider);

    // get projects
    if (_navigatedOrg != null) {
      _projectsAsync = ref
          .watch(n1OrganizationProjectsProvider(_navigatedOrg!.organizationID));

      // get folders by current level
      if (_folderLevel != null) {
        final args = GetDocumentFoldersArgs(
          orgId: _navigatedOrg!.organizationID,
          projectId: _navigatedProject!.id,
          parentId: _navigatedFolders.lastOrNull?.id,
        );

        _folders = ref.watch(n1DocumentFoldersCachedProvider(args));
      }
    }
  }

  Widget _mainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _folderPathBar(context),
        Expanded(child: _listView()),
      ],
    );
  }

  Widget _folderPathBar(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: Insets.compSmall),
        _upButton(context),
        const SizedBox(width: Insets.compMedium),
        NucleusOnePath(
          organizationName: _navigatedOrg?.organizationName,
          projectType: _navigatedProjectType,
          projectName: _navigatedProject?.name,
          folderNames: _navigatedFolders.map((e) => e.name).toList(),
        ),
      ],
    );
  }

  Widget _upButton(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).iconTheme.color,
      ),
      onPressed: (_n1LevelType == _N1LevelType.organizations)
          ? null
          : () {
              setState(() {
                if (_level > 0) {
                  _level--;
                  switch (_n1LevelType) {
                    case _N1LevelType.organizations:
                      _navigatedOrg = null;
                      break;
                    case _N1LevelType.projectTypes:
                      _navigatedProjectType = null;
                      _selectedProject = null;
                      _selectedFolder = null;
                      break;
                    case _N1LevelType.projectNames:
                      _navigatedProject = null;
                      _selectedFolder = null;
                      break;
                    case _N1LevelType.folders:
                      if (_navigatedFolders.isNotEmpty) {
                        final removed = _navigatedFolders.removeLast();
                        _selectedFolder = removed;
                      }
                      break;
                  }
                }
              });
            },
      child: Row(
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
            return _orgListTile(
              context: context,
              org: orgs[index],
            );
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
          return _projectTypeListTile(
            context: context,
            projectType: N1ProjectType.project,
          );
        } else {
          return _projectTypeListTile(
            context: context,
            projectType: N1ProjectType.department,
          );
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
            return _projectListTile(
              context: context,
              project: projects[index],
            );
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
    return _folders.when(
      data: (folders) {
        return _commonListView(
          itemCount: folders.length,
          itemBuilder: (context, index) {
            return _folderListTile(
              context: context,
              documentFolder: folders[index],
            );
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
          return const Divider(
            thickness: 1,
            height: 2,
          );
        },
      ),
    );
  }

  Widget _orgListTile({
    required BuildContext context,
    required n1.UserOrganization org,
  }) {
    void navToFolder() {
      setState(() {
        _level++;
        _navigatedOrg = org;
      });
    }

    return _commonListTile(
      context: context,
      titleIcon: const Icon(Icons.business),
      title: Text(org.organizationName),
      navToFolder: navToFolder,
      isSelected: false,
    );
  }

  Widget _projectTypeListTile({
    required BuildContext context,
    required N1ProjectType projectType,
  }) {
    void navToFolder() {
      ref
          .read(n1OrganizationProjects_ProjectTypeFilterProvider.notifier)
          .state = projectType;
      setState(() {
        _level++;
        _navigatedProjectType = projectType;
      });
    }

    final projectTypeText =
        (projectType == N1ProjectType.project) ? 'Projects' : 'Departments';
    return _commonListTile(
      context: context,
      titleIcon: (projectType == N1ProjectType.project)
          ? const Icon(FlutterIconCustomIcons.project)
          : const Icon(FlutterIconCustomIcons.department),
      title: Text(projectTypeText),
      navToFolder: navToFolder,
      isSelected: false,
    );
  }

  Widget _projectListTile({
    required BuildContext context,
    required n1.OrganizationProject project,
  }) {
    void navToFolder() {
      setState(() {
        _level++;
        _navigatedProject = project;
        _selectedProject = project;
      });
    }

    return _commonListTile(
      context: context,
      titleIcon: (_navigatedProjectType == N1ProjectType.project)
          ? const Icon(FlutterIconCustomIcons.project)
          : const Icon(FlutterIconCustomIcons.department),
      title: Text(project.name),
      navToFolder: navToFolder,
      isSelected: _selectedProject?.id == project.id,
      selectFolder: () {
        setState(() {
          _selectedProject = project;
        });
      },
    );
  }

  Widget _folderListTile({
    required BuildContext context,
    required n1.DocumentFolder documentFolder,
  }) {
    void navToFolder() {
      setState(() {
        _level++;
        _selectedFolder = documentFolder;
        _navigatedFolders.add(documentFolder);
      });
    }

    return _commonListTile(
      context: context,
      titleIcon: const Icon(Icons.folder),
      title: Text(documentFolder.name),
      navToFolder: navToFolder,
      isSelected: _selectedFolder?.id == documentFolder.id,
      selectFolder: () {
        setState(() {
          _selectedFolder = documentFolder;
        });
      },
    );
  }

  Widget _commonListTile({
    required BuildContext context,
    required Widget titleIcon,
    required Widget title,
    required VoidCallback navToFolder,
    required bool isSelected,
    VoidCallback? selectFolder,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      visualDensity:
          const VisualDensity(vertical: VisualDensity.minimumDensity),
      horizontalTitleGap: Insets.compXSmall,
      leading: _NavToFolderButton(onPressed: navToFolder),
      title: RawGestureDetector(
        gestures: {
          SerialTapGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<SerialTapGestureRecognizer>(
            () => SerialTapGestureRecognizer(),
            (SerialTapGestureRecognizer serialRecognizer) {
              serialRecognizer.onSerialTapUp = (details) {
                if (details.count == 1 && selectFolder != null) {
                  selectFolder();
                }
                if (details.count == 2) {
                  navToFolder();
                }
              };
            },
          )
        },
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            titleIcon,
            const SizedBox(width: Insets.compXSmall),
            title,
          ],
        ),
      ),
      selected: isSelected,
      selectedTileColor: colorScheme.surfaceVariant.withOpacity(0.33),
    );
  }

  BottomAppBar _bottomAppBar(BuildContext context) {
    Row selectedForDisplay() {
      if (_selectedProject == null) {
        return Row();
      }
      if (_selectedFolder == null) {
        if (_navigatedProjectType == N1ProjectType.project) {
          return Row(
            children: [
              const Icon(FlutterIconCustomIcons.project),
              const SizedBox(width: 2),
              Text(_selectedProject!.name),
            ],
          );
        } else {
          return Row(
            children: [
              const Icon(FlutterIconCustomIcons.department),
              const SizedBox(width: 2),
              Text(_selectedProject!.name),
            ],
          );
        }
      }
      return Row(
        children: [
          const SizedBox(width: 2),
          Text('${_selectedFolder?.name}'),
        ],
      );
    }

    final theme = Theme.of(context);
    return BottomAppBar(
      child: Container(
        constraints: const BoxConstraints(
          minHeight: bottomAppBarMinHeight,
        ),
        padding: const EdgeInsets.symmetric(horizontal: screenPadding),
        child: Row(
          children: [
            ElevatedButton(
              onPressed: (_selectedProject == null)
                  ? null
                  : () {
                      final folders = _navigatedFolders.toList();
                      if (_selectedFolder != folders.lastOrNull) {
                        folders.add(_selectedFolder!);
                      }
                      Navigator.pop(
                        context,
                        NucleusOneFolder(
                          organizationId: _navigatedOrg!.organizationID,
                          organizationName: _navigatedOrg!.organizationName,
                          projectId: _selectedProject!.id,
                          projectName: _selectedProject!.name,
                          projectType: N1ProjectType.fromAccessType(
                              _selectedProject!.accessType)!,
                          folderIds: folders.map((e) => e.id).toList(),
                          folderNames: folders.map((e) => e.name).toList(),
                        ),
                      );
                    },
              child: const Text('OK'),
            ),
            const SizedBox(width: Insets.compLarge),
            Text(
              'Selected: ',
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
            SelectionArea(child: selectedForDisplay()),
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
      onPressed: onPressed,
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
