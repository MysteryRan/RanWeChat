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

@interface RanChatDetialCell : NSTableCellView

@property(nonatomic, strong)RanLastMessageModal *modal;

@end

NS_ASSUME_NONNULL_END
