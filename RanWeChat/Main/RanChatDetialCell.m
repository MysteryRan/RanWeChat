//
//  RanChatDetialCell.m
//  RanWeChat
//
//  Created by zouran on 2020/7/10.
//  Copyright © 2020 ran. All rights reserved.
//

#import "RanChatDetialCell.h"
#import "Masonry.h"

@interface RanChatDetialCell()

@property(nonatomic, strong)NSImageView *headerImageView;
@property(nonatomic, strong)NSTextField *nameTF;
@property(nonatomic, strong)NSTextField *contentTF;
@property(nonatomic, strong)NSImageView *bubbleImageView;
@property(nonatomic, strong)NSImageView *imageV;

@end

@implementation RanChatDetialCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)setModal:(RanLastMessageModal *)modal {
    _modal = modal;
    // 头像
    self.headerImageView = [[NSImageView alloc] init];
    [self addSubview:self.headerImageView];
    self.headerImageView.image = [NSImage imageNamed:@"message_man_online"];
    if (modal.messageType == MessageTypeSend) {
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(10);
            make.top.equalTo(self).with.offset(10);
        }];
    } else {
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-10);
            make.top.equalTo(self).with.offset(10);
        }];
    }
    
    // 姓名
    self.nameTF = [[NSTextField alloc] init];
    self.nameTF.bordered = NO;
    self.nameTF.stringValue = modal.name;
    [self.nameTF sizeToFit];
    [self addSubview:self.nameTF];
    
    if (modal.messageType == MessageTypeSend) {
        self.nameTF.alignment = NSTextAlignmentLeft;
        [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerImageView.mas_right).with.offset(10);
            make.top.equalTo(self.headerImageView);
        }];
    } else {
        self.nameTF.alignment = NSTextAlignmentRight;
        [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(100);
            make.right.equalTo(self.headerImageView.mas_left);
            make.top.equalTo(self.headerImageView);
        }];
    }

    
    self.contentTF = [[NSTextField alloc] init];
    self.contentTF.selectable = YES;
    self.contentTF.drawsBackground = NO;
    self.contentTF.backgroundColor = [NSColor blueColor];
    self.contentTF.bordered = NO;
    [self.contentTF sizeToFit];
    self.contentTF.maximumNumberOfLines = 0;
    self.contentTF.font = [NSFont systemFontOfSize:14];
    self.contentTF.stringValue = modal.content;
    [self addSubview:self.contentTF];
    // 气泡
    self.bubbleImageView = [[NSImageView alloc] init];
    self.bubbleImageView.wantsLayer = YES;
    self.bubbleImageView.imageScaling = NSImageScaleAxesIndependently;
    
    [self addSubview:self.bubbleImageView];
    [self.bubbleImageView addSubview:self.contentTF];
    if (modal.messageType == MessageTypeSend) {
        self.bubbleImageView.imageAlignment = NSImageAlignTopLeft;
        self.bubbleImageView.image = [NSImage imageNamed:@"message_bubble_left"];
        [self.bubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameTF);
            make.top.equalTo(self.nameTF.mas_bottom).with.offset(5);
            make.width.mas_equalTo(modal.contentWidth+ 20);
            make.height.mas_equalTo(modal.contentHeight);
        }];
    } else {
        self.bubbleImageView.imageAlignment = NSImageAlignTopRight;
        self.bubbleImageView.image = [NSImage imageNamed:@"message_bubble_right"];
        [self.bubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.headerImageView.mas_left);
            make.top.equalTo(self.nameTF.mas_bottom).with.offset(5);
            make.width.mas_equalTo(modal.contentWidth + 20);
            make.height.mas_equalTo(modal.contentHeight);
        }];
        
    }


    // 文字内容
    if (modal.mediaType == MediaTypeText) {
        [self.contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bubbleImageView).with.offset(10);
            make.top.equalTo(self.bubbleImageView).with.offset(10);
            make.width.mas_equalTo(modal.contentWidth);
            make.height.mas_equalTo(modal.contentHeight);
        }];
    // 图片内容
    } else if (modal.mediaType == MediaTypePhoto) {
        self.imageV = [[NSImageView alloc] init];
        self.imageV.imageScaling = NSImageScaleAxesIndependently;
        self.imageV.image = [NSImage imageNamed:modal.content];
//        imageV.image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:@"/Users/zouran/Desktop/login.png"]];
//        imageV.image = [[NSImage alloc] initWithData:[NSData dataWithContentsOfFile:@"/Users/zouran/Desktop/login.png"]];
        // 从路径加载过来的
        if ([modal.content containsString:@"zouran"]) {
            self.imageV.image = [[NSImage alloc] initWithContentsOfFile:modal.content];
        }
        [self.bubbleImageView addSubview:self.imageV];
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bubbleImageView).with.offset(10);
            make.top.equalTo(self.bubbleImageView).with.offset(10);
            make.width.mas_equalTo(modal.contentWidth);
            make.height.mas_equalTo(modal.contentHeight);
        }];
        
    }
    
   
}

@end
