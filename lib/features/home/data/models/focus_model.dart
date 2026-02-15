import 'package:flutter/foundation.dart';

@immutable
class FocusModel {
  final String id;
  final String title;
  final String subtitle;
  final String tag;
  final bool done;

  const FocusModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.done,
  });

  FocusModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? tag,
    bool? done,
  }) {
    return FocusModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      tag: tag ?? this.tag,
      done: done ?? this.done,
    );
  }
}
