//
//  RanPeopleInvitedController.m
//  RanWeChat
//
//  Created by zouran on 2020/7/28.
//  Copyright © 2020 ran. All rights reserved.
//

#import "RanPeopleInvitedController.h"

@interface RanPeopleInvitedController ()

@end

@implementation RanPeopleInvitedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (IBAction)invitedClick:(NSButton *)sender {
    
}

- (IBAction)cancelClick:(NSButton *)sender {
    [self.view.window.sheetParent endSheet:self.view.window returnCode:NSModalResponseCancel];
}

@end
