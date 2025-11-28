// presentation/providers/admin_provider.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_faysal_game/data/repositories/admin_repository.dart';
import 'package:flutter_faysal_game/presentation/admin_panel/model/cllanges_model.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@lazySingleton
class AdminProvider with ChangeNotifier {
  final AdminRepository _adminRepository;

  // ── Form state ───────────────────────────────────────────────────────
  int selectedWeek = 1;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final pointsController = TextEditingController();
  final levelController = TextEditingController();

  File? _badgeImage;
  File? get badgeImage => _badgeImage;

  List<ChallengeTask> tasks = [];

  // ── UI state ────────────────────────────────────────────────────────
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  AdminProvider(this._adminRepository) {
    _loadDefaultWeek1();
  }

  // ── Default data for Week 1 ────────────────────────────────────────
  void _loadDefaultWeek1() {
    selectedWeek = 1;
    titleController.text = "Week 1: রিকশা রাইডার";
    descriptionController.text = "Take only rickshaw/bicycle for 3 consecutive days...";
    pointsController.text = "150";
    levelController.text = "1";
    tasks = [
      ChallengeTask(day: 1, task: "Take only rickshaw today"),
      ChallengeTask(day: 2, task: "Take only rickshaw today"),
      ChallengeTask(day: 3, task: "Take only rickshaw today"),
    ];
    notifyListeners();
  }

  // ── Simple setters ───────────────────────────────────────────────────
  void setWeek(int week) {
    selectedWeek = week;
    notifyListeners();
  }

  void setBadgeImage(File? image) {
    _badgeImage = image;
    notifyListeners();
  }

  // ── Task helpers ─────────────────────────────────────────────────────
  void addTask() {
    final newDay = tasks.isEmpty ? 1 : tasks.last.day + 1;
    tasks.add(ChallengeTask(day: newDay, task: ""));
    notifyListeners();
  }

  void updateTask(int index, String newTask) {
    tasks[index] = ChallengeTask(day: tasks[index].day, task: newTask);
    notifyListeners();
  }

  void updateTaskDay(int index, int newDay) {
    tasks[index] = ChallengeTask(day: newDay, task: tasks[index].task);
    notifyListeners();
  }

  void removeTask(int index) {
    tasks.removeAt(index);
    notifyListeners();
  }

  // ── Loading / Error ──────────────────────────────────────────────────
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ── Save ─────────────────────────────────────────────────────────────
  Future<void> saveChallenge() async {
    if (_badgeImage == null) {
      _setError("Please upload a badge image");
      return;
    }

    _setLoading(true);
    _setError(null);

    try {
    final challenge = Challenge(
  id: selectedWeek.toString(),
  week: selectedWeek,
  title: titleController.text,
  description: descriptionController.text,
  points: int.tryParse(pointsController.text) ?? 0,
  badgeUrl: '',
  level: int.tryParse(levelController.text) ?? 1,
  tasks: tasks, // ← Now correct type
);

      await _adminRepository.saveChallenge(challenge, _badgeImage!);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    pointsController.dispose();
    levelController.dispose();
    super.dispose();
  }
}