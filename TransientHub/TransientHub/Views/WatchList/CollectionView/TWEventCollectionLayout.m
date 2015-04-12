//
//  TWEventCollectionLayout.m
//
//  Created by Kevin Hunt on 2015-04-08.
//  Copyright (c) 2015 ProphetStudios. All rights reserved.
//

#import "TWEventCollectionLayout.h"

@interface TWEventCollectionLayout() {
}

/** The first unoccupied tile on the grid */
@property (nonatomic, assign) CGPoint firstOpenTile;
/** The farthest tile on the grid */
@property (nonatomic, assign) CGPoint farthestTilePoint;
/** Dictionary that represents each tile on the grid, storing the index path for UICollectionViewDataSource item occupying that tile */
@property (nonatomic, strong) NSMutableDictionary *indexPathByPosition;
/** Dictionary that stores the origin point on the tile grid for each UICollectionViewDataSource item, indexed by [section][row] */
@property (nonatomic, strong) NSMutableDictionary *positionByIndexPath;
/** Previous layout attributes, used when caching between layoutAttributesForElementInRect on each scroll event */
@property (nonatomic, strong) NSArray* previousLayoutAttributes;
/** Previous layout rect, used when caching between layoutAttributesForElementInRect on each scroll event */
@property (nonatomic, assign) CGRect previousLayoutRect;
/** The last index path placed successfully, used to prevent repetition when calling layout methods on each scroll event */
@property (nonatomic, strong) NSIndexPath *lastIndexPathPlaced;

@property(nonatomic, strong) NSMutableDictionary *headerAttributes;

@property (nonatomic, assign) CGSize tileSize;

@end

@implementation TWEventCollectionLayout

#pragma mark - Initialization

- (id)init {
    if ((self = [super init])) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _scrollDirection = UICollectionViewScrollDirectionVertical;
    _tileSize = CGSizeMake(50, 50);
    self.headerAttributes = [NSMutableDictionary dictionary];
}

#pragma mark - UICollectionViewLayout

- (void)prepareLayout {
    NSAssert(self.delegate, @"TWEventCollectionLayout requires a delegate");
    NSAssert([self.delegate conformsToProtocol:@protocol(TWEventCollectionLayoutDelegate)], @"TWEventCollectionLayout delegate must conform to TWEventCollectionLayoutDelegate protocol");
    
    [self calculateTileSize];
    
    // calculate the scrollable frame
    CGRect currentScrollFrame = CGRectMake(self.collectionView.contentOffset.x,
                                    self.collectionView.contentOffset.y,
                                    self.collectionView.frame.size.width,
                                    self.collectionView.frame.size.height);
    
    // determine the size of the area along the scrolling (unbounded) axis
    int maxTileIndex = 0;
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
        maxTileIndex = (CGRectGetMaxX(currentScrollFrame) / self.tileSize.width) + 1;
    else
        maxTileIndex = (CGRectGetMaxY(currentScrollFrame) / self.tileSize.height) + 1;
    // By default we will only layout what is found in the current frame of the view
    [self layoutTilesForSize:(self.layoutMode == TWEventCollectionLayoutModePrelayout ? INT_MAX : maxTileIndex)];
}

