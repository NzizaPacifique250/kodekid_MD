# KodeKid Providers Documentation

## Overview
Riverpod state management providers for the KodeKid application.

## Providers

### LessonProgressProvider
Manages lesson progress state and updates.
- Tracks lesson completion status
- Handles progress updates with gamification
- Awards badges on lesson completion
- Integrates with ProgressService and GamificationService

### UserCodeProvider  
Manages user code persistence and auto-save functionality.
- Loads saved code when opening lessons
- Auto-saves code every 2 seconds during editing
- Integrates with CodeStorageService

### UserProgressProvider
Manages dashboard progress data and chapter statistics.
- Converts lesson progress to chapter progress
- Calculates completion percentages and star ratings
- Provides default progress for new users

### UserStatsProvider & UserBadgesProvider
Handle gamification data display.
- UserStatsProvider: Gets user achievement statistics
- UserBadgesProvider: Retrieves earned badges for display

## Usage
All providers use Riverpod for reactive state management and automatic UI updates when data changes.