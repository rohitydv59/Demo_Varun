//
//  EYMyOrdersCell.h
//  Eyvee
//
//  Created by Disha Jain on 15/10/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYAllOrdersMtlModel.h"
#import "EYUtility.h"
#import "EYConstant.h"

//typedef enum
//{
//    EYOrderCurrent,
//    EYOrderPast
//}EYMyOrderType;

@interface EYMyOrdersCell : UITableViewCell
@property (assign, nonatomic) EYMyOrderType orderType;

-(void)setCurrentProduct:(EYAllOrdersMtlModel *)order andOrderType:(EYMyOrderType)type;
+(CGFloat)getHeightForCellWithWidth:(CGFloat)width cellData:(EYAllOrdersMtlModel*)order andOrderType:(EYMyOrderType)order;

@end
