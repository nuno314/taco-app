import 'package:flutter/material.dart';

class ButtonWidget {
  static Widget primary({
    required BuildContext context,
    required String title,
    Function()? onPressed,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 16),
    BoxConstraints constraints = const BoxConstraints(minHeight: 48.0),
    bool enable = true,
    Color? color,
  }) =>
      RawMaterialButton(
        fillColor: enable
            ? (color ?? Theme.of(context).colorScheme.primary)
            : Theme.of(context).colorScheme.primary.withAlpha(55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: enable ? onPressed : null,
        elevation: 0,
        padding: padding,
        constraints: constraints,
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.white,
              ),
          textAlign: TextAlign.center,
        ),
      );

  static Widget primaryIcon({
    required BuildContext context,
    required String title,
    required Widget icon,
    Function()? onPressed,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 15,
    ),
    BoxConstraints constraints = const BoxConstraints(minHeight: 48.0),
  }) =>
      RawMaterialButton(
        fillColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: onPressed,
        elevation: 0,
        padding: padding,
        constraints: constraints,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Text(
                title,
              ),
            ),
            const SizedBox(width: 6),
            icon,
          ],
        ),
      );

  static Widget notRecommend({
    required BuildContext context,
    String title = '',
    Function()? onPressed,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 16),
    BoxConstraints constraints = const BoxConstraints(minHeight: 48.0),
    bool enable = true,
  }) =>
      RawMaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: enable ? onPressed : null,
        elevation: 0,
        padding: padding,
        constraints: constraints,
        child: Text(
          title,
          textAlign: TextAlign.center,
        ),
      );

  static Widget denied({
    required BuildContext context,
    String title = '',
    Function()? onPressed,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 16),
    BoxConstraints constraints = const BoxConstraints(minHeight: 48.0),
    bool? reverseColor,
  }) =>
      RawMaterialButton(
        fillColor: reverseColor == true ? Colors.red : const Color(0xffFFF0F1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: onPressed,
        elevation: 0,
        padding: padding,
        constraints: constraints,
        child: Text(
          title,
          textAlign: TextAlign.center,
        ),
      );

  static Widget recommend({
    required BuildContext context,
    required String title,
    Function()? onPressed,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 16),
    BoxConstraints constraints = const BoxConstraints(minHeight: 48.0),
    bool enable = true,
  }) {
    return ButtonWidget.primary(
      context: context,
      title: title,
      onPressed: onPressed,
      padding: padding,
      constraints: constraints,
      enable: enable,
      color: Colors.blueAccent,
    );
  }
}
