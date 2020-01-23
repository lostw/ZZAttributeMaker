# ZZAttributeMaker

ZZAttributeMaker封装了NSAttributeString的创建。封装的目的除了简化原生NSAttributeString的使用，还有就是应对自己在项目内碰到的实际场景：**对指定文本的内容进行差异化显示**

因此ZZAttributeMaker加入了对文本的查找与正则匹配功能，避免手动指定range容易导致的出错



## 使用

```swift
one.attributedText = "Hello world 567".styled.prepend(icon: UIImage(named: "icon_baby")!).make {
  $0.range().fontSize(12)
  // 查找Hello
  $0.find(.text("Hello"))?.color(.blue).font(UIFont.systemFont(ofSize: 14))
  // 查找数字
  $0.find(.number)?.color(.red)
}

let text = """
I used to love correcting people’s grammar until \

I realized what I loved more was having friends.
-corfff
"""
two.attributedText = text.styled.make {
  // 设置段间距、行间距
  $0.range().paragraphSpacing(10).lineSpacing(4)
  // 正则匹配文本
  $0.findAll(.regex("cor\\w*\\b"))?.color(.red)
}
```



![](/Users/mac/Documents/ios/ZZAttributeMaker/ScreenShot.png)

## 其他

风格上跟代码结构上参照了masonry，因为这个项目最初是在阅读masonry的代码后对OC链式调用的实践