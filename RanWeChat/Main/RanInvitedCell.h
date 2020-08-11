//
//  RanInvitedCell.h
//  RanWeChat
//
//  Created by zouran on 2020/8/10.
//  Copyright © 2020 ran. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RanLastMessageModal.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^chooseAction)(RanLastMessageModal *modal);

@interface RanInvitedCell : NSTableCellView

@property(nonatomic,strong)RanLastMessageModal *modal;

@property(nonatomic, copy)chooseAction action;

@end

NS_ASSUME_NONNULL_END