- (CGSize)collectionViewContentSize {
    // Calculate section insets
    CGFloat sectionInsetsSize = 0;
    CGFloat headerSize = 0;
    for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section++) {
        UIEdgeInsets sectionEdgeInsets = [self edgeInsetsForSectionAtIndex:section];
        sectionInsetsSize += [self isVerticalLayout] ? (sectionEdgeInsets.top + sectionEdgeInsets.bottom) : (sectionEdgeInsets.left + sectionEdgeInsets.right);
        headerSize += [self.delegate sizeForHeaderView].height;
    }
    // Calculate contentSize for collection view
    CGSize contentSize;
    if ([self isVerticalLayout]) {
        contentSize = CGSizeMake(self.collectionView.frame.size.width, (self.farthestTilePoint.y + 1) * self.tileSize.height + sectionInsetsSize + headerSize);
    } else {
        contentSize = CGSizeMake((self.farthestTilePoint.x + 1) * self.tileSize.width + sectionInsetsSize, self.collectionView.frame.size.height);
    }
    return contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSAssert(self.delegate, @"TWEventCollectionLayout requires a delegate");
    NSAssert([self.delegate conformsToProtocol:@protocol(TWEventCollectionLayoutDelegate)], @"TWEventLayout delegate must conform to TWEventCollectionLayoutDelegate protocol");
    
    if (CGRectEqualToRect(rect, self.previousLayoutRect)) {
        return self.previousLayoutAttributes;
    }
    self.previousLayoutRect = rect;
    
    BOOL isVerticalLayout = [self isVerticalLayout];
    
    int unboundedAxisStart = isVerticalLayout ? rect.origin.y / self.tileSize.height : rect.origin.x / self.tileSize.width;
    int unboundedAxisLength = (isVerticalLayout ? rect.size.height / self.tileSize.height : rect.size.width / self.tileSize.width) + 1;
    int unboundedAxisMax = unboundedAxisStart + unboundedAxisLength;
    
    [self layoutTilesForSize:unboundedAxisMax];
    
    // Find all indexPaths that would fall within the rect
    NSMutableSet* attributes = [NSMutableSet set];
    NSArray *indexPaths = [self indexPathsInRect:rect];
    for (NSIndexPath *indexPath in indexPaths) {
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    
    // Grab the sections for all of the indexpaths found in the rect (for headers/footers)
    NSMutableIndexSet *sectionIndexes = [NSMutableIndexSet indexSet];
    for (UICollectionViewLayoutAttributes *layoutAttributes in attributes) {
        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            [sectionIndexes addIndex:layoutAttributes.indexPath.section];
        }
    }
    [sectionIndexes enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        [attributes addObject:layoutAttributes];
		
    }];
    
    return (self.previousLayoutAttributes = [attributes allObjects]);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    // Create basic frame
    CGRect frame = [self frameForIndexPath:indexPath];
    // Offset frame if header is present
    CGSize headerSize = [self sizeForHeaderView];
    CGFloat sectionOffset = ([self isVerticalLayout]) ? (headerSize.height * (indexPath.section + 1)) : headerSize.height;
    frame.origin.y += sectionOffset;
    // Apply cell edge insets
    UIEdgeInsets cellInsets = [self edgeInsetsForItemAtIndexPath:indexPath];
    attributes.frame = UIEdgeInsetsInsetRect(frame, cellInsets);
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CGSize headerSize = [self sizeForHeaderView];
        attributes.frame = CGRectMake(0,
                                      0,
                                      headerSize.width,
                                      headerSize.height);
        
        NSInteger section = attributes.indexPath.section;
        NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
        
        NSIndexPath *firstCellIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        NSIndexPath *lastCellIndexPath = [NSIndexPath indexPathForItem:MAX(0, (numberOfItemsInSection - 1)) inSection:section];
        
        UICollectionViewLayoutAttributes *firstCellAttrs = [self layoutAttributesForItemAtIndexPath:firstCellIndexPath];
        UICollectionViewLayoutAttributes *lastCellAttrs = [self layoutAttributesForItemAtIndexPath:lastCellIndexPath];
        
        
        CGFloat headerWidth = CGRectGetMaxX(lastCellAttrs.frame) - CGRectGetMinX(firstCellAttrs.frame);
        CGFloat headerHeight = CGRectGetHeight(attributes.frame);
        CGPoint origin = attributes.frame.origin;
        origin.x = CGRectGetMinX(firstCellAttrs.frame);
        origin.y = CGRectGetMinY(firstCellAttrs.frame) - headerHeight - [self edgeInsetsForItemAtIndexPath:indexPath].top;
        attributes.zIndex = 1024;
        attributes.frame = (CGRect){
            .origin = origin,
            .size = CGSizeMake(headerWidth, headerHeight)
        };

