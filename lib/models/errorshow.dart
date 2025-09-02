import 'package:flutter/material.dart';

class HighlightRange {
  final int start;
  final int end;
  final String predictedText;
  final String correctText;

  HighlightRange({
    required this.start,
    required this.end,
    required this.predictedText,
    required this.correctText,
  });
  factory HighlightRange.fromJson(Map<String, dynamic> json) {
    return HighlightRange(
      start: json['start'] as int,
      end: json['end'] as int,
      predictedText: json['predicted_text'] as String,
      correctText: json['correct_text'] as String,
    );
  }
}

class AnnotatedArabicText extends StatelessWidget {
  final String text; // correct_text
  final List<HighlightRange> highlights;
  final TextStyle baseStyle;
  final TextStyle highlightStyle;
  final TextStyle predictedStyle;
  final double labelGap; // space between predicted label and red text

  const AnnotatedArabicText({
    super.key,
    required this.text,
    required this.highlights,
    this.baseStyle = const TextStyle(fontSize: 20, color: Colors.white),
    this.highlightStyle = const TextStyle(fontSize: 20, color: Colors.red),
    this.predictedStyle = const TextStyle(fontSize: 14, color: Colors.white),
    this.labelGap = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    // Sort highlights by start ASC for main text
    final sorted = [...highlights]..sort((a, b) => a.start.compareTo(b.start));

// For overlay: sort by start DESC (highest start first) for RTL positioning
    final overlaySorted = [...sorted]..sort((a, b) => b.start.compareTo(a.start));

    return LayoutBuilder(
      builder: (context, constraints) {
        // Build base text as TextSpans only (no WidgetSpan!)
        final baseSpans = _buildBaseSpans(text, sorted, baseStyle, highlightStyle);

        // Paint once to measure line boxes for each highlight range
        final painter = TextPainter(
          text: TextSpan(children: baseSpans, style: baseStyle),
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          maxLines: null,
        );
        painter.layout(maxWidth: constraints.maxWidth);

        // Reserve vertical space for labels above the first line
        final textScale = MediaQuery.of(context).textScaleFactor;
        final labelHeight = (predictedStyle.fontSize ?? 14) * textScale;
        final extraTop = labelHeight + labelGap;

        // Build overlay labels positioned above each red segment (per line box)
        final overlay = <Widget>[];
        for (final r in overlaySorted) {
          final boxes = painter.getBoxesForSelection(
            TextSelection(baseOffset: r.start, extentOffset: r.end),
          );
          for (final box in boxes) {
            overlay.add(Positioned(
              left: constraints.maxWidth - box.right, // RTL alignment
              top: extraTop + box.top - labelHeight - labelGap,
              width: box.right - box.left,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  r.predictedText, // keep word as-is
                  textAlign: TextAlign.center,
                  style: predictedStyle,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                ),
              ),
            ));
          }
        }

        return SizedBox(
          width: constraints.maxWidth,
          // Height = padding for labels + base text height
          height: extraTop + painter.height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Base text with a top padding to make space for labels
              Padding(
                padding: EdgeInsets.only(top: extraTop),
                child: RichText(
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  text: TextSpan(children: baseSpans, style: baseStyle),
                ),
              ),
              // Labels
              ...overlay,
            ],
          ),
        );
      },
    );
  }

  List<TextSpan> _buildBaseSpans(
      String text,
      List<HighlightRange> highlights,
      TextStyle baseStyle,
      TextStyle highlightStyle,
      ) {
    final spans = <TextSpan>[];
    int current = 0;

    for (final r in highlights) {
      final start = r.start.clamp(0, text.length);
      final end = r.end.clamp(0, text.length);

      if (start > current) {
        spans.add(TextSpan(text: text.substring(current, start), style: baseStyle));
      }
      if (end > start) {
        spans.add(TextSpan(text: text.substring(start, end), style: highlightStyle));
        current = end;
      }
    }

    if (current < text.length) {
      spans.add(TextSpan(text: text.substring(current), style: baseStyle));
    }

    return spans;
  }
}

String reverseArabic(String input) {
  // Reverse the characters in the string
  return input.split('').reversed.join('');
}