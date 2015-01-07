//
//  CW2DTableVC2.m
//  Pods
//
//  Created by millionaryearl on 14/11/26.
//
//

#import "CW2DTableVC2.h"
#import "CW2DTableCell.h"

@interface CW2DTableVC2 ()

@property(nonatomic)NSMutableArray *dataSrcArr;             //general data source array
@property(nonatomic)NSMutableArray *dataSrcArrNumVersion;   //number version
//@property(nonatomic)NSMutableArray *dataSrcArrPerVersion;   //percentage version

@end


@implementation CW2DTableVC2

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //request dataSrcArr from web
        //assume strcutre
        _dataSrcArr = [[NSMutableArray alloc]init];
        _dataSrcArrNumVersion = [[NSMutableArray alloc]init];
//        CW2DTableLayoutStyle2 *tmplayout = (CW2DTableLayoutStyle2 *) self.collectionViewLayout;
//        tmplayout.hint = @"u mother fucking genious!!!";
//        _dataSrcArrPerVersion = [[NSMutableArray alloc]init];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshSrchRlt];
    //    [self performSegueWithIdentifier:@"PerformConfig" sender:nil];
}

-(void)refreshSrchRlt{
    
    /*  example data src
     *  mailnly consist of three sections, column headers, subcolumn headers and row content
     *  one thing need to be noticed is that row headers are split to each row
     *
     *  section1    col1             col2            col3               col3            col4            ...
     *  section2   row-h1           row-c1          row-c2            row-c3           row-c4           ...
     *      .         -             row-c1          row-c2            row-c3           row-c4           ...
     *      .         -             row-c1          row-c2            row-c3           row-c4           ...
     *      .      row-h2           row-c1          row-c2            row-c3           row-c4           ...
     *      .        ...
     */
    NSArray *columnNames = @[@"属性",@"大类",@"计划SKC",@"订货SKC",@"计划定量",@"计订数量占比",@"实际定量",@"量完成率",@"实定数量占比",@"计划定额",@"计划金额占比",@"实际定量",@"额完成率",@"实订金额占比"];
    NSArray *content1 =@[@"大类1",@"c1",@"c2",@"c3",@"c4",@"c5",@"c6",@"c7",@"c8",@"c9",@"c10",@"c11",@"c12",@"c13"];
    NSArray *content11 =@[@"c1",@"c2",@"c3",@"c4",@"c5",@"c6",@"c7",@"c8",@"c9",@"c10",@"c11",@"c12",@"c13"];
    NSArray *content2 =@[@"大类2",@"c1",@"c2",@"c3",@"c4",@"c5",@"c6",@"c7",@"c8",@"c9",@"c10",@"c11",@"c12",@"c13"];
    NSArray *content3 =@[@"大类3",@"c1",@"c2",@"c3",@"c4",@"c5",@"c6",@"c7",@"c8",@"c9",@"c10",@"c11",@"c12",@"c13"];
    NSArray *total = @[@"总计",@"sum1",@"sum2",@"sum3",@"sum4",@"sum5",@"sum6",@"sum7",@"sum8",@"sum9",@"sum10",@"sum11",@"sum12"];
     NSArray *totalSub = @[@"小计",@"sum1",@"sum2",@"sum3",@"sum4",@"sum5",@"sum6",@"sum7",@"sum8",@"sum9",@"sum10",@"sum11",@"sum12"];
     NSArray *totalMaj = @[@"主品小计",@"sum1",@"sum2",@"sum3",@"sum4",@"sum5",@"sum6",@"sum7",@"sum8",@"sum9",@"sum10",@"sum11",@"sum12"];
    [_dataSrcArrNumVersion addObject:columnNames];
    [_dataSrcArrNumVersion addObject:content1];
    for (int i=0; i<1; i++) {
        [_dataSrcArrNumVersion addObject:content11];
      
    }
    [_dataSrcArrNumVersion addObject:totalSub];
    [_dataSrcArrNumVersion addObject:content2];
    for (int i=0; i<6; i++) {
        [_dataSrcArrNumVersion addObject:content11];
        
    }
    [_dataSrcArrNumVersion addObject:totalSub];
    [_dataSrcArrNumVersion addObject:totalMaj];
    [_dataSrcArrNumVersion addObject:content3];
    for (int i=0; i<8; i++) {
        [_dataSrcArrNumVersion addObject:content11];
        
    }
    [_dataSrcArrNumVersion addObject:totalSub];
    [_dataSrcArrNumVersion addObject:total];
    
    _dataSrcArr = _dataSrcArrNumVersion;
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma -UICollectionView data Source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return [_dataSrcArr count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //     NSLog(@"%d",[_dataSrcArr[section] count]);
    return [_dataSrcArr[section] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.row ==0 && indexPath.section >0) {
//        if ([self.collectionView numberOfItemsInSection:indexPath.section]<[self.collectionView numberOfItemsInSection:0]) {
//            CW2DTableCell *emptyCell = (CW2DTableCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"emptyCell" forIndexPath:indexPath];
//            return  emptyCell;
//        }
//    }

    
    CW2DTableCell *cell = (CW2DTableCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CW2DTableCell" forIndexPath:indexPath];
    
    cell.nameLabel.text = _dataSrcArr[indexPath.section][indexPath.row];    
    
    cell.nameLabel.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = [[UIColor whiteColor]CGColor];
    [cell setBackgroundColor:[UIColor lightTextColor]];
    
    
    
    if (indexPath.section ==0) {
        //for column header
        [cell setBackgroundColor:[UIColor colorWithRed:(float)181/255 green:(float)181/255 blue:(float)251/255 alpha:1]];
    }
    
    if (indexPath.section >0 && indexPath.section%2==1) {
        //for odd row content cells
        [cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    }
   
    if (indexPath.row ==0){
        //for row header
        [cell setBackgroundColor:[UIColor colorWithRed:(float)181/255 green:(float)181/255 blue:(float)251/255 alpha:1]];
        
    }
    if (indexPath.row ==1 &&[self.collectionView numberOfItemsInSection:indexPath.section]==[self.collectionView numberOfItemsInSection:0]){
        //for subcrow header
        [cell setBackgroundColor:[UIColor colorWithRed:(float)181/255 green:(float)181/255 blue:(float)251/255 alpha:1]];
    }
    return cell;
}



#pragma -UICollectionView delegate

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.collectionView.collectionViewLayout invalidateLayout];
}




@end
