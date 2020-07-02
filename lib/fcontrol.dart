import 'package:flutter/material.dart';
import 'fdefine.dart';

import 'finnershadow.dart';

class FControl extends StatefulWidget {
  //组件标识，可以随意填写，用来在特殊情况下标识当前组件
  final String componentId;

  //组件宽高，不指定宽高的情况下，control的size会随内容变化而变化
  final double width;
  final double height;

  //组件的内外边距，默认均为0
  final EdgeInsetsGeometry margin; //组件外边距
  final EdgeInsetsGeometry padding; //组件内边距

  //组件视觉效果及外观设置
  //FAppearance，组件外观选项，支持三种外观，Flat（扁平风格）,Neumorphism（新拟态风格）,Material（材质风格）,
  //FLightOrientation 光源方向，分为左上、左下、右上、右下四个方向。用来控制光源照射方向，会影响高亮方向和阴影方向
  //FSurface 组件表面的视觉效果，  Flat（平面效果）、Convex（凸面效果）、Concave（凹面效果）该效果会随着光源而变化
  //FSurfaceForStateCallback 根据状态不同，返回不同的Surface
  //FShape 设置组件的边框及外形 支持RoundedRectangle（圆角）,ContinuousRectangle（连续弧度）,BeveledRectangle（斜角）三种形式
  //FShapeForStateCallback 根据状态不同，返回不同的Shape
  final FAppearance appearance;
  final FLightOrientation lightOrientation;
  final FSurface surface;
  final FSurfaceForStateCallback surfaceForCallback;
  final FShape shape;
  final FShapeForStateCallback shapeForStateCallback;

  //阴影设置
  //supportDropShadow 是否支持外阴影，默认为支持
  //supportInnerShadow 是否支持内阴影，主要用于新拟态风格，默认为支持
  //当任何一种阴影的support属性设置为true后，整个组件内部会去掉阴影层，从而ji
  final bool supportDropShadow;
  final FShadow dropShadow;
  final bool supportInnerShadow;
  final FShadow innerShadow;

  //背景色设置，color与gradient为互斥关系，设置了gradient就会覆盖color
  //Color 设置单色背景色
  //FColorForStateCallback 根据状态不同，返回不同的Color
  //Gradient 设置渐变背景色
  //FGradientForStateCallback 根据状态不同，返回不同的Gradient
  //maskColor 蒙板颜色，主要用于风格中的一些视觉效果，大多数情况下不应该被修改
  final Color color;
  final FColorForStateCallback colorForCallback;
  final Gradient gradient;
  final FGradientForStateCallback gradientForCallback;
  final Color maskColor;

  //组件的类型，组件支持的类型， Button,Toggle,
  //isSelected仅在controlType == Toggle的时候有效，可以通过设置isSelected来控制默认是否为“按下”状态
  final FType controlType;
  final bool isSelected;

  //是否禁用，默认为false，设置为yes时，会激活所有的stateForCallback回调
  final bool disabled;
  //是否与用户产生交互，默认为true，设置为false后，不会发生任何变化，只是不再响应事件
  final bool userInteractive;

  //子组件
  //FChildForStateCallback 子组件的callback方法，可以根据组件不同的状态来设置不同的子组件
  final Widget child;
  final FChildForStateCallback childForStateCallback;

  final FGroupController controller;

  final FOnTapCallback onTapCallback; //最近被点击后的callback
  final FOnTapDownCallback onTapDownCallback;
  final FOnTapUpCallback onTapUpCallback;
  final FOnTapCancelCallback onTapCancelCallback;

  const FControl({
    Key key,
    this.componentId = "componentId", //默认的componentId
    this.width,
    this.height,
    this.lightOrientation = FLightOrientation.LeftTop, //默认光源为左上角
    this.color = FPrimerColor,
    this.colorForCallback,
    this.gradient,
    this.gradientForCallback,
    this.surface = FSurface.Flat, //默认表面形状为“凸面”
    this.surfaceForCallback,
    this.childForStateCallback,
    this.shape,
    this.shapeForStateCallback,
    this.disabled = false, //默认为不禁用
    this.margin,
    this.padding,
    this.maskColor,
    this.supportDropShadow = true,
    this.dropShadow = const FShadow(),
    this.supportInnerShadow = true,
    this.innerShadow = const FShadow(),
    this.appearance,
    this.controlType = FType.Button, //默认类型为button
    this.isSelected = false, //默认为非选中
    this.userInteractive = true,
    this.controller,
    this.child,
    this.onTapCallback,
    this.onTapDownCallback,
    this.onTapUpCallback,
    this.onTapCancelCallback,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FControlState();
  }
}

class FControlState extends State<FControl> {
  FState controlState;

