# RanWeChat
仿写Mac端微信。
## 如果有人愿意提供socket服务可以一起完善该项目。

## 已完成功能:
 ### 1.登录界面的搭建。
![登录界面](https://github.com/MysteryRan/RanWeChat/blob/master/login.png "登录界面")
 ### 2.最近通话列表,与对话详情(文本)列表的展示。
![主界面](https://github.com/MysteryRan/RanWeChat/blob/master/main-view.png "主界面")
![发送文本消息与重发](https://github.com/MysteryRan/RanWeChat/blob/master/send-resend.gif "发送消息")
![拖拽发送图片](https://github.com/MysteryRan/RanWeChat/blob/master/dragsend.gif "发送消息")
 ### 3.音视频通话。
    这里感谢Jhuster,https://github.com/Jhuster/RTCStartupDemo 提供的WebRTC本地信令服务器。
![音视频通话](https://github.com/MysteryRan/RanWeChat/blob/master/video-chat.png "音视频通话")
![音视频通话](https://github.com/MysteryRan/RanWeChat/blob/master/videocall.gif "音视频通话")
### 4.分享自己的桌面。
![桌面共享](https://github.com/MysteryRan/RanWeChat/blob/master/screenshare.gif "共享桌面")
## 将要完成的功能:
 ### 1.图片聊天详情的布局。(已完成)
 ### 2.发送文字与图片功能。(已完成)
 ### 3.聊天详情的上拉加载。
## 想要找到好的解决方案:
 ### 1.点击不同的最近聊天实现聊天详情的切换？？？
    目前实先方案:
        聊天详情界面与最近通话列表在同一ViewController。
 ### 2.拖拽界面时,图片cell根据拖拽伸缩的功能？？？(已完成)
 ### 3.多选聊天详情的实现方案？？？
     尝试方案:
        1.利用NSCollectionView可以实现多选功能,但拉伸界面时,会导致布局错乱.
        2.利用NSTableView拉伸时不会出现布局错乱,但是不会出现选择方框功能。
  
