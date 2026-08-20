import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:vinyl_groove_test6/main.dart';
import 'package:vinyl_groove_test6/uitls/utils.dart';
import 'package:vinyl_groove_test6/uitls/info.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testMode = true;
  group('end-to-end test form 1.2', () {
    testWidgets('1', (tester) async {
      //1
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      await step(
        tester: tester,
        text: '[STEP No.1] 애플리케이션 실행',
        action: () async {},
      );

      await step(
        tester: tester,
        text: '[STEP No.2] 로그인 시도',
        action: () async {
          await tester.enterText(
            find.byType(TextFormField).at(0),
            'test@example.com',
          );
          await tester.enterText(find.byType(TextFormField).at(1), 'Test1234!');
          await tester.tap(find.text('로그인').last);
          await tester.pumpAndSettle(Duration(seconds: 3));
        },
      );

      await step(
        tester: tester,
        text: '[STEP No.3] 하단 네비게이션 상품 등록 진입 버튼 클릭',
        action: () async {
          await tester.tap(find.byKey(ValueKey('add')));
        },
      );

      await step(
        tester: tester,
        text: '[STEP No.4] "등록하기" 버튼 클릭',
        action: () async {
          await tester.ensureVisible(find.text('등록하기'));
          await tester.tap(find.text('등록하기').first);
        },
      );

      await step(
        tester: tester,
        text: '[STEP No.5] 이미지 영역 클릭 후 “갤러리에서 선택” 메뉴 선택하여 이미지 선택',
        action: () async {
          await tester.ensureVisible(find.byKey(ValueKey('imagepick')));
          await Future.delayed(Duration(seconds: 1));
          await tester.tap(find.byKey(ValueKey('imagepick')));
          await Future.delayed(Duration(seconds: 1));
          await tester.pumpAndSettle();
          await tester.tap(find.text('갤러리에서 선택'));
        },
      );

      await step(
        tester: tester,
        text: '[STEP No.6] 앨범명 입력상자 선택 후 앨범명 입력',
        action: () async {
          await tester.enterText(
            find.byType(TextFormField).at(0),
            'Test Vinyl Album',
          );
        },
      );

      await step(
        tester: tester,
        text: '[STEP No.7] 아티스트 입력상자 선택 후 아티스트 입력',
        action: () async {
          await tester.enterText(
            find.byType(TextFormField).at(1),
            'Test Artist',
          );
        },
      );

      await step(
        tester: tester,
        text: '[STEP No.8] 가격 입력 상자 선택 후 가격 입력',
        action: () async {
          await tester.ensureVisible(find.text('등록하기'));
          await tester.enterText(find.byType(TextFormField).at(2), '500');
        },
      );

      await step(
        tester: tester,
        text: '[STEP No.9] 상품 설명 상자 선택 후 상품 설명 입력',
        action: () async {
          await tester.enterText(
            find.byType(TextFormField).at(4),
            '테스트용 바이닐 앨범입니다',
          );
        },
      );

      await step(
        tester: tester,
        text: '[STEP No.10] "등록하기" 버튼 클릭',
        action: () async {
          await tester.tap(find.text('등록하기').first);
        },
      );

      await step(
        tester: tester,
        text: '[STEP No.11] 가격 입력 상자 선택 후 새 가격 입력',
        action: () async {
          await tester.enterText(find.byType(TextFormField).at(2), '45000');
        },
      );

      await step(
        tester: tester,
        text: '[STEP No.12] "등록하기" 버튼 클릭',
        action: () async {
          await tester.tap(find.text('등록하기').first);
          await tester.pumpAndSettle(Duration(seconds: 3));
        },
      );

      await step(
        tester: tester,
        text: '[STEP No.13] 하단 네비게이션 "마이페이지" 탭 클릭',
        action: () async {
          await tester.tap(find.text('마이페이지'));
        },
      );

      await step(
        tester: tester,
        text: '[STEP No.14] "내 등록 상품" 메뉴 클릭',
        action: () async {
          await tester.tap(find.text('내 등록 상품'));
        },
      );

      await step(
        tester: tester,
        text: '[STEP No.15] 등록된 첫 번째 상품 아이템 리스트에 표시 확인',
        action: () async {},
      );

      await step(
        tester: tester,
        text: '[STEP No.16] 첫 번째 상품 아이템 삭제 아이콘 버튼 클릭',
        action: () async {
          await tester.tap(find.byKey(ValueKey('remove0')));
        },
      );

      await step(
        tester: tester,
        text: '[STEP No.17] 다이얼로그의 "삭제" 버튼 클릭',
        action: () async {
          await tester.tap(find.text('삭제'));
        },
      );

      await step(
        tester: tester,
        text: '[STEP No.18] 등록 상품 목록 빈 상태 확인',
        action: () async {},
      );

      await step(
        tester: tester,
        text: '[STEP No.19] 뒤로가기 버튼 클릭',
        action: () async {
          await tester.tap(find.byKey(ValueKey('back_1')));
        },
      );

      await step(
        tester: tester,
        text: '[STEP No.20] "로그아웃" 버튼 클릭',
        action: () async {
          await tester.tap(find.text('로그아웃'));
        },
      );

      await step(
        tester: tester,
        text: '[STEP No.21] 로그아웃 확인 다이얼로그의 "로그아웃" 버튼 클릭',
        action: () async {
          await tester.tap(find.text('로그아웃').at(2));
        },
      );

      await step(
        tester: tester,
        text: '[STEP No.22] 로그인 화면 정상 표시 확인',
        action: () async {},
      );
    });
  });
}