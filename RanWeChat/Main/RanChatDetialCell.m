//
//  RanChatDetialCell.m
//  RanWeChat
//
//  Created by zouran on 2020/7/10.
//  Copyright © 2020 ran. All rights reserved.
//

#import "RanChatDetialCell.h"
#import "Masonry.h"
@interface RanLastMessageModal()

@end

@implementation RanChatDetialCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)setModal:(RanLastMessageModal *)modal {
    _modal = modal;
    // 头像
    NSImageView *headerImageView = [[NSImageView alloc] init];
    [self addSubview:headerImageView];
    headerImageView.image = [NSImage imageNamed:@"message_man_online"];
    if (modal.messageType == MessageTypeSend) {
        [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(10);
            make.top.equalTo(self).with.offset(10);
        }];
    } else {
        [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-10);
            make.top.equalTo(self).with.offset(10);
        }];
    }
    
    // 姓名
    NSTextField *nameTF = [[NSTextField alloc] init];
    nameTF.bordered = NO;
    nameTF.stringValue = modal.name;
    [nameTF sizeToFit];
    [self addSubview:nameTF];
    
    if (modal.messageType == MessageTypeSend) {
        nameTF.alignment = NSTextAlignmentLeft;
        [nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerImageView.mas_right).with.offset(10);
            make.top.equalTo(headerImageView);
        }];
    } else {
        nameTF.alignment = NSTextAlignmentRight;
        [nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(100);
            make.right.equalTo(headerImageView.mas_left);
            make.top.equalTo(headerImageView);
        }];
    }

    
    NSTextField *contentTF = [[NSTextField alloc] init];
    contentTF.selectable = YES;
    contentTF.drawsBackground = NO;
    contentTF.backgroundColor = [NSColor blueColor];
    contentTF.bordered = NO;
    [contentTF sizeToFit];
    contentTF.maximumNumberOfLines = 0;
    contentTF.font = [NSFont systemFontOfSize:14];
    contentTF.stringValue = modal.content;
    [self addSubview:contentTF];
    // 气泡
    NSImageView *bubbleImageView = [[NSImageView alloc] init];
    bubbleImageView.wantsLayer = YES;
    bubbleImageView.imageScaling = NSImageScaleAxesIndependently;
    
    [self addSubview:bubbleImageView];
    [bubbleImageView addSubview:contentTF];
    if (modal.messageType == MessageTypeSend) {
        bubbleImageView.imageAlignment = NSImageAlignTopLeft;
        bubbleImageView.image = [NSImage imageNamed:@"message_bubble_left"];
        [bubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameTF);
            make.top.equalTo(nameTF.mas_bottom).with.offset(5);
            make.width.mas_equalTo(modal.contentWidth+ 20);
            make.height.mas_equalTo(modal.contentHeight);
        }];
    } else {
        bubbleImageView.imageAlignment = NSImageAlignTopRight;
        bubbleImageView.image = [NSImage imageNamed:@"message_bubble_right"];
        [bubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(headerImageView.mas_left);
            make.top.equalTo(nameTF.mas_bottom).with.offset(5);
            make.width.mas_equalTo(modal.contentWidth + 20);
            make.height.mas_equalTo(modal.contentHeight);
        }];
        
    }


    // 文字内容
    if (modal.mediaType == MediaTypeText) {
        [contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bubbleImageView).with.offset(10);
            make.top.equalTo(bubbleImageView).with.offset(10);
            make.width.mas_equalTo(modal.contentWidth);
            make.height.mas_equalTo(modal.contentHeight);
        }];
    // 图片内容
    } else if (modal.mediaType == MediaTypePhoto) {
        NSImageView *imageV = [[NSImageView alloc] init];
        imageV.imageScaling = NSImageScaleAxesIndependently;
        imageV.image = [NSImage imageNamed:modal.content];
        imageV.wantsLayer = YES;
        imageV.layer.backgroundColor = [NSColor redColor].CGColor;
        [bubbleImageView addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bubbleImageView).with.offset(10);
            make.top.equalTo(bubbleImageView).with.offset(10);
            make.width.mas_equalTo(modal.contentWidth);
            make.height.mas_equalTo(modal.contentHeight);
        }];
        
    }
    
   
}

@end
