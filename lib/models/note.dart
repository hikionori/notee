import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Note extends Equatable {
  int id;
  String title;
  String content;
  DateTime createdAt;

  Note({
    this.id = 0,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, title, content, createdAt];
}
