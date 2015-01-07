//
//  CW2DTabeLayoutStyle3.m
//  Pods
//
//  Created by millionaryearl on 14/12/2.
//
//

#import "CW2DTabeLayoutStyle3.h"

@interface CW2DTabeLayoutStyle3()

@property (strong, nonatomic)NSMutableArray *itemAttributes;
@property (assign, nonatomic)CGSize calculatedContentSize;
@property (strong, nonatomic)NSMutableArray *rowArrIndex4Category;
@property (nonatomic)NSInteger columnMax;

@end


@implementation CW2DTabeLayoutStyle3

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
    _rowArrIndex4Category = [[NSMutableArray alloc]init];
    _columnMax = [self.collectionView numberOfItemsInSection:2];                //assuming first row has the most cells
    
    //set vars of each related parameter
    NSUInteger column = 0;                                                      //current column inside row
    NSInteger sectionTolNum = [self.collectionView numberOfSections];           //total number of sections
    
    CGFloat xOffset = self.itemOffSet.horizontal;
    CGFloat yOffset = self.itemOffSet.vertical;
    CGFloat rowHeightRecd = 0.0;
    
    CGFloat contentWidth = 0.0;                                                 //used to detemine contentSize
    CGFloat contentHeight = 0.0;                                                //
    
    
    /* parse the item numbers of each section to generate a dependent arr, which would be used to indicate which row should
     * expand on Y axis and which should shift one cell position to right.
     * e.g [1,4,1,1,1]
     * in this case, row 0, 2, 3, 4 should shift right. And row 1 should expand 4 times down on Y axis.
     */
    NSInteger timer = 1;
    
    for (NSInteger sectionI =0; sectionI <sectionTolNum; sectionI++) {
        [_rowArrIndex4Category addObject:@(1)];
    }
    NSInteger rowStartIndex = 2;
    for (NSInteger sectionI =0; sectionI <sectionTolNum-1; sectionI++) {
        NSInteger numOfItemsInRow = [self.collectionView numberOfItemsInSection:sectionI];
        
        if (numOfItemsInRow == _columnMax && timer!=1) {
            [_rowArrIndex4Category replaceObjectAtIndex:rowStartIndex withObject:@(timer)];
            rowStartIndex = 0;;
            timer = 1;
        }
        else if (sectionI == sectionTolNum -2 && timer !=1){
            [_rowArrIndex4Category replaceObjectAtIndex:rowStartIndex withObject:@(timer+1)];
            rowStartIndex = 0;
            timer = 1;
        }
        else if(sectionI >1){
            timer ++;
        }
        
        if (numOfItemsInRow == _columnMax && timer==1 && sectionI>1) {
            rowStartIndex = sectionI;
        }
    }
    NSLog(@"%@",_rowArrIndex4Category);
    //iterate through all items to calculate the UICollectionViewLayoutAttributes for each cell
    for (NSInteger sectionI =0; sectionI <sectionTolNum; sectionI++) {
        NSMutableArray *SectionIArr = [[NSMutableArray alloc]init];
        [self.itemAttributes addObject:SectionIArr];
        
        //the number of columns in each row, this value should be dynamically changed accroding to row index
        //do relavent change in controller file
        //!!!!!!!!!!!!!!!!!!!!!!!!!
        NSInteger numOfItemsInRow = [self.collectionView numberOfItemsInSection:sectionI];
        NSInteger rowWidthPadding = 0;
        
        if (numOfItemsInRow == _columnMax -1 && sectionI >0) {
            rowWidthPadding = 1;
        }
        if (sectionI ==1){
            rowWidthPadding = 2;
        }
        if (sectionI == sectionTolNum-1){
            rowWidthPadding = 0;
        }
        
        
        for (NSUInteger rowI = 0; rowI < numOfItemsInRow; rowI++) {
            CGSize itemSize = [self size4ItemWithSectionPara:sectionI RoWPara:rowI Timer4X:1 Timer4Y:1];
            
            //            if (itemSize.height >rowHeightRecd) {
            rowHeightRecd = itemSize.height;
            //        }
            
            //create the actual UICollectionViewLayoutAttributes and addit to _itemAttributes. THis will be used later in LayeroutAttributesForItemAtIndexPath;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:rowI inSection:sectionI];
            UICollectionViewLayoutAttributes *cellAttribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            NSInteger tmpTimer4Y = [_rowArrIndex4Category[sectionI]integerValue];
            if (numOfItemsInRow == _columnMax && sectionI >0 && rowI==0) {
                itemSize.height =itemSize.height *tmpTimer4Y;
            }
            
            cellAttribute.frame = CGRectIntegral(CGRectMake(xOffset+rowWidthPadding*itemSize.width, yOffset, itemSize.width, itemSize.height));
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
    
    
    for (int rowIndex = 0; rowIndex <[_itemAttributes[0] count]; rowIndex++){
        UICollectionViewLayoutAttributes *layoutAttributes = _itemAttributes[0][rowIndex];
        NSIndexPath *firstObjectIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        NSIndexPath *lastObjectIndexPath = [NSIndexPath indexPathForItem:[_itemAttributes[0] count]-1 inSection:0];
        
        UICollectionViewLayoutAttributes *firstObjectAttrs;
        UICollectionViewLayoutAttributes *lastObjectAttrs;
        
        firstObjectAttrs = [self layoutAttributesForItemAtIndexPath:firstObjectIndexPath];
        lastObjectAttrs = [self layoutAttributesForItemAtIndexPath:lastObjectIndexPath];
        
        
        CGFloat headerHeight = (rowIndex <2)? CGRectGetHeight(layoutAttributes.frame)/2.0:CGRectGetHeight(layoutAttributes.frame);
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
    
    

    
    for (int sectionIndex = 0; sectionIndex <[_itemAttributes count]; sectionIndex++){
        
        NSInteger firstSectionIndex = 999999999;
        NSInteger lastSectionIndex = 0;
        CGFloat margin2LeftBound = 0;
        for (int i =0; i<[_rowArrIndex4Category count]; i++) {
            if ([self.collectionView numberOfItemsInSection:i] == 14) {
                if (firstSectionIndex ==999999999 ) {
                    firstSectionIndex = i;
                }else{
                    lastSectionIndex =i;
                }
                
            }
        }
        if ([self.collectionView numberOfItemsInSection:sectionIndex] == _columnMax || sectionIndex ==0) {
            
            for (int j = 0; j<2; j++) {
                for (int k=j; k>0; k--) {
                    UICollectionViewLayoutAttributes *tmp =_itemAttributes[sectionIndex][k-1];
                    margin2LeftBound = margin2LeftBound + tmp.frame.size.width;
                }
                UICollectionViewLayoutAttributes *layoutAttributes = _itemAttributes[sectionIndex][j];
                
                NSIndexPath *firstObjectIndexPath = [NSIndexPath indexPathForItem:j inSection:firstSectionIndex];
                NSIndexPath *lastObjectIndexPath = [NSIndexPath indexPathForItem:j inSection:lastSectionIndex];
                
                UICollectionViewLayoutAttributes *firstObjectAttrs;
                UICollectionViewLayoutAttributes *lastObjectAttrs;
                
                firstObjectAttrs = [self layoutAttributesForItemAtIndexPath:firstObjectIndexPath];
                lastObjectAttrs = [self layoutAttributesForItemAtIndexPath:lastObjectIndexPath];
                
                CGFloat headerWidth = CGRectGetWidth(layoutAttributes.frame);
                CGRect frameWithEdgeInsets = UIEdgeInsetsInsetRect(layoutAttributes.frame, cv.contentInset);
                CGPoint origin = frameWithEdgeInsets.origin;
                
                origin.x = MAX(
                               MAX(
                                   contentOffset.x +cv.contentInset.left +margin2LeftBound,
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
            
        }
        else if(sectionIndex !=1){
            for (int k=1; k>0; k--) {
                UICollectionViewLayoutAttributes *tmp =_itemAttributes[sectionIndex][k-1];
                margin2LeftBound = margin2LeftBound + tmp.frame.size.width;
            }
            if (sectionIndex == [self.collectionView numberOfSections]-1){
                margin2LeftBound = 0;
            }
            UICollectionViewLayoutAttributes *layoutAttributes = _itemAttributes[sectionIndex][0];
            
            NSIndexPath *firstObjectIndexPath = [NSIndexPath indexPathForItem:1 inSection:firstSectionIndex];
            NSIndexPath *lastObjectIndexPath = [NSIndexPath indexPathForItem:1 inSection:lastSectionIndex];
            
            UICollectionViewLayoutAttributes *firstObjectAttrs;
            UICollectionViewLayoutAttributes *lastObjectAttrs;
            
            firstObjectAttrs = [self layoutAttributesForItemAtIndexPath:firstObjectIndexPath];
            lastObjectAttrs = [self layoutAttributesForItemAtIndexPath:lastObjectIndexPath];
            
            CGFloat headerWidth = CGRectGetWidth(layoutAttributes.frame);
            CGRect frameWithEdgeInsets = UIEdgeInsetsInsetRect(layoutAttributes.frame, cv.contentInset);
            CGPoint origin = frameWithEdgeInsets.origin;
            
            origin.x = MAX(
                           MAX(
                               contentOffset.x +cv.contentInset.left+margin2LeftBound,
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
        
        
    }
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in _itemAttributes[1]){
        NSIndexPath *firstObjectIndexPath = [NSIndexPath indexPathForItem:0 inSection:1];
        NSIndexPath *lastObjectIndexPath = [NSIndexPath indexPathForItem:[_itemAttributes[1] count]-1 inSection:1];
        
        UICollectionViewLayoutAttributes *firstObjectAttrs;
        UICollectionViewLayoutAttributes *lastObjectAttrs;
        
        firstObjectAttrs = [self layoutAttributesForItemAtIndexPath:firstObjectIndexPath];
        lastObjectAttrs = [self layoutAttributesForItemAtIndexPath:lastObjectIndexPath];
        
        UICollectionViewLayoutAttributes *mainHeader =_itemAttributes[0][3];
        CGFloat headerHeight = CGRectGetHeight(layoutAttributes.frame);
        CGRect frameWithEdgeInsets = UIEdgeInsetsInsetRect(layoutAttributes.frame, cv.contentInset);
        CGPoint origin = frameWithEdgeInsets.origin;
        
        origin.y = MAX(
                       MAX(
                           CGRectGetHeight(mainHeader.frame)+contentOffset.y +cv.contentInset.top +_itemOffSet.vertical,
                           CGRectGetHeight(mainHeader.frame)+(CGRectGetMinY(firstObjectAttrs.frame)-headerHeight)
                           ),
                       (CGRectGetMaxY(lastObjectAttrs.frame)-headerHeight)
                       );
        
//        if ( layoutAttributes.indexPath.row == 0 || layoutAttributes.indexPath.row == 1 ){
//            layoutAttributes.zIndex = 2048;
//        }else{
            layoutAttributes.zIndex = 1024;
//        }
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

-(CGSize)size4ItemWithSectionPara:(NSInteger)sectionI RoWPara:(NSInteger)rowI Timer4X:(NSInteger)timer4X Timer4Y:(NSInteger)timer4Y{
    //resize cell to corresponding size
    CGSize rltSize;
    CGFloat x=120.0,y=44.0;
    
    if (sectionI ==0 && rowI>1) {
        x=360.0;
    }
    
    if (sectionI == 0 && rowI <2){
        y=88.0;
    }
    
    if (sectionI == [self.collectionView numberOfSections]-1 && rowI ==0){
        x=240.0;
    }
    rltSize = CGSizeMake(x, y);
    return rltSize;
}



@end
