import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    this.controller,
    this.focusNode,
    this.decoration,
    this.enabled = true,
    this.fillColor = false,
    this.hintText,
    this.title,
    this.maxLines,
    this.onSubmitted,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final bool enabled;
  final String? hintText;
  final String? title;
  final bool fillColor;
  final int? maxLines;
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null) Text(title!),
        SizedBox(height: 4),
        TextField(
          controller: controller,
          focusNode: focusNode,
          maxLines: maxLines,
          onSubmitted: onSubmitted,
          decoration: decoration ??
              InputDecoration(
                filled: !enabled || fillColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
                border: OutlineInputBorder(),

                hintText: hintText,
                hintStyle: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.grey),
                // errorText: value.validation,
                // errorStyle: themeData.textTheme.subtitle1?.copyWith(
                //   color: Colors.red,
                //   fontSize: value.validation?.isNotEmpty == true ? null : 1,
                // ),
                errorMaxLines: 2,
                // suffixIcon: Padding(
                //   padding: EdgeInsets.symmetric(horizontal: suffixIconSize),
                //   child: _getSuffixIcon(),
                // ),
                // suffixIconConstraints: BoxConstraints(
                //   minHeight: suffixIconSize,
                //   minWidth: suffixIconSize,
                // ),
                // prefixIcon: hasPrefixIcon
                //     ? Padding(
                //         padding: EdgeInsets.symmetric(horizontal: prefixIconSize),
                //         child: widget.prefixIcon,
                //       )
                //     : null,
                // prefixIconConstraints: hasPrefixIcon
                //     ? BoxConstraints(
                //         minHeight: suffixIconSize,
                //         minWidth: suffixIconSize,
                //       )
                //     : null,
                // fillColor: widget.enable ? widget.fillColor : null,
                // counterStyle: themeData.textTheme.subtitle1,
              ),
        ),
      ],
    );
  }
}
