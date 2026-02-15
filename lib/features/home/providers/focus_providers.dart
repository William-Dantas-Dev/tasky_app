import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasky_app/features/home/data/models/focus_model.dart';


enum PomodoroStatus { idle, running, paused, finished }
enum PomodoroPhase { work, breakTime }

class FocusSessionState {
  final FocusModel focus;

  final int workMinutes;
  final int breakMinutes;

  final int totalSeconds;
  final int remainingSeconds;

  final PomodoroStatus status;
  final PomodoroPhase phase;

  const FocusSessionState({
    required this.focus,
    required this.workMinutes,
    required this.breakMinutes,
    required this.totalSeconds,
    required this.remainingSeconds,
    required this.status,
    required this.phase,
  });

  double get progress {
    if (totalSeconds <= 0) return 0.0;
    final doneSeconds = totalSeconds - remainingSeconds;
    return (doneSeconds / totalSeconds).clamp(0.0, 1.0);
  }

  String get timeLeftText {
    final m = remainingSeconds ~/ 60;
    final s = remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  bool get isRunning => status == PomodoroStatus.running;
  bool get isPaused => status == PomodoroStatus.paused;
  bool get isFinished => status == PomodoroStatus.finished;

  String get phaseLabel => phase == PomodoroPhase.work ? 'Foco' : 'Pausa';

  FocusSessionState copyWith({
    FocusModel? focus,
    int? workMinutes,
    int? breakMinutes,
    int? totalSeconds,
    int? remainingSeconds,
    PomodoroStatus? status,
    PomodoroPhase? phase,
  }) {
    return FocusSessionState(
      focus: focus ?? this.focus,
      workMinutes: workMinutes ?? this.workMinutes,
      breakMinutes: breakMinutes ?? this.breakMinutes,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      status: status ?? this.status,
      phase: phase ?? this.phase,
    );
  }
}

class FocusController extends Notifier<FocusSessionState> {
  Timer? _timer;

  @override
  FocusSessionState build() {
    ref.onDispose(_stopTimer);

    const initialFocus = FocusModel(
      id: 'focus-1',
      title: 'Foco do dia',
      subtitle: 'Sem distração',
      tag: 'POMODORO',
      done: false,
    );

    const work = 25;
    const brk = 5;
    final total = work * 60;

    return FocusSessionState(
      focus: initialFocus,
      workMinutes: work,
      breakMinutes: brk,
      totalSeconds: total,
      remainingSeconds: total,
      status: PomodoroStatus.idle,
      phase: PomodoroPhase.work,
    );
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  int _phaseSeconds(PomodoroPhase phase) {
    return (phase == PomodoroPhase.work ? state.workMinutes : state.breakMinutes) * 60;
  }

  void _switchPhase(PomodoroPhase nextPhase) {
    final secs = _phaseSeconds(nextPhase);
    state = state.copyWith(
      phase: nextPhase,
      totalSeconds: secs,
      remainingSeconds: secs,
      // mantém running: a ideia é "auto start" da próxima fase
      status: PomodoroStatus.running,
    );
  }

  void _finishSession() {
    _stopTimer();
    state = state.copyWith(
      status: PomodoroStatus.finished,
      remainingSeconds: 0,
      focus: state.focus.copyWith(done: true),
    );
  }

  void _tick() {
    final next = state.remainingSeconds - 1;

    if (next > 0) {
      state = state.copyWith(remainingSeconds: next);
      return;
    }

    // chegou no zero
    if (state.phase == PomodoroPhase.work) {
      // terminou o foco -> começa a pausa automaticamente
      _switchPhase(PomodoroPhase.breakTime);
      return;
    }

    // terminou a pausa -> finaliza a sessão
    _finishSession();
  }

  void _startTimerTicking() {
    _stopTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.status != PomodoroStatus.running) {
        _stopTimer();
        return;
      }
      _tick();
    });
  }

  void startOrResume() {
    // Permite reiniciar quando finished
    if (state.focus.done && state.status != PomodoroStatus.finished) return;

    if (state.status == PomodoroStatus.finished) {
      reset(); // volta pro work idle
    }

    if (state.status == PomodoroStatus.running) return;

    state = state.copyWith(status: PomodoroStatus.running);
    _startTimerTicking();
  }

  void pause() {
    if (state.status != PomodoroStatus.running) return;
    state = state.copyWith(status: PomodoroStatus.paused);
    _stopTimer();
  }

  void toggleRunPause() {
    if (state.status == PomodoroStatus.finished) {
      reset();
      startOrResume();
      return;
    }

    if (state.status == PomodoroStatus.running) {
      pause();
      return;
    }

    startOrResume();
  }

  void reset({int? workMinutes, int? breakMinutes}) {
    _stopTimer();

    final work = (workMinutes ?? state.workMinutes).clamp(1, 180);
    final brk = (breakMinutes ?? state.breakMinutes).clamp(1, 60);

    final total = work * 60;

    state = state.copyWith(
      workMinutes: work,
      breakMinutes: brk,
      phase: PomodoroPhase.work,
      totalSeconds: total,
      remainingSeconds: total,
      status: PomodoroStatus.idle,
      focus: state.focus.copyWith(done: false),
    );
  }

  void setDurations({
    required int workMinutes,
    required int breakMinutes,
    bool startAfter = false,
  }) {
    reset(workMinutes: workMinutes, breakMinutes: breakMinutes);
    if (startAfter) startOrResume();
  }

  void markDone() {
    _stopTimer();
    state = state.copyWith(
      phase: PomodoroPhase.breakTime,
      status: PomodoroStatus.finished,
      remainingSeconds: 0,
      focus: state.focus.copyWith(done: true),
    );
  }
}

final focusControllerProvider =
    NotifierProvider<FocusController, FocusSessionState>(FocusController.new);
