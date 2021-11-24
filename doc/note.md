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
```
