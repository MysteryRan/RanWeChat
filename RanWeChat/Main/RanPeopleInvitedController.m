//
//  RanPeopleInvitedController.m
//  RanWeChat
//
//  Created by zouran on 2020/7/28.
//  Copyright © 2020 ran. All rights reserved.
//

#import "RanPeopleInvitedController.h"
#import "RanInvitedCell.h"
#import "RanLastMessageModal.h"
#import "RanContactRowView.h"
#import "RanInvitedItem.h"

@interface RanPeopleInvitedController ()<NSTabViewDelegate,NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *invitedTableView;
@property (weak) IBOutlet NSCollectionView *collectionView;

@property(nonatomic, strong)NSMutableArray *friends;

@property(nonatomic, strong)NSMutableArray *selectedFriends;

@end

@implementation RanPeopleInvitedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.invitedTableView.rowHeight = 80;
    self.invitedTableView.allowsMultipleSelection = YES;
    self.invitedTableView.allowsEmptySelection = YES;
    
    // 最近通话数组
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"friends" ofType:@"plist"];
    NSArray *modalArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    self.friends = [NSMutableArray arrayWithCapacity:0];
    self.selectedFriends = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *modalDic in modalArray) {
        RanLastMessageModal *modal = [RanLastMessageModal initWithPlist:modalDic];
        if ([modal.name isEqualToString:@"ccc"]) {
            modal.isSelected = YES;
            [self.selectedFriends addObject:modal];
        }
        [self.friends addObject:modal];
    }
    [self.invitedTableView reloadData];
    
    
    [self.collectionView registerNib:[[NSNib alloc] initWithNibNamed:@"RanInvitedItem" bundle:nil] forItemWithIdentifier:@"cell"];
    [self.collectionView reloadData];
}

#pragma mark NSTableView DataSource Delegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.friends.count;
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    RanInvitedCell *cell = [tableView makeViewWithIdentifier:@"invited" owner:self];
    cell.modal = self.friends[row];
    cell.action = ^(RanLastMessageModal * _Nonnull modal) {
        modal.isSelected = !modal.isSelected;
        if (modal.isSelected) {
            [self.selectedFriends addObject:modal];
            [tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:YES];
            [self.collectionView reloadData];
        } else {
            [tableView deselectRow:row];
            [self.selectedFriends removeObject:modal];
            [self.collectionView reloadData];
        }
        
        [tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:row] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
    };
    return cell;
}

- (nullable NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
    RanContactRowView *rowView = [tableView makeViewWithIdentifier:@"rowView" owner:self];
    if (!rowView) {
        rowView = [[RanContactRowView alloc] init];
        rowView.identifier = @"rowView";
    }
    return rowView;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
//    NSLog(@"------%ld",(long)row);
//    RanLastMessageModal *modal = self.friends[row];
//    modal.isSelected = !modal.isSelected;
//    [tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:row] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
//    return YES;
    return NO;

}

//选择的东西
//- (NSIndexSet *)tableView:(NSTableView *)tableView selectionIndexesForProposedSelection:(NSIndexSet *)proposedSelectionIndexes {
//    return [NSIndexSet indexSetWithIndex:2];
//}


- (void)tableViewSelectionDidChange:(NSNotification *)notification {
//    NSLog(@"%@",notification.ob);
//    NSLog(@"%@",notification.object)
//    NSTableView *tableView = notification.object;

}

- (IBAction)invitedClick:(NSButton *)sender {
    [self.view.window.sheetParent endSheet:self.view.window returnCode:NSModalResponseCancel];
}

- (IBAction)cancelClick:(NSButton *)sender {
    [self.view.window.sheetParent endSheet:self.view.window returnCode:NSModalResponseCancel];
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectedFriends.count;
}

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {

}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    RanInvitedItem *item = [collectionView makeItemWithIdentifier:@"cell" forIndexPath:indexPath];
    RanLastMessageModal *modal = self.selectedFriends[indexPath.item];
    item.modal = modal;
    item.action = ^(RanLastMessageModal * _Nonnull modal) {
        [self.selectedFriends removeObject:modal];
        if (modal.isSelected) {
            modal.isSelected = FALSE;
        }
        [collectionView reloadData];
        [self.invitedTableView reloadData];
    };
    return item;
}


- (NSSize)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return NSMakeSize(collectionView.frame.size.width / 5, collectionView.frame.size.width / 5);
}

- (CGFloat)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MIN;
}

@end
