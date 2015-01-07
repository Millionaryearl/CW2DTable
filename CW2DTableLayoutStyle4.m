//
//  CW2DTableLayoutStyle4.m
//  Pods
//
//  Created by millionaryearl on 14/12/4.
//
//

#import "CW2DTableLayoutStyle4.h"

@interface CW2DTableLayoutStyle4()

@property (strong, nonatomic)NSMutableArray *itemAttributes;
@property (assign, nonatomic)CGSize calculatedContentSize;
@end


@implementation CW2DTableLayoutStyle4

-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)prepareLayout{
    [self setItemOffSet:UIOffsetMake(0.0, 0.0)];
    [self setItemAttributes:nil];
    _itemAttributes = [[NSMutableArray alloc]init];
    
    //set vars of each related parameter
    NSUInteger column = 0;                                                      //current column inside row
    NSInteger sectionTolNum = [self.collectionView numberOfSections];           //total number of sections
    
    CGFloat xOffset = self.itemOffSet.horizontal;
    CGFloat yOffset = self.itemOffSet.vertical;
    CGFloat rowHeightRecd = 0.0;
    
    CGFloat contentWidth = 0.0;                                                 //used to detemine contentSize
    CGFloat contentHeight = 0.0;                                                //
    
    //the number of columns in each row, this value should be dynamically changed accroding to row index
    //    CGFloat numOfColumnsInRow =10;
    
    //iterate through all items to calculate the UICollectionViewLayoutAttributes for each cell
    
    for (NSInteger sectionI =0; sectionI <sectionTolNum; sectionI++) {
        NSMutableArray *SectionIArr = [[NSMutableArray alloc]init];
        [self.itemAttributes addObject:SectionIArr];
        
        //the number of columns in each row, this value should be dynamically changed accroding to row index
        //do relavent change in controller file
        //!!!!!!!!!!!!!!!!!!!!!!!!!
        NSUInteger numOfItemsInRow = [self.collectionView numberOfItemsInSection:sectionI];
        
        for (NSUInteger rowI = 0; rowI < numOfItemsInRow; rowI++) {
            CGSize itemSize = [self size4ItemWithSectionPara:sectionI RoWPara:rowI];
            
//            if (itemSize.height >rowHeightRecd) {
                rowHeightRecd = itemSize.height;
//            }
            
            //create the actual UICollectionViewLayoutAttributes and addit to _itemAttributes. THis will be used later in LayeroutAttributesForItemAtIndexPath;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:rowI inSection:sectionI];
            UICollectionViewLayoutAttributes *cellAttribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            cellAttribute.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height));
            [self.itemAttributes[sectionI] addObject:cellAttribute];
            
            xOffset = xOffset+itemSize.width +self.itemOffSet.horizontal;
            column++;
            
            //create a new row if this cell reached the end of its row
            if (column == numOfItemsInRow) {
                
                if (xOffset>contentWidth) {
                    contentWidth = xOffset;
                }
                
                //reset record vars
                column = 0;
                xOffset = self.itemOffSet.horizontal;
                yOffset += rowHeightRecd +self.itemOffSet.vertical;
            }
            
        }
        
    }
    //get the lst item to calculate total height of the content
    if ([self.itemAttributes count]>1) {
        UICollectionViewLayoutAttributes *lastAttributes = [self.itemAttributes[sectionTolNum-1] lastObject];
        contentHeight = lastAttributes.frame.origin.y + lastAttributes.frame.size.height;
        
        //record the calculated size
        _calculatedContentSize = CGSizeMake(contentWidth, contentHeight);
        
    }
}

