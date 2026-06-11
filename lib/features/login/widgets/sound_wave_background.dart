import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SoundWaveBackground extends StatelessWidget {
  const SoundWaveBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        height: 122,
        width: double.infinity,
        child: SvgPicture.asset(
          'assets/illustrations/wave.svg',
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
