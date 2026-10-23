import 'package:flutter_test/flutter_test.dart';
import 'package:fcontrol/fdefine.dart';

void main() {
  test('FShape defaults', () {
    const shape = FShape();
    expect(shape.borderShape, FBorderShape.RoundedRectangle);
  });

  test('FCorner.all sets all corners', () {
    final corner = FCorner.all(8);
    expect(corner.leftTopCorner, 8);
    expect(corner.rightBottomCorner, 8);
  });
}
