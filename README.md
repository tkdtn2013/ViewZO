
<div align="center">

[![KakaoPay](https://img.shields.io/badge/KakaoPay-Donate-FFCD00?style=plastic&logo=kakao)](https://qr.kakaopay.com/FeigyCEXy1f406175)
[![pub package](https://img.shields.io/pub/v/viewzo.svg)](https://pub.dev/packages/viewzo)

</div>
<hr>

# ViewZo Library

`ViewZo`는 다양한 이미지와 pdf를 스크롤과 페이징으로 표시할 수 있는 Flutter 위젯입니다. 커스터마이징 옵션을 제공합니다.

## 사용법

다음은 `ViewZo` 위젯을 사용하는 예제입니다:

```dart
import 'package:flutter/material.dart';
import 'package:viewzo/viewzo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('ViewZo Example'),
        ),
        body: Center(
          child: ViewZo(
            items: [
              'https://example.com/image1.png',
              'https://example.com/image2.png',
            ],
            isPage: true,
            fit: BoxFit.contain,
            width: 300,
            height: 400,
            scrollOffsetCallback: (offset) {
              print('Scroll offset: $offset');
            },
            pageCallback: (page) {
              print('Current page: $page');
            },
            scrollBarThumbWidth: 8.0,
            scrollBarThumbColor: Colors.blue,
            scrollBarThumbVisibility: true,
            scrollBarTrackVisibility: true,
            scrollBarTrackColor: Colors.grey,
            scrollBarThumbRadius: Radius.circular(4.0),
            scrollBarTrackRadius: Radius.circular(4.0),
            headers: {
              'User-Agent': 'YourApp/1.0.0',
            },
          ),
        ),
      ),
    );
  }
}
```

## 속성

- `items`: 표시할 이미지의 URL 목록 또는 로컬파일 입니다. **필수**.
- `isPage`: `true`인 경우 페이징 **필수**.
- `fit`: 이미지를 화면에 어떻게 맞출지 결정하는 `BoxFit` 값입니다. **필수**.
- `width`: 위젯의 너비입니다. 선택 사항.
- `height`: 위젯의 높이입니다. 선택 사항.
- `scrollOffsetCallback`: 스크롤 오프셋이 변경될 때 호출되는 콜백입니다. 선택 사항.
- `pageCallback`: 현재 페이지가 변경될 때 호출되는 콜백입니다. 선택 사항.
- `scrollBarThumbWidth`: 스크롤바의 너비 선택 사항.
- `scrollBarThumbColor`: 스크롤바의 색상 선택 사항.
- `scrollBarThumbVisibility`: 스크롤바 표시 여부. 선택 사항.
- `scrollBarTrackVisibility`: 스크롤바 트랙 표시 여부. 선택 사항.
- `scrollBarTrackColor`: 스크롤바 트랙의 색상입니다. 선택 사항.
- `scrollBarThumbRadius`: 스크롤바의 반경입니다. 선택 사항.
- `scrollBarTrackRadius`: 스크롤바 트랙의 반경입니다. 선택 사항.
- `headers`: HTTP 요청에 사용할 추가 헤더입니다. 선택 사항.

## 예제

### 기본 사용 예제

```dart
ViewZo(
  items: [
    'https://example.com/image1.png',
    'https://example.com/image2.png',
  ],
  isPage: true,
  fit: BoxFit.contain,
)
```

### 스크롤 콜백 및 페이지 콜백 사용 예제

```dart
ViewZo(
  items: [
    'https://example.com/image1.png',
    'https://example.com/image2.png',
  ],
  isPage: true,
  fit: BoxFit.contain,
  scrollOffsetCallback: (offset) {
    print('Scroll offset: $offset');
  },
  pageCallback: (page) {
    print('Current page: $page');
  },
)
```

### 스크롤바 커스터마이징 예제

```dart
ViewZo(
  items: [
    'https://example.com/image1.png',
    'https://example.com/image2.png',
  ],
  isPage: true,
  fit: BoxFit.contain,
  scrollBarThumbWidth: 8.0,
  scrollBarThumbColor: Colors.blue,
  scrollBarThumbVisibility: true,
  scrollBarTrackVisibility: true,
  scrollBarTrackColor: Colors.grey,
  scrollBarThumbRadius: Radius.circular(4.0),
  scrollBarTrackRadius: Radius.circular(4.0),
)
```

### HTTP 헤더 추가 예제

```dart
ViewZo(
  items: [
    'https://example.com/image1.png',
    'https://example.com/image2.png',
  ],
  isPage: true,
  fit: BoxFit.contain,
  headers: {
    'User-Agent': 'YourApp/1.0.0',
  },
)
```

이 라이브러리는 다양한 이미지를 쉽게 로드하고 표시할 수 있는 기능을 제공합니다. 사용 예제를 통해 다양한 기능을 탐색해보세요.
