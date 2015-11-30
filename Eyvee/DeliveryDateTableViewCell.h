//
//  rentalTableViewCell.h
//  eyVee
//
//  Created by Disha Jain on 11/08/15.
//  Copyright (c) 2015 Disha Jain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
   deliveryDateMode = 0,
    selectSizeMode = 1,
    pickUpMode = 2,
    filterDeliveryDateMode=3
    
}deliveryAndSizeMode;

@interface DeliveryDateTableViewCell : UITableViewCell

@property (nonatomic, assign) deliveryAndSizeMode mode;
@property (nonatomic, strong) UIButton *calenderButton;
@property (nonatomic, strong) UILabel *middleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andMode:(deliveryAndSizeMode)mode;
- (void)updateMode:(deliveryAndSizeMode)mode;
-(void)updateMiddleLabelFromDetailVC:(NSString*)sizeReceived;
@end
