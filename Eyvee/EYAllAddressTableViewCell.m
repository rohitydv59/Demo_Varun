//
//  EYAllAddressTableViewCell.m
//  Eyvee
//
//  Created by kartik shahzadpuri on 9/29/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYAllAddressTableViewCell.h"
#import "EYShippingAddressMtlModel.h"

@interface EYAllAddressTableViewCell()
@property (nonatomic, strong) IBOutlet UILabel * addressDescription;
@property (nonatomic, strong) EYShippingAddressMtlModel * shippingAddress;
@end
@implementation EYAllAddressTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)populateAddressWithData:(EYShippingAddressMtlModel *)address
{
    _shippingAddress = address;
    
    NSMutableString * mixedStrng = [address.fullName mutableCopy];
    if (address.contactNum.length > 0) {
        [mixedStrng appendString:[NSString stringWithFormat:@",%@",address.contactNum]];
    }
    [_addressDescription setText:[NSString stringWithFormat:@"%@\n%@,%@\n%@-%@\n%@,%@",mixedStrng,address.addressLine1,address.addressLine2,address.cityName,address.pincode,address.stateName,address.countryName]];
}

#pragma Button Actions

- (IBAction)pressSelect:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(selectAddressWithData:)]) {
        [_delegate selectAddressWithData:_shippingAddress];
    }
}

- (IBAction)pressEdit:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(editAddressWithData:)]) {
        [_delegate editAddressWithData:_shippingAddress];
    }
}

- (IBAction)pressRemove:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(removeAddressWithData:)]) {
        [_delegate removeAddressWithData:_shippingAddress];
    }
}
@end
