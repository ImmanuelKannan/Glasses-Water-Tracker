//
//  StatsViewController.m
//  Glasses Water Tracker
//
//  Created by Immanuel Kannan on 24/06/2017.
//  Copyright © 2017 Immanuel Kannan. All rights reserved.
//

#import "StatsViewController.h"
#import "BarGraphView.h"
#import "BarGraphCollectionViewCell.h"
#import "Constants.h"

@interface StatsViewController () < UICollectionViewDelegateFlowLayout, UICollectionViewDataSource >

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) BarGraphView *barGraph;

@end

@implementation StatsViewController

- (instancetype)init {
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup];
    
}

#pragma mark - Setup Methods

- (void)setup {
    
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    [self setupScrollView];
    [self setupBarGraph];
    
}

- (void)setupScrollView {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height + 200);
    [self.view addSubview:self.scrollView];
    
}

- (void)setupBarGraph {
    
    self.barGraph = [[BarGraphView alloc] init];
    self.barGraph.backgroundColor = [UIColor redColor];
    self.barGraph.translatesAutoresizingMaskIntoConstraints = FALSE;
    [self.scrollView addSubview:self.barGraph];
    
    [self.barGraph.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor multiplier:1].active = true;
    [self.barGraph.heightAnchor constraintEqualToAnchor:self.scrollView.heightAnchor multiplier:.45].active = true;
    [self.barGraph.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor].active = true;
    [self.barGraph.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor constant:10].active = true;
    
    self.barGraph.barGraphCollectionView.delegate = self;
    self.barGraph.barGraphCollectionView.dataSource = self;
    
    self.barGraph.barGraphCollectionView.scrollEnabled = FALSE;
    
}

#pragma mark - Bar Graph Delegate & Data Source Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BarGraphCollectionViewCell *cell = [self.barGraph.barGraphCollectionView dequeueReusableCellWithReuseIdentifier:kProgressBarCellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor purpleColor];
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.barGraph.barGraphCollectionView.bounds.size.width / 7) - 10, self.barGraph.barGraphCollectionView.bounds.size.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 5, 0, 5);
}

@end
