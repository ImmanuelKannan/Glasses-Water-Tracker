//
//  BarGraphView.m
//  Glasses Water Tracker
//
//  Created by Immanuel Kannan on 24/06/2017.
//  Copyright © 2017 Immanuel Kannan. All rights reserved.
//

#import "BarGraphView.h"
#import "BarGraphCollectionViewCell.h"
#import "Constants.h"

@implementation BarGraphView

- (instancetype)init {
    if (self = [super init]) {
        
        [self setup];
        
    }
    
    return self;
}

- (void)setup {
    
    [self setupBarGraphCollectionView];
    
}

- (void)setupBarGraphCollectionView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    self.barGraphCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.barGraphCollectionView.backgroundColor = [UIColor orangeColor];
    self.barGraphCollectionView.translatesAutoresizingMaskIntoConstraints = FALSE;
    [self addSubview:self.barGraphCollectionView];
    
    [self.barGraphCollectionView.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = true;
    [self.barGraphCollectionView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:.85].active = true;
    [self.barGraphCollectionView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = true;
    [self.barGraphCollectionView.topAnchor constraintEqualToAnchor:self.topAnchor].active = true;
    
    [self.barGraphCollectionView registerClass:[BarGraphCollectionViewCell class] forCellWithReuseIdentifier:kProgressBarCellIdentifier];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
