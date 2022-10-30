import 'package:flutter/material.dart';

import '../../shared/config.dart';

class DottedPictureContainer extends StatelessWidget {
  final VoidCallback onTap;
  const DottedPictureContainer({required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    SharedConfigs.colors.secondary,
                    SharedConfigs.colors.tertiary,
                  ],
                  stops: const [0.0, 1.3],
                ),
              ),
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 8),
            const Text('Adicionar foto')
          ],
        ),
      ),
    );
  }
}
