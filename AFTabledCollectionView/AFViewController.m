//
//  AFViewController.m
//  AFTabledCollectionView
//
//  Created by Ash Furrow on 2013-03-14.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFViewController.h"
#import "AFIndexedCollectionView.h"
#import "AFTableViewCell.h"

@interface AFViewController ()

@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionary;

@end

@implementation AFViewController

-(void)loadView
{
    [super loadView];
    
    const NSInteger numberOfTableViewRows = 20;
    const NSInteger numberOfCollectionViewCells = 15;
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:numberOfTableViewRows];
    
    for (NSInteger tableViewRow = 0; tableViewRow < numberOfTableViewRows; tableViewRow++)
    {
        NSMutableArray *colorArray = [NSMutableArray arrayWithCapacity:numberOfCollectionViewCells];
        
        for (NSInteger collectionViewItem = 0; collectionViewItem < numberOfCollectionViewCells; collectionViewItem++)
        {
            
            CGFloat red = arc4random() % 255;
            CGFloat green = arc4random() % 255;
            CGFloat blue = arc4random() % 255;
            UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0f];
            
            [colorArray addObject:color];
        }
        
        [mutableArray addObject:colorArray];
    }
    
    self.colorArray = [NSArray arrayWithArray:mutableArray];
    
    self.contentOffsetDictionary = [NSMutableDictionary dictionary];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.colorArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    AFTableViewCell *cell = (AFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[AFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
        
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(AFTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setCollectionViewDataSourceDelegate:self index:indexPath.row];
    NSInteger index = cell.collectionView.index;
    
    CGFloat horizontalOffset = [self.contentOffsetDictionary[[@(index) stringValue]] floatValue];
    [cell.collectionView setContentOffset:CGPointMake(horizontalOffset, 0)];
}

#pragma mark - UITableViewDelegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(AFIndexedCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *collectionViewArray = self.colorArray[collectionView.index];
    return collectionViewArray.count;
}

-(UICollectionViewCell *)collectionView:(AFIndexedCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    
    NSArray *collectionViewArray = self.colorArray[collectionView.index];
    cell.backgroundColor = collectionViewArray[indexPath.item];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![scrollView isKindOfClass:[AFIndexedCollectionView class]]) return;
    
    CGFloat horizontalOffset = scrollView.contentOffset.x;
    
    AFIndexedCollectionView *collectionView = (AFIndexedCollectionView *)scrollView;
    NSInteger index = collectionView.index;
    self.contentOffsetDictionary[[@(index) stringValue]] = @(horizontalOffset);
}

@end