-(CGSize)collectionViewContentSize{
    return self.calculatedContentSize;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return  self.itemAttributes[indexPath.section][indexPath.row];
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *myAttributes = [[NSMutableArray alloc]init];
    UICollectionView *const cv = self.collectionView;
    CGPoint const contentOffset = cv.contentOffset;
    
    for (int sectionIndex = 0; sectionIndex <[_itemAttributes count]; sectionIndex++){
        UICollectionViewLayoutAttributes *layoutAttributes = _itemAttributes[sectionIndex][0];
        
        NSIndexPath *firstObjectIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        NSIndexPath *lastObjectIndexPath = [NSIndexPath indexPathForItem:0 inSection:[_itemAttributes count]-1];
        
        UICollectionViewLayoutAttributes *firstObjectAttrs;
        UICollectionViewLayoutAttributes *lastObjectAttrs;
        
        firstObjectAttrs = [self layoutAttributesForItemAtIndexPath:firstObjectIndexPath];
        lastObjectAttrs = [self layoutAttributesForItemAtIndexPath:lastObjectIndexPath];
        
        CGFloat headerWidth = CGRectGetWidth(layoutAttributes.frame);
        CGRect frameWithEdgeInsets = UIEdgeInsetsInsetRect(layoutAttributes.frame, cv.contentInset);
        CGPoint origin = frameWithEdgeInsets.origin;
        
        origin.x = MAX(
                       MAX(
                           contentOffset.x +cv.contentInset.left,
                           (CGRectGetMinX(firstObjectAttrs.frame)-headerWidth)
                           ),
                       (CGRectGetMaxX(lastObjectAttrs.frame)-headerWidth)
                       );
        if ( layoutAttributes.indexPath.section <1){
            layoutAttributes.zIndex = 2048;
        }else{
            layoutAttributes.zIndex = 1024;
        }
        
        layoutAttributes.frame = (CGRect){
            .origin = origin,
            .size = layoutAttributes.frame.size
        };
    }
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in _itemAttributes[0]){
        NSIndexPath *firstObjectIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        NSIndexPath *lastObjectIndexPath = [NSIndexPath indexPathForItem:[_itemAttributes[0] count]-1 inSection:0];
        
        UICollectionViewLayoutAttributes *firstObjectAttrs;
        UICollectionViewLayoutAttributes *lastObjectAttrs;
        
        firstObjectAttrs = [self layoutAttributesForItemAtIndexPath:firstObjectIndexPath];
        lastObjectAttrs = [self layoutAttributesForItemAtIndexPath:lastObjectIndexPath];
        
        CGFloat headerHeight = CGRectGetHeight(layoutAttributes.frame);
        CGRect frameWithEdgeInsets = UIEdgeInsetsInsetRect(layoutAttributes.frame, cv.contentInset);
        CGPoint origin = frameWithEdgeInsets.origin;
        
        origin.y = MAX(
                       MAX(
                           contentOffset.y +cv.contentInset.top,
                           (CGRectGetMinY(firstObjectAttrs.frame)-headerHeight)
                           ),
                       (CGRectGetMaxY(lastObjectAttrs.frame)-headerHeight)
                       );
        if ( layoutAttributes.indexPath.row == 0){
            layoutAttributes.zIndex = 2048;
        }else{
            layoutAttributes.zIndex = 1024;
        }
        layoutAttributes.frame = (CGRect){
            .origin = origin,
            .size = layoutAttributes.frame.size
        };
        
    }

    
    for(NSMutableArray *tmpSection in _itemAttributes){
        for (UICollectionViewLayoutAttributes *cellAttributes in tmpSection){
            if (CGRectIntersectsRect(rect, cellAttributes.frame)){
                [myAttributes addObject:cellAttributes];
            }
        }
    }
    
    return myAttributes;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

-(CGSize)size4ItemWithSectionPara:(NSInteger)sectionI RoWPara:(NSInteger)rowI{
    //resize cell to corresponding size
    CGSize rltSize;
    CGFloat x=120.0,y=44.0;
    
    if (sectionI ==0 ) {
        y=264;
    }
    
    rltSize = CGSizeMake(x, y);
    return rltSize;
}
@end
