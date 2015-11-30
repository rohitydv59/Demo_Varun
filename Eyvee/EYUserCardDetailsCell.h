//
//  EYUserCardDetailsCell.h
//  Eyvee
//
//  Created by Neetika Mittal on 02/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UserDetailTypeCardNumber = 0,
    UserDetailTypeNameOnCard = 1,
    UserDetailTypeCVV = 2,
    UserDetailTypeExpiryDate = 3
}UserDetailType;

@interface EYUserCardDetailsCell : UITableViewCell

@property (nonatomic, assign) UserDetailType type;
@property (nonatomic, strong) UITextField *tf;

@end
