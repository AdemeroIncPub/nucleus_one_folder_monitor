import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart'
    hide DataTable, DataColumn, DataRow, DataCell;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pool/pool.dart';
import 'package:quiver/strings.dart' as quiver;

import '../../application/monitored_folder.dart';
import '../../application/providers.dart';
import '../../application/settings.dart';
import '../util/dialog_helper.dart';
import '../util/style.dart';
import '../widgets/data_table.dart';
import 'monitored_folder_details_screen.dart';

part 'main_screen.freezed.dart';

final sortedMonitoredFoldersProvider = StateProvider.family
    .autoDispose<IList<MonitoredFolder>, SortArgs>((ref, args) {
  final monitoredFolders = ref.watch(monitoredFoldersProvider);

  if (args.columnIndex != null) {
    return monitoredFolders.sorted((a, b) {
      String a2;
      String b2;
      if (args.columnIndex == 1) {
        a2 = a.description.toLowerCase();
        b2 = b.description.toLowerCase();
      } else {
        a2 = a.name.toLowerCase();
        b2 = b.name.toLowerCase();
      }
      if (args.ascending) {
        return a2.compareTo(b2);
      } else {
        return b2.compareTo(a2);
      }
    }).lock;
  } else {
    return monitoredFolders;
  }
});

@freezed
class SortArgs with _$SortArgs {
  factory SortArgs({
    int? columnIndex,
    @Default(true) bool ascending,
  }) = _SortArgs;
}

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  bool _sortAscending = true;

  String? _selectedId;
  int? _sortColumn;

  @override
  void initState() {
    super.initState();
    unawaited(_updateMonitoredFoldersFromNucleusOne());
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: _appBar(context, settings),
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          primary: true,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: screenPadding),
            child: _mainContent(context),
          ),
        ),
      ),
      bottomNavigationBar: _bottomAppBar(context, settings),
    );
  }

  AppBar _appBar(BuildContext context, Settings settings) {
    return AppBar(
      title: const Text('Monitored Folders'),
      actions: [
        _settingsButton(context, settings),
        _aboutButton(context),
        const SizedBox(width: Insets.compXSmall),
      ],
    );
  }

  Widget _mainContent(BuildContext context) {
    final sortedMonitoredFolders = ref.watch(sortedMonitoredFoldersProvider(
        SortArgs(columnIndex: _sortColumn, ascending: _sortAscending)));
    final colorScheme = Theme.of(context).colorScheme;

    final columns = [
      DataColumn(
        label: const Text('Name'),
        onSort: (columnIndex, ascending) {
          setState(() {
            _sortColumn = columnIndex;
            _sortAscending = ascending;
          });
        },
      ),
      DataColumn(
        label: const Text('Description'),
        onSort: (columnIndex, ascending) {
          setState(() {
            _sortColumn = columnIndex;
            _sortAscending = ascending;
          });
        },
      ),
    ];

    final rows = sortedMonitoredFolders.mapIndexed((index, mf) {
      return DataRow(
        key: ObjectKey(mf),
        color: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primaryContainer.withOpacity(0.8);
          } else if (states.contains(MaterialState.hovered)) {
            return null; // Use the default value if hovered.
          }
          return null;
          // if (index.isEven) {
          //   return colorScheme.surfaceVariant.withOpacity(0.33);
          // } else {
          //   return colorScheme.surface.withOpacity(0.1);
          // }
        }),
        selected: mf.id == _selectedId,
        cells: [
          DataCell(
            Text(mf.name),
            onTap: () => _selectMonitoredFolder(monitoredFolderId: mf.id),
            onDoubleTap: () async => _editMonitoredFolder(context, mf),
          ),
          DataCell(
            Text(mf.description),
            onTap: () => _selectMonitoredFolder(monitoredFolderId: mf.id),
            onDoubleTap: () async => _editMonitoredFolder(context, mf),
          ),
        ],
      );
    }).toList();

    return SizedBox(
      width: double.infinity,
      child: DataTable(
        expandColumnIndex: 1,
        sortColumnIndex: _sortColumn,
        sortAscending: _sortAscending,
        showCheckboxColumn: false,
        showBottomBorder: true,
        headingRowColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return colorScheme.primary.withOpacity(0.1);
            }
            return null; // Use the default value.
          },
        ),
        columns: columns,
        rows: rows,
      ),
    );
  }

  void _selectMonitoredFolder({required String monitoredFolderId}) {
    setState(() {
      if (_selectedId == monitoredFolderId) {
        _selectedId = null;
      } else {
        _selectedId = monitoredFolderId;
      }
    });
  }

  Future<void> _editMonitoredFolder(
      BuildContext context, MonitoredFolder mfToEdit) {
    setState(() {
      _selectedId = mfToEdit.id;
    });
    return Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => MonitoredFolderDetailsScreen(
          mfToEdit: mfToEdit,
        ),
        settings: const RouteSettings(
          name: MonitoredFolderDetailsScreen.routeName,
        ),
      ),
    );
  }

  IconButton _settingsButton(BuildContext context, Settings settings) {
    return IconButton(
      icon: const Icon(Icons.settings),
      tooltip: 'Settings',
      onPressed: () async {
        await _showSettings(context, settings);
      },
    );
  }

  IconButton _aboutButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.help),
      tooltip: 'About',
      onPressed: () async {
        final info = await PackageInfo.fromPlatform();
        showAboutDialog(
          context: context,
          applicationVersion: 'version ${info.version}',
        );
      },
    );
  }

  FloatingActionButton _addButton(BuildContext context, Settings settings) {
    Future<String?> pushRoute(BuildContext context) async {
      return Navigator.push(
        context,
        MaterialPageRoute<String>(
          builder: (context) => const MonitoredFolderDetailsScreen(),
          settings: const RouteSettings(
            name: MonitoredFolderDetailsScreen.routeName,
          ),
        ),
      );
    }

    return FloatingActionButton(
      elevation: 0,
      disabledElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      onPressed: () async {
        if (quiver.isNotBlank(settings.apiKey)) {
          _selectedId = await pushRoute(context);
        } else {
          await _showSettings(context, settings);
          final apiKey = ref.read(settingsProvider).apiKey;
          if (quiver.isNotBlank(apiKey) && mounted) {
            _selectedId = await pushRoute(context);
          }
        }
      },
      child: const Icon(Icons.add),
    );
  }

  BottomAppBar _bottomAppBar(BuildContext context, Settings settings) {
    return BottomAppBar(
      child: Container(
        constraints: const BoxConstraints(
          minHeight: bottomAppBarMinHeight,
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.all(Insets.compSmall),
              child: _addButton(context, settings),
            ),
            const SizedBox(width: Insets.compXSmall),
            _editButton(context),
            const SizedBox(width: Insets.compXSmall),
            _deleteButton(context),
          ],
        ),
      ),
    );
  }

  Widget _editButton(BuildContext context) {
    final monitoredFolders = ref.watch(monitoredFoldersProvider);

    return TextButton(
      onPressed: (_selectedId == null)
          ? null
          : () async {
              final mfToEdit =
                  monitoredFolders.singleWhere((x) => x.id == _selectedId);
              return _editMonitoredFolder(context, mfToEdit);
            },
      child: const Text('EDIT'),
    );
  }

  Widget _deleteButton(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.error,
      ),
      onPressed: (_selectedId == null)
          ? null
          : () async {
              final result = await showConfirmationDialog(
                context,
                title: const Text('Confirm Delete'),
                contentText:
                    'Permanently delete the selected monitored folder?',
                falseText: 'CANCEL',
                trueText: 'DELETE',
                dangerous: true,
              );

              if (result ?? false) {
                ref
                    .read(settingsProvider.notifier)
                    .deleteMonitoredFolder(monitoredFolderId: _selectedId!);
                _selectedId = null;
              }
            },
      child: const Text('DELETE'),
    );
  }

  Future<void> _showSettings(BuildContext context, Settings settings) async {
    final apiKey = await showTextInputDialog(
      context,
      contentConstraints: const BoxConstraints(minWidth: 500),
      title: const Text('Set API key'),
      initialText: settings.apiKey,
      helperText:
          'Generate API keys in your profile in the Nucleus One web app',
      hintText: 'Your API key',
    );
    if (apiKey != null) {
      ref.read(settingsProvider.notifier).setApiKey(apiKey);
    }
  }

  Future<void> _updateMonitoredFoldersFromNucleusOne() async {
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final mfs = ref.read(monitoredFoldersProvider);
    final pool = Pool(4);

    //todo(apn): handle org/project/folder not found
    // test no longer exists as well as never did, I got 500 error by passing
    // bogus folderId
    for (final mf in mfs) {
      final orgsF =
          pool.withResource(() => ref.read(n1UserOrganizationsProvider.future));
      final projectsF = pool.withResource(() => ref.read(
          n1OrganizationProjectsProvider(mf.n1Folder.organizationId).future));
      final docFoldersF = mf.n1Folder.folderIds.map((folderId) {
        final args = GetDocumentFolderByIdArgs(
          orgId: mf.n1Folder.organizationId,
          projectId: mf.n1Folder.projectId,
          folderId: folderId,
        );
        return pool.withResource(() {
          return ref.read(n1DocumentFolderByIdProvider(args).future);
        });
      });

      try {
        final orgs = await orgsF;
        final projects = await projectsF;
        final docFolders = await Future.wait(docFoldersF);

        final orgName = orgs
            .firstWhere((x) => x.organizationID == mf.n1Folder.organizationId)
            .organizationName;
        final projectName =
            projects.firstWhere((x) => x.id == mf.n1Folder.projectId).name;

        final newMf = mf.copyWith.n1Folder(
          organizationName: orgName,
          projectName: projectName,
          folderNames: docFolders.map((x) => x!.name).toList(),
        );

        settingsNotifier.saveMonitoredFolder(newMf);
        // ignore: empty_catches, avoid_catches_without_on_clauses
      } catch (e) {} // brute force ignore errors updating names
    }

    await pool.close();
    return pool.done;
  }
}