//    CGPoint snapPoint = [self.delegate snapPointForHeader];
//        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
//            CGFloat headerHeight = CGRectGetHeight(attributes.frame);
//            CGPoint origin = attributes.frame.origin;
//            origin.y = MIN(MAX(snapPoint.y, (CGRectGetMinY(firstCellAttrs.frame) - headerHeight - [self edgeInsetsForItemAtIndexPath:indexPath].top)),
//                           (CGRectGetMaxY(lastCellAttrs.frame) - headerHeight));
//
//            origin.y = CGRectGetMinY(firstCellAttrs.frame) - headerHeight - [self edgeInsetsForItemAtIndexPath:indexPath].top;
//            
//            attributes.zIndex = 1024;
//            attributes.frame = (CGRect){
//                .origin = origin,
//                .size = attributes.frame.size
//            };
//        } else {
//            CGFloat headerWidth = MIN(// minimum between section and collectionview frame
//                                      MIN(CGRectGetMaxX(lastCellAttrs.frame) - CGRectGetMinX(firstCellAttrs.frame),
//                                          self.collectionView.frame.size.width
//                                          ),
//                                      MAX(CGRectGetMaxX(lastCellAttrs.frame) - snapPoint.x, [self.delegate minimumSizeForHeaderViewAtIndexPath:indexPath].width
//                                          ));
////            CGFloat headerWidth = CGRectGetMaxX(lastCellAttrs.frame) - CGRectGetMinX(firstCellAttrs.frame);
//            
//            CGPoint origin = attributes.frame.origin;
//            origin.x = MIN(CGRectGetMinX(firstCellAttrs.frame),
//                           CGRectGetMaxX(lastCellAttrs.frame) - headerWidth);
////            origin.x = CGRectGetMinX(firstCellAttrs.frame);
//            
//            attributes.zIndex = 1024;
//            attributes.frame = (CGRect){
//                .origin = origin,
//                .size = CGSizeMake(headerWidth, attributes.frame.size.height)
//            };
//        }
        
    }
    
    // Notify delegate of header snap to origin
//    TWEventCollectionViewLayoutAttributes *previousAttributes = self.headerAttributes[@(indexPath.section)];
//    if (CGPointEqualToPoint(attributes.frame.origin, snapPoint)) {
//        if (!previousAttributes.isSnapped) {
//            attributes.snapped = YES;
//            [self.delegate headerDidSnapAtIndexPath:indexPath];
//        } else {
//            attributes.snapped = previousAttributes.isSnapped;
//        }
//    } else {
//        if (previousAttributes.isSnapped) {
//            attributes.snapped = NO;
//            [self.delegate headerDidUnsnapAtIndexPath:indexPath];
//        } else {
//            attributes.snapped = previousAttributes.isSnapped;
//        }
//    }
    self.headerAttributes[@(indexPath.section)] = attributes;
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    // We always return yes because our supplementary views are constantly updating, which requires layout invalidation
    // Would throw an internal inconsistency exception if we attempted to update them without invalidation
//    return YES;
    // In the future - test this for performance gain when not using headers
//    if ([self sizeForHeaderView].height > 0) {
//        return YES;
//    } else {
        return (!CGRectEqualToRect(newBounds, self.collectionView.bounds));
//    }
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
    for (UICollectionViewUpdateItem* item in updateItems) {
        if (item.updateAction == UICollectionUpdateActionInsert || item.updateAction == UICollectionUpdateActionMove) {
            [self layoutTilesToIndexPath:item.indexPathAfterUpdate];
        }
    }
}

- (void)invalidateLayout {
    [super invalidateLayout];
    _farthestTilePoint = CGPointZero;
    self.firstOpenTile = CGPointZero;
    self.previousLayoutRect = CGRectZero;
    self.previousLayoutAttributes = nil;
    self.lastIndexPathPlaced = nil;
    [self clearPositions];
}

#pragma mark - Property Overrides

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;
    [self invalidateLayout];
}

- (void)setTileSize:(CGSize)blockSize {
    _tileSize = blockSize;
    [self invalidateLayout];
}

#pragma mark - Layout Calculation

/**
 * Iterates through the collection view datasource and attempts to layout items on the grid up to the 
 * given maximum tile.
 *
 * @param maxTileIndex the maximum tile index to use as a maximum during layout calculation
 */
- (void)layoutTilesForSize:(int)maxTileIndex {
    NSUInteger numberOfSections = [self.collectionView numberOfSections];
    for (NSUInteger section = self.lastIndexPathPlaced.section; section < numberOfSections; section++) {
        NSUInteger numberOfRows = [self.collectionView numberOfItemsInSection:section];
        for (NSUInteger row = (!self.lastIndexPathPlaced || self.lastIndexPathPlaced.section != section ? 0 : self.lastIndexPathPlaced.row + 1); row < numberOfRows; row++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            if ([self didPlaceItemAtIndexPath:indexPath]) {
                self.lastIndexPathPlaced = indexPath;
            }
            
            // End prelayout if we reach the bounds of the visible layout before we reach the end of the data source
            if (([self isVerticalLayout] ? self.firstOpenTile.y : self.firstOpenTile.x) >= maxTileIndex) {
                return;
            }
        }
    }
}

