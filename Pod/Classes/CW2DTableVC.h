//
//  TwoDStatisticVController.h
//  SmartOrder-V2
//
//  Created by millionaryearl on 14-5-9.
//  Copyright (c) 2014年 Shanghai AgileMobi Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CW2DTableLayout.h"

@interface CW2DTableVC : UICollectionViewController <UIPopoverControllerDelegate>

@property (assign, nonatomic) IBOutlet UISegmentedControl *rltTypeSwitchBtn;
@property (strong, nonatomic) NSDictionary *dicRecd;

@end
