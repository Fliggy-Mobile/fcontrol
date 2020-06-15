import 'package:flutter/material.dart';
import 'finnershadow.dart';
import 'fcontroldefine.dart';


class FControl extends StatefulWidget{
  
  final String controlName;                                               //组件名称
  final double width;                                                     //组件宽
  final double height;                                                    //组件高

  final FLightOrientation lightOrientation;                                //光源方向
  
  final List<Color> backgroundColors;                                     //背景颜色
  final FControlBackgroundColorForStateCallback backgroundColorsCallback; //背景颜色callback

  final FSurfaceShape surfaceShape;                                        //表面形状
  final FControlSurfaceForStateCallback surfaceShapeCallback;             //表面形状callback

  final Widget child;                                                     //子组件
  final FControlChildForStateCallback childForStateCallback;              //子组件callback

  final FShapeEffects shapeEffects;                                       //光影效果
  final FControlShapeForStateCallback shapeForStateCallback;              //光影效果callback

  final FControlClickEventCallback clickEventCallback;


  final FControlState controlState;
  final bool disabled;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  final Color maskColor;

  final bool supportDropShadow;
  final FShadowEffects dropShadow;
  
  final bool supportInnerShadow;
  final FShadowEffects innerShadow;

  final FControlAppearance appearance;
  final FControlType controlType;
  final bool isSelected;

  final FGroupController controller;

  const FControl({
    Key key, 
    this.lightOrientation = FLightOrientation.LeftTop, 
    this.width, 
    this.height, 
    this.margin = EdgeInsets.zero, 
    this.padding = EdgeInsets.zero, 

    this.backgroundColors = const [Colors.red,Colors.purple], 
    this.backgroundColorsCallback, 

    this.surfaceShape = FSurfaceShape.Flat, 
    this.surfaceShapeCallback,

    this.child, 
    this.childForStateCallback, 

    this.maskColor = Colors.black12,
    this.controlState = FControlState.Normal, 

    this.appearance = FControlAppearance.Neumorphism, 
    this.dropShadow, 
    this.innerShadow, 
    this.controlType = FControlType.Toggle, 
    this.isSelected = false, 
    this.controller, 
    this.supportDropShadow = true,
    this.supportInnerShadow = true, 
    this.controlName, 
    this.clickEventCallback, 
    this.shapeEffects,
    this.shapeForStateCallback,
    this.disabled = false,
  }) : super(key: key); 

  @override
  State<StatefulWidget> createState() {
    return _FControlState();
  }
}

class _FControlState extends State<FControl>{

  FControlState controlState;
  List<Color> defaultBackgroundColors;
  List<Color> currentBackgroundColors;

  Widget defaultWidget;
  Widget currentWidget;

  Border defaultBorder;
  Border currentBorder;

  FShapeEffects defaultShape;
  FShapeEffects currentShape;

  FSurfaceShape defaultSurface;
  FSurfaceShape currentSurface;


  bool isSelected;

  String controlName;

  List<Color> fixBackgroundColors(List<Color> colors,List<Color> defaultColors){
    List<Color> backgroundColors = colors;
    if(defaultColors == null || defaultColors.length < 1){
      defaultColors = [Colors.red,Colors.red];
    }else if(defaultColors.length == 1){
      Color c = defaultColors[0];
      Color copyc = Color.fromARGB(c.alpha, c.red, c.green, c.blue);
      defaultColors = List();
      defaultColors.add(c);
      defaultColors.add(copyc);
    }
    if(backgroundColors == null || backgroundColors.length < 1){
      backgroundColors = defaultColors;
    }else if(backgroundColors.length == 1){
      Color c = backgroundColors[0];
      Color copyc = Color.fromARGB(c.alpha, c.red, c.green, c.blue);
      backgroundColors = List();
      backgroundColors.add(c);
      backgroundColors.add(copyc);
    }
    return backgroundColors;
  }

