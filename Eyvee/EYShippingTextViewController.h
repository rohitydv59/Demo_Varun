//
//  EYShippingTextViewController.h
//  Eyvee
//
//  Created by Disha Jain on 20/10/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    SiteInfoDefault = 0,
    SiteInfoShippingTextMode = 1,
    SiteInfoQualityTextMode = 2,
    SiteInfoWhyMode = 3
} SiteInfoVCMode;

@interface EYShippingTextViewController : UIViewController

@property (nonatomic,assign) SiteInfoVCMode siteInfoMode;
@property (weak, nonatomic) IBOutlet UILabel *shippingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *siteInfoImageView;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (strong, nonatomic) NSString *textString;
@property (strong, nonatomic) NSString *headingString;

@end
