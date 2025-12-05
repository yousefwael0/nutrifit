import 'package:flutter/material.dart';

/// Workout timer screen
class WorkoutTimerScreen extends StatefulWidget {
  final dynamic workout; // Workout model

  const WorkoutTimerScreen({super.key, required this.workout});

  @override
  State<WorkoutTimerScreen> createState() => _WorkoutTimerScreenState();
}

class _WorkoutTimerScreenState extends State<WorkoutTimerScreen> {
  late int _remainingSeconds;
  late int _totalSeconds;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.workout.durationMinutes * 60;
    _remainingSeconds = _totalSeconds;
  }

  /// Format seconds to MM:SS
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  /// Toggle timer
  void _toggleTimer() {
    setState(() => _isRunning = !_isRunning);

    if (_isRunning) {
      _startTimer();
    }
  }

  /// Start timer countdown
  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isRunning && mounted) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _isRunning = false;
            _showCompletionDialog();
          }
        });
        _startTimer();
      }
    });
  }

  /// Show completion dialog
  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Workout Complete!'),
        content: Text('Great job! You completed ${widget.workout.name}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  /// Reset timer
  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _remainingSeconds = _totalSeconds;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_totalSeconds - _remainingSeconds) / _totalSeconds;

    return Scaffold(
      appBar: AppBar(title: Text(widget.workout.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Progress circle
            SizedBox(
              width: 250,
              height: 250,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background circle
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey[200]!, width: 10),
                    ),
                  ),
                  // Progress arc
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF4CAF50),
                        width: 10,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                    ),
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 10,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                  // Time display
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatTime(_remainingSeconds),
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'of ${_formatTime(_totalSeconds)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  label: Text(_isRunning ? 'Pause' : 'Start'),
                  onPressed: _toggleTimer,
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  onPressed: _resetTimer,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Workout details
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Workout Details',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Duration: ${widget.workout.durationMinutes} min',
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          'Calories: ${widget.workout.caloriesBurned.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
