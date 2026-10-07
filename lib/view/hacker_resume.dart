import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_arivu/globals/app_assets.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';
import 'package:portfolio_arivu/globals/portfolio_content.dart';
import 'package:portfolio_arivu/globals/sound_fx.dart';
import 'package:portfolio_arivu/globals/voice_tts.dart';
import 'package:url_launcher/url_launcher.dart';

/// Terminal / hacker-style interactive resume.
class HackerResumePage extends StatefulWidget {
  const HackerResumePage({super.key});

  @override
  State<HackerResumePage> createState() => _HackerResumePageState();
}

class _HackerResumePageState extends State<HackerResumePage>
    with TickerProviderStateMixin {
  static const _matrix = Color(0xFF39FF14);
  static const _muted = Color(0xFF6BFF8A);

  late final AnimationController _scan;
  late final AnimationController _blink;
  final _scroll = ScrollController();

  final List<_TermLine> _lines = [];
  bool _booting = true;
  bool _done = false;
  int _cmdIndex = 0;

  late final List<_ShellCmd> _commands = [
    _ShellCmd(
      prompt: 'whoami',
      body: '${PortfolioContent.name}\n${PortfolioContent.role}  ·  2+ years',
    ),
    const _ShellCmd(
      prompt: 'cat ~/contact.txt',
      body:
          'email     arivazhagan3172@gmail.com\n'
          'github    github.com/Arivu3172\n'
          'linkedin  linkedin.com/in/arivazhagan-a-0431bb24a',
    ),
    _ShellCmd(
      prompt: 'cat ~/summary.md',
      body: PortfolioContent.aboutBody,
    ),
    const _ShellCmd(
      prompt: 'ls ~/experience/',
      body:
          'howdy/\n'
          'timesmed_doctor_patient/\n'
          'timesmed_vka/\n'
          'coding_style/',
    ),
    const _ShellCmd(
      prompt: 'cat ~/experience/log.txt',
      body: '''
[2024-2025]  Flutter Developer @ Howdy · TimesMed · Coding Style
  → UI systems, auth, REST, Firebase, performance, release support

[2024-2025]  Healthcare products @ TimesMed Doctor, Patient & VKA
  → Clinical flows, role-based screens, production stability

[2025]       Product craft @ Cross-platform delivery
  → Reusable widgets, clean architecture, polished motion''',
    ),
    const _ShellCmd(
      prompt: 'cat ~/skills.json',
      body: '''
{
  "core": ["Flutter", "Dart", "Material 3", "Responsive UI"],
  "state": ["Provider", "GetX", "Clean Architecture"],
  "data":  ["REST API", "Firebase", "Auth", "Firestore"],
  "ship":  ["Android", "iOS", "Web", "Git"]
}''',
    ),
    const _ShellCmd(
      prompt: 'cat ~/projects.list',
      body: '''
Howdy ......................... Flutter · API · UI System
TimesMed Doctor & Patient ..... Flutter · Firebase · Healthcare
TimesMed VKA .................. Flutter · Modules · UX
Coding Style .................. Architecture · Widgets · Craft''',
    ),
    const _ShellCmd(
      prompt: r'echo $STATUS',
      body: 'AVAILABLE_FOR_HIRE=true\nREADY_TO_SHIP=true\nNEXT_SCENE=YOURS',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scan = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _blink = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..repeat(reverse: true);
    SoundFx.instance.playWhoosh();
    _boot();
  }

  @override
  void dispose() {
    _scan.dispose();
    _blink.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _boot() async {
    await _typeLine(
      _TermLine(
        kind: _LineKind.system,
        text: '> boot sequence // portfolio_kernel v3.1.7',
      ),
      charDelay: 12,
    );
    await _typeLine(
      _TermLine(kind: _LineKind.system, text: '> loading resume.bin ........ OK'),
      charDelay: 10,
    );
    await _typeLine(
      _TermLine(
        kind: _LineKind.system,
        text: '> access granted: ${PortfolioContent.name.toUpperCase()}',
      ),
      charDelay: 10,
    );
    await Future<void>.delayed(const Duration(milliseconds: 220));
    if (!mounted) return;
    setState(() => _booting = false);
    await _runCommands();
  }

  Future<void> _runCommands() async {
    while (_cmdIndex < _commands.length && mounted) {
      final cmd = _commands[_cmdIndex];
      await _typeLine(
        _TermLine(kind: _LineKind.prompt, text: 'root@arivu:~\$ ${cmd.prompt}'),
        charDelay: 18,
      );
      await Future<void>.delayed(const Duration(milliseconds: 120));
      for (final row in cmd.body.split('\n')) {
        await _typeLine(
          _TermLine(kind: _LineKind.output, text: row),
          charDelay: 4,
        );
      }
      await _typeLine(_TermLine(kind: _LineKind.blank, text: ''), charDelay: 0);
      _cmdIndex++;
    }
    if (!mounted) return;
    setState(() => _done = true);
    SoundFx.instance.playChime();
  }

  Future<void> _typeLine(_TermLine line, {required int charDelay}) async {
    if (charDelay <= 0 || line.text.isEmpty) {
      setState(() => _lines.add(line));
      _scrollToEnd();
      return;
    }

    final buffer = StringBuffer();
    setState(() => _lines.add(_TermLine(kind: line.kind, text: '')));
    final idx = _lines.length - 1;

    for (final rune in line.text.runes) {
      if (!mounted) return;
      buffer.writeCharCode(rune);
      setState(() => _lines[idx] = _TermLine(kind: line.kind, text: buffer.toString()));
      _scrollToEnd();
      await Future<void>.delayed(Duration(milliseconds: charDelay));
    }
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.jumpTo(_scroll.position.maxScrollExtent);
    });
  }

  Future<void> _skip() async {
    if (_done) return;
    setState(() {
      _lines
        ..clear()
        ..addAll([
          _TermLine(
            kind: _LineKind.system,
            text: '> boot sequence // portfolio_kernel v3.1.7',
          ),
          _TermLine(
            kind: _LineKind.system,
            text: '> access granted: ${PortfolioContent.name.toUpperCase()}',
          ),
          _TermLine(kind: _LineKind.blank, text: ''),
        ]);
      for (final cmd in _commands) {
        _lines.add(
          _TermLine(kind: _LineKind.prompt, text: 'root@arivu:~\$ ${cmd.prompt}'),
        );
        for (final row in cmd.body.split('\n')) {
          _lines.add(_TermLine(kind: _LineKind.output, text: row));
        }
        _lines.add(_TermLine(kind: _LineKind.blank, text: ''));
      }
      _booting = false;
      _done = true;
      _cmdIndex = _commands.length;
    });
    SoundFx.instance.playClick();
    _scrollToEnd();
  }

  Future<void> _speakResume() async {
    SoundFx.instance.playClick();
    final script = [
      'Resume for ${PortfolioContent.name}, ${PortfolioContent.role}.',
      PortfolioContent.aboutBody,
      'Experience includes Howdy, TimesMed, and Coding Style.',
      'Skills: Flutter, Dart, Firebase, REST APIs, Android, iOS, and web.',
      'Status: available for hire.',
    ].join(' ');
    await VoiceTts.instance.speak(script);
  }

  Future<void> _openClassic() async {
    SoundFx.instance.playClick();
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const _ClassicResumeView()),
    );
  }

  TextStyle _mono({
    double size = 13,
    Color color = _matrix,
    FontWeight weight = FontWeight.w400,
  }) {
    return GoogleFonts.sourceCodePro(
      fontSize: size,
      color: color,
      fontWeight: weight,
      height: 1.45,
      letterSpacing: 0.2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020805),
      appBar: AppBar(
        backgroundColor: const Color(0xFF041008),
        foregroundColor: _matrix,
        elevation: 0,
        title: Text(
          'resume.sh  —  secure shell',
          style: _mono(size: 13, weight: FontWeight.w600),
        ),
        actions: [
          if (!_done)
            TextButton(
              onPressed: _skip,
              child: Text('SKIP >>', style: _mono(size: 11, color: AppColors.themeColor)),
            ),
          IconButton(
            tooltip: 'Speak resume',
            onPressed: _speakResume,
            icon: const Icon(Icons.record_voice_over_rounded, size: 20),
          ),
          IconButton(
            tooltip: 'Classic image',
            onPressed: _openClassic,
            icon: const Icon(Icons.image_outlined, size: 20),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Stack(
        children: [
          // Matrix rain-ish dots
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _scan,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _MatrixRainPainter(t: _scan.value),
                  );
                },
              ),
            ),
          ),
          // Scanline
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _scan,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _ScanlinePainter(t: _scan.value),
                  );
                },
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: _matrix.withValues(alpha: 0.25)),
                  ),
                ),
                child: Text(
                  _booting
                      ? 'INITIALIZING...'
                      : _done
                          ? 'SESSION COMPLETE  ·  ${PortfolioContent.name.toUpperCase()}'
                          : 'STREAMING RESUME  ·  ${_cmdIndex + 1}/${_commands.length}',
                  style: _mono(size: 11, color: _muted),
                ),
              ),
              Expanded(
                child: SelectionArea(
                  child: ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                    itemCount: _lines.length + (_done ? 1 : 1),
                    itemBuilder: (context, index) {
                      if (index >= _lines.length) {
                        return AnimatedBuilder(
                          animation: _blink,
                          builder: (context, _) {
                            return Text(
                              _done
                                  ? 'root@arivu:~\$ █'
                                  : '█',
                              style: _mono(
                                color: _matrix.withValues(
                                  alpha: 0.35 + _blink.value * 0.65,
                                ),
                              ),
                            );
                          },
                        );
                      }
                      final line = _lines[index];
                      return Text(
                        line.text.isEmpty ? ' ' : line.text,
                        style: _mono(
                          color: switch (line.kind) {
                            _LineKind.system => AppColors.themeColor,
                            _LineKind.prompt => _muted,
                            _LineKind.output => _matrix,
                            _LineKind.blank => _matrix,
                          },
                          weight: line.kind == _LineKind.prompt
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (_done)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF041008),
                    border: Border(
                      top: BorderSide(color: _matrix.withValues(alpha: 0.25)),
                    ),
                  ),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _TermAction(
                        label: 'mailto',
                        onTap: () => launchUrl(
                          Uri.parse('mailto:arivazhagan3172@gmail.com'),
                        ),
                      ),
                      _TermAction(
                        label: 'github',
                        onTap: () => launchUrl(
                          Uri.parse('https://github.com/Arivu3172'),
                        ),
                      ),
                      _TermAction(
                        label: 'linkedin',
                        onTap: () => launchUrl(
                          Uri.parse(
                            'https://www.linkedin.com/in/arivazhagan-a-0431bb24a',
                          ),
                        ),
                      ),
                      _TermAction(
                        label: 'classic_resume.png',
                        onTap: _openClassic,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TermAction extends StatelessWidget {
  const _TermAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        SoundFx.instance.playClick();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF39FF14).withValues(alpha: 0.55),
          ),
        ),
        child: Text(
          './$label',
          style: GoogleFonts.sourceCodePro(
            color: const Color(0xFF39FF14),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ShellCmd {
  const _ShellCmd({required this.prompt, required this.body});
  final String prompt;
  final String body;
}

enum _LineKind { system, prompt, output, blank }

class _TermLine {
  const _TermLine({required this.kind, required this.text});
  final _LineKind kind;
  final String text;
}

class _ClassicResumeView extends StatelessWidget {
  const _ClassicResumeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF041008),
        foregroundColor: const Color(0xFF39FF14),
        title: Text(
          'classic_resume.png',
          style: GoogleFonts.sourceCodePro(fontSize: 13),
        ),
      ),
      body: InteractiveViewer(
        minScale: 0.6,
        maxScale: 4,
        child: Center(
          child: Image.asset(
            AppAssets.resume,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Text(
              'resume image missing',
              style: GoogleFonts.sourceCodePro(color: const Color(0xFF39FF14)),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScanlinePainter extends CustomPainter {
  _ScanlinePainter({required this.t});
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height * t;
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          const Color(0xFF39FF14).withValues(alpha: 0.08),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, y - 40, size.width, 80));
    canvas.drawRect(Rect.fromLTWH(0, y - 40, size.width, 80), paint);

    final line = Paint()
      ..color = const Color(0xFF39FF14).withValues(alpha: 0.03)
      ..strokeWidth = 1;
    for (double i = 0; i < size.height; i += 3) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), line);
    }
  }

  @override
  bool shouldRepaint(covariant _ScanlinePainter oldDelegate) =>
      oldDelegate.t != t;
}

class _MatrixRainPainter extends CustomPainter {
  _MatrixRainPainter({required this.t});
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(7);
    final paint = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < 40; i++) {
      final x = rng.nextDouble() * size.width;
      final speed = 0.3 + rng.nextDouble() * 0.7;
      final y = ((t * speed + rng.nextDouble()) % 1.0) * size.height;
      paint.color = const Color(0xFF39FF14)
          .withValues(alpha: 0.04 + rng.nextDouble() * 0.06);
      canvas.drawCircle(Offset(x, y), 1.2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MatrixRainPainter oldDelegate) =>
      oldDelegate.t != t;
}
