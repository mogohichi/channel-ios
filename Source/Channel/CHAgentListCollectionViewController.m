//
//  CHAgentListCollectionViewController.m
//  Channel
//
//  Created by Apisit Toompakdee on 4/3/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHAgentListCollectionViewController.h"
#import "CHAgentCollectionViewCell.h"
#import "CHAgent.h"

@interface CHAgentListCollectionViewController ()

@end

@implementation CHAgentListCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

-(void)setAgents:(NSArray *)agents{
    _agents = agents;
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.agents.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CHAgentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    CHAgent* agent = [self.agents objectAtIndex:indexPath.row];
    cell.agent = agent;
    if (agent.imageUrl != nil){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:agent.imageUrl]];
            dispatch_async(dispatch_get_main_queue(), ^{
                CHAgentCollectionViewCell *toUpdateCell = (CHAgentCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
                if (toUpdateCell != nil) {
                    toUpdateCell.imageView.image = [UIImage imageWithData:data];
                }
            });
        });
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(60.0, 70.0);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section{
    CGFloat totalCellWidth = 60.0 * self.agents.count;
    
    CGFloat totalSpacingWidth = 0;// 10.0 * (self.agents.count - 1);
    
    CGFloat leftInset = (self.collectionView.bounds.size.width - (totalCellWidth + totalSpacingWidth)) / 2.0;
    CGFloat rightInset = leftInset;
    
    return UIEdgeInsetsMake(0, leftInset, 0, rightInset);
}
@end
