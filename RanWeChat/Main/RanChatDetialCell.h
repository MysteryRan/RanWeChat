//
//  RanChatDetialCell.h
//  RanWeChat
//
//  Created by zouran on 2020/7/10.
//  Copyright © 2020 ran. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RanLastMessageModal.h"

NS_ASSUME_NONNULL_BEGIN

@protocol resendDelegate<NSObject>

- (void)resendWith:(RanLastMessageModal *)modal;


@end

@interface RanChatDetialCell : NSTableCellView

@property(nonatomic, strong)RanLastMessageModal *modal;

@property(nonatomic, weak)id<resendDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
