//
//  deliveryDateTableViewCell.h
//  eyVee
//
//  Created by Disha Jain on 11/08/15.
//  Copyright (c) 2015 Disha Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RentalTableViewCell.h"
typedef enum
{
    rentalCellFilter = 0,
    rentalCellAddToBag = 1,
    
    
}rentalCellMode;

@interface RentalTableViewCell : UITableViewCell

@property (strong,nonatomic)UIButton *buttonDay1;
@property (strong,nonatomic)UIButton *buttonDay2;
@property (nonatomic,assign)rentalCellMode rentalCellType;
-(void) updateCellWithFourRentDict:(NSMutableDictionary *)fourRentDict withEightRentDict:(NSMutableDictionary *)eightRentDict;
-(void)updateCellWithAppliedFilters:(NSInteger) value;
-(void)updateMode:(rentalCellMode)rentalCellModeSelected;
@end
