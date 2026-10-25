// One set of problems, start to finish. A set is finite and says so: its total is known from
// the first problem, and it ends. Nothing here keeps time, counts a streak or scores.

import 'problems.dart';

enum Outcome {
  /// Right on the first answer.
  first,

  /// Right after another go.
  retried,

  /// The person asked to see the answer.
  shown,
}

enum Phase {
  /// Waiting for an answer.
  asking,

  /// The last answer was not quite right. Try again, or ask to see it.
  notQuite,

  /// This problem is settled; the person moves on when they choose.
  settled,

  /// The set is over, finished or stopped.
  ended,
}

class Attempted {
  Attempted(this.problem);
  final Problem problem;
  final answers = <int>[];
  Outcome? outcome;

  /// The answer that settled it, when an answer did. Under "close enough" this may differ
  /// from the exact answer.
  int? get accepted => outcome == Outcome.shown ? null : (answers.isEmpty ? null : answers.last);
}

class Session {
  Session(this.problems, this.scoring) : assert(problems.isNotEmpty), attempts = [Attempted(problems.first)];

  final List<Problem> problems;
  final Scoring scoring;
  final List<Attempted> attempts;
  var phase = Phase.asking;
  var stopped = false;

  int get index => attempts.length - 1;
  int get total => problems.length;
  Problem get current => problems[index];
  Attempted get here => attempts.last;

  /// The ones the person saw through, in order. A stopped set lists only those.
  List<Attempted> get done => [
    for (final a in attempts)
      if (a.outcome != null) a,
  ];

  /// Returns whether the answer was accepted.
  bool answer(int given) {
    assert(phase == Phase.asking);
    final a = here..answers.add(given);
    if (isCorrect(current.answer, given, scoring)) {
      a.outcome = a.answers.length == 1 ? Outcome.first : Outcome.retried;
      phase = Phase.settled;
      return true;
    }
    phase = Phase.notQuite;
    return false;
  }

  void tryAgain() {
    assert(phase == Phase.notQuite);
    phase = Phase.asking;
  }

  void show() {
    assert(phase == Phase.notQuite || phase == Phase.asking);
    here.outcome = Outcome.shown;
    phase = Phase.settled;
  }

  void next() {
    assert(phase == Phase.settled);
    if (index + 1 >= total) {
      phase = Phase.ended;
    } else {
      attempts.add(Attempted(problems[index + 1]));
      phase = Phase.asking;
    }
  }

  /// Ends the set here. What was done is kept and shown; the unsettled problem is dropped.
  void stop() {
    if (phase == Phase.ended) return;
    stopped = true;
    phase = Phase.ended;
  }
}
