import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_arivu/globals/app_assets.dart';
import 'package:portfolio_arivu/main.dart';

void main() {
  test('MyApp widget can be constructed', () {
    expect(const MyApp(), isA<MyApp>());
  });

  test('App assets point to the assets folder', () {
    expect(AppAssets.certificate1, startsWith('assets/'));
    expect(AppAssets.resume, 'assets/resume.png');
  });
}
