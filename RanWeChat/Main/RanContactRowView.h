//
//  RanContactRowView.h
//  myWeChat
//
//  Created by zouran on 2019/7/10.
//  Copyright © 2019 ran. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol rightDownSelected<NSObject>

- (void)selected;

@end

@interface RanContactRowView : NSTableRowView {
@private
    BOOL mouseInside;
    NSTrackingArea *trackingArea;
}

@property (nonatomic,weak)id<rightDownSelected>delegate;

@property (nonatomic, assign, getter = isShowingMenu) BOOL showingMenu;

@end

void DrawSeparatorInRect(NSRect rect);


NS_ASSUME_NONNULL_END
