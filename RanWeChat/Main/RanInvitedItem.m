//
//  RanInvitedItem.m
//  RanWeChat
//
//  Created by zouran on 2020/8/11.
//  Copyright © 2020 ran. All rights reserved.
//

#import "RanInvitedItem.h"

@interface RanInvitedItem ()

@property (weak) IBOutlet NSButton *cancelBtn;

@end

@implementation RanInvitedItem

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)setModal:(RanLastMessageModal *)modal {
    _modal = modal;
    self.nameLabel.stringValue = modal.name;
    if ([modal.name isEqualToString:@"ccc"]) {
        self.cancelBtn.hidden = YES;
    } else {
        self.cancelBtn.hidden = NO;
    }
}

- (IBAction)cancelInvitedClick:(NSButton *)sender {
    self.action(self.modal);
}

@end
