//
//  CHAgentCollectionViewCell.m
//  Channel
//
//  Created by Apisit Toompakdee on 4/3/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHAgentCollectionViewCell.h"

@implementation CHAgentCollectionViewCell

- (void)setupView{
    self.titleLabel.text = self.agent.name;
}
-(void)setAgent:(CHAgent *)agent{
    _agent = agent;
    [self setupView];
}

@end
