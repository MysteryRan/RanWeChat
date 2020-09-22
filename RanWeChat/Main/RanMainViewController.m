//
//  RanMainViewController.m
//  RanWeChat
//
//  Created by zouran on 2020/7/9.
//  Copyright © 2020 ran. All rights reserved.
//

#import "RanMainViewController.h"
#import "RanContactCell.h"
#import "RanContactRowView.h"
#import "RanHeaderCell.h"
#import "RanLastTalkTableView.h"

#import "RanVideoChatWindow.h"
#import "RanLastMessageModal.h"
#import "RanChatDetialCell.h"

#import "RanLastTalkHeaderCell.h"
#import "RanDragTableView.h"

//#import "RanHeaderViewController.h"
#import "RanHeaderWindowController.h"

#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"

#import "INPopoverController.h"
#import "RanHeaderViewController.h"


@interface RanMainViewController ()<NSTableViewDataSource,NSTabViewDelegate,NSTextViewDelegate,ranDragFileDlegate,resendDelegate>

@property (weak) IBOutlet NSView *leftMainBar;

@property (weak) IBOutlet RanLastTalkTableView *ranLastTalkTableView;
@property (weak) IBOutlet RanDragTableView *detialChatTableView;

@property (weak) IBOutlet NSView *sendCoverView;

@property (weak) IBOutlet NSView *rightView;


@property(nonatomic, strong)NSMutableArray *lasttalkArray;
@property(nonatomic, strong)NSMutableArray *detialArray;

@property (nonatomic,strong) NSPopover *popover;

@property (weak) IBOutlet NSLayoutConstraint *rightBarSide;

@property (nonatomic, strong)INPopoverController *popoverController;

@end

@implementation RanMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 头像弹窗
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    RanHeaderViewController *headerViewController = [storyboard instantiateControllerWithIdentifier:@"headerinside"];
    self.popoverController = [[INPopoverController alloc] initWithContentViewController:headerViewController];
    self.popoverController.closesWhenApplicationBecomesInactive = YES;
    // Do view setup here.
    self.leftMainBar.wantsLayer = YES;
    self.leftMainBar.layer.backgroundColor = [NSColor colorWithSRGBRed:31 / 255.0 green:140 / 255.0 blue:235 / 255.0 alpha:1].CGColor;
    
//    self.ranLastTalkTableView.allowsMultipleSelection = YES;
    
    RanLastTalkHeaderCell *headerCell = [[RanLastTalkHeaderCell alloc] init];
    headerCell.stringValue = @"";
    self.ranLastTalkTableView.tableColumns[0].headerCell = headerCell;
    self.ranLastTalkTableView.rowHeight = 80;
    
    NSTableHeaderView *header = self.ranLastTalkTableView.headerView;
    NSView *searchView = [[NSView alloc] init];
    searchView.frame = CGRectMake(0, 0, header.frame.size.width, header.frame.size.height);
    searchView.wantsLayer = YES;
    searchView.layer.backgroundColor = [NSColor redColor].CGColor;
    [header addSubview:searchView];
    NSRect rect = header.frame;
    header.frame = NSMakeRect(rect.origin.x, rect.origin.y, rect.size.width, 54);
    header.layer.backgroundColor = [NSColor grayColor].CGColor;
    
    // 最近通话数组
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"lasttalklist" ofType:@"plist"];
    NSArray *modalArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    self.lasttalkArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *modalDic in modalArray) {
        RanLastMessageModal *modal = [RanLastMessageModal initWithPlist:modalDic];
        [self.lasttalkArray addObject:modal];
    }
    [self.ranLastTalkTableView reloadData];
    
    // 聊天详情
    NSBundle *detialbundle = [NSBundle mainBundle];
    NSString *detialplistPath = [detialbundle pathForResource:@"detialtalk" ofType:@"plist"];
    NSArray *detialmodalArray = [[NSArray alloc] initWithContentsOfFile:detialplistPath];
    self.detialArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *modalDic in detialmodalArray) {
        RanLastMessageModal *modal = [RanLastMessageModal initWithPlist:modalDic];
        [self.detialArray addObject:modal];
    }

    
    // 拖拽代理
