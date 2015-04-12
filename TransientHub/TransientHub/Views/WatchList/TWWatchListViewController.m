//
//  TWWatchListViewController.m
//  TransientHub
//
//  Created by Kevin Hunt on 2015-04-08.
//  Copyright (c) 2015 ProphetStudios. All rights reserved.
//

#import "TWWatchListViewController.h"
#import "TWEventBaseCell.h"
#import "TWEventCollectionLayout.h"
#import "AppDelegate.h"
#import "TWDataManager.h"
#import "TWCRTSEvent.h"

static NSString * const kEventReusableCellIdentifier          = @"TWEventBaseCell";

@interface TWWatchListViewController ()

@end

NSUInteger const kNumberOfTilesForHorizontalLayoutForiPad = 3;
NSUInteger const kNumberOfTilesForHorizontalLayoutForiPhone = 1;
NSUInteger const kNumberOfTilesForVerticalLayoutForiPad = 3;
NSUInteger const kNumberOfTilesForVerticalLayoutForiPhone = 3;

@implementation TWWatchListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self commonInit];
}

- (void)commonInit {
    [self.collectionView registerNib:[UINib nibWithNibName:@"TWEventBaseCell" bundle:nil] forCellWithReuseIdentifier:kEventReusableCellIdentifier];
    [self.collectionView registerClass:[TWEventBaseCell class] forCellWithReuseIdentifier:kEventReusableCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *) getSegueID{
    return @"watchListSegue";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setAppearance];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _eventItems = [[TWDataManager sharedDataManager] getSampleFeedData];
    
    [self configureLayoutForOrientation:self.interfaceOrientation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self configureLayoutForOrientation:self.interfaceOrientation];
}

- (TWBaseEventViewController *)eventViewControllerAtIndexPath:(NSIndexPath *)indexPath {
    //TODO: fix
    return nil;
}

#pragma mark - Initialization

- (void)setAppearance {
    [[UICollectionView appearance] setBackgroundColor:[UIColor clearColor]];
    [[TWEventBaseCell appearance] setBackgroundColor:[UIColor blackColor]];
    
    self.sectionHeaders = [NSMutableDictionary dictionary];
    
    self.scrollDirectionForLandscapeOrientation = UICollectionViewScrollDirectionHorizontal;
    self.scrollDirectionForPortraitOrientation = UICollectionViewScrollDirectionVertical;
}

/**
 * Calculates the necessary parameters required for the CollectionViewLayout to perform
 * its layout operations.
 */
- (void)configureLayoutForOrientation:(UIInterfaceOrientation)orientation {
    TWEventCollectionLayout *layout = (id)[self.collectionView collectionViewLayout];
    layout.layoutMode = TWEventCollectionLayoutModeBatch;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.currentScrollDirection = self.scrollDirectionForLandscapeOrientation;
    } else {
        self.currentScrollDirection = self.scrollDirectionForPortraitOrientation;
    }
    layout.scrollDirection = self.currentScrollDirection;
    [self.collectionView reloadData];
}

- (TWEventBaseCell *)configureItemCellAtIndexPath:(NSIndexPath *)indexPath forCollectionView:(UICollectionView *)collectionView {
    TWEventBaseCell *cell = (TWEventBaseCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kEventReusableCellIdentifier forIndexPath:indexPath];
    
    TWCRTSEvent *event = _eventItems[indexPath.row];
    
    [cell setImageURL:event.refImgUrl];
    cell.title.text = [NSString stringWithFormat:@"%f",event.magnitude];
    
    return cell;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_eventItems) {
        return [_eventItems count];
    } else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TWEventBaseCell *cell = nil;
    cell = [self configureItemCellAtIndexPath:indexPath forCollectionView:collectionView];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: create details page

}


#pragma mark - TWEventCollectionLayoutDelegate

- (UIEdgeInsets)insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(0, 0, 7, 7);
}

- (NSUInteger)numberOfTilesToFitForScrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    if (DEVICE_IS_IPAD) {
        if (scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            return kNumberOfTilesForHorizontalLayoutForiPad;
        } else {
            return kNumberOfTilesForVerticalLayoutForiPad;
        }
    } else {
        if (scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            return kNumberOfTilesForHorizontalLayoutForiPhone;
        } else {
            return kNumberOfTilesForVerticalLayoutForiPhone;
        }
    }
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return (indexPath.section == 0) ? LARGE_BLOCK_SIZE : MEDIUM_BLOCK_SIZE;
    } else {
        return SMALL_BLOCK_SIZE;
    }
}

- (CGSize)sizeForHeaderView {
    return CGSizeMake(self.collectionView.frame.size.width, 0);
}

- (CGSize)tileSizeAspectRatio {
    return CGSizeMake(13.0f, 19.0f);
}

@end
