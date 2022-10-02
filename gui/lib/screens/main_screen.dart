import 'package:flutter/material.dart'
    hide DataTable, DataColumn, DataRow, DataCell;

import '../util/style.dart';
import '../widgets/data_table.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const int numItems = 10;

  int? selectedRow;
  int? sortColumn;
  bool sortAscending = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        margin: const EdgeInsets.only(left: screenPadding, top: 12),
        child: _mainContent(context),
      ),
      floatingActionButton: _addButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: _bottomAppBar(context),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('Monitored Folders'),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {},
        ),
      ],
    );
  }

  Column _mainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Container(
        //   margin: const EdgeInsets.only(right: screenPadding),
        //   child: Text(
        //     'Monitored Folders',
        //     style: Theme.of(context).textTheme.titleLarge,
        //   ),
        // ),
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

  FloatingActionButton _addButton() {
    return FloatingActionButton(
      onPressed: () {},
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
}
