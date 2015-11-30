//
//  EYAddressTextField.m
//  Eyvee
//
//  Created by Disha Jain on 25/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYAddressTextField.h"
#import "EYConstant.h"

@implementation EYAddressTextField

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.textColor = kBlackTextColor;
        self.font = AN_REGULAR(15.0);
        self.autocorrectionType = UITextAutocorrectionTypeNo;

    }
    return self;
}
@end
