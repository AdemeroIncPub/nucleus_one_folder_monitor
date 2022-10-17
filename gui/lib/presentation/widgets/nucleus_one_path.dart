import 'dart:io' as io;
import 'package:flutter/material.dart';

import '../../application/enums.dart';
import '../util/flutter_icon_custom_icons_icons.dart';

class NucleusOnePath extends StatelessWidget {
  const NucleusOnePath({
    super.key,
    required this.organizationName,
    required this.projectType,
    required this.projectName,
    this.folderNames = const [],
    this.textStyle,
  });

  final String? organizationName;
  final N1ProjectType? projectType;
  final String? projectName;
  final List<String> folderNames;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final parts = <Widget>[];
    final slash = io.Platform.pathSeparator;
    if (organizationName != null) {
      parts.addAll([
        const Icon(Icons.business),
        const SizedBox(width: 4),
        Text(organizationName!),
      ]);
    }
    if (projectType != null) {
      if (projectType == N1ProjectType.project) {
        parts.add(Text(slash));
        parts.add(const Icon(FlutterIconCustomIcons.project));
        parts.add(const SizedBox(width: 2));
      } else {
        parts.add(Text(slash));
        parts.add(const SizedBox(width: 2));
        parts.add(const Icon(FlutterIconCustomIcons.department));
        parts.add(const SizedBox(width: 4));
      }

      if (projectName != null) {
        parts.add(Text(projectName!));
      }
    }
    final folderPath = folderNames.fold('', (acc, folder) {
      return '$acc$slash$folder';
    });
    parts.add(Text(folderPath));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DefaultTextStyle.merge(
        style: textStyle,
        child: SelectionArea(
          child: Row(
            children: parts,
          ),
        ),
      ),
    );
  }
}