  void dispose(){
    print("dispose ...");
    if(widget.controller != null){
      widget.controller.states.remove(this);
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    print("didChangeDependencies ...");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(FControl oldWidget) {
    print("didUpdateWidget ...");
    currentSurface = widget.surfaceShape;
    if(widget.surfaceShapeCallback != null){
      currentSurface = widget.surfaceShapeCallback(widget,controlState);
      if(currentShape == null){
        currentSurface = widget.surfaceShape;
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    print("deactivate ...");
    super.deactivate();
  }

  void initState(){
    print("initState ...");
    if(widget.controller != null){
      widget.controller.states.add(this);
    }
    controlState = widget.controlState;
    isSelected = widget.isSelected;

    if(widget.disabled){
      controlState = FControlState.Disable;
    }

    defaultBackgroundColors = fixBackgroundColors(widget.backgroundColors,widget.backgroundColors);
    if(widget.backgroundColorsCallback != null){
      currentBackgroundColors = widget.backgroundColorsCallback(widget,controlState);
    }
    currentBackgroundColors = fixBackgroundColors(currentBackgroundColors,widget.backgroundColors);

    defaultShape = widget.shapeEffects;
    if(defaultShape == null){
      defaultShape = FShapeEffects();
    }
    currentShape = defaultShape;

    defaultWidget = widget.child;
    if(widget.childForStateCallback != null){
      currentWidget = widget.childForStateCallback(widget,controlState);
    }
    if(currentWidget == null){
      currentWidget = defaultWidget;
    }

    defaultSurface = widget.surfaceShape;
    if(widget.surfaceShapeCallback != null){
      currentSurface = widget.surfaceShapeCallback(widget,controlState);
    }
    if(currentSurface == null){
      currentSurface = defaultSurface;
    }
   
    if(widget.controlType == FControlType.Toggle && isSelected){
      controlState = FControlState.Highlight;
      controlGestureHandlerForState(controlState);
    }

    super.initState();
  }

  void controlGestureHandlerForState(FControlState state){

    if(widget.disabled){
      state = FControlState.Disable;
    }

    if(widget.backgroundColorsCallback != null){
      currentBackgroundColors = widget.backgroundColorsCallback(widget,state);
    }
    currentBackgroundColors = fixBackgroundColors(currentBackgroundColors, defaultBackgroundColors);

    if(widget.childForStateCallback != null){
      currentWidget = widget.childForStateCallback(widget,state);
    }
    if(currentWidget == null){
        currentWidget = defaultWidget;
    }

    if(widget.surfaceShapeCallback != null){
      currentSurface = widget.surfaceShapeCallback(widget,state);
      if(currentSurface == null){
        currentSurface = widget.surfaceShape;
      }
    }
    
    setState(() {
      
    });
  }

  ShapeBorder createShapeBorder(FControlState state,bool justShape){
    if(widget.shapeForStateCallback != null){
      currentShape = widget.shapeForStateCallback(widget,state);
    }
    if(currentShape == null){
      currentShape = defaultShape;
    }
    switch (currentShape.shape) {
      case FBorderShape.BeveledRectangle:
        return BeveledRectangleBorder(
          borderRadius: currentShape.borderRadius,
          side: justShape?BorderSide(color: Colors.transparent, width: 0):currentShape.side,
        );
      case FBorderShape.ContinuousRectangle:
        return ContinuousRectangleBorder(
          borderRadius: currentShape.borderRadius,
          side: justShape?BorderSide(color: Colors.transparent,width: 0):currentShape.side,
        );
      default:
        return RoundedRectangleBorder(
          borderRadius: currentShape.borderRadius,
          side: justShape?BorderSide(color: Colors.transparent,width: 0):currentShape.side,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
      decoration: ShapeDecoration(
        gradient: createGradientBackgroundColorForState(controlState),
        shape: createShapeBorder(controlState,true),
        shadows: createDropShadowList(widget.appearance, controlState, widget.lightOrientation, widget.dropShadow,widget.supportDropShadow),
      ),
      foregroundDecoration: ShapeDecoration(
        shape: createShapeBorder(controlState,false),
      ),
      child: 
        InkWell(
          child: createChildContainer(widget.appearance,controlState,widget.lightOrientation,widget.innerShadow),
          onTap: () {
            if(widget.controlType == FControlType.Button){
              controlState = FControlState.Normal;
              controlGestureHandlerForState(controlState);
            }else{
              controlState = isSelected?FControlState.Highlight:FControlState.Normal;
              if(widget.controller != null && widget.controller.states.length > 0){
                List<Widget> all = List();
                Widget changed;
                for(int i=0;i<widget.controller.states.length;i++){
                  _FControlState state = widget.controller.states[i];
                  all.add(state.widget);
                  if(state != this){
                    
                    if(state.isSelected == false && state.controlState == FControlState.Normal){
                      continue;
                    }
                    // String temp = state.controlName;
                    // print("other ($temp) start update state");
                    state.isSelected = false;
                    state.controlState = FControlState.Normal;
                    state.controlGestureHandlerForState(state.controlState);
                    // print("other ($temp) end update state");
                  }else{
                    changed = this.widget;
                    controlGestureHandlerForState(controlState);
                  }
                }
                if(widget.controller.groupClickCallback != null){
                  widget.controller.groupClickCallback(changed,isSelected,all);
                }
              }else{
                controlGestureHandlerForState(controlState);
              }
            }
            if(widget.clickEventCallback != null){
              widget.clickEventCallback(widget,isSelected);
            }
            
          },
          onTapDown: (details) {
            if(widget.controlType == FControlType.Button){
              controlState = FControlState.Highlight;
            }else{
              if(widget.controller != null && widget.controller.mustBeSelected && isSelected){
                return;
              }
              isSelected = !isSelected;
              controlState = FControlState.Highlight;
            }
            controlGestureHandlerForState(controlState);
          },
          onTapCancel: () {
            if(widget.controlType == FControlType.Button){
              controlState = FControlState.Normal;
            }else{
              controlState = isSelected?FControlState.Highlight:FControlState.Normal;
            }
            controlGestureHandlerForState(controlState);
          },
        ),
      );
  }

  List<BoxShadow> createDropShadowList(FControlAppearance appearance,
                                       FControlState state,
                                       FLightOrientation lightOrientation,
                                       FShadowEffects dropShadowEffect,
                                       bool canUseShadow){
    List<BoxShadow> shadows = List();
    switch (appearance) {
      case FControlAppearance.Flat://扁平风格，忽略所有阴影效果
        break;
      case FControlAppearance.Material://Google风格，只处理背光阴影
        if(dropShadowEffect == null){
          dropShadowEffect = FShadowEffects();
        }
        shadows.add(BoxShadow(
          color: dropShadowEffect.shadowColor,
          offset: dropShadowOffset(appearance,lightOrientation,state,true,dropShadowEffect),
          blurRadius: dropShadowEffect.shadowDistance,
          spreadRadius: dropShadowEffect.shadowSpread,
        ));
        break;
      default: //FControlAppearance.Neumorphism，新拟态风格，处理向光和背光两个阴影
        if(canUseShadow == false){
          return shadows;
        }
        if(dropShadowEffect == null){
          dropShadowEffect = FShadowEffects();
        }
        shadows.add(BoxShadow(
          color: dropShadowEffect.highlightColor,
          offset: dropShadowOffset(appearance,lightOrientation,state,true,dropShadowEffect),
          blurRadius: (state == FControlState.Highlight)?0:dropShadowEffect.highlightBlur,
          spreadRadius: (state == FControlState.Highlight)?0:dropShadowEffect.highlightSpread,
        ));
        shadows.add(BoxShadow(
          color: dropShadowEffect.shadowColor,
          offset: dropShadowOffset(appearance,lightOrientation,state,false,dropShadowEffect),
          blurRadius: (state == FControlState.Highlight)?0: dropShadowEffect.shadowBlur,
          spreadRadius: (state == FControlState.Highlight)?0: dropShadowEffect.shadowSpread,
        ));
    }
    return shadows;
  }

  Widget createChildContainer(FControlAppearance appearance,
                              FControlState state,
                              FLightOrientation lightOrientation,
                              FShadowEffects innerShadow){
    
    switch (appearance) {
      case FControlAppearance.Flat://扁平风格，忽略所有阴影效果
        Color highlightMaskColor = (state == FControlState.Highlight)?widget.maskColor:Colors.transparent;
        return Stack(
            children:[
              Container(
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  shape: createShapeBorder(state,true),
                  gradient: createGradientBackgroundColorForState(state),
                ),
                padding: widget.padding,
                child: currentWidget,
              ),
              createSurfaceShapeShadow(widget.lightOrientation),
              Container(
                decoration: ShapeDecoration(
                  shape: createShapeBorder(state,true),
                  color: highlightMaskColor,
                  ),),
            ],
        );
      case FControlAppearance.Material://Google风格，不做内阴影
        return Stack(
            children:[
              Container(
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  shape: createShapeBorder(state,true),
                  gradient: createGradientBackgroundColorForState(state),
                ),
                padding: widget.padding,
                child: currentWidget,
              ),
              createSurfaceShapeShadow(widget.lightOrientation),
            ],
        );
      default: //FControlAppearance.Neumorphism
        if(innerShadow == null){
          innerShadow = FShadowEffects();
        }
        if(widget.supportInnerShadow){
          return InnerShadow(
              blur: innerShadow.highlightBlur,
              color: innerShadowColor(true,state,innerShadow),
              offset: innerShadowOffset(widget.lightOrientation,false,state,innerShadow),
              child: InnerShadow(
                blur:innerShadow.shadowDistance,
                color: innerShadowColor(false,state,innerShadow),
                offset: innerShadowOffset(widget.lightOrientation,true,state,innerShadow),
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        shape: createShapeBorder(state,true),
                        gradient: createGradientBackgroundColorForState(controlState),
                      ),
                      child: currentWidget,
                    ),
                    createSurfaceShapeShadow(widget.lightOrientation),
                  ],
                )
              ),
          );
        }else{
          return Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                  shape: createShapeBorder(state,true),
                  gradient: createGradientBackgroundColorForState(state),
                ),
                  child: currentWidget,
                ),
                createSurfaceShapeShadow(widget.lightOrientation),
              ],
          );
        }
        
    }
  }

  

  LinearGradient createGradientBackgroundColorForState(FControlState state){
    return LinearGradient(colors: currentBackgroundColors);
  }

  Offset dropShadowOffset(FControlAppearance appearance,      //外观风格
                          FLightOrientation lightOrientation,  //光源方向，在FControlAppearance.Flat时无效
                          FControlState state,                //控件状态
                          bool isHighlight,                   //当前是否处理高光，仅在FControlAppearance.Neumorphism时有效
                          FShadowEffects shadowEffect){       //光影效果定义，仅在FControlAppearance.Neumorphism且isHighlight=true时处理高光
    Offset offset;
    if(appearance == FControlAppearance.Flat ||
       state == FControlState.Highlight){
      return Offset.zero;
    }
    switch(lightOrientation){
      case FLightOrientation.LeftTop:
        if(appearance == FControlAppearance.Material){
          offset = Offset(shadowEffect.shadowDistance,shadowEffect.shadowDistance);
        }else{ //FControlAppearance.Neumorphism
          offset = isHighlight?Offset(-shadowEffect.highlightDistance,-shadowEffect.highlightDistance)
                              :Offset(shadowEffect.shadowDistance,shadowEffect.shadowDistance);
        }
        return offset;
      case FLightOrientation.LeftBottom:
        if(appearance == FControlAppearance.Material){
          offset = Offset(shadowEffect.shadowDistance, -shadowEffect.shadowDistance);
        }else{ //FControlAppearance.Neumorphism
          offset = isHighlight?Offset(-shadowEffect.highlightDistance,shadowEffect.highlightDistance)
                              :Offset(shadowEffect.shadowDistance,-shadowEffect.shadowDistance);
        }
        return offset;
      case FLightOrientation.RightTop:
        if(appearance == FControlAppearance.Material){
          offset = Offset(-shadowEffect.shadowDistance, shadowEffect.shadowDistance);
        }else{ //FControlAppearance.Neumorphism
          offset = isHighlight?Offset(shadowEffect.highlightDistance,-shadowEffect.highlightDistance)
                              :Offset(-shadowEffect.shadowDistance,shadowEffect.shadowDistance);
        }
        return offset;
      case FLightOrientation.RightBottom:
        if(appearance == FControlAppearance.Material){
          offset = Offset(-shadowEffect.shadowDistance, -shadowEffect.shadowDistance);
        }else{ //FControlAppearance.Neumorphism
          offset = isHighlight?Offset(shadowEffect.highlightDistance,shadowEffect.highlightDistance)
                              :Offset(-shadowEffect.shadowDistance,-shadowEffect.shadowDistance);
        }
        return offset;
    }
    return null;
  }

  Color innerShadowColor(bool isBacklight,
                         FControlState state,
                         FShadowEffects innerShadow){
    if(state == FControlState.Normal || state == FControlState.Disable){
      return Color.fromARGB(0, 0, 0, 0);
    }else{
      return isBacklight?innerShadow.highlightColor:innerShadow.shadowColor;
    }
  }

  Offset innerShadowOffset(FLightOrientation lightOrientation,
                           bool isBacklight,
                           FControlState state,
                           FShadowEffects innerShadow){
    double forwardlightDistance = innerShadow.highlightDistance.abs();
    double backlightDistance = innerShadow.shadowDistance.abs();
    switch(lightOrientation){
      case FLightOrientation.LeftTop:
      {
        Offset offset = isBacklight?Offset(backlightDistance, backlightDistance):Offset(-forwardlightDistance, -forwardlightDistance);
        if(state == FControlState.Normal || state == FControlState.Disable){
          offset = Offset.zero;
        }
        return offset;
      } 
      case FLightOrientation.LeftBottom:
      {
        Offset offset = isBacklight?Offset(backlightDistance, -backlightDistance):Offset(-forwardlightDistance, forwardlightDistance);
        if(controlState == FControlState.Normal || controlState == FControlState.Disable){
          offset = Offset.zero;
        }
        return offset;
      }
      case FLightOrientation.RightTop:
      {
        Offset offset = isBacklight?Offset(-backlightDistance, backlightDistance):Offset(forwardlightDistance,-forwardlightDistance);
        if(controlState == FControlState.Normal || controlState == FControlState.Disable){
          offset = Offset.zero;
        }
        return offset;
      }
      case FLightOrientation.RightBottom:
      {
        Offset offset = isBacklight?Offset(-backlightDistance,-backlightDistance):Offset(forwardlightDistance,forwardlightDistance);
        if(controlState == FControlState.Normal || controlState == FControlState.Disable){
          offset = Offset.zero;
        }
        return offset;
      }
    }
    return isBacklight?Offset(backlightDistance, backlightDistance):Offset(-forwardlightDistance, -forwardlightDistance);
  }

  Widget createSurfaceShapeShadow(FLightOrientation lightOrientation){
    
    Color surfaceShadowColor = Colors.black26;
    switch(currentSurface){
      case FSurfaceShape.Flat:
        return Container(
              decoration: ShapeDecoration(
                        shape: createShapeBorder(controlState,true),
                      ),
            );
      case FSurfaceShape.Convex:{
        switch(lightOrientation){
          case FLightOrientation.LeftTop:
            return Container(
              decoration: ShapeDecoration(
                        shape: createShapeBorder(controlState,true),
                        gradient: LinearGradient(
                  colors:[Colors.transparent,surfaceShadowColor],
                  stops: [0.4,1.0],
                  begin:Alignment.topLeft,
                  end:Alignment.bottomRight),
              ),
            );
          case FLightOrientation.LeftBottom:
            return Container(
              decoration: ShapeDecoration(
                        shape: createShapeBorder(controlState,true),
                        gradient: LinearGradient(
                  colors:[Colors.transparent,surfaceShadowColor],
                  stops: [0.4,1.0],
                  begin:Alignment.bottomLeft,
                  end:Alignment.topRight),
              ),
            );
          case FLightOrientation.RightTop:
            return Container(
              decoration: ShapeDecoration(
                        shape: createShapeBorder(controlState,true),
                        gradient: LinearGradient(
                  colors:[Colors.transparent,surfaceShadowColor],
                  stops: [0.4,1.0],
                  begin:Alignment.topRight,
                  end:Alignment.bottomLeft),
              ),
            );
          case FLightOrientation.RightBottom:
            return Container(
              decoration: ShapeDecoration(
                        shape: createShapeBorder(controlState,true),
                        gradient: LinearGradient(
                  colors:[Colors.transparent,surfaceShadowColor],
                  stops: [0.4,1.0],
                  begin:Alignment.bottomRight,
                  end:Alignment.topLeft),
              ),
            );
        }
        return Container(
          decoration: ShapeDecoration(
                        shape: createShapeBorder(controlState,true),
                        gradient: LinearGradient(
                  colors:[Colors.transparent,surfaceShadowColor],
                  stops: [0.4,1.0],
                  begin:Alignment.topLeft,
                  end:Alignment.bottomRight),
              ),
            );
      }
      case FSurfaceShape.Concave:{
        switch(lightOrientation){
          case FLightOrientation.LeftTop:
            return Container(
              decoration: ShapeDecoration(
                        shape: createShapeBorder(controlState,true),
                        gradient: LinearGradient(
                  colors:[surfaceShadowColor,Colors.transparent],
                  begin:Alignment.topLeft,
                  end:Alignment.bottomRight),
              ),
            );
          case FLightOrientation.LeftBottom:
            return Container(
              decoration: ShapeDecoration(
                        shape: createShapeBorder(controlState,true),
                        gradient: LinearGradient(
                  colors:[surfaceShadowColor,Colors.transparent],
                  begin:Alignment.bottomLeft,
                  end:Alignment.topRight),
              ),
            );
          case FLightOrientation.RightTop:
            return Container(
               decoration: ShapeDecoration(
                        shape: createShapeBorder(controlState,true),
                        gradient: LinearGradient(
                  colors:[surfaceShadowColor,Colors.transparent],
                  begin:Alignment.topRight,
                  end:Alignment.bottomLeft),
              ),
            );
          case FLightOrientation.RightBottom:
            return Container(
              decoration: ShapeDecoration(
                        shape: createShapeBorder(controlState,true),
                        gradient: LinearGradient(
                  colors:[surfaceShadowColor,Colors.transparent],
                  begin:Alignment.bottomRight,
                  end:Alignment.topLeft),
              ),
            );
        }
      } 
    }
    return Container(
      decoration: ShapeDecoration(
                        shape: createShapeBorder(controlState,true),
                        gradient: LinearGradient(
                  colors:[Colors.transparent,surfaceShadowColor],
                  begin:Alignment.topLeft,
                  end:Alignment.bottomRight),
              ),
            );
  }
  
}

