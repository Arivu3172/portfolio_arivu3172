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
    final wide = MediaQuery.sizeOf(context).width >= 800;
    final status = _booting
        ? 'BOOT'
        : _done
            ? 'READY'
            : 'LIVE ${_cmdIndex + 1}/${_commands.length}';

    return Scaffold(
      backgroundColor: const Color(0xFF020805),
      body: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _scan,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _HackerBackdropPainter(t: _scan.value),
                  );
                },
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(wide ? 28 : 12),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 920),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0x66101812),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: _matrix.withValues(alpha: 0.45)),
                      boxShadow: [
                        BoxShadow(
                          color: _matrix.withValues(alpha: 0.12),
                          blurRadius: 28,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _ConsoleBar(
                          status: status,
                          mono: _mono,
                          onBack: () => Navigator.of(context).maybePop(),
                          onSkip: _done ? null : _skip,
                          onSpeak: _speakResume,
                          onImage: _openClassic,
                        ),
                        Expanded(
                          child: SelectionArea(
                            child: ListView.builder(
                              controller: _scroll,
                              padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
                              itemCount: _lines.length + 1,
                              itemBuilder: (context, index) {
                                if (index >= _lines.length) {
                                  return AnimatedBuilder(
                                    animation: _blink,
                                    builder: (context, _) {
                                      return Text(
                                        _done ? 'root@arivu:~\$ █' : '█',
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
                                final isPrompt = line.kind == _LineKind.prompt;
                                return Padding(
                                  padding: EdgeInsets.only(
                                    top: isPrompt ? 10 : 0,
                                    bottom: 1,
                                  ),
                                  child: Text(
                                    line.text.isEmpty ? ' ' : line.text,
                                    style: _mono(
                                      color: switch (line.kind) {
                                        _LineKind.system => AppColors.themeColor,
                                        _LineKind.prompt => _muted,
                                        _LineKind.output => _matrix,
                                        _LineKind.blank => _matrix,
                                      },
                                      weight: isPrompt
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        if (_done)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _TermAction(
                                  label: 'mail',
                                  onTap: () => launchUrl(
                                    Uri.parse(
                                      'mailto:arivazhagan3172@gmail.com',
                                    ),
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
                                  label: 'image',
                                  onTap: _openClassic,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConsoleBar extends StatelessWidget {
  const _ConsoleBar({
    required this.status,
    required this.mono,
    required this.onBack,
    required this.onSkip,
    required this.onSpeak,
    required this.onImage,
  });

  final String status;
  final TextStyle Function({
    double size,
    Color color,
    FontWeight weight,
  }) mono;
  final VoidCallback onBack;
  final VoidCallback? onSkip;
  final VoidCallback onSpeak;
  final VoidCallback onImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x9907140C),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF39FF14).withValues(alpha: 0.28),
          ),
        ),
      ),
      child: Row(
        children: [
          _dot(const Color(0xFFFF5F57)),
          const SizedBox(width: 6),
          _dot(const Color(0xFFFEBC2E)),
          const SizedBox(width: 6),
          _dot(const Color(0xFF28C840)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'resume.sh',
              style: mono(size: 13, weight: FontWeight.w700),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              color: const Color(0xFF39FF14).withValues(alpha: 0.12),
            ),
            child: Text(status, style: mono(size: 10, color: const Color(0xFF6BFF8A))),
          ),
          if (onSkip != null)
            TextButton(
              onPressed: onSkip,
              child: Text('SKIP', style: mono(size: 11, color: AppColors.themeColor)),
            ),
          IconButton(
            tooltip: 'Speak',
            onPressed: onSpeak,
            icon: const Icon(Icons.record_voice_over_rounded, size: 18),
            color: const Color(0xFF39FF14),
          ),
          IconButton(
            tooltip: 'Image',
            onPressed: onImage,
            icon: const Icon(Icons.image_outlined, size: 18),
            color: const Color(0xFF39FF14),
          ),
          IconButton(
            tooltip: 'Back',
            onPressed: onBack,
            icon: const Icon(Icons.close_rounded, size: 18),
            color: const Color(0xFF39FF14),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(99),
          color: const Color(0xFF39FF14).withValues(alpha: 0.08),
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

/// Circuit board, traveling packets, and a radar sweep.
class _HackerBackdropPainter extends CustomPainter {
  _HackerBackdropPainter({required this.t});

  final double t;

  static const _green = Color(0xFF39FF14);

  @override
  void paint(Canvas canvas, Size size) {
    final trace = Paint()
      ..color = _green.withValues(alpha: 0.42)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    final pad = Paint()..color = _green.withValues(alpha: 0.7);

    final lanes = <double>[
      size.height * 0.18,
      size.height * 0.42,
      size.height * 0.67,
      size.height * 0.86,
    ];
    for (final y in lanes) {
      canvas.drawLine(Offset(24, y), Offset(size.width - 24, y), trace);
      for (double x = 48; x < size.width - 40; x += 92) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(x, y), width: 7, height: 7),
            const Radius.circular(1),
          ),
          pad,
        );
        if (x.toInt() % 3 == 0) {
          canvas.drawLine(Offset(x, y), Offset(x, y + 36), trace);
          canvas.drawCircle(Offset(x, y + 36), 2.2, pad);
        }
      }
      final packetX = 24 + ((t * 1.7 + y) % 1) * (size.width - 48);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(packetX, y), width: 18, height: 4),
          const Radius.circular(2),
        ),
        Paint()..color = const Color(0xFFD8FFD8).withValues(alpha: 0.85),
      );
    }

    _radar(canvas, Offset(size.width * 0.86, size.height * 0.22), 72);
    _brackets(canvas, size);
    _label(canvas, const Offset(28, 18), 'SYS://ARIVU');
    _label(canvas, Offset(size.width - 118, size.height - 28), 'LINK 04');
  }

  void _radar(Canvas canvas, Offset center, double radius) {
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = _green.withValues(alpha: 0.5);
    for (var i = 1; i <= 3; i++) {
      canvas.drawCircle(center, radius * i / 3, ring);
    }
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      ring,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      ring,
    );

    final angle = t * math.pi * 2;
    final sweep = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        angle - 0.7,
        0.7,
        false,
      )
      ..close();
    canvas.drawPath(
      sweep,
      Paint()..color = _green.withValues(alpha: 0.32),
    );
    canvas.drawLine(
      center,
      Offset(center.dx + math.cos(angle) * radius, center.dy + math.sin(angle) * radius),
      Paint()
        ..color = _green.withValues(alpha: 0.8)
        ..strokeWidth = 1.4,
    );
    canvas.drawCircle(
      Offset(
        center.dx + math.cos(angle * 1.7) * radius * 0.55,
        center.dy + math.sin(angle * 1.3) * radius * 0.4,
      ),
      3,
      Paint()..color = const Color(0xFFE8FFE8),
    );
  }

  void _brackets(Canvas canvas, Size size) {
    const arm = 22.0;
    final paint = Paint()
      ..color = _green.withValues(alpha: 0.75)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    final corners = <Offset>[
      const Offset(16, 16),
      Offset(size.width - 16, 16),
      Offset(16, size.height - 16),
      Offset(size.width - 16, size.height - 16),
    ];
    final signs = <Offset>[
      const Offset(1, 1),
      const Offset(-1, 1),
      const Offset(1, -1),
      const Offset(-1, -1),
    ];
    for (var i = 0; i < corners.length; i++) {
      final o = corners[i];
      final s = signs[i];
      canvas.drawLine(o, o + Offset(arm * s.dx, 0), paint);
      canvas.drawLine(o, o + Offset(0, arm * s.dy), paint);
    }
  }

  void _label(Canvas canvas, Offset at, String text) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: _green.withValues(alpha: 0.7),
          fontSize: 10,
          fontFamily: 'monospace',
          letterSpacing: 1.4,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, at);
  }

  @override
  bool shouldRepaint(covariant _HackerBackdropPainter oldDelegate) =>
      oldDelegate.t != t;
}
