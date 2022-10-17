import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiver/strings.dart' as quiver;

import '../../application/monitored_folder.dart';
import '../../application/providers.dart';
import '../util/style.dart';
import '../widgets/nucleus_one_path.dart';
import 'select_nucleus_one_folder_screen.dart';

enum _FileDispositionType {
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
  final _descriptionFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _monitoredFolderTextFieldController = TextEditingController();
  final _moveToFolderTextFieldController = TextEditingController();
  final _n1DestinationFormFieldFocusNode = FocusNode();
  final _n1DestinationFormFieldKey =
      GlobalKey<FormFieldState<NucleusOneFolder>>();

  final _nameTextFieldController = TextEditingController();
  late final _originalMf =
      (_editing) ? widget.mfToEdit! : MonitoredFolder.defaultValue();

  bool _isHovering = false;

  _FileDispositionType? _fileDispositionType;

  @override
  void dispose() {
    _n1DestinationFormFieldFocusNode.removeListener(_handleFocusChanged);
    _nameTextFieldController.dispose();
    _descriptionFieldController.dispose();
    _monitoredFolderTextFieldController.dispose();
    _n1DestinationFormFieldFocusNode.dispose();
    _moveToFolderTextFieldController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _n1DestinationFormFieldFocusNode.addListener(_handleFocusChanged);

    if (_editing) {
      final toEdit = widget.mfToEdit!;
      _nameTextFieldController.text = toEdit.name;
      _descriptionFieldController.text = toEdit.description;
      _monitoredFolderTextFieldController.text = toEdit.monitoredFolder;

      _fileDispositionType = toEdit.fileDisposition.map(
        delete: (_) => _FileDispositionType.delete,
        move: (md) {
          _moveToFolderTextFieldController.text = md.folderPath;
          return _FileDispositionType.move;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (_editing)
            ? const Text('Edit Monitored Folder')
            : const Text('New Monitored Folder'),
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

  bool get _editing => widget.mfToEdit != null;

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
                if (_fileDispositionType == _FileDispositionType.move) ...[
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
              controller: _nameTextFieldController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (quiver.isBlank(value)) {
                  return 'This field is required';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {});
              },
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
            controller: _descriptionFieldController,
            onChanged: (value) {
              setState(() {});
            },
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
              setState(() {
                _monitoredFolderTextFieldController.text = selectedPath;
              });
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
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

  Widget _n1DestinationFormRow(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            final result = await Navigator.push<NucleusOneFolder>(
              context,
              MaterialPageRoute(
                builder: (context) => const SelectNucleusOneFolderScreen(),
                settings: const RouteSettings(
                  name: SelectNucleusOneFolderScreen.routeName,
                ),
              ),
            );
            if (result != null) {
              setState(() {
                _n1DestinationFormFieldKey.currentState?.didChange(result);
              });
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
                child: FormField<NucleusOneFolder>(
                  key: _n1DestinationFormFieldKey,
                  initialValue: (_editing) ? _originalMf.n1Folder : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    // A project is the minimum required for a valid n1Folder
                    if (quiver.isBlank(value?.projectId)) {
                      return 'This field is required';
                    }
                    return null;
                  },
                  builder: (FormFieldState<NucleusOneFolder> field) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Nucleus One destination',
                        hintText:
                            'Use the edit button to select the Nucleus One destination',
                        errorText: field.errorText,
                      ),
                      isEmpty: field.value == null,
                      isFocused: _n1DestinationFormFieldFocusNode.hasFocus,
                      isHovering: _isHovering,
                      child: NucleusOnePath(
                        organizationName: field.value?.organizationName,
                        projectType: field.value?.projectType,
                        projectName: field.value?.projectName,
                        folderNames: field.value?.folderNames ?? [],
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
            child: DropdownButtonFormField<_FileDispositionType>(
              decoration: const InputDecoration(
                labelText: 'File disposition',
              ),
              value: _fileDispositionType,
              items: const [
                DropdownMenuItem(
                  value: _FileDispositionType.delete,
                  child: Text('Delete'),
                ),
                DropdownMenuItem(
                  value: _FileDispositionType.move,
                  child: Text('Move'),
                ),
              ],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null) {
                  return 'This field is required';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _fileDispositionType = value;
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
              setState(() {
                _moveToFolderTextFieldController.text = selectedPath;
              });
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (_fileDispositionType == _FileDispositionType.move &&
                  quiver.isBlank(value)) {
                return 'This field is required';
              }
              return null;
            },
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
          _nameTextFieldController.text = _originalMf.name;
          _descriptionFieldController.text = _originalMf.description;
          _monitoredFolderTextFieldController.text =
              _originalMf.monitoredFolder;
          _n1DestinationFormFieldKey.currentState?.reset();
          _fileDispositionType = _originalMf.fileDisposition.map(
            delete: (_) {
              _moveToFolderTextFieldController.text = '';
              return _FileDispositionType.delete;
            },
            move: (value) {
              _moveToFolderTextFieldController.text = value.folderPath;
              return _FileDispositionType.move;
            },
          );
        });
      },
    );
  }

  Widget _saveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState?.validate() ?? true) {
          FileDisposition fileDisposition;
          if (_fileDispositionType == _FileDispositionType.move) {
            fileDisposition = const FileDisposition.delete();
          } else {
            fileDisposition = FileDisposition.move(
                folderPath: _moveToFolderTextFieldController.text);
          }

          final mfToSave = _originalMf.copyWith(
            name: _nameTextFieldController.text,
            description: _descriptionFieldController.text,
            monitoredFolder: _monitoredFolderTextFieldController.text,
            n1Folder: _n1DestinationFormFieldKey.currentState!.value!,
            fileDisposition: fileDisposition,
          );

          ref.read(settingsProvider.notifier).saveMonitoredFolder(mfToSave);
          Navigator.pop(context);
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
