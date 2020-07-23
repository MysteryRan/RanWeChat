//
//  RanEmotionViewController.m
//  RanWeChat
//
//  Created by zouran on 2020/7/22.
//  Copyright © 2020 ran. All rights reserved.
//

#import "RanEmotionViewController.h"
#import "RanEmotionItem.h"

@interface RanEmotionViewController ()<NSCollectionViewDataSource,NSCollectionViewDelegate,NSCollectionViewDelegateFlowLayout>

@property (weak) IBOutlet NSCollectionView *collectionView;

@end

@implementation RanEmotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self.collectionView registerNib:[[NSNib alloc] initWithNibNamed:@"RanEmotionItem" bundle:nil] forItemWithIdentifier:@"cell"];
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {

}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    RanEmotionItem *item = [collectionView makeItemWithIdentifier:@"cell" forIndexPath:indexPath];
    item.titleLabel.stringValue = self.dataSource[indexPath.item];
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
