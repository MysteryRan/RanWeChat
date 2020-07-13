//
//  RanVideChatController.h
//  RanWeChat
//
//  Created by zouran on 2020/7/9.
//  Copyright © 2020 ran. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebRTC/WebRTC.h>

NS_ASSUME_NONNULL_BEGIN

@interface RanVideChatController : NSViewController

@property(nonatomic, strong)RTCCameraVideoCapturer * capture;

@end

NS_ASSUME_NONNULL_END
