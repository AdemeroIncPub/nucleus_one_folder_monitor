import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path_;
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
  final _inputFolderTextFieldController = TextEditingController();
  final _moveToFolderTextFieldController = TextEditingController();
  final _n1DestinationFormFieldFocusNode = FocusNode();
  final _n1DestinationFormFieldKey =
      GlobalKey<FormFieldState<NucleusOneFolder>>();

  final _nameTextFieldController = TextEditingController();

  var _enabled = true;
  bool _isHovering = false;

  _FileDispositionType? _fileDispositionType;

  @override
  void dispose() {
    _n1DestinationFormFieldFocusNode.removeListener(_handleFocusChanged);
    _nameTextFieldController.dispose();
    _descriptionFieldController.dispose();
    _inputFolderTextFieldController.dispose();
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
      _inputFolderTextFieldController.text = toEdit.inputFolder;

      _fileDispositionType = toEdit.fileDisposition.map(
        delete: (_) => _FileDispositionType.delete,
        move: (md) {
          _moveToFolderTextFieldController.text = md.folderPath;
          return _FileDispositionType.move;
        },
      );
      _enabled = toEdit.enabled;
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
            margin: const EdgeInsets.all(screenPadding),
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
                _enabledFormRow(context),
                _formRowSpacer,
                _nameFormRow(context),
                _formRowSpacer,
                _descriptionFormRow(context),
                _formRowSpacer,
                _inputFolderFormRow(context),
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

  Widget _inputFolderFormRow(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () async {
            final selectedPath = await FilePicker.platform.getDirectoryPath(
              dialogTitle: 'Select input folder',
              initialDirectory: _inputFolderTextFieldController.text,
              lockParentWindow: true,
            );
            if (selectedPath != null) {
              setState(() {
                _inputFolderTextFieldController.text = selectedPath;
              });
            }
          },
        ),
        const SizedBox(width: Insets.compXSmall),
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Input folder',
              hintText: 'Use the edit button to select the input folder',
              errorMaxLines: 3,
            ),
            controller: _inputFolderTextFieldController,
            readOnly: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              String inputFolder;
              if (quiver.isBlank(value)) {
                return 'This field is required';
              } else {
                inputFolder = value!;
              }

              // Ensure input folder is not any saved move to folder
              final savedMfs = ref.read(monitoredFoldersProvider);
              final savedMfsValidation = savedMfs.map((mf) {
                // If editing, do not check against this saved move to folder.
                // The move to formfield's validator will check against this
                // input folder
                if (widget.mfToEdit?.id == mf.id) {
                  return null;
                }

                return mf.fileDisposition.whenOrNull(
                  move: (moveToFolder) {
                    if (path_.equals(inputFolder, moveToFolder)) {
                      final nameDesc = [mf.name, mf.description].join(': ');
                      return 'Cannot be the same as the move to folder of '
                          'another monitored folder, but matches the move to '
                          'folder for $nameDesc';
                    }
                    return null;
                  },
                );
              }).firstWhere(
                (msg) => msg != null,
                orElse: () => null,
              );
              return savedMfsValidation;
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
                  initialValue: widget.mfToEdit?.n1Folder,
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
                hintText:
                    'Use the edit button to select the destination folder',
                errorMaxLines: 3),
            controller: _moveToFolderTextFieldController,
            readOnly: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (_fileDispositionType == _FileDispositionType.move) {
                String moveToFolder;
                if (quiver.isBlank(value)) {
                  return 'This field is required';
                } else {
                  moveToFolder = value!;
                }

                // Ensure move to folder is not the input folder
                final inputFolder = _inputFolderTextFieldController.text;
                if (path_.equals(moveToFolder, inputFolder)) {
                  return 'Cannot be the same as the input folder';
                }

                // Ensure move to folder is not any saved input folder
                final savedMfs = ref.read(monitoredFoldersProvider);
                final savedMfsValidation = savedMfs.map((mf) {
                  // If editing, do not check against this saved input folder.
                  // Already checked against this proposed input folder above.
                  if (widget.mfToEdit?.id == mf.id) {
                    return null;
                  }

                  if (path_.equals(moveToFolder, mf.inputFolder)) {
                    final nameDesc = [mf.name, mf.description].join(': ');
                    return 'Cannot be the same as the input folder of another '
                        'monitored folder, but matches the input folder for '
                        '$nameDesc';
                  }
                }).firstWhere(
                  (msg) => msg != null,
                  orElse: () => null,
                );
                return savedMfsValidation;
              } else {
                return null;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _enabledFormRow(BuildContext context) {
    return CheckboxListTile(
      title: const Text('Enabled'),
      subtitle:
          const Text('If unchecked, this monitored folder will not be active'),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      value: _enabled,
      onChanged: (value) {
        setState(() {
          _enabled = value!;
        });
      },
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
          final mf = widget.mfToEdit;
          _nameTextFieldController.text = mf?.name ?? '';
          _descriptionFieldController.text = mf?.description ?? '';
          _inputFolderTextFieldController.text = mf?.inputFolder ?? '';
          _n1DestinationFormFieldKey.currentState?.reset();
          _fileDispositionType = mf?.fileDisposition.map(
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
        if (_formKey.currentState?.validate() ?? false) {
          FileDisposition fileDisposition;
          if (_fileDispositionType == _FileDispositionType.delete) {
            fileDisposition = const FileDisposition.delete();
          } else {
            fileDisposition = FileDisposition.move(
                folderPath: _moveToFolderTextFieldController.text);
          }

          final MonitoredFolder mfToSave;
          if (_editing) {
            mfToSave = widget.mfToEdit!.copyWith(
              name: _nameTextFieldController.text,
              description: _descriptionFieldController.text,
              inputFolder: _inputFolderTextFieldController.text,
              n1Folder: _n1DestinationFormFieldKey.currentState!.value!,
              fileDisposition: fileDisposition,
              enabled: _enabled,
            );
          } else {
            mfToSave = MonitoredFolder.defaultId(
                name: _nameTextFieldController.text,
                description: _descriptionFieldController.text,
                inputFolder: _inputFolderTextFieldController.text,
                n1Folder: _n1DestinationFormFieldKey.currentState!.value!,
                fileDisposition: fileDisposition,
                enabled: _enabled);
          }

          ref.read(settingsProvider.notifier).saveMonitoredFolder(mfToSave);
          Navigator.pop(context, mfToSave.id);
        } else {
          final colorScheme = Theme.of(context).colorScheme;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: colorScheme.surfaceVariant,
              content: Text(
                'Please correct marked issues and try again',
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
