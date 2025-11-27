enum CountdownStatus {
  idle, // 未开始
  running, // 运行中
  paused, // 已暂停
  completed, // 已完成（正常结束）
  overtime, // 超时（允许负数时）
}
