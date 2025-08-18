import 'dart:math';
import 'dart:math' show pi;
import 'package:flutter/material.dart';

void main() {
  runApp(const ColorTapApp());
}

class ColorTapApp extends StatelessWidget {
  const ColorTapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Tap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const ColorTapGame(),
    );
  }
}

class NamedColor {
  final String label;
  final Color value;
  const NamedColor(this.label, this.value);
}

const List<NamedColor> kPalette = [
  NamedColor('Red', Colors.red),
  NamedColor('Green', Colors.green),
  NamedColor('Blue', Colors.blue),
  NamedColor('Yellow', Colors.yellow),
  NamedColor('Orange', Colors.orange),
  NamedColor('Purple', Colors.purple),
  NamedColor('Pink', Colors.pink),
  NamedColor('Brown', Colors.brown),
  NamedColor('Cyan', Colors.cyan),
  NamedColor('Lime', Colors.lime),
];

class ColorTapGame extends StatefulWidget {
  const ColorTapGame({super.key});

  @override
  State<ColorTapGame> createState() => _ColorTapGameState();
}

class _ColorTapGameState extends State<ColorTapGame> {
  final _rng = Random();
  late List<NamedColor> _options;
  late NamedColor _target;

  int _score = 0;
  int _round = 1;
  final int _totalRounds = 10;

  // Settings (Drawer)
  int _gridSize = 6; // 6 or 9
  bool _showLabelsOnTiles = false;

  bool _roundCleared = false;

  @override
  void initState() {
    super.initState();
    _setupOptions();
  }

  void _setupOptions() {
    final needed = _gridSize;
    final shuffled = [...kPalette]..shuffle(_rng);
    _options = shuffled.take(needed).toList();
    _target = _options[_rng.nextInt(_options.length)];
    _roundCleared = false;
    setState(() {});
  }

  void _newRound() {
    // If last round is already played, show Game Over instead of starting a new round
    if (_round >= _totalRounds) {
      _showGameOver();
      return;
    }
    _round++;
    _setupOptions();
  }

  void _onCorrect() {
    if (!_roundCleared) {
      _score++;
      _roundCleared = true;
    }
    _showFeedback(true);
  }

  void _onWrong() {
    _showFeedback(false);
  }

  void _showFeedback(bool isCorrect) {
    final cs = Theme.of(context).colorScheme;
    final bg = isCorrect ? cs.primaryContainer : cs.errorContainer;
    final fg = isCorrect ? cs.onPrimaryContainer : cs.onErrorContainer;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: bg,
          elevation: 6,
          margin: const EdgeInsets.all(16),
          duration: const Duration(milliseconds: 1200),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isCorrect ? Icons.check_circle : Icons.cancel, color: fg, size: 28),
              const SizedBox(width: 10),
              Text(
                isCorrect ? 'Correct!' : 'Wrong!',
                style: TextStyle(
                  color: fg,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      );
  }

