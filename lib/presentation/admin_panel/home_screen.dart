import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_faysal_game/core/utils/helpers.dart';
import 'package:flutter_faysal_game/presentation/admin_panel/manage_challenges.dart';
import 'package:flutter_faysal_game/presentation/providers/auth_provider.dart';
import 'package:flutter_faysal_game/presentation/screens/authentication/sign_in.dart';
import 'package:provider/provider.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel"),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).signOut();
              Helpers.pushReplacement(SignInScreen());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Top Admin Cards Section (Fixed Height Area)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.deepPurple, Colors.deepPurple.shade300],
              ),
            ),
            child: Column(
              children: [
                const Text(
                  "Admin Actions",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildCompactAdminCard(
                        title: "Challenges",
                        icon: Icons.task,
                        color: Colors.blue,
                        onTap: () => Helpers.push(const ManageChallengesScreen()),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildCompactAdminCard(
                        title: "Badges",
                        icon: Icons.emoji_events,
                        color: Colors.orange,
                        onTap: () {
                          // TODO: Navigate
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildCompactAdminCard(
                        title: "Users",
                        icon: Icons.people,
                        color: Colors.green,
                        onTap: () {
                          // TODO: Navigate
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Divider + Title for Submissions
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.grey[50],
            child: Row(
              children: [
                const Icon(Icons.pending_actions, color: Colors.deepPurple, size: 22),
                const SizedBox(width: 8),
                const Text(
                  "Pending Submissions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('submit')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "${snapshot.data!.docs.length}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),

          // Submissions List (Takes remaining space)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('submit')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text("Error: ${snapshot.error}"),
                      ],
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        const Text(
                          "No submissions yet",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                final submissions = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: submissions.length,
                  itemBuilder: (context, index) {
                    final doc = submissions[index];
                    return SubmissionCard(
                      doc: doc,
                      firestore: _firestore,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactAdminCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              radius: 24,
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Separate StatefulWidget for each submission card to prevent rebuilds
class SubmissionCard extends StatefulWidget {
  final DocumentSnapshot doc;
  final FirebaseFirestore firestore;

  const SubmissionCard({
    super.key,
    required this.doc,
    required this.firestore,
  });

  @override
  State<SubmissionCard> createState() => _SubmissionCardState();
}

class _SubmissionCardState extends State<SubmissionCard> {
  bool _isProcessing = false;

Future<void> _handleApprove() async {
  if (_isProcessing) return;

  setState(() => _isProcessing = true);



  final userDocRef = widget.firestore.collection('users').doc(widget.doc.id);

  try {
    // Use transaction for atomic update (recommended!)
    await widget.firestore.runTransaction((transaction) async {
      final userSnapshot = await transaction.get(userDocRef);

      if (!userSnapshot.exists) {
        throw Exception("User not found!");
      }

      final userData = userSnapshot.data()!;
      final stats = (userData['stats'] as Map<String, dynamic>?) ?? {};
      final currentLevel = stats['level'] as int? ?? 0;
      final completedDays = (stats['completedDays'] as int?) ?? 0;
      final totalPoints = (stats['totalPoints'] as int?) ?? 0;
      final streak = (stats['streak'] as int?) ?? 0;

      // Example logic: +10 points per approved day, +1 completed day
      final newCompletedDays = completedDays + 1;
      final newPoints = totalPoints + 150;

      // Optional: Update current streak (you need logic based on last submission date)
      // For now, simple +1 streak (you can make it smarter later)

      // Update the submission first
      final submitDocRef = widget.firestore.collection('submit').doc(widget.doc.id);
      transaction.update(submitDocRef, {
        'isApproved': true,
        'approvedAt': FieldValue.serverTimestamp(),
        'status': 'approved',
      });

      // Update user's stats
      transaction.set(userDocRef, {
        'stats': {
          'level': currentLevel, // You can add level-up logic later
          'completedDays': newCompletedDays,
          'totalPoints': newPoints,
          'streak': streak + 1, // or keep your own streak logic
          'lastActiveDate': FieldValue.serverTimestamp(),
          // Add more fields as needed
        },
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); // Important: merge to not overwrite other fields!
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Submission Approved & Stats Updated!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  } finally {
    if (mounted) {
      setState(() => _isProcessing = false);
    }
  }
}
  Future<void> _handleReject() async {
    if (_isProcessing) return;

    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reject Submission"),
        content: const Text("Are you sure you want to reject this submission?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Reject"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isProcessing = true);

    try {
      await widget.firestore.collection('submit').doc(widget.doc.id).update({
        'isApproved': false,
        'rejectedAt': FieldValue.serverTimestamp(),
        'status': 'rejected',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.cancel, color: Colors.white),
                SizedBox(width: 8),
                Text("Submission Rejected"),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.doc.data()! as Map<String, dynamic>;
    final userName = data['userName'] ?? 'Unknown User';
    final week = data['week'] ?? 0;
    final day = data['day'] ?? 0;
    final imageUrl = data['imageUrl'] as String?;
    final status = data['status'] ?? '';
    final isApproved = data['isApproved'] ?? false;
 Widget _buildImage(String url) {
    if (url.isEmpty) {
      return Container(height: 20,width: 20,);
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(
          color: const Color(0xFF00D9A5),
          strokeWidth: 2,
        ),
      ),
      errorWidget: (context, url, error) => Container(height: 20,width: 20,),
      httpHeaders: const {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
      },
    );
  }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: status == 'approved'
              ? Colors.green.withOpacity(0.3)
              : status == 'rejected'
                  ? Colors.red.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Image
              ClipRRect(
  borderRadius: BorderRadius.circular(8),
  child: Container(
    width: 80,    // ← Fixed width
    height: 80,   // ← Fixed height
    color: Colors.grey[200],
    child: _buildImage(imageUrl ?? ""),
  ),
),
                const SizedBox(width: 12),
                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            "Week $week • Day $day",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      if (status.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: status == 'approved'
                                ? Colors.green.withOpacity(0.1)
                                : status == 'rejected'
                                    ? Colors.red.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            status.toUpperCase(),
                            style: TextStyle(
                              color: status == 'approved'
                                  ? Colors.green
                                  : status == 'rejected'
                                      ? Colors.red
                                      : Colors.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            // Action Buttons
            if (status != 'approved' && status != 'rejected') ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _isProcessing ? null : _handleReject,
                      icon: _isProcessing
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.close, size: 18),
                      label: const Text("Reject"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _isProcessing ? null : _handleApprove,
                      icon: _isProcessing
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check, size: 18),
                      label: const Text("Approve"),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}