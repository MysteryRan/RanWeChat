//
//  RanPageControl.m
//  nscollectionviewDemo
//
//  Created by zouran on 2020/7/23.
//  Copyright © 2020 ran. All rights reserved.
//

/*
 默认 小圆点 居中显示 大小为 20 * 20  左右对齐
 */
#import "RanPageControl.h"
#import "RanButton.h"

@interface RanPageControl()

@property(nonatomic, strong)NSMutableArray<RanButton *> *btns;

@end

@implementation RanPageControl

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)setTotalNum:(int)totalNum {
    _totalNum = totalNum;
    self.btns = [NSMutableArray arrayWithCapacity:0];
    // 显示button
    for (int i = 0; i < totalNum; i ++) {
        CGFloat margin = 10;
        RanButton *btn = [RanButton buttonWithTitle:@"" target:self action:@selector(btnClick:)];
        btn.isSelected = NO;
        btn.wantsLayer = YES;
        btn.layer.backgroundColor = [NSColor yellowColor].CGColor;
        [btn.layer setCornerRadius:5];
        [btn.layer setMasksToBounds:YES];
        [btn setHighlighted:NO];
        [btn setTag:i];
        CGFloat btnX = margin * (i + 1) + i * 10;
        [self.btns addObject:btn];
        btn.frame = CGRectMake(btnX, 0, 10, 10);
        btn.bordered = NO;
        [self addSubview:btn];
    }
}

- (void)btnClick:(RanButton *)sender {
    for (RanButton *btn in self.btns) {
        btn.isSelected = NO;
    }
    sender.isSelected = !sender.isSelected;
    if ([self.delegate respondsToSelector:@selector(selectedIndex:)]) {
        [self.delegate selectedIndex:sender.tag];
    }
}

- (void)setCurrentNum:(int)currentNum {
    _currentNum = currentNum;
    for (RanButton *btn in self.btns) {
        btn.isSelected = NO;
    }
    self.btns[currentNum].isSelected = YES;
}

@end
