import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:vinyl_groove_test5/main.dart';
import 'package:vinyl_groove_test5/utils/utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test form 1.1', () {
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

        text: '[STEP No.2] 잘못된 이메일 형식으로 로그인 시도',
        action: () async {
          await tester.enterText(
            find.byType(TextFormField).at(0),
            'invalid-email',
          );
          await tester.enterText(find.byType(TextFormField).at(1), 'Test1234!');
          await tester.tap(find.text('로그인').last);
        },
      );

      await step(
        tester: tester,

        text: '[STEP No.3] 입력 필드 초기화 후 짧은 비밀번호로 로그인 시도',
        action: () async {
          await tester.enterText(find.byType(TextFormField).at(0), '');
          await tester.enterText(find.byType(TextFormField).at(1), '');
          await tester.pumpAndSettle();
          await tester.enterText(
            find.byType(TextFormField).at(0),
            'test@example.com',
          );
          await tester.enterText(find.byType(TextFormField).at(1), '123');
          await tester.tap(find.text('로그인').last);
        },
      );

      await step(
        tester: tester,

        text: '[STEP No.4] 입력 필드 초기화 후 정상 값으로 로그인 시도',
        action: () async {
          await tester.enterText(find.byType(TextFormField).at(0), '');
          await tester.enterText(find.byType(TextFormField).at(1), '');
          await tester.pumpAndSettle();
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

        text: '[STEP No.5] 하단 네비게이션의 "탐색" 탭 클릭',
        action: () async {
          await tester.tap(find.text('탐색'));
        },
      );

      await step(
        tester: tester,

        text: '[STEP No.6] 장르 필터 순차 클릭',
        action: () async {
          await tester.tap(find.text('Rock'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Jazz'));
        },
      );

      await step(
        tester: tester,

        text: '[STEP No.7] 음반 상태 필터 순차 클릭',
        action: () async {
          await tester.tap(find.text('NM').first);
          await tester.pumpAndSettle();
          await tester.tap(find.text('VG+').first);
        },
      );

      await step(
        tester: tester,

        text: '[STEP No.8] "접기" 버튼 클릭',
        action: () async {
          await tester.tap(find.text('접기'));
        },
      );

      await step(
        tester: tester,

        text: '[STEP No.9] 정렬 드롭다운 선택',
        action: () async {
          await tester.tap(find.byType(PopupMenuButton<String>));
          await tester.pumpAndSettle();
          await tester.tap(find.text('인기 매물순'));
        },
      );

      await step(
        tester: tester,

        text: '[STEP No.10] 아래로 스크롤하여 15번째 상품 아이템까지 이동',
        action: () async {
          for (var i = 0; i < 10; i++) {
            if (find.byKey(ValueKey('item14')).evaluate().isNotEmpty) {
              await tester.ensureVisible(find.byKey(ValueKey('item14')));
              await tester.pumpAndSettle();
              return;
            }
            ;

            await tester.drag(find.byType(Scrollable).first, Offset(0, -400));
            await tester.pumpAndSettle(
              Duration(milliseconds: 300),
              EnginePhase.sendSemanticsUpdate,
              Duration(seconds: 3),
            );
          }
        },
      );

      await step(
        tester: tester,

        text: '[STEP No.11] 15번째 상품 아이템 클릭',
        action: () async {
          await tester.tap(find.byKey(ValueKey('item14')));
        },
      );

      await step(
        tester: tester,

        text: '[STEP No.12] 앱바 우측 관심 아이콘 버튼 클릭',
        action: () async {
          await tester.tap(find.byKey(ValueKey('favorite')));
          await tester.pumpAndSettle(Duration(seconds: 3));
        },
      );

      await step(
        tester: tester,

        text: '[STEP No.13] 뒤로가기 버튼 클릭 후 하단 네비게이션 “관심상품“ 탭 클릭',
        action: () async {
          await tester.tap(find.byKey(ValueKey('back')));
          await tester.pumpAndSettle();
          await tester.tap(find.text('관심상품'));
        },
      );

      await step(
        tester: tester,

        text: '[STEP No.14] 등록된 관심 상품 아이템 리스트 표시 확인',
        action: () async {},
      );

      await step(
        tester: tester,

        text: '[STEP No.15] 첫 번째 아이템의 관심(하트) 아이콘 버튼 클릭',
        action: () async {
          await tester.tap(find.byKey(ValueKey('heart0')));
        },
      );

      await step(
        tester: tester,

        text: '[STEP No.16] 비활성화 관심 상품 아이템 리스트 표시 확인',
        action: () async {},
      );

      await step(
        tester: tester,

        text: '[STEP No.17] 하단 네비게이션 "홈" 탭 클릭',
        action: () async {
          await tester.tap(find.text('홈'));
        },
      );

      await step(
        tester: tester,

        text: '[STEP No.18] 하단 네비게이션 "관심상품" 탭 클릭',
        action: () async {
          await tester.tap(find.text('관심상품'));
        },
      );

      await step(
        tester: tester,

        text: '[STEP No.19] 비활성화 관심 상품 아이템 리스트 제거 확인',
        action: () async {},
      );
    });
  });
}
