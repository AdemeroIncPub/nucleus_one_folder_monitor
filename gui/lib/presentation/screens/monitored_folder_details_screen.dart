import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiver/strings.dart' as quiver;

import '../../application/monitored_folder.dart';
import '../util/style.dart';

const Widget _fieldEditButtonWidthSpacer = SizedBox(width: 48);
const Widget _formRowSpacer = SizedBox(height: Insets.compSmall);

class MonitoredFolderDetailsScreen extends ConsumerStatefulWidget {
  const MonitoredFolderDetailsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MonitoredFolderDetailsScreenState();
}

class _MonitoredFolderDetailsScreenState
    extends ConsumerState<MonitoredFolderDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  FileDisposition? _fileDisposition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitored Folder Details'),
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          primary: true,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: screenPadding)
                .copyWith(bottom: screenPadding),
            child: _mainContent(context),
          ),
        ),
      ),
      bottomNavigationBar: _bottomAppBar(context),
    );
  }

  Widget _mainContent(BuildContext context) {
    // This Align pushes the scrollbar all the way to the right.
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        constraints: const BoxConstraints(minWidth: 600),
        child: IntrinsicWidth(
          child: Form(
            key: _formKey,
            onWillPop: () async => true, //todo(apn): warn if there are changes
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _nameFormRow(context),
                _formRowSpacer,
                _descriptionFormRow(context),
                _formRowSpacer,
                _localFolderFormRow(context),
                _formRowSpacer,
                _n1DestinationFormRow(context),
                _formRowSpacer,
                _fileDispositionFormRow(context),
                if (_fileDisposition == FileDisposition.move) ...[
                  _formRowSpacer,
                  _moveFileDestinationFormRow(context),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _nameFormRow(BuildContext context) {
    return Row(
      children: [
        _fieldEditButtonWidthSpacer,
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
            validator: (value) {
              if (quiver.isBlank(value)) {
                return 'This field is required';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _descriptionFormRow(BuildContext context) {
    return Row(
      children: [
        _fieldEditButtonWidthSpacer,
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Description',
            ),
          ),
        ),
      ],
    );
  }

  Widget _localFolderFormRow(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            await showDialog<void>(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  content: Text('OK'),
                );
              },
            );
          },
          icon: const Icon(Icons.edit),
        ),
        const SizedBox(width: Insets.compXSmall),
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Folder to monitor',
            ),
            readOnly: true,
          ),
        ),
      ],
    );
  }

  Widget _n1DestinationFormRow(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            await showDialog<void>(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  content: Text('OK'),
                );
              },
            );
          },
          icon: const Icon(Icons.edit),
        ),
        const SizedBox(width: Insets.compXSmall),
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Nucleus One destination',
            ),
            readOnly: true,
          ),
        ),
      ],
    );
  }

  Widget _fileDispositionFormRow(BuildContext context) {
    return Row(
      children: [
        _fieldEditButtonWidthSpacer,
        Container(
          constraints: const BoxConstraints(minWidth: 200),
          child: IntrinsicWidth(
            child: DropdownButtonFormField(
              decoration: const InputDecoration(
                labelText: 'File disposition',
                // label: Text('File disposition', softWrap: false),
              ),
              items: const [
                DropdownMenuItem(
                  value: FileDisposition.delete,
                  child: Text('Delete'),
                ),
                DropdownMenuItem(
                  value: FileDisposition.move,
                  child: Text('Move'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _fileDisposition = value;
                });
              },
            ),
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: () async {
            await showDialog<void>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('File Disposition'),
                  content: const Text(
                      'There are two options for handling your files after '
                      'they have been uploaded to Nucleus One.\n'
                      '- Delete local files once they are in Nucleus One.\n'
                      '- Move files to another local folder once they are in Nucleus One.'),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                  actionsAlignment: MainAxisAlignment.start,
                );
              },
            );
          },
          icon: const Icon(Icons.help),
        ),
      ],
    );
  }

  Widget _moveFileDestinationFormRow(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            await showDialog<void>(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  content: Text('OK'),
                );
              },
            );
          },
          icon: const Icon(Icons.edit),
        ),
        const SizedBox(width: Insets.compXSmall),
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Move to folder',
            ),
            readOnly: true,
          ),
        ),
      ],
    );
  }

  BottomAppBar _bottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Container(
        constraints: const BoxConstraints(
          minHeight: bottomAppBarMinHeight,
        ),
        padding: const EdgeInsets.only(left: screenPadding),
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
