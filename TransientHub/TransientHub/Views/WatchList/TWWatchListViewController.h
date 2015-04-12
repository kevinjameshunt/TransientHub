//
//  TWWatchListViewController.h
//  TransientHub
//
//  Created by Kevin Hunt on 2015-04-08.
//  Copyright (c) 2015 ProphetStudios. All rights reserved.
//

#import "TWBaseFeedViewController.h"
#import "TWBaseEventViewController.h"
#import "TWEventCollectionLayout.h"

#define SMALL_BLOCK_SIZE CGSizeMake(1, 1)
#define MEDIUM_BLOCK_SIZE CGSizeMake(2, 2)
#define LARGE_BLOCK_SIZE ((DEVICE_IS_IPAD) ? CGSizeMake(kNumberOfTilesForHorizontalLayoutForiPad, kNumberOfTilesForHorizontalLayoutForiPad) : MEDIUM_BLOCK_SIZE)
#define DELTA (MEDIUM_BLOCK_SIZE.width * MEDIUM_BLOCK_SIZE.height) - (SMALL_BLOCK_SIZE.width * SMALL_BLOCK_SIZE.height)

extern NSUInteger const kNumberOfTilesForHorizontalLayoutForiPad;
extern NSUInteger const kNumberOfTilesForHorizontalLayoutForiPhone;
extern NSUInteger const kNumberOfTilesForVerticalLayoutForiPad;
extern NSUInteger const kNumberOfTilesForVerticalLayoutForiPhone;


@interface TWWatchListViewController : TWBaseFeedViewController <UICollectionViewDataSource, UICollectionViewDelegate, TWEventCollectionLayoutDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *contentItems;
@property (nonatomic, strong) NSMutableDictionary *sectionHeaders;
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirectionForLandscapeOrientation;
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirectionForPortraitOrientation;
@property (nonatomic, assign) UICollectionViewScrollDirection currentScrollDirection;
@property (nonatomic, strong) NSDictionary *headerFontAttributes;

- (TWBaseEventViewController *)eventViewControllerAtIndexPath:(NSIndexPath *)indexPath;


@end