/**
 * Iterates through the collection view data source and attempts to layout items on the grid up to the given
 * index path.
 *
 * @param path the index path to use as a maximum during layout calculation
 */
- (void)layoutTilesToIndexPath:(NSIndexPath*)path {
    NSUInteger numberOfSections = [self.collectionView numberOfSections];
    for (NSUInteger section = self.lastIndexPathPlaced.section; section < numberOfSections; section++) {
        NSUInteger numberOfRows = [self.collectionView numberOfItemsInSection:section];
        for (NSUInteger row = (!self.lastIndexPathPlaced ? 0 : self.lastIndexPathPlaced.row + 1); row < numberOfRows; row++) {
            // Exit when we reach the path maximum
            if ((section >= path.section) && (row > path.row)) {
                return;
            }
            
            // Place the item and record the indexpath
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            if ([self didPlaceItemAtIndexPath:indexPath]) {
                self.lastIndexPathPlaced = indexPath;
            }
        }
    }
}

/**
 * Attempts to place the given collection view item on the layout grid and returns a boolean indicating 
 * success or failure to do so.
 *
 * @param indexPath the UICollectionViewDataSource indexPath of the item 
 * @return BOOL specifying yes if the item was placed in the grid successfully, no otherwise
 */
- (BOOL)didPlaceItemAtIndexPath:(NSIndexPath*)indexPath {
    CGSize itemSize = [self getSizeForItemAtIndexPath:indexPath];
    BOOL result = [self searchForNextOpenTileBlockWithSize:(CGSize)itemSize
                                   foundTileOperationBlock:^(CGPoint tileBlockOrigin) {
                                       // Record the tiles occupied by the item in our grid data structure
                                       [self setIndexPath:indexPath forPoint:tileBlockOrigin];
                                       [self iterateTilesInTileBlockAtOriginPoint:tileBlockOrigin withSize:itemSize operationBlock:^(CGPoint point) {
                                           [self setPoint:point forIndexPath:indexPath];
                                           self.farthestTilePoint = point;
                                           return YES;
                                       }];
                                       return YES;
                                   }];
    return result;
}

/**
 * Iterates through the tile grid to find the next open block of tiles that will fit specified itemSize. Will perform optional
 * operation block on the found tile.
 *
 * @param itemSize the size of the tile block being requested, presumably for a collection view datasource item
 * @param operationBlock a block that will return a BOOL indicating whether its operation was successful
 * @return BOOL yes if the provided operation was successful, no otherwise
 */
- (BOOL)searchForNextOpenTileBlockWithSize:(CGSize)itemSize foundTileOperationBlock:(BOOL(^)(CGPoint))operationBlock {
    // assume there are no previous open tiles
    BOOL foundOpenSpace = NO;
    BOOL isVerticallyUnbounded = self.scrollDirection == UICollectionViewScrollDirectionVertical;
    
    // the double ;; is deliberate, the unrestricted dimension should iterate indefinitely
    // Start at the last known open space and iterate through tiles
    for (NSUInteger tilePointOnUnboundedAxis = (isVerticallyUnbounded ? self.firstOpenTile.y : self.firstOpenTile.x);; tilePointOnUnboundedAxis++) {
        for (NSUInteger tilePointOnBoundedAxis = 0; tilePointOnBoundedAxis < [self maxTilePointOnBoundedAxis]; tilePointOnBoundedAxis++) {
            CGPoint tilePoint = CGPointMake(isVerticallyUnbounded ? tilePointOnBoundedAxis : tilePointOnUnboundedAxis,
                                            isVerticallyUnbounded ? tilePointOnUnboundedAxis : tilePointOnBoundedAxis);
            // Skip this tilepoint if its already occupied
            if ([self indexPathForPoint:tilePoint]) {
                continue;
            }
            // Flag this tilePoint as the first known open tile in the grid
            if (!foundOpenSpace) {
                self.firstOpenTile = tilePoint;
                foundOpenSpace = YES;
            }
            // Check if the required tiles are available to fulfill the item's size
            BOOL available = [self tileAtPoint:tilePoint isAvailableForItemSize:itemSize];
            if (available) {
                return operationBlock(tilePoint);
            } else {
                NSLog(@"Found available tiles but cannot fit item at tile origin {%.0f, %.0f}...", tilePoint.x, tilePoint.y);
            }
        }
    }
    return NO;
}

