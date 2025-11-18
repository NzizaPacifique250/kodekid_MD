import 'package:flutter/material.dart';

class ChapterProgressModel {
  final int chapterNumber;
  final String title;
  final int progressPercentage;
  final int completedStars; // 0-3 stars
  final Color chapterColor;

  ChapterProgressModel({
    required this.chapterNumber,
    required this.title,
    required this.progressPercentage,
    required this.completedStars,
    required this.chapterColor,
  });
}

