//
//  DetailPageContentViewController.h
//  Eyvee
//
//  Created by Varun Kapoor on 02/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DetailPageContentViewController;

@protocol DetailPageContentViewControllerDelegate <NSObject>
- (void)didSingleTapInDetailPageContentViewController:(DetailPageContentViewController *)controller;
@end


@interface DetailPageContentViewController : UIViewController

@property (nonatomic, weak) id <DetailPageContentViewControllerDelegate> delegate;
@property NSUInteger pageIndex;
//@property NSString *imageFile;
@property (strong, nonatomic) UIImageView * headerImageView;

- (void)setImageURL:(NSString *)largeImageURL;
- (void)setImageURL:(NSString *)largeImageURL placeHolderImage:(UIImage *)image;

@end
