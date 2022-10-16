import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiver/strings.dart' as quiver;

import '../../application/enums.dart';
import '../../application/monitored_folder.dart';
import '../../application/providers.dart';
import '../util/style.dart';
import '../widgets/nucleus_one_path.dart';
import 'select_nucleus_one_folder_screen.dart';

enum FileDispositionType {
  delete,
  move,
}

const Widget _fieldEditButtonWidthSpacer = SizedBox(width: 48);
const Widget _formRowSpacer = SizedBox(height: Insets.compSmall);

class MonitoredFolderDetailsScreen extends ConsumerStatefulWidget {
  const MonitoredFolderDetailsScreen({super.key, this.mfToEdit});

  static const routeName = '/MonitoredFolderDetailsScreen';

  /// If null then a new [MonitoredFolder] will be created.
  final MonitoredFolder? mfToEdit;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MonitoredFolderDetailsScreenState();
}

class _MonitoredFolderDetailsScreenState
    extends ConsumerState<MonitoredFolderDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _monitoredFolderTextFieldController = TextEditingController();
  final _moveToFolderTextFieldController = TextEditingController();
  final _n1DestinationFormFieldFocusNode = FocusNode();
  final _n1DestinationFormFieldKey =
      GlobalKey<FormFieldState<SelectNucleusOneFolderScreenResult>>();

  late final _originalMf =
      (isNew) ? MonitoredFolder.defaultValue() : widget.mfToEdit!;

  bool _isHovering = false;
  late var _mf = _originalMf.copyWith();

  FileDispositionType? _fileDispositionType;

  // if editing then need to set value...
  // late FileDispositionType? _fileDispositionType = _mf.fileDisposition.map(
  //   delete: (_) => FileDispositionType.delete,
  //   move: (_) => FileDispositionType.move,
  // );

  @override
  void dispose() {
    _n1DestinationFormFieldFocusNode.removeListener(_handleFocusChanged);
    _n1DestinationFormFieldFocusNode.dispose();
    _monitoredFolderTextFieldController.dispose();
    _moveToFolderTextFieldController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _n1DestinationFormFieldFocusNode.addListener(_handleFocusChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (isNew)
            ? const Text('New Monitored Folder')
            : const Text('Edit Monitored Folder'),
        actions: [
          _resetButton(context),
          const SizedBox(width: Insets.compXSmall),
        ],
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          primary: true,
          child: Container(
            margin: const EdgeInsets.all(screenPadding).copyWith(top: 0),
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
              children: [
                _nameFormRow(context),
                _formRowSpacer,
                _descriptionFormRow(context),
                _formRowSpacer,
                _monitoredFolderFormRow(context),
                _formRowSpacer,
                _n1DestinationFormRow(context),
                _formRowSpacer,
                _fileDispositionFormRow(context),
                if (_fileDispositionType == FileDispositionType.move) ...[
                  _formRowSpacer,
                  _moveToFolderFormRow(context),
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
              // onSaved: (newValue) => _mf = _mf.copyWith(name: newValue ?? ''),
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
            // onSaved: (newValue) =>
            //     _mf = _mf.copyWith(description: newValue ?? ''),
          ),
        ),
      ],
    );
  }

  Widget _monitoredFolderFormRow(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () async {
            final selectedPath = await FilePicker.platform.getDirectoryPath(
              dialogTitle: 'Select folder to monitor',
              initialDirectory: _monitoredFolderTextFieldController.text,
              lockParentWindow: true,
            );
            if (selectedPath != null) {
              _monitoredFolderTextFieldController.text = selectedPath;
              setState(() {});
            }
          },
        ),
        const SizedBox(width: Insets.compXSmall),
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Folder to monitor',
              hintText: 'Use the edit button to select the folder to monitor',
            ),
            controller: _monitoredFolderTextFieldController,
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
            final result =
                await Navigator.push<SelectNucleusOneFolderScreenResult>(
              context,
              MaterialPageRoute(
                builder: (context) => const SelectNucleusOneFolderScreen(),
                settings: const RouteSettings(
                  name: SelectNucleusOneFolderScreen.routeName,
                ),
              ),
            );
            if (result != null) {
              _n1DestinationFormFieldKey.currentState?.didChange(result);
            }
          },
          icon: const Icon(Icons.edit),
        ),
        const SizedBox(width: Insets.compXSmall),
        Expanded(
          child: GestureDetector(
            onTap: () => _n1DestinationFormFieldFocusNode.requestFocus(),
            child: MouseRegion(
              cursor: MaterialStateMouseCursor.textable,
              onEnter: (event) => _handleHover(true),
              onExit: (event) => _handleHover(false),
              child: Focus(
                focusNode: _n1DestinationFormFieldFocusNode,
                child: FormField<SelectNucleusOneFolderScreenResult>(
                  key: _n1DestinationFormFieldKey,
                  initialValue: null,
                  builder: (FormFieldState<SelectNucleusOneFolderScreenResult>
                      field) {
                    return InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Nucleus One destination',
                        hintText:
                            'Use the edit button to select the Nucleus One destination',
                      ),
                      isEmpty: field.value == null,
                      isFocused: _n1DestinationFormFieldFocusNode.hasFocus,
                      isHovering: _isHovering,
                      child: NucleusOnePath(
                        organizationName: field.value?.org.organizationName,
                        projectType: N1ProjectType.fromAccessType(
                            field.value?.project.accessType),
                        projectName: field.value?.project.name,
                        folderNames:
                            field.value?.folders.map((e) => e.name).toList() ??
                                [],
                        textStyle: Theme.of(context).textTheme.subtitle1,
                      ),
                    );
                  },
                ),
              ),
            ),
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
            child: DropdownButtonFormField<FileDispositionType>(
              decoration: const InputDecoration(
                labelText: 'File disposition',
                // label: Text('File disposition', softWrap: false),
              ),
              value: _fileDispositionType,
              items: const [
                DropdownMenuItem(
                  value: FileDispositionType.delete,
                  child: Text('Delete'),
                ),
                DropdownMenuItem(
                  value: FileDispositionType.move,
                  child: Text('Move'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _fileDispositionType = value;
                });
              },
              // onSaved: (newValue) =>
              //     _mf = _mf.copyWith(fileDisposition: newValue),
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

  Widget _moveToFolderFormRow(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            final selectedPath = await FilePicker.platform.getDirectoryPath(
              dialogTitle: 'Select destination folder',
              initialDirectory: _moveToFolderTextFieldController.text,
              lockParentWindow: true,
            );
            if (selectedPath != null) {
              _moveToFolderTextFieldController.text = selectedPath;
              setState(() {});
            }
          },
          icon: const Icon(Icons.edit),
        ),
        const SizedBox(width: Insets.compXSmall),
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Move to folder',
              hintText: 'Use the edit button to select the destination folder',
            ),
            controller: _moveToFolderTextFieldController,
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
        padding: const EdgeInsets.symmetric(horizontal: screenPadding),
        child: Row(
          children: [
            _saveButton(context),
          ],
        ),
      ),
    );
  }

  Widget _resetButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.restore),
      tooltip: 'Reset form',
      style: IconButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.error,
      ),
      onPressed: () {
        setState(() {
          _formKey.currentState?.reset();
        });
      },
    );
  }

  Widget _saveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState?.validate() ?? true) {
          _formKey.currentState?.save();
          ref.read(settingsProvider.notifier).saveMonitoredFolder(_mf);
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
      child: const Text('SAVE'),
    );
  }

  void _handleHover(bool hovering) {
    if (hovering != _isHovering) {
      setState(() {
        _isHovering = hovering;
      });
    }
  }

  void _handleFocusChanged() => setState(() {});
}