//    self.detialChatTableView.dragDelegate = self;
    self.detialChatTableView.usesAutomaticRowHeights = YES;
    [self.detialChatTableView reloadData];
    [self.detialChatTableView scrollRowToVisible:self.detialArray.count - 1];
    
    // 右键删除菜单
    NSMenu *ranMenu = [[NSMenu alloc] init];
    NSMenuItem *item1 = [[NSMenuItem alloc] initWithTitle:@"xx" action:@selector(playMusic:) keyEquivalent:@""];
    NSMenuItem *item2 = [[NSMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteRow:) keyEquivalent:@""];
    NSMenuItem *item3 = [[NSMenuItem alloc] initWithTitle:@"xxx" action:@selector(playNextMusic:) keyEquivalent:@""];
    [item1 setTarget:self];
    [item2 setTarget:self];
    [item3 setTarget:self];
    [ranMenu addItem:item1];
    [ranMenu addItem:[NSMenuItem separatorItem]];
    [ranMenu addItem:item2];
    [ranMenu addItem:[NSMenuItem separatorItem]];
    [ranMenu addItem:item3];
    self.ranLastTalkTableView.menu = ranMenu;
    
    self.detialChatTableView.allowsMultipleSelection = YES;
    [self.detialChatTableView setColumnAutoresizingStyle:NSTableViewUniformColumnAutoresizingStyle];
        //最后一行自动宽等比增减
    //    [self.treeView sizeLastColumnToFit];
    //app第一次运行Column 自动宽等比增减，否则会有滚动条
    [self.detialChatTableView sizeToFit];
    
    // 右侧sideBar
    self.rightView.wantsLayer = YES;
    self.rightView.layer.backgroundColor = [NSColor redColor].CGColor;
}



- (void)deleteRow:(id)sender {
    NSInteger rightClicked = [self.ranLastTalkTableView clickedRow];
    [self.lasttalkArray removeObjectAtIndex:rightClicked];
    [self.ranLastTalkTableView reloadData];
}

- (void)dragMoveIn {
    self.sendCoverView.wantsLayer = YES;
    self.sendCoverView.layer.backgroundColor = [NSColor grayColor].CGColor;
//    self.sendCoverView.hidden = NO;
}

- (void)dragMoveOut {
    
//    self.sendCoverView.hidden = YES;
}

- (void)dragDown:(NSArray *)files {
    NSLog(@"%@",files);
    
    for (NSString *imageStr in files) {
        RanLastMessageModal *modal = [RanLastMessageModal new];
        modal.name = @"aaa";
        modal.time = @"sdsd";
        modal.content = imageStr;
        NSImage *ttimage = [[NSImage alloc] initWithContentsOfFile:imageStr];
        modal.imageWidth = [NSString stringWithFormat:@"%f",ttimage.size.width];
        modal.imageHeight = [NSString stringWithFormat:@"%f",ttimage.size.height];
        CGFloat width = ttimage.size.width;
        CGFloat height = ttimage.size.height;
        if (width > 280) {
            height = height / (width / 280);
            width = 280;
        }
        modal.contentHeight = height + 20;
        modal.contentWidth =  width;
        modal.mediaType = 1;
        modal.messageType = 1;
        [self.detialArray addObject:modal];
    }
    [self.detialChatTableView reloadData];
    [self.detialChatTableView scrollRowToVisible:self.detialArray.count - 1];
}


#pragma mark NSTableView DataSource Delegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (tableView == self.ranLastTalkTableView) {
        return self.lasttalkArray.count;
    } else {
        return self.detialArray.count;
    }
    
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if (tableView == self.ranLastTalkTableView) {
        NSString *strIdt = @"123";
        RanContactCell *cell = [tableView makeViewWithIdentifier:strIdt owner:self];
        cell.modal = self.lasttalkArray[row];
        return cell;
    } else {
        RanChatDetialCell *cell = [tableView makeViewWithIdentifier:@"cell" owner:self];
        cell.delegate = self;
        cell.modal = self.detialArray[row];
        return cell;
    }
}

//指定自定义的行
- (nullable NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
    if (tableView == self.ranLastTalkTableView) {
        RanContactRowView *rowView = [tableView makeViewWithIdentifier:@"rowView" owner:self];
        if (!rowView) {
            rowView = [[RanContactRowView alloc] init];
            rowView.identifier = @"rowView";
        }
        return rowView;
    } else {
        return nil;
    }
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    if (tableView == self.ranLastTalkTableView) {
        return YES;
    } else {
        return NO;
    }

}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {


}

- (void)drawContextMenuHighlightForRow:(NSInteger)row {

}

// 弹出聊天窗口
- (IBAction)videoChatClick:(NSButton *)sender {
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    RanVideoChatWindow *imWindowController = [storyboard instantiateControllerWithIdentifier:@"video"];
    [imWindowController showWindow:nil];
    
}

