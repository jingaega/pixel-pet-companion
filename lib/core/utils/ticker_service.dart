import 'dart:async';

/// Simple ticker that emits a tick every [period].
class TickerService {
  final Duration period;
  Timer? _timer;
  void Function()? onTick;

  TickerService({this.period = const Duration(seconds: 1)});

  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(period, (_) => onTick?.call());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
