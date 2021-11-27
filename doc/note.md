## 2021-11-26 14:04:24

### end

- @ques flutter 平台单独 import
- @ques flutter sort import

## 2021-11-25 20:35:13

new Directory(appDocDirectory.path+'/'+'dir').create(recursive: true)
// The created directory is returned as a Future.
.then((Directory directory) {
print('Path of New Dir: '+directory.path);
});

## 2021-11-25 09:32:10

- web

  - 0:00:13.260399
  - 0:00:09.004700

- ios
  flutter: combine() executed in:>0 0:00:00.000104
  flutter: combine() executed in:>1 0:00:00.150738
  flutter: combine() executed in:>2 0:00:00.332120
  flutter: combine() executed in:>3 0:00:00.348953
  flutter: combine() executed in:>4 0:00:00.840439

- CocoaPods recommended version 1.10.0

- @todo 比较 ios 和 web 的性能差距

## 2021-11-24 14:43:09

combine 能不能通过其他进程来处理

- @ques Isolate 是不是只能传递字符串

- @ques 转化成真正的异步任务

```dart

<!-- 1 -->
Future(() => print('Task1 Future 2'));

<!-- 2 -->
void coding(language) {
  print("hello " + language);
}
void main() {
  Isolate.spawn(coding, "Dart");
}

<!-- 3 -->
void coding(SendPort port) {
  const sum = 1 + 2;
  // 给调用方发送结果
  port.send(sum);
}

void main() {
  testIsolate();
}

testIsolate() async {
  ReceivePort receivePort = ReceivePort(); // 创建管道
  Isolate isolate = await Isolate.spawn(coding, receivePort.sendPort); // 创建 Isolate，并传递发送管道作为参数
    // 监听消息
  receivePort.listen((message) {
    print("data: $message");
    receivePort.close();
    isolate?.kill(priority: Isolate.immediate);
    isolate = null;
  });
}

<!-- 4 -->

compute方法
```
