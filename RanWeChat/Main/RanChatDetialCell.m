//
//  RanChatDetialCell.m
//  RanWeChat
//
//  Created by zouran on 2020/7/10.
//  Copyright © 2020 ran. All rights reserved.
//

#import "RanChatDetialCell.h"
#import "Masonry.h"
#import "RanChatImageView.h"
#import "RanChatRightImageView.h"

@interface RanChatDetialCell()

@property(nonatomic, strong)NSImageView *headerImageView; // 头像
@property(nonatomic, strong)NSTextField *nameTF;  //姓名
@property(nonatomic, strong)NSTextField *contentTF;  //文字内容
@property(nonatomic, strong)NSImageView *bubbleImageView; //气泡框
@property(nonatomic, strong)RanChatImageView *imageV; //图片内容
@property(nonatomic, strong)NSProgressIndicator *indicator; //文字等待
@property(nonatomic, strong)NSButton *resendButton;

@end

@implementation RanChatDetialCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)setModal:(RanLastMessageModal *)modal {
    _modal = modal;
    if (self.headerImageView) [self.headerImageView removeFromSuperview];
    if (self.nameTF) [self.nameTF removeFromSuperview];
    if (self.contentTF) [self.contentTF removeFromSuperview];
    if (self.bubbleImageView) [self.bubbleImageView removeFromSuperview];
    if (self.imageV) [self.imageV removeFromSuperview];
    if (self.indicator) [self.indicator removeFromSuperview];
    if (self.resendButton) [self.resendButton removeFromSuperview];
    // 头像
    self.headerImageView = [[NSImageView alloc] init];
    [self addSubview:self.headerImageView];
    self.headerImageView.image = [NSImage imageNamed:@"message_man_online"];
    if (modal.messageType == MessageTypeSend) {
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(10);
            make.top.equalTo(self).with.offset(10);
            make.width.height.mas_offset(50);
        }];
    } else {
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-10);
            make.top.equalTo(self).with.offset(10);
            make.width.height.mas_offset(50);
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

    self.contentTF = [NSTextField wrappingLabelWithString:modal.content];
    self.contentTF.selectable = YES;
    self.contentTF.lineBreakMode = NSLineBreakByCharWrapping;
    self.contentTF.editable = NO;
    self.contentTF.bordered = NO;
    self.contentTF.maximumNumberOfLines = 0;
    self.contentTF.font = [NSFont systemFontOfSize:14];
    // 气泡
    if (modal.messageType == MessageTypeSend) {
        self.bubbleImageView = [[RanChatImageView alloc] init];
    } else {
        self.bubbleImageView = [[RanChatRightImageView alloc] init];
        
    }
    
//    self.bubbleImageView.imageScaling = NSImageScaleAxesIndependently;
    
    // 文字内容
    if (modal.mediaType == MediaTypeText) {
        [self addSubview:self.bubbleImageView];
        self.bubbleImageView.layer.backgroundColor = [NSColor redColor].CGColor;
        [self addSubview:self.contentTF];
        if (modal.messageType == MessageTypeSend) {
            [self.contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headerImageView.mas_right).with.offset(20);
                make.top.equalTo(self.headerImageView.mas_bottom).with.offset(-10);
                make.right.lessThanOrEqualTo(self).with.offset(-250);
                make.bottom.equalTo(self).with.offset(-30);
            }];
            [self.bubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.left.equalTo(self.contentTF).with.offset(-10);
                 make.top.equalTo(self.contentTF).with.offset(-10);
                 make.right.equalTo(self.contentTF).with.offset(10);
                 make.bottom.equalTo(self.contentTF).with.offset(10);
             }];
        } else {
            [self.contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.lessThanOrEqualTo(self).multipliedBy(0.5);
                make.top.equalTo(self.headerImageView.mas_bottom).with.offset(-10);
                make.right.equalTo(self.headerImageView.mas_left).with.offset(-10);
                make.bottom.equalTo(self).with.offset(-30);
            }];
            [self.bubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.left.equalTo(self.contentTF).with.offset(-10);
                 make.top.equalTo(self.contentTF).with.offset(-10);
                 make.right.equalTo(self.contentTF).with.offset(10);
                 make.bottom.equalTo(self.contentTF).with.offset(10);
             }];
            
            self.indicator = [NSProgressIndicator new];
            self.indicator.style = NSProgressIndicatorStyleSpinning;
            [self addSubview:self.indicator];
            [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.bubbleImageView.mas_left).with.offset(-5);
                make.bottom.equalTo(self.bubbleImageView.mas_bottom);
                make.width.height.mas_equalTo(20);
            }];

            self.resendButton = [NSButton new];
            [self.resendButton setTitle:@"重发"];
            [self addSubview:self.resendButton];
            [self.resendButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.bubbleImageView.mas_left).with.offset(-5);
                make.bottom.equalTo(self.bubbleImageView.mas_bottom);
                make.width.height.mas_equalTo(20);
            }];
            self.resendButton.hidden = YES;

            if (modal.sendStatus == SendingStatus) {
                [self.indicator startAnimation:nil];
            } else if (modal.sendStatus == SuccessStatus) {
                [self.indicator removeFromSuperview];
            } else {
                [self.indicator removeFromSuperview];
                // 重新发送按钮
                self.resendButton.hidden = NO;
                [self.resendButton setTarget:self];
                [self.resendButton setAction:@selector(resendClick:)];
            }
        }
    // 图片内容
    } else if (modal.mediaType == MediaTypePhoto) {
        if (modal.messageType == MessageTypeSend) {
            self.imageV = [[RanChatImageView alloc] init];
        } else {
            self.imageV = [[RanChatRightImageView alloc] init];
        }
        
        
//        self.imageV.imageScaling = NSImageScaleAxesIndependently;
        self.imageV.wantsLayer = YES;
//        self.imageV.layer = [[CALayer alloc] init];
        //    self.bubbleImageView.imageScaling = NSImageScaleNone;
//        self.imageV.layer.contentsGravity = kCAGravityResizeAspectFill;
//        self.imageV.layer.contents = [NSImage imageNamed:modal.content];
//        self.imageV.image = [NSImage imageNamed:modal.content];
//        imageV.image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:@"/Users/zouran/Desktop/login.png"]];
//        imageV.image = [[NSImage alloc] initWithData:[NSData dataWithContentsOfFile:@"/Users/zouran/Desktop/login.png"]];
        // 从路径加载过来的
        self.imageV.contentImage = [NSImage imageNamed:modal.content];
        if ([modal.content containsString:@"zouran"]) {
            self.imageV.contentImage = [[NSImage alloc] initWithContentsOfFile:modal.content];
        }
        [self addSubview:self.imageV];
        if (modal.messageType == MessageTypeSend) {
            [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headerImageView.mas_right).with.offset(10);
                make.top.equalTo(self.headerImageView).with.offset(20);
                make.right.equalTo(self).with.offset(-300);
                make.bottom.equalTo(self).with.offset(10);
                make.height.mas_equalTo(self.imageV.mas_width).multipliedBy(0.7);
            }];
        } else {
            [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(300);
                make.top.equalTo(self.headerImageView).with.offset(20);
                make.right.equalTo(self.headerImageView.mas_left).with.offset(-10);
                make.bottom.equalTo(self).with.offset(10);
                make.height.mas_equalTo(self.imageV.mas_width).multipliedBy(0.7);
            }];
        }
    }
}

- (void)resendClick:(NSButton *)sender {
    if ([self.delegate respondsToSelector:@selector(resendWith:)]) {
        [self.delegate resendWith:self.modal];
    }
}

@end
