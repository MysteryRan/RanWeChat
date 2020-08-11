//
//  RanInvitedItem.h
//  RanWeChat
//
//  Created by zouran on 2020/8/11.
//  Copyright © 2020 ran. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RanLastMessageModal.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^cancelAction)(RanLastMessageModal *modal);

@interface RanInvitedItem : NSCollectionViewItem

@property (weak) IBOutlet NSTextField *nameLabel;

@property(nonatomic, strong)RanLastMessageModal *modal;

@property(nonatomic, copy)cancelAction action;

@end

NS_ASSUME_NONNULL_END
