//
//  EDImageViewerController.h
//  EazyDiner
//
//  Created by Shubham Mandal on 03/06/15.
//  Copyright (c) 2015 Pulkit Arora. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "EDConstants.h"

@interface EDImageViewerController : UIViewController<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSNumber *restaurantId;

@property (nonatomic, strong) NSArray * imageArray;
@property (nonatomic, strong) NSArray * largeImageArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withCurrentIndex:(NSInteger)currentIndex;
@end