/**
 * Determines whether the tile at the given CGPoint has sufficient adjacent tiles to provide a block specified by itemSize.
 *
 * @param tilePoint the tile being evaluated
 * @param itemSize the size of the tile block desired
 * @return BOOL yes if the tile being evaluated has sufficient adjacent space to accomodate the itemSize, no otherwise
 */
- (BOOL)tileAtPoint:(CGPoint)tilePoint isAvailableForItemSize:(CGSize)itemSize {
    // Check that the tiles required to fulfill the item's size are open
    CGPoint point = tilePoint;
    // Is the tile empty?
    if ([self indexPathForPoint:point]) {
        return NO;
    }
    // Is the tile within the bounds?
    BOOL inBounds = ([self isVerticalLayout] ? point.x + itemSize.width : point.y + itemSize.height) <= [self maxTilePointOnBoundedAxis];
    if (!inBounds) {
        if (([self isVerticalLayout] ? tilePoint.x : tilePoint.y) == 0) {
            return YES;
        }
        
        NSNumber *unboundedAxisPoint = @(self.isVerticalLayout ? point.y : point.x);
        NSNumber *boundedAxisPoint = @(self.isVerticalLayout ? point.x : point.y);
        self.indexPathByPosition[boundedAxisPoint][unboundedAxisPoint] = [NSNull null];
        return NO;
    }
    return YES;
}

/**
 * Iterates through all tiles within the specified tile block by column then row.
 *
 * @param originPoint the origin of the tile block to be iterated
 * @param itemSize the size of the tile block in tiles
 * @param operation the operation to perform on each tile, must return a BOOL
 * @return BOOL indicating yes if the iteration completed successfully, no otherwise
 */
