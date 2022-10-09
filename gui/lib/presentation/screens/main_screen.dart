import 'package:collection/collection.dart';
import 'package:flutter/material.dart'
    hide DataTable, DataColumn, DataRow, DataCell;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quiver/strings.dart' as quiver;

import '../../application/providers.dart';
import '../../application/settings.dart';
import '../util/dialog_helper.dart';
import '../util/style.dart';
import '../widgets/data_table.dart';
import 'monitored_folder_details_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  bool _sortAscending = true;

  int? _selectedRow;
  int? _sortColumn;

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
            child: _mainContent(context, settings),
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

  Widget _mainContent(BuildContext context, Settings settings) {
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

    final rows = settings.monitoredFolders.mapIndexed((index, mf) {
      return DataRow(
        color: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primaryContainer.withOpacity(0.8);
          } else if (states.contains(MaterialState.hovered)) {
            return null; // Use the default value if hovered.
          }
          if (index.isEven) {
            return colorScheme.surfaceVariant.withOpacity(0.33);
          } else {
            return colorScheme.surface.withOpacity(0.1);
          }
        }),
        selected: _selectedRow == index,
        onSelectChanged: (bool? value) {
          setState(() {
            if (value ?? true) {
              _selectedRow = index;
            } else {
              _selectedRow = null;
            }
          });
        },
        cells: [
          DataCell(
            Text(mf.name),
          ),
          DataCell(
            Text(mf.description),
          ),
        ],
      );
    }).toList();

    final rowsSorted = () {
      if (_sortColumn != null) {
        if (_sortAscending) {
          return rows;
        } else {
          return rows.reversed.toList();
        }
      }
      return rows;
    }();

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
        rows: rowsSorted,
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
    Future<void> pushRoute(BuildContext context) async {
      await Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) => const MonitoredFolderDetailsScreen(),
          settings: const RouteSettings(
            name: '/MonitoredFolderDetailsScreen',
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
          await pushRoute(context);
        } else {
          await _showSettings(context, settings);
          final apiKey = ref.read(settingsProvider).apiKey;
          if (quiver.isNotBlank(apiKey) && mounted) {
            await pushRoute(context);
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
            _editButton(context, settings),
            const SizedBox(width: Insets.compXSmall),
            _deleteButton(context),
          ],
        ),
      ),
    );
  }

  Widget _editButton(BuildContext context, Settings settings) {
    return TextButton(
      onPressed: (_selectedRow == null)
          ? null
          : () async {
              await Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => MonitoredFolderDetailsScreen(
                    mfToEdit: settings.monitoredFolders[_selectedRow!],
                  ),
                  settings: const RouteSettings(
                    name: '/MonitoredFolderDetailsScreen',
                  ),
                ),
              );
            },
      child: const Text('EDIT'),
    );
  }

  Widget _deleteButton(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.error,
      ),
      onPressed: (_selectedRow == null) ? null : () {},
      child: const Text('DELETE'),
    );
  }

  Future<void> _showSettings(BuildContext context, Settings settings) async {
    final apiKey = await showTextInputDialog(
      context,
      contentConstraints: const BoxConstraints(minWidth: 500),
      title: const Text('Set API key'),
      text: settings.apiKey,
      helperText:
          'Generate API keys in your profile in the Nucleus One web app',
      hintText: 'Your API key',
    );
    if (apiKey != null) {
      ref.read(settingsProvider.notifier).setApiKey(apiKey);
    }
  }
}
