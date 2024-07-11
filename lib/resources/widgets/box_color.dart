import 'package:flutter/material.dart';

class BoxColor extends StatelessWidget {
  final Widget? child;
  final BoxBorder? border;
  final Color? color;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final DecorationImage? image;

  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final BlendMode? backgroundBlendMode;
  final BoxShape? shape;
  final BoxConstraints? constraints;
  final void Function()? onTap;

  const BoxColor({
    Key? key,
    this.child,
    this.border,
    this.color,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.image,
    this.borderRadius,
    this.boxShadow,
    this.gradient,
    this.backgroundBlendMode,
    this.shape,
    this.constraints,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          image: image,
          border: border,
          borderRadius: borderRadius,
          color: color,
          boxShadow: boxShadow,
          shape: shape ?? BoxShape.rectangle,
          gradient: gradient,
        ),
        constraints: constraints,
        child: child,
      ),
    );
  }
}
