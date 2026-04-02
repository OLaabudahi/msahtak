import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/i18n/app_i18n.dart';
import '../../language/bloc/language_bloc.dart';
import '../../language/bloc/language_event.dart';
import '../../language/bloc/language_state.dart';
import '../../../services/language_service.dart';

class AuthLanguageHeader extends StatelessWidget {
  const AuthLanguageHeader({super.key, required this.titleKey});
  final String titleKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            context.t(titleKey),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [AppColors.secondary, AppColors.amber],
                      stops: [0.0, 1.0],
                    ).createShader(bounds);
                  },
                  child: const Icon(
                    Icons.language,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width:2),
                Container(
                  constraints: const BoxConstraints(maxWidth: 95),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.amber,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: state.code,
                      isDense: true,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        size: 20,
                        color: AppColors.amber,
                      ),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      dropdownColor: Colors.white,
                      elevation: 8,
                      borderRadius: BorderRadius.circular(8),
                      items: LanguageService.supported
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.code,
                              child: Text(e.label),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v == null) return;
                        context.read<LanguageBloc>().add(LanguageChanged(v));
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
