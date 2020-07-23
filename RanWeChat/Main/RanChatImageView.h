//
//  RanChatImageView.h
//  RanWeChat
//
//  Created by zouran on 2020/7/17.
//  Copyright © 2020 ran. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RanLastMessageModal.h"

NS_ASSUME_NONNULL_BEGIN

@interface RanChatImageView : NSImageView

@property(nonatomic, assign)MessageType messageType;

@property(nonatomic, strong)NSImage *contentImage;

@end

NS_ASSUME_NONNULL_END