- (BOOL)iterateTilesInTileBlockAtOriginPoint:(CGPoint)originPoint withSize:(CGSize)itemSize operationBlock:(BOOL(^)(CGPoint))operation {
    for (int col = originPoint.x; col < (originPoint.x + itemSize.width); col++) {
        for (int row = originPoint.y; row < (originPoint.y + itemSize.height); row++) {
            if (!operation(CGPointMake(col, row))) {
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - Grid Tile Data Structure

/**
 * Returns the index path of the UICollectionViewCell item occupying the grid tile at the specified point.
 * 
 * @param a point on the tile grid occupied by the cell/item
 * @return NSIndexPath of the cell/item occupying the grid tile
 */
- (NSIndexPath*)indexPathForPoint:(CGPoint)point {
    BOOL isVert = self.scrollDirection == UICollectionViewScrollDirectionVertical;
    NSNumber *unrestrictedPoint = @(isVert ? point.y : point.x);
    NSNumber *restrictedPoint = @(isVert ? point.x : point.y);
    return self.indexPathByPosition[restrictedPoint][unrestrictedPoint];
}

/**
 * Sets the origin point on the tile grid for the UICollectionViewCell item at the specified index path.
 * 
 * @param point the origin point on the tile grid
 * @param indexPath the index path of the cell/item
 */
- (void)setPoint:(CGPoint)point forIndexPath:(NSIndexPath*)indexPath {
    BOOL isVerticalLayout = [self isVerticalLayout];
    NSNumber *unboundedAxisPoint = @(isVerticalLayout ? point.y : point.x);
    NSNumber *boundedAxisPoint = @(isVerticalLayout ? point.x : point.y);
    
    NSMutableDictionary *innerDict = self.indexPathByPosition[boundedAxisPoint];
    if (!innerDict) {
        self.indexPathByPosition[boundedAxisPoint] = [NSMutableDictionary dictionary];
    }
    self.indexPathByPosition[boundedAxisPoint][unboundedAxisPoint] = indexPath;
}

/**
 * Sets the index path of the UICollectionViewCell item for a given point on the tile grid.
 * 
 * @param indexPath the index path of the cell/item
 * @param point a point on the tile grid occupied by the cell/item
 */
- (void)setIndexPath:(NSIndexPath*)indexPath forPoint:(CGPoint)point {
    NSMutableDictionary *innerDict = self.positionByIndexPath[@(indexPath.section)];
    if (!innerDict) {
        self.positionByIndexPath[@(indexPath.section)] = [NSMutableDictionary dictionary];
    }
    self.positionByIndexPath[@(indexPath.section)][@(indexPath.row)] = [NSValue valueWithCGPoint:point];
}

/**
 * Returns the origin point on the tile grid for the UICollectionViewCell item at the specified index path.
 *
 * @param the index path of the cell/item
 * @return CGPoint containing the origin for the cell/item
 */
- (CGPoint)pointForIndexPath:(NSIndexPath*)indexPath {
    // if item does not have a position, we will make one!
    if (!self.positionByIndexPath[@(indexPath.section)][@(indexPath.row)]) {
        [self layoutTilesToIndexPath:indexPath];
    }
    return [self.positionByIndexPath[@(indexPath.section)][@(indexPath.row)] CGPointValue];
}

/**
 * Resets all tile grid information.
 */
- (void) clearPositions {
    self.indexPathByPosition = [NSMutableDictionary dictionary];
    self.positionByIndexPath = [NSMutableDictionary dictionary];
}

#pragma mark - Helper Methods

/**
 * Calculates the size in pixels for each tile on the grid, based on the tile size aspect ratio
 * (optionally provided by the delegate) and supplemental view sizes.
 */
- (void)calculateTileSize {
    // Calculate the content size
    CGRect tileFrame = self.collectionView.frame;
    CGFloat headerHeight = [self sizeForHeaderView].height;
    tileFrame.size.height -= headerHeight;

    NSUInteger tileCountAlongFixedAxis = [self.delegate numberOfTilesToFitForScrollDirection:self.scrollDirection];
    CGFloat blockWidth = 0;
    CGFloat blockHeight = 0;
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        blockHeight = tileFrame.size.height / tileCountAlongFixedAxis;
        blockWidth = blockHeight * (self.tileSizeAspectRatio.width / self.tileSizeAspectRatio.height);
    } else {
        blockWidth = tileFrame.size.width / tileCountAlongFixedAxis;
        blockHeight = blockWidth * (self.tileSizeAspectRatio.height / self.tileSizeAspectRatio.width);
    }
    self.tileSize = CGSizeMake(blockWidth, blockHeight);
}

/**
 * Calculates the frame for the UICollectionViewCell item at the given index path.
 * 
 * @param indexPath the index path of the cell item
 * @return CGRect representing the calculated frame of the item
 */
- (CGRect)frameForIndexPath:(NSIndexPath*)indexPath {
    CGPoint point = [self pointForIndexPath:indexPath];
    CGSize itemSize = [self getSizeForItemAtIndexPath:indexPath];
    CGRect itemRect = CGRectMake((point.x * self.tileSize.width),
                                 (point.y * self.tileSize.height),
                                 (itemSize.width * self.tileSize.width),
                                 (itemSize.height * self.tileSize.height));;
    return itemRect;
}

/**
 * Calculates the index paths for items that would be found in the given rectangle.
 * 
 * @param rect the rectangle area to use for finding index paths
 * @return NSArray containing all index paths found in the rectangle area
 */
- (NSArray *)indexPathsInRect:(CGRect)rect {
    NSMutableArray *indexPaths = [NSMutableArray array];
	NSInteger numberOfSections = (self.lastIndexPathPlaced) ? self.lastIndexPathPlaced.section + 1 : 0;
    
    for (NSInteger section = 0; section < numberOfSections; section++) {
        NSInteger numberOfRows = (section == self.lastIndexPathPlaced.section ? (self.lastIndexPathPlaced.row + 1) : [self.collectionView numberOfItemsInSection:section]);
        
        for (NSInteger rowIndex = 0; rowIndex < numberOfRows; rowIndex++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:section];
            if (CGRectIntersectsRect([self frameForIndexPath:indexPath], rect)) {
                [indexPaths addObject:indexPath];
            }
        }
    }
    return indexPaths;
}

/**
 * Returns the intended size in tiles for the collection view datasource item. Defaults to 1x1 since the delegate method is optional.
 *
 * @param indexPath the NSIndexPath of the item in the collection view datasource
 * @return CGSize the size of the item in tile units
 */
- (CGSize)getSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize = CGSizeMake(1, 1);
    if ([self.delegate respondsToSelector:@selector(sizeForItemAtIndexPath:)]) {
        itemSize = [self.delegate sizeForItemAtIndexPath:indexPath];
    }
    return itemSize;
}

/**
 * Returns the edge insets for the UICollectionViewCell at the specified index path, supplied by the delegate. If the delegate 
 * does not supply edge inset information, the default value stored in the layout will be provided. This will be zero unless
 * the implementing collection view has set the itemInset property to another value.
 * 
 * @param indexPath the index path of the item for which edge insets are being requested
 * @return UIEdgeInsets specifying the inset values for the cell item
 */
- (UIEdgeInsets)edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(insetsForItemAtIndexPath:)]) {
        return [self.delegate insetsForItemAtIndexPath:indexPath];
    } else {
        return self.itemInset;
    }
}

