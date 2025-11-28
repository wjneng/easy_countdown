# EasyCountdown 倒计时组件介绍与使用文档

# 一、组件概述

EasyCountdown 是一款轻量级、高可定制的 Flutter 倒计时组件，支持多种倒计时场景（如验证码倒计时、活动倒计时等）。组件提供了灵活的配置选项、实时状态回调和简洁的控制器 API，帮助开发者快速实现稳定可靠的倒计时功能，同时兼顾性能优化，避免不必要的 UI 重建和回调重复触发。

# 二、核心特性

- **多状态管理**：支持 `idle`（未开始）、`running`（运行中）、`paused`（已暂停）、`completed`（结束）四种状态，覆盖各类倒计时场景。

- **灵活配置**：可自定义倒计时总时长、刷新间隔、是否自动播放、重置时是否恢复初始时长等。

- **控制器 API**：通过 `EasyCountdownController` 实现开始、暂停、重置、手动更新剩余时长等操作，并支持实时进度回调。

- **性能优化**：仅在状态或剩余时长实际变化时触发 UI 重建和回调，避免冗余更新。

- **边界安全**：内置时长合法性校验，防止负数时长异常；自动处理组件销毁时的资源释放。

# 三、使用说明

在需要使用的文件中导入组件：

```dart
import 'package:easy_countdown/easy_countdown.dart';
```

##  快速开始
```dart
EasyCountdown(
    config: CountDownConfig(
        duration: Duration(seconds: 10),
        autoPlay: true,
        onDone: () {
            print('done');
        },
    ),
    builder: (context, value, status) {
        return Text(CountdownFormatUtils.formatHHmmss(value));
    },
),
```
## 控制器设置
```dart
final EasyCountdownController _countdownController = EasyCountdownController(
    onProgress: (value) {
        print('controller status: ${value.status}');
    },
);

@override
void dispose() {
    _countdownController.dispose();
    super.dispose();
}
```

# 四、核心类说明

##  CountDownConfig（倒计时配置）

用于配置倒计时的基础参数，支持以下属性：

|属性名|类型|默认值|说明|
|---|---|---|---|
|duration|Duration|必填|倒计时总时长（必须非负）|
|autoPlay|bool|true|是否初始化后自动开始倒计时|
|interval|Duration|Duration(seconds:1)|倒计时刷新间隔|
|resetToOriginal|bool|true|重置时是否恢复初始时长（false 则保留当前剩余时长）|
|onDone|VoidCallback?|null|倒计时结束（`completed` 状态）时的回调|
##  EasyCountdownController（倒计时控制器）

用于控制倒计时的状态和行为，支持以下方法和属性：

|方法/属性|类型|说明|
|---|---|---|
|constructor|EasyCountdownController({onProgress})|构造函数，`onProgress` 为实时进度回调（参数为 `CountDownProgress`）|
|start()|void|开始/恢复倒计时（仅当状态非 `running` 时生效）|
|pause()|void|暂停倒计时（仅当状态为 `running` 时生效）|
|reset()|void|重置倒计时（根据 `resetToOriginal` 决定是否恢复初始时长）|
|updateRemainingDuration(Duration)|void|手动更新剩余时长（时长必须非负）|
|remainingDuration|Duration|获取当前剩余时长（实时同步）|
|status|CountdownStatus|获取当前倒计时状态（实时同步）|
|dispose()|void|销毁控制器，释放资源（必须在组件 dispose 时调用）|
