//
//  EYOrderCell.h
//  Eyvee
//
//  Created by Disha Jain on 21/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYUtility.h"
#import "EYAllOrdersMtlModel.h"

//typedef enum
//{
//    EYPastOrders,
//    EYCurrentOrders
//}EYOrderType;

@interface EYOrderCell : UITableViewCell
-(void)updateOrderDetailCell:(EYAllOrdersMtlModel*)orderModel;
+(CGFloat)getHeightForCellWithWidth:(CGFloat)width andProductModel:(EYAllOrdersMtlModel*)model;

@end