  void _showHowToPlay() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('How to Play', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• Read the target color on top.'),
              Text('• Tap the matching color tile.'),
              Text('• Use Next to go to the next round.'),
              Text('• The game ends after 10 rounds.'),
              Text('• Settings in the drawer: Grid Size & Labels.'),
              SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _resetGame() {
    _score = 0;
    _round = 1;
    _setupOptions();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Game reset.'),
        duration: Duration(milliseconds: 800),
      ),
    );
  }

  void _hint() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Hint: Look for ${_target.label}.'),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  void _showGameOver() {
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: 16 + MediaQuery.of(ctx).padding.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.emoji_events, size: 56, color: cs.primary),
              const SizedBox(height: 8),
              const Text('Game Over', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text(
                'Final Score: $_score / $_totalRounds',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _resetGame();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Play Again'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => Navigator.of(ctx).pop(),
                icon: const Icon(Icons.close),
                label: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Tap'),
        actions: [
          IconButton(
            tooltip: 'How to Play',
            icon: const Icon(Icons.info_outline),
            onPressed: _showHowToPlay,
          )
        ],
      ),

      // Settings Drawer
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              const ListTile(
                title: Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text('Grid Size'),
                subtitle: const Text('Number of tiles'),
                trailing: DropdownButton<int>(
                  value: _gridSize,
                  items: const [
                    DropdownMenuItem(value: 6, child: Text('6 (3x2)')),
                    DropdownMenuItem(value: 9, child: Text('9 (3x3)')),
                  ],
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => _gridSize = v);
                    _setupOptions();
                  },
                ),
              ),
              SwitchListTile(
                title: const Text('Show Labels on Tiles'),
                subtitle: const Text('Accessibility aid'),
                value: _showLabelsOnTiles,
                onChanged: (val) => setState(() => _showLabelsOnTiles = val),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About'),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'Color Tap',
                    applicationVersion: '1.0.0',
                    applicationLegalese: '© 2025',
                  );
                },
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            children: [
              // Target label
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Find: ', style: TextStyle(fontSize: 20)),
                    Text(_target.label,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: _options
                      .map(
                        (opt) => ColorTile(
                      key: ValueKey('${opt.label}-${_round}'),
                    color: opt.value,
                      label: opt.label,
                      showLabel: _showLabelsOnTiles,
                      isTarget: opt.label == _target.label,
                      onCorrect: _onCorrect,
                      onWrong: _onWrong,
                    ),
                  )
                      .toList(),
                ),
              ),
              const SizedBox(height: 72), // large FAB breathing space
            ],
          ),
        ),
      ),

      // Footer info
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Round: $_round/$_totalRounds', style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('Score: $_score', style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),

      // BIG centered Next button
      floatingActionButton: FloatingActionButton.large(
        onPressed: _newRound,
        child: const Icon(Icons.play_arrow, size: 36),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      // Helpers
      persistentFooterButtons: [
        TextButton.icon(
          onPressed: _resetGame,
          icon: const Icon(Icons.restart_alt),
          label: const Text('Reset'),
        ),
        TextButton.icon(
          onPressed: _hint,
          icon: const Icon(Icons.lightbulb_outline),
          label: const Text('Hint'),
        ),
      ],
    );
  }
}

// ---- Animated Tile ----
class ColorTile extends StatefulWidget {
  const ColorTile({
    super.key,
    required this.color,
    required this.label,
    required this.showLabel,
    required this.isTarget,
    required this.onCorrect,
    required this.onWrong,
  });

  final Color color;
  final String label;
  final bool showLabel;
  final bool isTarget;
  final VoidCallback onCorrect;
  final VoidCallback onWrong;

  @override
  State<ColorTile> createState() => _ColorTileState();
}

class _ColorTileState extends State<ColorTile> with TickerProviderStateMixin {
  late final AnimationController _flipCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 350),
  );

  late final AnimationController _shakeCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  late final Animation<double> _flip = Tween(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(parent: _flipCtrl, curve: Curves.easeInOut),
  );

  late final Animation<double> _shake = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0, end: -8), weight: 1),
    TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 2),
    TweenSequenceItem(tween: Tween(begin: 8, end: -6), weight: 2),
    TweenSequenceItem(tween: Tween(begin: -6, end: 4), weight: 2),
    TweenSequenceItem(tween: Tween(begin: 4, end: 0), weight: 1),
  ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.easeOut));

  bool _isAnimating = false;

  @override
  void dispose() {
    _flipCtrl.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  Future<void> _playFlip() async {
    if (_isAnimating) return;
    _isAnimating = true;
    try {
      await _flipCtrl.forward();
      await _flipCtrl.reverse();
    } finally {
      _isAnimating = false;
    }
  }

  Future<void> _playShake() async {
    if (_isAnimating) return;
    _isAnimating = true;
    try {
      await _shakeCtrl.forward(from: 0);
    } finally {
      _isAnimating = false;
    }
  }

  void _handleTap() {
    if (widget.isTarget) {
      _playFlip();
      widget.onCorrect();
    } else {
      _playShake();
      widget.onWrong();
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16);

    return AnimatedBuilder(
      animation: Listenable.merge([_flip, _shake]),
      builder: (context, child) {
        final double angle = _flip.value * pi;
        final double scale = 1.0 + (_flip.value * 0.06);
        final Matrix4 transform = Matrix4.identity()
          ..translate(_shake.value)
          ..setEntry(3, 2, 0.001)
          ..rotateY(angle);

        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: Transform.scale(
            scale: scale,
            child: InkWell(
              onTap: _handleTap,
              borderRadius: borderRadius,
              child: Ink(
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: borderRadius,
                ),
                child: Stack(
                  children: [
                    const SizedBox.expand(),
                    if (widget.showLabel)
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
