//
//  RanPageControl.h
//  nscollectionviewDemo
//
//  Created by zouran on 2020/7/23.
//  Copyright © 2020 ran. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RanPageControlSelectedDelegate<NSObject>

- (void)selectedIndex:(NSInteger)index;

@end

@interface RanPageControl : NSView

// 总共的
@property(nonatomic, assign)int totalNum;
// 当前的
@property(nonatomic, assign)int currentNum;

@property(nonatomic, weak)id<RanPageControlSelectedDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