  Color defaultColor;
  Color currentColor;

  Gradient defaultGradient;
  Gradient currentGradient;


  Widget defaultWidget;
  Widget currentWidget;

  Border defaultBorder;
  Border currentBorder;

  FShape defaultShape;
  FShape currentShape;

  FSurface defaultSurface;
  FSurface currentSurface;

  bool isSelected = false;
  bool disabled = false;

  bool supportDropShadow = true;

  FType controlType = FType.Button;
  FAppearance appearance = FAppearance.Flat;
  FLightOrientation lightOrientation = FLightOrientation.LeftTop;

  Color maskColor;

  void initState() {
    controlState = FState.Normal;
    appearance = widget.appearance ?? FAppearance.Flat;
    supportDropShadow = widget.supportDropShadow ?? true;
    lightOrientation = widget.lightOrientation ?? FLightOrientation.LeftTop;
    controlType = widget.controlType ?? FType.Button;
    maskColor = widget.maskColor ?? Colors.black12;

    defaultColor = widget.color ?? FPrimerColor;
    defaultGradient = widget.gradient;

    if (widget.controller != null) {
      widget.controller.states.add(this);
    }

    isSelected = widget.isSelected ?? false;

    if (controlType == FType.Toggle) {
      controlState = isSelected ? FState.Highlighted : FState.Normal;
    }

    disabled = widget.disabled ?? false;
    if (disabled) {
      controlState = FState.Disable;
      defaultColor = FDisableColor;
      // defaultBackgroundColors = [FDisableColor, FDisableColor];
    }

    if (widget.colorForCallback != null) {
      currentColor = widget.colorForCallback(widget, controlState);
    }
    currentColor = currentColor ?? defaultColor;

    if (widget.gradientForCallback != null) {
      currentGradient = widget.gradientForCallback(widget, controlState);
    }

    // if (widget.backgroundColorsForCallback != null) {
    //   currentBackgroundColors =
    //       widget.backgroundColorsForCallback(widget, controlState);
    // }
    // currentBackgroundColors =
    //     _fixBackgroundColors(currentBackgroundColors, widget.backgroundColors);

    defaultShape = widget.shape ?? FShape();
    currentShape = defaultShape;

    defaultWidget = widget.child;
    if (widget.childForStateCallback != null) {
      currentWidget = widget.childForStateCallback(widget, controlState);
    }
    currentWidget = currentWidget ?? defaultWidget;

    defaultSurface = widget.surface;
    if (widget.surfaceForCallback != null) {
      currentSurface = widget.surfaceForCallback(widget, controlState);
    }

    currentSurface = currentSurface ?? defaultSurface;

    if (controlType == FType.Toggle && isSelected) {
      controlState = FState.Highlighted;
      _controlGestureHandlerForState();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (disabled) {
      controlState = FState.Disable;
      _controlGestureHandlerForState();
      return createCoreControl();
    }
    if (widget.userInteractive == false) {
      return createCoreControl();
    }
    return GestureDetector(
      onTapDown: (details) {
        if (controlType == FType.Button) {
          controlState = FState.Highlighted;
        } else {
          if (widget.controller != null &&
              widget.controller.mustBeSelected &&
              isSelected) {
            return;
          }
          isSelected = !isSelected;
          controlState = FState.Highlighted;
        }
        _controlGestureHandlerForState();
        if (widget.onTapDownCallback != null) {
          widget.onTapDownCallback(widget, isSelected);
        }
      },
      onTapUp: (details) {
        if (widget.onTapUpCallback != null) {
          widget.onTapUpCallback(widget, isSelected);
        }
      },
      onTapCancel: () {
        if (controlType == FType.Button) {
          controlState = FState.Normal;
        } else {
          controlState =
          isSelected ? FState.Highlighted : FState.Normal;
        }
        _controlGestureHandlerForState();
        if (widget.onTapCancelCallback != null) {
          widget.onTapCancelCallback(widget, isSelected);
        }
      },
      onTap: () {
        if (controlType == FType.Button) {
          controlState = FState.Normal;
          _controlGestureHandlerForState();
        } else {
          controlState =
          isSelected ? FState.Highlighted : FState.Normal;
          if (widget.controller != null &&
              widget.controller.states.length > 0) {
            List<Widget> all = List();
            Widget changed;
            for (int i = 0; i < widget.controller.states.length; i++) {
              FControlState state = widget.controller.states[i];
              all.add(state.widget);
              if (state != this) {
                if (state.isSelected == false &&
                    state.controlState == FState.Normal) {
                  continue;
                }
                state.isSelected = false;
                state.controlState = FState.Normal;
                state._controlGestureHandlerForState();
              } else {
                changed = this.widget;
                _controlGestureHandlerForState();
              }
            }
            if (widget.controller.groupClickCallback != null) {
              widget.controller.groupClickCallback(changed, isSelected, all);
            }
          } else {
            _controlGestureHandlerForState();
          }
        }
        if (widget.onTapCallback != null) {
          widget.onTapCallback(widget, isSelected);
        }
      },
      child: createCoreControl(),
    );
  }

  //============> 工具函数

  Widget createCoreControl() {
    return Container(
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
      decoration: ShapeDecoration(
        color: (currentGradient != null) ? null : currentColor,
        gradient: currentGradient ?? defaultGradient,
        shape: _createShapeBorder(controlState, false),
        shadows: _createDropShadowList(
            controlState, widget.dropShadow, supportDropShadow),
      ),
      foregroundDecoration: ShapeDecoration(
        shape: _createShapeBorder(controlState, false),
      ),
      child: _createChildContainer(
          controlState, widget.lightOrientation, widget.innerShadow),
    );
  }

  Widget _createChildContainer(FState state,
      FLightOrientation lightOrientation, FShadow innerShadow) {
    switch (appearance) {
      case FAppearance.Flat: //扁平风格，忽略所有阴影效果
        return Container(
          foregroundDecoration: _createSurfaceShape(),
          // decoration: ShapeDecoration(
          //   shape: _createShapeBorder(state, true),
          //   gradient: _createGradientBackgroundColorForState(state),
          // ),
          padding: widget.padding,
          child: currentWidget,
        );
      case FAppearance.Material: //Google风格，不做内阴影
        return Container(
          // alignment: Alignment.center,
          foregroundDecoration: _createSurfaceShape(),
          // decoration: ShapeDecoration(
          //   shape: _createShapeBorder(state, true),
          //   gradient: _createGradientBackgroundColorForState(state),
          // ),
          padding: widget.padding,
          child: currentWidget,
        );
      default: //FControlAppearance.Neumorphism
        if (innerShadow == null) {
          innerShadow = FShadow();
        }
        if (widget.supportInnerShadow ?? true) {
          return FInnerShadow(
            blur: innerShadow.highlightBlur,
            color: _innerShadowColor(true, state, innerShadow),
            offset: _innerShadowOffset(false, state, innerShadow),
            child: FInnerShadow(
              blur: innerShadow.shadowDistance,
              color: _innerShadowColor(false, state, innerShadow),
              offset: _innerShadowOffset(true, state, innerShadow),
              child: Container(
                padding: widget.padding,
                foregroundDecoration: _createSurfaceShape(),
                decoration: ShapeDecoration(
                  color: (currentGradient != null) ? null : currentColor,
                  gradient: currentGradient ?? defaultGradient,
                  shape: _createShapeBorder(state, true),
                  // gradient:
                  //     _createGradientBackgroundColorForState(controlState),
                ),
                child: currentWidget,
              ),
            ),
          );
        } else {
          return Container(
            padding: widget.padding,
            foregroundDecoration: _createSurfaceShape(),
            decoration: ShapeDecoration(
              color: (currentGradient != null) ? null : currentColor,
              gradient: currentGradient ?? defaultGradient,
              shape: _createShapeBorder(state, true),
              // gradient: _createGradientBackgroundColorForState(state),
            ),
            child: currentWidget,
          );
        }
    }
  }

  //统一处理手势操作
  void _controlGestureHandlerForState() {
    if (widget.colorForCallback != null) {
      currentColor =
          widget.colorForCallback(widget, controlState) ?? defaultColor;
    }

    if (widget.gradientForCallback != null) {
      currentGradient =
          widget.gradientForCallback(widget, controlState) ?? defaultGradient;
    }

    if (widget.childForStateCallback != null) {
      currentWidget =
          widget.childForStateCallback(widget, controlState) ?? defaultWidget;
    }

    if (widget.surfaceForCallback != null) {
      currentSurface =
          widget.surfaceForCallback(widget, controlState) ?? defaultSurface;
    }

    if (widget.shapeForStateCallback != null) {
      currentShape =
          widget.shapeForStateCallback(widget, controlState) ?? defaultShape;
    }

    setState(() {});
  }

  //处理边框
  ShapeBorder _createShapeBorder(FState state, bool justShape) {
    if (widget.shapeForStateCallback != null) {
      currentShape =
          widget.shapeForStateCallback(widget, state) ?? defaultShape;
    } else {
      currentShape = defaultShape;
    }
    // justShape = false;

    switch (currentShape.borderShape) {
      case FBorderShape.BeveledRectangle:
        return BeveledRectangleBorder(
          borderRadius: currentShape.borderRadius,
          side: justShape ? BorderSide.none : currentShape.side,
        );
      case FBorderShape.ContinuousRectangle:
        return ContinuousRectangleBorder(
          borderRadius: currentShape.borderRadius,
          side: justShape ? BorderSide.none : currentShape.side,
        );
      default:
        return RoundedRectangleBorder(
          borderRadius: currentShape.borderRadius,
          side: justShape ? BorderSide.none : currentShape.side,
        );
    }
  }

  List<BoxShadow> _createDropShadowList(
      FState state, FShadow dropShadow, bool canUseShadow) {
    List<BoxShadow> shadows = List();
    switch (appearance) {
      case FAppearance.Flat: //扁平风格，忽略所有阴影效果
        break;
      case FAppearance.Material: //Google风格，只处理背光阴影
        if (canUseShadow == false) {
          return shadows;
        }
        if (dropShadow == null) {
          dropShadow = FShadow();
        }
        shadows.add(BoxShadow(
          color: dropShadow.shadowColor,
          offset: _dropShadowOffset(
              appearance, lightOrientation, state, true, dropShadow),
          blurRadius: dropShadow.shadowDistance,
          spreadRadius: dropShadow.shadowSpread,
        ));
        break;
      default: //FControlAppearance.Neumorphism，新拟态风格，处理向光和背光两个阴影
        if (canUseShadow == false) {
          return shadows;
        }
        if (dropShadow == null) {
          dropShadow = FShadow();
        }
        shadows.add(BoxShadow(
          color: dropShadow.highlightColor,
          offset: _dropShadowOffset(
              appearance, lightOrientation, state, true, dropShadow),
          blurRadius:
          (state == FState.Highlighted) ? 0 : dropShadow.highlightBlur,
          spreadRadius: (state == FState.Highlighted)
              ? 0
              : dropShadow.highlightSpread,
        ));
        shadows.add(BoxShadow(
          color: dropShadow.shadowColor,
          offset: _dropShadowOffset(
              appearance, lightOrientation, state, false, dropShadow),
          blurRadius:
          (state == FState.Highlighted) ? 0 : dropShadow.shadowBlur,
          spreadRadius:
          (state == FState.Highlighted) ? 0 : dropShadow.shadowSpread,
        ));
    }
    return shadows;
  }

  Offset _dropShadowOffset(
      FAppearance appearance, //外观风格
      FLightOrientation lightOrientation, //光源方向，在FControlAppearance.Flat时无效
      FState state, //控件状态
      bool isHighlight, //当前是否处理高光，仅在FControlAppearance.Neumorphism时有效
      FShadow shadow) {
    //光影效果定义，仅在FControlAppearance.Neumorphism且isHighlight=true时处理高光
    Offset offset;
    if (appearance == FAppearance.Flat || state == FState.Highlighted) {
      return Offset.zero;
    }
    switch (lightOrientation) {
      case FLightOrientation.LeftTop:
        if (appearance == FAppearance.Material) {
          offset = Offset(shadow.shadowDistance, shadow.shadowDistance);
        } else {
          //FControlAppearance.Neumorphism
          offset = isHighlight
              ? Offset(-shadow.highlightDistance, -shadow.highlightDistance)
              : Offset(shadow.shadowDistance, shadow.shadowDistance);
        }
        return offset;
      case FLightOrientation.LeftBottom:
        if (appearance == FAppearance.Material) {
          offset = Offset(shadow.shadowDistance, -shadow.shadowDistance);
        } else {
          //FControlAppearance.Neumorphism
          offset = isHighlight
              ? Offset(-shadow.highlightDistance, shadow.highlightDistance)
              : Offset(shadow.shadowDistance, -shadow.shadowDistance);
        }
        return offset;
      case FLightOrientation.RightTop:
        if (appearance == FAppearance.Material) {
          offset = Offset(-shadow.shadowDistance, shadow.shadowDistance);
        } else {
          //FControlAppearance.Neumorphism
          offset = isHighlight
              ? Offset(shadow.highlightDistance, -shadow.highlightDistance)
              : Offset(-shadow.shadowDistance, shadow.shadowDistance);
        }
        return offset;
      case FLightOrientation.RightBottom:
        if (appearance == FAppearance.Material) {
          offset = Offset(-shadow.shadowDistance, -shadow.shadowDistance);
        } else {
          //FControlAppearance.Neumorphism
          offset = isHighlight
              ? Offset(shadow.highlightDistance, shadow.highlightDistance)
              : Offset(-shadow.shadowDistance, -shadow.shadowDistance);
        }
        return offset;
    }
    return null;
  }

  Color _innerShadowColor(
      bool isBacklight, FState state, FShadow innerShadow) {
    if (state == FState.Normal || state == FState.Disable) {
      return Color.fromARGB(0, 0, 0, 0);
    } else {
      return isBacklight ? innerShadow.highlightColor : innerShadow.shadowColor;
    }
  }

  Offset _innerShadowOffset(
      bool isBacklight, FState state, FShadow innerShadow) {
    double forwardlightDistance = innerShadow.highlightDistance.abs();
    double backlightDistance = innerShadow.shadowDistance.abs();
    switch (lightOrientation) {
      case FLightOrientation.LeftTop:
        {
          Offset offset = isBacklight
              ? Offset(backlightDistance, backlightDistance)
              : Offset(-forwardlightDistance, -forwardlightDistance);
          if (state == FState.Normal || state == FState.Disable) {
            offset = Offset.zero;
          }
          return offset;
        }
      case FLightOrientation.LeftBottom:
        {
          Offset offset = isBacklight
              ? Offset(backlightDistance, -backlightDistance)
              : Offset(-forwardlightDistance, forwardlightDistance);
          if (controlState == FState.Normal ||
              controlState == FState.Disable) {
            offset = Offset.zero;
          }
          return offset;
        }
      case FLightOrientation.RightTop:
        {
          Offset offset = isBacklight
              ? Offset(-backlightDistance, backlightDistance)
              : Offset(forwardlightDistance, -forwardlightDistance);
          if (controlState == FState.Normal ||
              controlState == FState.Disable) {
            offset = Offset.zero;
          }
          return offset;
        }
      case FLightOrientation.RightBottom:
        {
          Offset offset = isBacklight
              ? Offset(-backlightDistance, -backlightDistance)
              : Offset(forwardlightDistance, forwardlightDistance);
          if (controlState == FState.Normal ||
              controlState == FState.Disable) {
            offset = Offset.zero;
          }
          return offset;
        }
    }
    return isBacklight
        ? Offset(backlightDistance, backlightDistance)
        : Offset(-forwardlightDistance, -forwardlightDistance);
  }

  ShapeDecoration _createSurfaceShape() {
    Color surfaceShadowColor = Colors.black26;
    switch (currentSurface) {
      case FSurface.Flat:
        return ShapeDecoration(
            shape: _createShapeBorder(controlState, true),
            color: (controlState == FState.Highlighted)
                ? maskColor
                : Colors.transparent);
      case FSurface.Convex:
        switch (lightOrientation) {
          case FLightOrientation.LeftTop:
            return ShapeDecoration(
              shape: _createShapeBorder(controlState, true),
              gradient: LinearGradient(
                  colors: [Colors.transparent, surfaceShadowColor],
                  stops: [0.4, 1.0],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            );
          case FLightOrientation.LeftBottom:
            return ShapeDecoration(
              shape: _createShapeBorder(controlState, true),
              gradient: LinearGradient(
                  colors: [Colors.transparent, surfaceShadowColor],
                  stops: [0.4, 1.0],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight),
            );
          case FLightOrientation.RightTop:
            return ShapeDecoration(
              shape: _createShapeBorder(controlState, true),
              gradient: LinearGradient(
                  colors: [Colors.transparent, surfaceShadowColor],
                  stops: [0.4, 1.0],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft),
            );
          case FLightOrientation.RightBottom:
            return ShapeDecoration(
              shape: _createShapeBorder(controlState, true),
              gradient: LinearGradient(
                  colors: [Colors.transparent, surfaceShadowColor],
                  stops: [0.4, 1.0],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight),
            );
        }
        return ShapeDecoration(
          shape: _createShapeBorder(controlState, true),
          gradient: LinearGradient(
              colors: [Colors.transparent, surfaceShadowColor],
              stops: [0.4, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        );
      case FSurface.Concave:
        switch (lightOrientation) {
          case FLightOrientation.LeftTop:
            return ShapeDecoration(
              shape: _createShapeBorder(controlState, true),
              gradient: LinearGradient(
                  colors: [surfaceShadowColor, Colors.transparent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            );
          case FLightOrientation.LeftBottom:
            return ShapeDecoration(
              shape: _createShapeBorder(controlState, true),
              gradient: LinearGradient(
                  colors: [surfaceShadowColor, Colors.transparent],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight),
            );
          case FLightOrientation.RightTop:
            return ShapeDecoration(
              shape: _createShapeBorder(controlState, true),
              gradient: LinearGradient(
                  colors: [surfaceShadowColor, Colors.transparent],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft),
            );
          case FLightOrientation.RightBottom:
            return ShapeDecoration(
              shape: _createShapeBorder(controlState, true),
              gradient: LinearGradient(
                  colors: [surfaceShadowColor, Colors.transparent],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight),
            );
        }
        return ShapeDecoration(
          shape: _createShapeBorder(controlState, true),
          gradient: LinearGradient(
              colors: [surfaceShadowColor, Colors.transparent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        );
    }
  }

  //============> 重载部分生存周期函数，用于不同状态的变化响应
  void didUpdateWidget(FControl oldWidget) {
    appearance = widget.appearance ?? FAppearance.Flat;
    defaultWidget = widget.child;
    defaultColor = widget.color ?? FPrimerColor;
    defaultGradient = widget.gradient;
    if (controlState == FState.Normal) {
      currentWidget = defaultWidget;
      currentColor = defaultColor;
      currentGradient = defaultGradient;
    }

    currentWidget = currentWidget ?? defaultWidget;
    currentGradient = currentGradient ?? defaultGradient;
    currentColor = currentColor ?? defaultColor;
    // defaultBackgroundColors = widget.backgroundColors ?? [FPrimerColor];
    disabled = widget.disabled ?? false;
    if (disabled) {
      controlState = FState.Disable;
      defaultColor = FDisableColor;
      // defaultBackgroundColors = [FDisableColor, FDisableColor];
    }
    defaultShape = widget.shape ?? FShape();
    supportDropShadow = widget.supportDropShadow ?? true;
    maskColor = widget.maskColor ?? Colors.black12;
    isSelected = widget.isSelected ?? false;
    lightOrientation = widget.lightOrientation ?? FLightOrientation.LeftTop;
    controlType = widget.controlType ?? FType.Button;
    currentSurface = widget.surface ?? FSurface.Flat;

    if (controlType == FType.Toggle) {
      controlState = isSelected ? FState.Highlighted : FState.Normal;
      _controlGestureHandlerForState();
    }

    if (disabled) {
      controlState = FState.Disable;
    }

    if (widget.surfaceForCallback != null) {
      currentSurface = widget.surfaceForCallback(widget, controlState);
      currentSurface = currentSurface ?? (widget.surface ?? FSurface.Flat);
    }
    super.didUpdateWidget(oldWidget);
  }

  void dispose() {
    if (widget.controller != null) {
      widget.controller.states.remove(this);
    }
    super.dispose();
  }
}
