import 'package:flutter/material.dart';
import 'dart:math' as math;

class FShape {
  final FBorderShape borderShape;
  final BorderRadiusGeometry borderRadius;
  final BorderSide side;

  const FShape({
    this.borderShape: FBorderShape.RoundedRectangle,
    this.borderRadius: const BorderRadius.all(Radius.circular(10)),
    this.side: const BorderSide(
        color: Colors.transparent, style: BorderStyle.solid, width: 0),
  });
}

class FShadow {
  final Color highlightColor;
  final double highlightDistance;
  final double highlightBlur;
  final double highlightSpread;

  final Color shadowColor;
  final double shadowDistance;
  final double shadowBlur;
  final double shadowSpread;

  const FShadow({
    this.highlightColor = FHighlightShadowColor,
    this.highlightDistance = 3,
    this.highlightBlur = 6,
    this.highlightSpread = 1,
    this.shadowColor = FDarkShadowColor,
    this.shadowDistance = 3,
    this.shadowBlur = 6,
    this.shadowSpread = 1,
  });
}

typedef FGroupContorllerClickCallback = List<Color> Function(
    Widget stateChanged, bool selected, List<Widget> widgets);

class FGroupController {
  final List<State> states = List();
  final FGroupContorllerClickCallback groupClickCallback;
  final bool mustBeSelected;
  FGroupController({this.mustBeSelected = false, this.groupClickCallback});
}

enum FGradientType {
  Linear,
  Radial,
  Sweep,
}

enum FLightOrientation {
  LeftTop,
  LeftBottom,
  RightTop,
  RightBottom,
}

enum FBorderShape {
  RoundedRectangle,
  ContinuousRectangle,
  BeveledRectangle,
}

enum FSurface {
  Flat, //平面
  Convex, //凸面
  Concave, //凹面
}

enum FState {
  Normal,
  Highlighted,
  Disable,
}

enum FAppearance {
  Flat,
  Neumorphism,
  Material,
}

enum FType {
  Button,
  Toggle,
}

typedef FColorForStateCallback = Color Function(
    Widget sender, FState state);
typedef FGradientForStateCallback = Gradient Function(
    Widget sender, FState state);
typedef FBorderForStateCallback = Border Function(
    Widget sender, FState state);
typedef FChildForStateCallback = Widget Function(
    Widget sender, FState state);
typedef FTapEventForStateCallback = void Function(
    Widget sender, FState state, bool checked);
typedef FShapeForStateCallback = FShape Function(
    Widget sender, FState state);
typedef FSurfaceForStateCallback = FSurface Function(
    Widget sender, FState state);

typedef FOnTapCallback = void Function(Widget sender, bool checked);
typedef FOnTapDownCallback = void Function(Widget sender, bool checked);
typedef FOnTapCancelCallback = void Function(Widget sender, bool checked);
typedef FOnTapUpCallback = void Function(Widget sender, bool checked);

//ZenUI库中所有组件的主颜色
const Color FPrimerColor = Colors.lightBlueAccent;
const Color FInnerShadowColor = Colors.black38;
const Offset FInnerShadowOffset = Offset(10, 10);
const Color FHighlightShadowColor = Colors.white;
const Color FDarkShadowColor = Colors.black;
const Color FDisableColor = Colors.grey;
