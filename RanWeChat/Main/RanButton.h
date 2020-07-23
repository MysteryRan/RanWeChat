//
//  RanButton.h
//  nscollectionviewDemo
//
//  Created by zouran on 2020/7/23.
//  Copyright © 2020 ran. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSUInteger, ButtonState) {
    ButtonNormalState      = 0,
    ButtonHoverState       = 1,
    ButtonHighlightState   = 2,
    ButtonSelectedState    = 3
};

NS_ASSUME_NONNULL_BEGIN

@interface RanButton : NSButton

@property(nonatomic, assign)ButtonState state;

@property(nonatomic, assign)BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
