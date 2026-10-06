import 'package:flutter/material.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';
import 'package:portfolio_arivu/globals/sound_fx.dart';
import 'package:portfolio_arivu/globals/text_style.dart';
import 'package:portfolio_arivu/globals/voice_tts.dart';

/// Gold "LISTEN" control that toggles text-to-speech for a script.
class SpeakButton extends StatelessWidget {
  const SpeakButton({
    super.key,
    required this.text,
    this.compact = false,
  });

  final String text;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: VoiceTts.instance,
      builder: (context, _) {
        final tts = VoiceTts.instance;
        final active = tts.isSpeakingText(text);
        return InkWell(
          onTap: () async {
            SoundFx.instance.playClick();
            if (active) {
              await tts.stop();
            } else {
              await tts.speak(text);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 10 : 12,
              vertical: compact ? 6 : 8,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: active
                    ? AppColors.lawGreen
                    : AppColors.themeColor.withValues(alpha: 0.65),
              ),
              color: active
                  ? AppColors.themeColor.withValues(alpha: 0.12)
                  : Colors.transparent,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  active ? Icons.stop_rounded : Icons.record_voice_over_rounded,
                  size: compact ? 14 : 16,
                  color: AppColors.themeColor,
                ),
                const SizedBox(width: 8),
                Text(
                  active ? 'STOP' : 'LISTEN',
                  style: AppTextStyles.indexStyle().copyWith(
                    fontSize: compact ? 10 : 11,
                    letterSpacing: 2.2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
