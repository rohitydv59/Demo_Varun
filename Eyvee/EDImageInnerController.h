//
//  EDImageInnerController.h
//  EazyDiner
//
//  Created by Shubham Mandal on 03/06/15.
//  Copyright (c) 2015 Pulkit Arora. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EDImageInnerController;
@protocol EDImageInnerControllerDelegate <NSObject>

- (void)didSingleTapInViewController:(EDImageInnerController *)controller;

@end

@interface EDImageInnerController : UIViewController

@property (nonatomic, strong) NSString *imageStr;
@property (nonatomic, strong) NSString *largeImageStr;

@property (nonatomic, weak) id <EDImageInnerControllerDelegate> delegate;

@end
