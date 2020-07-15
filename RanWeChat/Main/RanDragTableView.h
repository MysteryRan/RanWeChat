//
//  RanDragTableView.h
//  RanWeChat
//
//  Created by zouran on 2020/7/14.
//  Copyright © 2020 ran. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ranDragFileDlegate<NSObject>

- (void)dragMoveIn;

- (void)dragMoveOut;

- (void)dragDown:(NSArray *)files;

@end

@interface RanDragTableView : NSTableView

@property(nonatomic, weak)id<ranDragFileDlegate>dragDelegate;

@end

NS_ASSUME_NONNULL_END
