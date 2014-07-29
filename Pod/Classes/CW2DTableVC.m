//
//  TwoDStatisticVController.m
//  SmartOrder-V2
//
//  Created by millionaryearl on 14-5-9.
//  Copyright (c) 2014年 Shanghai AgileMobi Co., Ltd. All rights reserved.
//

#import "CW2DTableVC.h"
#import "CW2DTableCell.h"

@interface CW2DTableVC ()

@property(nonatomic)NSMutableArray *dataSrcArr;             //general data source array
@property(nonatomic)NSMutableArray *dataSrcArrNumVersion;   //number version
@property(nonatomic)NSMutableArray *dataSrcArrPerVersion;   //percentage version

@end

@implementation CW2DTableVC


-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //request dataSrcArr from web
        //assume strcutre
        _dataSrcArr = [[NSMutableArray alloc]init];
        _dataSrcArrNumVersion = [[NSMutableArray alloc]init];
        _dataSrcArrPerVersion = [[NSMutableArray alloc]init];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dicRecd = [[NSDictionary alloc]init];
    
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
     *  section1    -                       col-h1                            col-h2                    ...
     *  section2    -             sub-col-h1      sub-col-h2        sub-col-h3       sub-col-h4         ...
     *  section3   row-h1           row-c1          row-c2            row-c3           row-c4           ...
     *             row-h2           row-c1          row-c2            row-c3           row-c4           ...
     *              ...
     */
    NSArray *columnNames = @[@"ColHeader →",@"COL1",@"COL2",@"COL3",@"COL4",@"COL5",@"COL6"];
    NSArray *subColumnNames =@[@"RowHeader ↓",@"qty",@"$",@"qty",@"$",@"qty",@"$",@"qty",@"$",@"qty",@"$",@"qty",@"$"];
    NSArray *contentNumber =@[@"ROW",@"10",@"10,000",@"10",@"10,000",@"10",@"10,000",@"10",@"10,000",@"10",@"10,000",@"10",@"10,000"];
    NSArray *contentPercent = @[@"ROW",@"30.1%",@"43.9%",@"30.1%",@"43.9%",@"30.1%",@"43.9%",@"30.1%",@"43.9%",@"30.1%",@"43.9%",@"30.1%",@"43.9%"];
    [_dataSrcArrNumVersion addObject:columnNames];
    [_dataSrcArrNumVersion addObject:subColumnNames];
    [_dataSrcArrPerVersion addObject:columnNames];
    [_dataSrcArrPerVersion addObject:subColumnNames];
    
    for (int i=0; i<30; i++) {
        [_dataSrcArrNumVersion addObject:contentNumber];
        [_dataSrcArrPerVersion addObject:contentPercent];
    }
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
    
    CW2DTableCell *cell = (CW2DTableCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CW2DTableCell" forIndexPath:indexPath];

    cell.nameLabel.text = _dataSrcArr[indexPath.section][indexPath.row];
    [cell setBackgroundColor:[UIColor lightTextColor]];
   
    if (indexPath.section ==0) {
        //for column header
        [cell setBackgroundColor:[UIColor colorWithRed:(float)152/255 green:(float)251/255 blue:(float)181/255 alpha:1]];
    }
    if (indexPath.section ==1){
        //for subcolumn header
        [cell setBackgroundColor:[UIColor colorWithRed:(float)180/255 green:(float)251/255 blue:(float)180/255 alpha:1]];
    }
    if (indexPath.section >2 && indexPath.section%2==1) {
        //for odd row content cells
        [cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    }
    if (indexPath.row ==0){
        //for row header
        [cell setBackgroundColor:[UIColor colorWithRed:(float)152/255 green:(float)251/255 blue:(float)181/255 alpha:1]];

    }
    return cell;
}



#pragma -UICollectionView delegate

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.collectionView.collectionViewLayout invalidateLayout];
}


#pragma -UISegmentedControl delegate
-(IBAction)changeSeg:(id)sender{
       switch (_rltTypeSwitchBtn.selectedSegmentIndex) {
        case 0:
               _dataSrcArr = _dataSrcArrNumVersion;
               [self.collectionView reloadData];
            break;
        case 1:
               _dataSrcArr = _dataSrcArrPerVersion;
               [self.collectionView reloadData];
            break;
        default:
            break;
    }
    
}

@end
