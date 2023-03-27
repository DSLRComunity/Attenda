import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';

class ScrollableWidget extends StatefulWidget {
  final Widget child;

  const ScrollableWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<ScrollableWidget> createState() => _ScrollableWidgetState();
}

class _ScrollableWidgetState extends State<ScrollableWidget> {
  final _verticalScrollController=ScrollController();
  final _horizontalScrollController=ScrollController();

  @override
  Widget build(BuildContext context) => ImprovedScrolling(
    scrollController: _verticalScrollController,
    enableKeyboardScrolling: true,
    enableCustomMouseWheelScrolling: true,
    keyboardScrollConfig: KeyboardScrollConfig(
      arrowsScrollAmount: 100,
      homeScrollDurationBuilder: (currentScrollOffset, minScrollOffset) {
        return const Duration(milliseconds: 100);
      },
      endScrollDurationBuilder: (currentScrollOffset, maxScrollOffset) {
        return const Duration(milliseconds: 2000);
      },
    ),
    child: ImprovedScrolling(
      scrollController: _horizontalScrollController,
      enableKeyboardScrolling: true,
      enableCustomMouseWheelScrolling: true,
      keyboardScrollConfig: KeyboardScrollConfig(
        arrowsScrollAmount: 100,
        homeScrollDurationBuilder: (currentScrollOffset, minScrollOffset) {
          return const Duration(milliseconds: 100);
        },
        endScrollDurationBuilder: (currentScrollOffset, maxScrollOffset) {
          return const Duration(milliseconds: 2000);
        },
      ),
      child: AdaptiveScrollbar(
        controller: _verticalScrollController,
        position: ScrollbarPosition.left,
        child: AdaptiveScrollbar(
          controller: _horizontalScrollController,
          position: ScrollbarPosition.bottom,
          child: SingleChildScrollView(
            controller: _horizontalScrollController,
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              controller: _verticalScrollController,
              scrollDirection: Axis.vertical,
              child: widget.child,
            ),
          ),
        ),
      ),
    ),
  );
}