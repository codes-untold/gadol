import 'package:flutter/material.dart';
import 'design_tokens.dart';

class AppSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;

  const AppSearchBar({
    Key? key,
    required this.controller,
    this.placeholder = 'Search products...',
    required this.onChanged,
    this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: placeholder,
        prefixIcon: Icon(
          Icons.search,
          color: Theme.of(context).colorScheme.outline,
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).colorScheme.outline,
                ),
                onPressed: () {
                  controller.clear();
                  onChanged('');
                  onClear?.call();
                },
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppPadding.md,
          vertical: AppPadding.md,
        ),
      ),
    );
  }
}
