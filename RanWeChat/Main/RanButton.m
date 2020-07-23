//
//  RanButton.m
//  nscollectionviewDemo
//
//  Created by zouran on 2020/7/23.
//  Copyright © 2020 ran. All rights reserved.
//

#import "RanButton.h"

@interface RanButton()


@end

@implementation RanButton

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

//- (void)mouseDown:(NSEvent *)event {
//    self.layer.backgroundColor = [NSColor greenColor].CGColor;
//}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (self.isSelected) {
        self.layer.backgroundColor = [NSColor blueColor].CGColor;
    } else {
        self.layer.backgroundColor = [NSColor yellowColor].CGColor;
    }
}



@end
