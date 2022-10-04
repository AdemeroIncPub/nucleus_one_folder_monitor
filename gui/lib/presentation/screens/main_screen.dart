import 'package:flutter/material.dart'
    hide DataTable, DataColumn, DataRow, DataCell;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../application/providers.dart';
import '../../application/settings.dart';
import '../util/dialog_helper.dart';
import '../util/style.dart';
import '../widgets/data_table.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  static const int numItems = 10;

  bool sortAscending = true;

  int? selectedRow;
  int? sortColumn;

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: settings.whenOrNull(
        data: (settings) => _appBar(context, settings),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: screenPadding)
            .copyWith(top: 12),
        child: settings.when(
          loading: _loading,
          //todo(apn): show error
          error: (error, stackTrace) => Text('$error\n$stackTrace'),
          data: (_) => _mainContent(context),
        ),
      ),
      floatingActionButton: settings.whenOrNull(
        data: (settings) => _addButton(context, settings),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: settings.whenOrNull(
        data: (_) => _bottomAppBar(context),
      ),
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

  Widget _loading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: FractionallySizedBox(
                heightFactor: 0.25,
                widthFactor: 0.25,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column _mainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: _dataTable(context),
          ),
        ),
      ],
    );
  }

  Widget _dataTable(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final columns = [
      DataColumn(
        label: const Text('Name'),
        onSort: (columnIndex, ascending) {
          setState(() {
            sortColumn = columnIndex;
            sortAscending = ascending;
          });
        },
      ),
      DataColumn(
        label: const Text('Description'),
        onSort: (columnIndex, ascending) {
          setState(() {
            sortColumn = columnIndex;
            sortAscending = ascending;
          });
        },
      ),
    ];

    final rows = List<DataRow>.generate(numItems, (index) {
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
        selected: selectedRow == index,
        onSelectChanged: (bool? value) {
          setState(() {
            if (value ?? true) {
              selectedRow = index;
            } else {
              selectedRow = null;
            }
          });
        },
        cells: [
          DataCell(
            Text('name $index'),
          ),
          DataCell(
            Text('description $index'),
          ),
        ],
      );
    });

    final rowsSorted = () {
      if (sortColumn != null) {
        if (sortAscending) {
          return rows;
        } else {
          return rows.reversed.toList();
        }
      }
      return rows;
    }();

    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        primary: true,
        child: DataTable(
          expandColumnIndex: 1,
          sortColumnIndex: sortColumn,
          sortAscending: sortAscending,
          showCheckboxColumn: false,
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
      ),
    );
  }

  IconButton _settingsButton(BuildContext context, Settings settings) {
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () async {
        await _showSettings(context, settings);
      },
    );
  }

  IconButton _aboutButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.help),
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
    return FloatingActionButton(
      onPressed: () async {
        if (settings.apiKey.isEmpty) {
          return _showSettings(context, settings);
        } else {
          // go to add screen
        }
      },
      child: const Icon(Icons.add),
    );
  }

  BottomAppBar _bottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.only(left: screenPadding),
        child: Row(
          children: [
            _editButton(),
            const SizedBox(width: Insets.compXSmall),
            _deleteButton(context),
          ],
        ),
      ),
    );
  }

  Widget _editButton() {
    return TextButton(
      onPressed: (selectedRow == null) ? null : () {},
      child: const Text('EDIT'),
    );
  }

  Widget _deleteButton(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.error,
      ),
      onPressed: (selectedRow == null) ? null : () {},
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