/**
 * Returns the edge insets for the section at the specified index, supplied by the delegate. If the delegate does not 
 * supply edge inset information, the default value stored in the layout will be provided. This will be zero unless
 * the implementing collection view has set the sectionInset property to another value.
 * 
 * @param sectionIndex the index of the section for which edge insets are being requested
 * @return UIEdgeInsets specifying the inset values for the section
 */
- (UIEdgeInsets)edgeInsetsForSectionAtIndex:(NSUInteger)sectionIndex {
    if ([self.delegate respondsToSelector:@selector(insetsForSectionAtIndex:)]) {
        return [self.delegate insetsForSectionAtIndex:sectionIndex];
    } else {
        return self.sectionInset;
    }
}

/**
 * Returns the size for the header view, supplied by the delegate. If the delegate does not supply size information,
 * the size defaults to zero (no header).
 *
 * @return CGSize with height and width of the header view
 */
- (CGSize)sizeForHeaderView {
    if ([self.delegate respondsToSelector:@selector(sizeForHeaderView)]) {
        return [self.delegate sizeForHeaderView];
    } else {
        return CGSizeZero;
    }
}

/**
 * Returns the aspect ratio size for grid tiles, supplied by the delegate. If the delegate does not supply size information,
 * the aspect ratio defaults to 1:1 (square).
 *
 * @return CGSize specifying an aspect ratio
 */
- (CGSize)tileSizeAspectRatio {
    if ([self.delegate respondsToSelector:@selector(tileSizeAspectRatio)]) {
        return [self.delegate tileSizeAspectRatio];
    } else {
        return CGSizeMake(1, 1);
    }
}

/**
 * Determines the maximum possible size of an item in grid tiles along the bounded (non-scrolling) axis.
 * @return the maximum size possible for the bounded axis
 */
- (NSUInteger)maxTilePointOnBoundedAxis {
    
    int size = [self isVerticalLayout] ?
        (self.collectionView.frame.size.width - (self.sectionInset.right + self.sectionInset.left)) / self.tileSize.width :
        (self.collectionView.frame.size.height - (self.sectionInset.top + self.sectionInset.bottom)) / self.tileSize.height;
    
    if(size == 0) {
        static BOOL didShowMessage;
        if (!didShowMessage) {
            NSLog(@"%@: cannot fit block of size: %@ in frame %@!  Defaulting to 1", [self class], NSStringFromCGSize(self.tileSize), NSStringFromCGRect(self.collectionView.frame));
            didShowMessage = YES;
        }
        return 1;
    }
    
    return size;
}

- (void)setFarthestTilePoint:(CGPoint)point {
    _farthestTilePoint = CGPointMake(MAX(self.farthestTilePoint.x, point.x), MAX(self.farthestTilePoint.y, point.y));
}

/**
 * Returns whether or not the layout is a vertically-scrolling layout or a horizontally-scrolling layout.
 * @return BOOL indicating yes if the layout scrolls vertically, no if the layout scrolls horizontally.
 */
- (BOOL)isVerticalLayout {
    return self.scrollDirection == UICollectionViewScrollDirectionVertical;
}

@end
