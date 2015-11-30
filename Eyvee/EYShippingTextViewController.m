//
//  EYShippingTextViewController.m
//  Eyvee
//
//  Created by Disha Jain on 20/10/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYShippingTextViewController.h"
#import "EYAllAPICallsManager.h"
#import "EYConstant.h"
#import "EYUtility.h"
#import "EYError.h"
#import "EYSiteInfoMtlModel.h"

@interface EYShippingTextViewController ()

@end

@implementation EYShippingTextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
   
    if (self.siteInfoMode == SiteInfoShippingTextMode)
    {
        self.navigationItem.title = @"Shipping";
        [self getShippingText];
    }
    else if(self.siteInfoMode == SiteInfoQualityTextMode)
    {
        self.navigationItem.title = @"Quality";
        [self getShippingText];
    }
    else if(self.siteInfoMode == SiteInfoDefault)
    {
        _siteInfoImageView.image = [UIImage imageNamed:@"style_notes"];
        self.navigationItem.title = @"Stylist Notes";
        _shippingLabel.text = _textString;
        _mainLabel.text = _headingString;
    }
    else
    {
        self.navigationItem.title = @"Pincode & Delivery";
        _siteInfoImageView.image = [UIImage imageNamed:@"why_location"];
        _shippingLabel.text = _textString;
        _mainLabel.text = @"Pincode & Delivery";
    }
        
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)getShippingText
{
    __weak __typeof(self) weakSelf = self;
  //  [EYUtility showHUDWithTitle:@"Loading"];

    [[EYAllAPICallsManager sharedManager]getSiteInfoWithParameters:nil withRequestPath:kSiteInfoFilePath shouldCache:NO withCompletionBlock:^(id responseObject, EYError *error) {
        if (responseObject)
        {
           [weakSelf setShippingText:responseObject withError:error];
        }
        else
        {
           
        }

    }];
}

-(void)setShippingText:(id)response withError:(EYError *)error
{
    [EYUtility hideHUD];
    if (response && !error)
    {
        EYSiteInfoMtlModel *siteModel= (EYSiteInfoMtlModel*)response;
        
        if (_siteInfoMode == SiteInfoShippingTextMode)
        {
            _mainLabel.text = @"Shipping & Returns";
            _siteInfoImageView.image = [UIImage imageNamed:@"shipping"];
            _shippingLabel.text = siteModel.shippingInformation;
            
        }
        else if(_siteInfoMode == SiteInfoQualityTextMode)
        {
            _mainLabel.text = @"Quality Guarantee";
            _siteInfoImageView.image = [UIImage imageNamed:@"quality_assurance"];
            _shippingLabel.text = siteModel.qualityAssurance;
        }
    }
    else
        {
            
        }
}


@end
