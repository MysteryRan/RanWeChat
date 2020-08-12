//
//  RanEmotionPageController.m
//  RanWeChat
//
//  Created by zouran on 2020/7/22.
//  Copyright © 2020 ran. All rights reserved.
//

#import "RanEmotionPageController.h"
#import "RanEmotionViewController.h"
#import "RanPageControl.h"

@interface RanEmotionPageController ()<NSPageControllerDelegate,RanPageControlSelectedDelegate>

@property (weak) IBOutlet RanPageControl *ranPageControl;


@end

@implementation RanEmotionPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.delegate = self;
    
    self.arrangedObjects = @[@[@"1"],@[@"2"],@[@"3"],@[@"4"]];
    
    self.ranPageControl.totalNum = 4;
    self.ranPageControl.delegate = self;
    self.ranPageControl.currentNum = 0;
    
}

- (void)pageController:(NSPageController *)pageController prepareViewController:(NSViewController *)viewController withObject:(id)object {
    
    if ([viewController isKindOfClass:[RanEmotionViewController class]]) {
        RanEmotionViewController *emotion = (RanEmotionViewController *)viewController;
        emotion.dataSource = object;
    }
    
}

- (NSString *)pageController:(NSPageController *)pageController identifierForObject:(id)object {
    return @"emotion";
}

- (NSViewController *)pageController:(NSPageController *)pageController viewControllerForIdentifier:(NSPageControllerObjectIdentifier)identifier {
    NSViewController *vc = [[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"emotion"];
    return vc;
}

- (void)pageControllerWillStartLiveTransition:(NSPageController *)pageController {
//    if (pageController.selectedIndex == 0 || pageController.selectedIndex >= 3) {
//        [self completeTransition];
//    }
}

- (void)pageControllerDidEndLiveTransition:(NSPageController *)pageController {
//    NSLog(@"%ld",(long)pageController.selectedIndex);
    self.ranPageControl.currentNum = pageController.selectedIndex;
    [self completeTransition];
}

- (void)selectedIndex:(NSInteger)index {
    [self takeSelectedIndexFrom:@(index)];
}

- (IBAction)leftBtnClick:(NSButton *)sender {
    [self takeSelectedIndexFrom:@(0)];
}

- (IBAction)rightBtnClick:(NSButton *)sender {
    [self takeSelectedIndexFrom:@(3)];
}




@end
