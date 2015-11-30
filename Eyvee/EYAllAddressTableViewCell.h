//
//  EYAllAddressTableViewCell.h
//  Eyvee
//
//  Created by kartik shahzadpuri on 9/29/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EYShippingAddressMtlModel;

@protocol EYAddressActionDelegate <NSObject>

- (void)editAddressWithData:(EYShippingAddressMtlModel *)address;
- (void)removeAddressWithData:(EYShippingAddressMtlModel *)address;
- (void)selectAddressWithData:(EYShippingAddressMtlModel *)address;

@end

@interface EYAllAddressTableViewCell : UITableViewCell
@property (nonatomic, weak) id<EYAddressActionDelegate> delegate;
- (void)populateAddressWithData:(EYShippingAddressMtlModel *)address;
@end
