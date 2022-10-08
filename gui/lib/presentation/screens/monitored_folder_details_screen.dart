import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiver/strings.dart' as quiver;

import '../../application/monitored_folder.dart';
import '../../application/providers.dart';
import '../util/style.dart';

const Widget _fieldEditButtonWidthSpacer = SizedBox(width: 48);
const Widget _formRowSpacer = SizedBox(height: Insets.compSmall);

class MonitoredFolderDetailsScreen extends ConsumerStatefulWidget {
  const MonitoredFolderDetailsScreen({super.key, this.mfToEdit});

  /// If null then anew [MonitoredFolder] will be created.
  final MonitoredFolder? mfToEdit;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MonitoredFolderDetailsScreenState();
}

class _MonitoredFolderDetailsScreenState
    extends ConsumerState<MonitoredFolderDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _originalMf =
      (isNew) ? MonitoredFolder.defaultValue() : widget.mfToEdit!;

  late var _mf = _originalMf.copyWith();

  late FileDisposition? _fileDisposition = _mf.fileDisposition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (isNew)
            ? const Text('New Monitored Folder')
            : const Text('Edit Monitored Folder'),
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

  bool get isNew => widget.mfToEdit == null;

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
          child: Focus(
            autofocus: true,
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              initialValue: _mf.name,
              validator: (value) {
                if (quiver.isBlank(value)) {
                  return 'This field is required';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onSaved: (newValue) => _mf = _mf.copyWith(name: newValue ?? ''),
            ),
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
            initialValue: _mf.description,
            onSaved: (newValue) =>
                _mf = _mf.copyWith(description: newValue ?? ''),
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
              value: _fileDisposition,
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
              onSaved: (newValue) =>
                  _mf = _mf.copyWith(fileDisposition: newValue),
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
            _resetButton(context),
            const SizedBox(width: Insets.compSmall),
            _saveButton(context),
          ],
        ),
      ),
    );
  }

  Widget _resetButton(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.error,
      ),
      onPressed: () {
        setState(() {
          _formKey.currentState?.reset();
        });
      },
      child: const Text('RESET'),
    );
  }

  Widget _saveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState?.validate() ?? true) {
          _formKey.currentState?.save();
          await ref.read(settingsProvider.notifier).saveMonitoredFolder(_mf);
          if (mounted) Navigator.pop(context);
        } else {
          final colorScheme = Theme.of(context).colorScheme;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: colorScheme.surfaceVariant,
              content: Text(
                'Please correct any issues and try again',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
              action: SnackBarAction(
                label: 'DISMISS',
                onPressed: () {
                  if (mounted) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  }
                },
              ),
            ),
          );
        }
      },
      child: (isNew) ? const Text('CREATE') : const Text('UPDATE'),
    );
  }
}
