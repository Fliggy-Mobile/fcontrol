import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:fcontrol/fdefine.dart';

class FInnerShadow extends SingleChildRenderObjectWidget {
  final double blur;
  final Color color;
  final Offset offset;
  FInnerShadow({
    Key? key,
    this.blur = 10,
    this.color = FInnerShadowColor,
    this.offset = FInnerShadowOffset,
    Widget? child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    final _ZenUIRenderInnerShadow renderObject = _ZenUIRenderInnerShadow();
    updateRenderObject(context, renderObject);
    return renderObject;
  }

  @override
  void updateRenderObject(
      BuildContext context, _ZenUIRenderInnerShadow renderObject) {
    renderObject
      ..color = color
      ..blur = blur
      ..dx = offset.dx
      ..dy = offset.dy;
  }
}

class _ZenUIRenderInnerShadow extends RenderProxyBox {
  double? blur;
  Color? color;
  double? dx;
  double? dy;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;
    final Rect rectOuter = offset & size;
    final Rect rectInner = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      size.width,
      size.height,
    );
    final Canvas canvas = context.canvas..saveLayer(rectOuter, Paint());
    context.paintChild(child!, offset);
    Paint shadowPaint = Paint()
      ..blendMode = BlendMode.srcATop
      ..imageFilter = ImageFilter.blur(sigmaX: blur ?? 0, sigmaY: blur ?? 0)
      ..colorFilter = ColorFilter.mode(color ?? Colors.white, BlendMode.srcOut);
    canvas
      ..saveLayer(rectOuter, shadowPaint)
      ..saveLayer(rectInner, Paint())
      ..translate(dx ?? 0, dy ?? 0);
    context.paintChild(child!, offset);
    context.canvas..restore()..restore()..restore();
  }
}