- (BOOL)textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector {
    // 回车
    if (commandSelector == @selector(insertNewline:)) {
        RanLastMessageModal *modal = [RanLastMessageModal new];
        modal.name = textView.string;
        modal.time = @"sdsd";
        modal.content = [NSMutableString stringWithString:textView.string];;
        modal.mediaType = 0;
        modal.messageType = 1;
        [self.detialArray addObject:modal];
        [self.detialChatTableView reloadData];
        [self.detialChatTableView scrollRowToVisible:self.detialArray.count - 1];
        textView.string = @"";
        [self.detialArray enumerateObjectsUsingBlock:^(RanLastMessageModal *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.time isEqualToString:@"sdsd"]) {
                obj.sendStatus = FailStatus;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   [self.detialChatTableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:idx]
                         columnIndexes:[NSIndexSet indexSetWithIndex:0]];
                });
 
            }
        }];
        return YES;
    } else if (commandSelector == @selector(deleteBackward:)) {
        //Do something against DELETE key
        if (textView.string.length == 0) {
            return YES;
        }
        
        NSMutableString *finalStr = [NSMutableString stringWithString:textView.string];
        NSRange deleteRange = {[finalStr length] - 1, 1};
        
        [finalStr deleteCharactersInRange:deleteRange];
        
        textView.string = finalStr;
        NSLog(@"%@",textView.string);
        return YES;
        
    } else if (commandSelector == @selector(insertTab:)) {
        //Do something against TAB key
        NSLog(@"%@",textView.string);
        
        return YES;
    }
    return YES;
}


- (void)resendWith:(nonnull RanLastMessageModal *)modal {
    [self.detialArray enumerateObjectsUsingBlock:^(RanLastMessageModal *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               if (obj == modal) {
                   obj.sendStatus = SendingStatus;
                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                      [self.detialChatTableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:idx]
                            columnIndexes:[NSIndexSet indexSetWithIndex:0]];
                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                           obj.sendStatus = SuccessStatus;
                          [self.detialChatTableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:idx]
                                columnIndexes:[NSIndexSet indexSetWithIndex:0]];
                       });
                   });
    
               }
           }];
    
}

- (IBAction)showEmotionClick:(NSButton *)sender {
    
    NSViewController *vc = [[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"ranPage"];
    
    self.popover.contentViewController = vc;
    [self.popover showRelativeToRect:sender.bounds ofView:sender preferredEdge:NSRectEdgeMaxY];
    
    NSView *popoverView = [[vc view] superview];
    [popoverView setWantsLayer:YES];
    [[popoverView layer] setBackgroundColor:[NSColor whiteColor].CGColor];
}

-(NSPopover *)popover {
    if (!_popover) {
        _popover = [[NSPopover alloc]init];
        _popover.behavior = NSPopoverBehaviorTransient;
        _popover.contentSize = NSMakeSize(400, 300);
        _popover.animates = NO;
    }
    return _popover;
}

- (IBAction)headerClick:(NSButton *)sender {
    if (self.popoverController.popoverIsVisible) {
        [self.popoverController closePopover:nil];
    } else {
        [self.popoverController presentPopoverFromRect:[sender bounds] inView:sender preferredArrowDirection:INPopoverArrowDirectionRight anchorsToPositionView:YES];
    }
    
}

- (IBAction)morePeopleClick:(NSButton *)sender {
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    NSWindowController *imWindowController = [storyboard instantiateControllerWithIdentifier:@"morePeople"];
    [self.view.window beginSheet:imWindowController.window completionHandler:^(NSModalResponse returnCode) {
      
    }];
}

- (IBAction)showRightSideClick:(NSButton *)sender {
    
//    NSAnimationContext.runAnimationGroup({ (context) in
//        context.duration = 0.3
//      context.timingFunction = CAMediaTimingFunction(name: .easeIn)
//      sideBarRightConstraint.animator().constant = 0
//    }) {
//      self.sidebarAnimationState = .shown
//      self.sideBarStatus = type
//    }
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        context.duration = 0.2;
        context.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
        if (self.rightBarSide.constant == 0) {
            [self.rightBarSide animator].constant = 200;
        } else {
            [self.rightBarSide animator].constant = 0;
        }
    }];
}

- (void)mouseUp:(NSEvent *)event {
    [self.rightBarSide animator].constant = 0;
}

@end
