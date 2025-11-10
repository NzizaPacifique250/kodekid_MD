# KodeKid Services Documentation

## Overview
This directory contains all the backend service integrations for the KodeKid platform.

## Services

### ProgressService
Handles user lesson progress tracking and completion status.
- `updateLessonProgress()` - Updates lesson completion and scores
- `getLessonProgress()` - Retrieves individual lesson progress
- `getUserProgress()` - Gets all user progress data

### GamificationService  
Manages badges, achievements, and user statistics.
- `awardBadge()` - Awards badges for accomplishments
- `getUserBadges()` - Retrieves user's earned badges
- `updateAchievement()` - Updates user statistics

### CourseService
Manages course and lesson content from Firebase.
- `getLessonsByCourse()` - Gets lessons for a specific course
- `getLessonById()` - Retrieves individual lesson data
- `getAllCourses()` - Gets all available courses

### CodeStorageService
Handles user code persistence across sessions.
- `saveCode()` - Saves user code for a lesson
- `loadCode()` - Loads previously saved code
- `getUserCodes()` - Gets all user's saved code

### PythonExecutionService
Executes Python code safely in a sandboxed environment.
- `executeCode()` - Runs Python code and returns output
- Configured with Programiz API for real execution
- Fallback to local simulation when API unavailable