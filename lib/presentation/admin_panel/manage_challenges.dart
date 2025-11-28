// presentation/screens/manage_challenges_screen.dart
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_faysal_game/presentation/admin_panel/provider/admin_provider.dart';
import 'package:provider/provider.dart';

class ManageChallengesScreen extends StatelessWidget {
  const ManageChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _ManageChallengesBody();
    
  }
}

class _ManageChallengesBody extends StatelessWidget {
  const _ManageChallengesBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<AdminProvider>(
    
      builder: (context, provider,child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Manage Challenges"),
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          body: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Form(
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate.fixed([
                            // ── Week ───────────────────────────────────────
                            DropdownButtonFormField<int>(
                              value: provider.selectedWeek,
                              decoration: const InputDecoration(
                                labelText: "Select Week",
                                border: OutlineInputBorder(),
                              ),
                              items: List.generate(
                                35,
                                (i) => DropdownMenuItem(
                                  value: i + 1,
                                  child: Text("Week ${i + 1}"),
                                ),
                              ),
                              onChanged: (week) => provider.setWeek(week!),
                            ),
                            const SizedBox(height: 16),
        
                            // ── Title ───────────────────────────────────────
                            TextFormField(
                              controller: provider.titleController,
                              decoration: const InputDecoration(
                                labelText: "Title",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
        
                            // ── Description ─────────────────────────────────
                            TextFormField(
                              controller: provider.descriptionController,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                labelText: "Description",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
        
                            // ── Points ──────────────────────────────────────
                            TextFormField(
                              controller: provider.pointsController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Points",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
        
                            // ── Badge Image ─────────────────────────────────
                            const Text("Badge Image *", style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            _BadgeUploadCard(provider: provider),
                            const SizedBox(height: 16),
        
                            // ── Level ───────────────────────────────────────
                            TextFormField(
                              controller: provider.levelController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Level",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 24),
        
                            // ── Tasks Header ─────────────────────────────────
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Tasks", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle, color: Colors.deepPurple),
                                  onPressed: provider.addTask,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ]),
                        ),
                      ),
        
                      // ── Tasks List ───────────────────────────────────
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final task = provider.tasks[index];
                              return _TaskTile(
                                day: task.day,
                                text: task.task,
                                onDayChanged: (d) => provider.updateTaskDay(index, d),
                                onTextChanged: (t) => provider.updateTask(index, t),
                                onDelete: () => provider.removeTask(index),
                              );
                            },
                            childCount: provider.tasks.length,
                          ),
                        ),
                      ),
        
                      const SliverToBoxAdapter(child: SizedBox(height: 100)),
                    ],
                  ),
                ),
        
          // ── Fixed Save Button ───────────────────────────────────────
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await provider.saveChallenge();
                  if (provider.errorMessage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Challenge saved!")),
                    );
                    // Optional: reset form
                    // provider._loadDefaultWeek1();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(provider.errorMessage!)),
                    );
                  }
                },
                icon: provider.isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.save),
                label: const Text("Save Challenge"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}

// ────────────────────────────────────────────────────────────────────────
// Badge Upload Card
// ────────────────────────────────────────────────────────────────────────
class _BadgeUploadCard extends StatelessWidget {
  final AdminProvider provider;
  const _BadgeUploadCard({required this.provider});

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      provider.setBadgeImage(File(result.files.single.path!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: provider.badgeImage == null ? Colors.red.shade300 : Colors.transparent, width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: provider.badgeImage == null
              ? Column(
                  children: [
                    Icon(Icons.add_a_photo, size: 48, color: Colors.grey[600]),
                    const SizedBox(height: 8),
                    const Text("Tap to upload badge image", style: TextStyle(color: Colors.grey)),
                  ],
                )
              : Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        provider.badgeImage!,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => provider.setBadgeImage(null),
                        style: IconButton.styleFrom(backgroundColor: Colors.black54),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────
// Task Tile (same as before)
// ────────────────────────────────────────────────────────────────────────
class _TaskTile extends StatelessWidget {
  final int day;
  final String text;
  final ValueChanged<int> onDayChanged;
  final ValueChanged<String> onTextChanged;
  final VoidCallback onDelete;

  const _TaskTile({
    required this.day,
    required this.text,
    required this.onDayChanged,
    required this.onTextChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(day),
      direction: DismissDirection.endToStart,
      background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
      onDismissed: (_) => onDelete(),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          leading: InkWell(
            onTap: () async {
              final newDay = await showDialog<int>(
                context: context,
                builder: (_) => _DayPickerDialog(current: day),
              );
              if (newDay != null && newDay != day) onDayChanged(newDay);
            },
            child: Chip(label: Text("Day $day"), backgroundColor: Colors.deepPurple.shade50),
          ),
          title: TextFormField(
            initialValue: text,
            decoration: const InputDecoration(hintText: "Enter task description", border: InputBorder.none),
            onChanged: onTextChanged,
          ),
          trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
        ),
      ),
    );
  }
}

class _DayPickerDialog extends StatefulWidget {
  final int current;
  const _DayPickerDialog({required this.current});

  @override
  State<_DayPickerDialog> createState() => _DayPickerDialogState();
}

class _DayPickerDialogState extends State<_DayPickerDialog> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.current.toString());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Change Day"),
      content: TextField(
        controller: _ctrl,
        keyboardType: TextInputType.number,
        autofocus: true,
        decoration: const InputDecoration(labelText: "Day number", border: OutlineInputBorder()),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () {
            final val = int.tryParse(_ctrl.text);
            if (val != null && val > 0) Navigator.pop(context, val);
          },
          child: const Text("OK"),
        ),
      ],
    );
  }
}