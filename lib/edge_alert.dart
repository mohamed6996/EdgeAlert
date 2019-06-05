library edge_alert;

import 'package:flutter/material.dart';
import 'package:instacheeta/widgets/rtl_text.dart';

class EdgeAlert {
  static final int LENGTH_SHORT = 1; //1 seconds
  static final int LENGTH_LONG = 2; // 2 seconds
  static final int LENGTH_VERY_LONG = 3; // 3 seconds

  static final int TOP = 1;
  static final int BOTTOM = 2;

  static final int LEFT = 1;
  static final int RIGHT = 2;

  static void show(BuildContext context,
      {String title,
      String description,
      int duration,
      int gravity,
      int slideGravity,
      Color backgroundColor,
      IconData icon}) {
    OverlayView.createView(context,
        title: title,
        description: description,
        duration: duration,
        gravity: gravity,
        slideGravity: slideGravity,
        backgroundColor: backgroundColor,
        icon: icon);
  }
}

class OverlayView {
  static final OverlayView _singleton = new OverlayView._internal();

  factory OverlayView() {
    return _singleton;
  }

  OverlayView._internal();

  static OverlayState _overlayState;
  static OverlayEntry _overlayEntry;
  static bool _isVisible = false;

  static void createView(BuildContext context,
      {String title,
      String description,
      int duration,
      int gravity,
      Color backgroundColor,
      IconData icon,
      int slideGravity}) {
    _overlayState = Navigator.of(context).overlay;

    if (!_isVisible) {
      _isVisible = true;

      _overlayEntry = OverlayEntry(builder: (context) {
        return EdgeOverlay(
          title: title,
          description: description,
          overlayDuration: duration == null ? EdgeAlert.LENGTH_SHORT : duration,
          gravity: gravity == null ? EdgeAlert.TOP : gravity,
          slideGravity: slideGravity == null ? EdgeAlert.LEFT : slideGravity,
          backgroundColor:
              backgroundColor == null ? Colors.grey : backgroundColor,
          icon: icon == null ? Icons.notifications : icon,
        );
      });

      _overlayState.insert(_overlayEntry);
    }
  }

  static dismiss() async {
    if (!_isVisible) {
      return;
    }
    _isVisible = false;
    _overlayEntry?.remove();
  }
}

class EdgeOverlay extends StatefulWidget {
  final String title;
  final String description;
  final int overlayDuration;
  final int gravity;
  final Color backgroundColor;
  final IconData icon;
  final int slideGravity;

  EdgeOverlay(
      {this.title,
      this.description,
      this.overlayDuration,
      this.gravity,
      this.backgroundColor,
      this.icon,
      this.slideGravity});

  @override
  _EdgeOverlayState createState() => _EdgeOverlayState();
}

class _EdgeOverlayState extends State<EdgeOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Tween<Offset> _positionTween;
  Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 750));

    if (widget.gravity == 1) {
      _positionTween =
          Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset.zero);
    } else {
      _positionTween =
          Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0));
    }

    _positionAnimation = _positionTween.animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));

    _controller.forward();

    listenToAnimation();
  }

  listenToAnimation() async {
    _controller.addStatusListener((listener) async {
      if (listener == AnimationStatus.completed) {
        await Future.delayed(Duration(seconds: widget.overlayDuration));
        _controller.reverse();
        await Future.delayed(Duration(milliseconds: 700));
        OverlayView.dismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double bottomHeight = MediaQuery.of(context).padding.bottom;

    return Positioned(
      top: widget.gravity == 1 ? 0 : null,
      bottom: widget.gravity == 2 ? 0 : null,
      child: SlideTransition(
        position: _positionAnimation,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(
              20,
              widget.gravity == 1 ? statusBarHeight + 20 : bottomHeight + 20,
              20,
              widget.gravity == 1 ? 20 : 35),
          color: widget.backgroundColor,
          child: OverlayWidget(
              title: widget.title,
              description: widget.description,
              iconData: widget.icon,
              slideGravity: widget.slideGravity),
        ),
      ),
    );
  }
}

class OverlayWidget extends StatelessWidget {
  final String title;
  final String description;
  final IconData iconData;
  final int slideGravity;

  OverlayWidget(
      {this.title = '',
      this.description = '',
      this.iconData,
      this.slideGravity});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Row(
        children: <Widget>[
          if (slideGravity == EdgeAlert.LEFT) AnimatedIcon(iconData: iconData),
          Padding(padding: EdgeInsets.only(right: 15)),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              title == null
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Align(
                          alignment: slideGravity == EdgeAlert.LEFT
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Text(
                            title
                          ),
                        ),
                      ),
                    ),
              Align(
                alignment: slideGravity == EdgeAlert.LEFT
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: description == null
                    ? Container()
                    : Text(description),
              )
            ],
          )),
          Padding(padding: EdgeInsets.only(right: 15)),
          if (slideGravity == EdgeAlert.RIGHT) AnimatedIcon(iconData: iconData),
        ],
      ),
    );
  }
}

class AnimatedIcon extends StatefulWidget {
  final IconData iconData;

  AnimatedIcon({this.iconData});

  @override
  _AnimatedIconState createState() => _AnimatedIconState();
}

class _AnimatedIconState extends State<AnimatedIcon>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        lowerBound: 0.8,
        upperBound: 1.1,
        duration: Duration(milliseconds: 600));

    _controller.forward();
    listenToAnimation();
  }

  listenToAnimation() async {
    _controller.addStatusListener((listener) async {
      if (listener == AnimationStatus.completed) {
        _controller.reverse();
      }
      if (listener == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedBuilder(
        animation: _controller,
        child: Icon(
          widget.iconData,
          size: 35,
          color: Colors.white,
        ),
        builder: (context, widget) =>
            Transform.scale(scale: _controller.value, child: widget),
      ),
    );
  }
}
