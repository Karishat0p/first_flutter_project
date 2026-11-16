import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

abstract class SvgObjects {
  static void init() {
    final pics = <String>[
      'assets/svg/flag-ru.svg',
      'assets/svg/uk.svg',
    ];

    for (final String p in pics) {
      final loader = SvgAssetLoader(p);
      svg.cache.putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
    }
  }
}

class SvgRu extends StatelessWidget {
  const SvgRu({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/svg/flag-ru.svg');
  }
}

class SvgUk extends StatelessWidget {
  const SvgUk({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/svg/uk.svg');
  }
}