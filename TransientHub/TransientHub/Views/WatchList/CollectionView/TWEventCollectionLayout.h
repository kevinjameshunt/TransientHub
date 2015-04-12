//
//  TWEventCollectionLayout.h
//
//  Created by Kevin Hunt on 2015-04-08.
//  Copyright (c) 2015 ProphetStudios. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Defines the method used by TWEventCollectionLayout for calculating the 
 * layout attributes for the Collection View. 
 * 
 * DO NOT set to prelayout if the collection view uses headers; "sticky" headers
 * require constant layout re-calculations and this will result in horrible performance.
 */
typedef NS_ENUM(NSUInteger, TWEventCollectionLayoutMode) {
    TWEventCollectionLayoutModePrelayout, /**< Instructs the layout to pre-calculate positioning for all elements in the datasource. */
    TWEventCollectionLayoutModeBatch /**< Instructs the layout to calculate position for a limited number of elements. */
};

@protocol TWEventCollectionLayoutDelegate <UICollectionViewDelegate>
@required
/**
 * Provides the grid-unit size expected for the item at the given index path.
 *
 * @param indexPath the index path of the collection view item being processed
 * @return a CGSize in grid-units representing the size of the item
 */
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 * Provides the number of tiles to fit along the fixed axis for the given scroll direction. For 
 * horizontal scrolling, this specifies the number of tiles that will precisely fit along the vertical axis.
 * For vertical scrolling, this specifies the number of tiles that will precisely fit along the horizontal 
 * axis.
 * 
 * @param scrollDirection the scroll direction of the collection view
 * @return NSUInteger specifying how many tiles should fit
 */
- (NSUInteger)numberOfTilesToFitForScrollDirection:(UICollectionViewScrollDirection)scrollDirection;
@optional

/**
 * Provides the insets/margins for the section at the given index.
 *
 * @param sectionIndex the index of the section for which edge insets are being requested
 * @return UIEdgeInsets specifying the inset values for the section
 */
- (UIEdgeInsets)insetsForSectionAtIndex:(NSUInteger)sectionIndex;

/**
 * Provides the insets/margins for the UICollectionViewCell at the given index path.
 *
 * @param indexPath the index path of the cell item for which insets will be provided
 * @return UIEdgeInsets specifying the inset values for the cell item
 */
- (UIEdgeInsets)insetsForItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 * Returns the intended size of the section footer view.
 * 
 * @return CGSize containing the width and height of the footer view
 */
- (CGSize)sizeForFooterView;

/**
 * Returns the intended size of the section header view.
 *
 * @return CGSize containing the width and height of the header view
 */
- (CGSize)sizeForHeaderView;

/**
 * Return the aspect ratio used to determine the pixel/point-size of grid tiles.
 *
 * @return CGSize specifying an aspect ratio
 */
- (CGSize)tileSizeAspectRatio;

/** 
 * Returns the minimum possible size of the section header view, used when the section header
 * is compressing due to horizontal scrolling.
 * 
 * @param indexPath the index path for the section being inspected
 
 */
- (CGSize)minimumSizeForHeaderViewAtIndexPath:(NSIndexPath *)indexPath;

/**
 * Informs the delegate that a header at the index path did snap to the contentView origin.
 * 
 * @param indexPath the index path of the section header
 */
- (void)headerDidSnapAtIndexPath:(NSIndexPath *)indexPath;

- (void)headerDidUnsnapAtIndexPath:(NSIndexPath *)indexPath;
/** 

 * Specifies the point that is considered the "snap" origin. If no value is set, the layout
 * assumes the snap origin is the contentOffset of the CollectionView.
 * 
 * @return CGPoint to be considered as the snap point for the header
 */
- (CGPoint)snapPointForHeader;

/**
 * Specifies the point that is considered the "UNsnap" origin. If no value is set, the layout
 * assumes the unsnap origin is the contentOffset of the CollectionView.
 *
 * @return CGPoint to be considered as the unsnap point for the header
 */
- (CGPoint)unsnapPointForHeader;

@end

/**
 * Provides a grid-style layout that enables UICollectionViewCell items to occupy more than one tile on the
 * grid.
 */
@interface TWEventCollectionLayout : UICollectionViewLayout

/** Specifies the actual pixel-size of each tile in the grid */
@property (nonatomic, readonly) CGSize tileSize;

/** Specifies the scroll direction for the grid, also the direction in which new cells will be added */
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

/** Specifies the delegate that implements the TWEventCollectionLayoutDelegate protocol */
@property (nonatomic, weak) IBOutlet id<TWEventCollectionLayoutDelegate> delegate;

/** Specifies the insets for all sections, referred to if the delegate for the layout does not specify section insets via collectionView:layout:insetForSectionAtIndex: */
@property (nonatomic, assign) UIEdgeInsets sectionInset;

/** Specifies the insets for all items, referred to if the delegate for the layout does not specify inset insets via collectionView:layout:insetForItemAtIndex:inSection: */
@property (nonatomic, assign) UIEdgeInsets itemInset;

/** Defines the method used to calculate the layout attributes for the collection view. */
@property (nonatomic, assign) TWEventCollectionLayoutMode layoutMode;

@end
