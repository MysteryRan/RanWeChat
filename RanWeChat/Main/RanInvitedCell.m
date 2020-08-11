//
//  RanInvitedCell.m
//  RanWeChat
//
//  Created by zouran on 2020/8/10.
//  Copyright © 2020 ran. All rights reserved.
//

#import "RanInvitedCell.h"



@interface RanInvitedCell()

@property (weak) IBOutlet NSTextField *nameLab;
@property (weak) IBOutlet NSButton *statusBtn;



@end

@implementation RanInvitedCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    self.statusBtn.enabled = NO;
    
    // Drawing code here.
}

- (IBAction)chooseClick:(NSButton *)sender {
    if (![self.modal.name isEqualToString:@"ccc"]) {
        self.action(self.modal);
    }
}

- (void)setModal:(RanLastMessageModal *)modal {
    _modal = modal;
    self.nameLab.stringValue = modal.name;
    
    if (modal.isSelected) {
        self.statusBtn.state = NSControlStateValueOn;
    } else {
        self.statusBtn.state = NSControlStateValueOff;
    }

}

@end
