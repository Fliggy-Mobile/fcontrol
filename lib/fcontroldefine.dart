
import 'package:flutter/material.dart';

class FShapeEffects{
  final FBorderShape shape;
  final BorderRadiusGeometry borderRadius;
  final BorderSide side;

  const FShapeEffects({
    this.shape:FBorderShape.RoundedRectangle,
    this.borderRadius:const BorderRadius.all(Radius.circular(10)),
    this.side:const BorderSide(color: Colors.transparent, style: BorderStyle.solid, width: 1), 
  });
}

class FShadowEffects{
  Color highlightColor;
  double highlightDistance;
  double highlightBlur;
  double highlightSpread;

  Color shadowColor;
  double shadowDistance;
  double shadowBlur;
  double shadowSpread;

  FShadowEffects({
    this.highlightColor = Colors.white,
    this.highlightDistance = 5,
    this.highlightBlur = 10,
    this.highlightSpread = 2,
    this.shadowColor = Colors.black,
    this.shadowDistance = 5,
    this.shadowBlur = 10,
    this.shadowSpread = 2,
  });
}

typedef FGroupContorllerClickCallback = List<Color> Function(Widget stateChanged,bool selected,List<Widget> widgets);

class FGroupController{
  final List<State> states = List();
  final FGroupContorllerClickCallback groupClickCallback;
  final bool mustBeSelected;

  FGroupController({
    this.mustBeSelected = false, 
    this.groupClickCallback
  });
}

enum FLightOrientation{
  LeftTop,
  LeftBottom,
  RightTop,
  RightBottom,
}

enum FBorderShape{
  RoundedRectangle,
  ContinuousRectangle,
  BeveledRectangle,
}

enum FSurfaceShape{
  Flat, //平面
  Convex, //凸面
  Concave, //凹面
}

enum FControlState{
  Normal,
  Highlight,
  Disable,
}

enum FControlAppearance{
  Flat,
  Neumorphism,
  Material,
}

enum FControlType{
  Button,
  Toggle,
}

typedef FControlBackgroundColorForStateCallback = List<Color> Function(Widget sender,FControlState state);
typedef FControlBorderForStateCallback = Border Function(Widget sender,FControlState state);
typedef FControlChildForStateCallback = Widget Function(Widget sender,FControlState state);
typedef FControlTapEventForStateCallback = void Function(Widget sender,FControlState state,bool isSelected);
typedef FControlClickEventCallback = void Function(Widget sender,bool isSelected);
typedef FControlShapeForStateCallback = FShapeEffects Function(Widget sender, FControlState state);
typedef FControlSurfaceForStateCallback = FSurfaceShape Function(Widget sender, FControlState state);