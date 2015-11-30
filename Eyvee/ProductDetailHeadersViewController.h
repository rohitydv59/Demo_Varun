//
//  ProductDetailHeadersViewController.h
//  Eyvee
//
//  Created by Varun Kapoor on 02/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYGetAllProductsMTLModel.h"
#import "EDImageViewerController.h"
#import "DetailPageContentViewController.h"

@class ProductDetailHeadersViewController;

@protocol ProductDetailHeaderViewControllerDelegate <NSObject>
- (void)didSingleTapInProductDetail:(ProductDetailHeadersViewController *)controller withCurrentIndex:(NSUInteger) currentIndex withImageArray:(NSMutableArray *)imageArray withLargeImageArray:(NSMutableArray *)largeImageArray;
@end

@interface ProductDetailHeadersViewController : UIViewController <UIPageViewControllerDataSource, DetailPageContentViewControllerDelegate,UINavigationControllerDelegate >

@property (nonatomic, weak) id <ProductDetailHeaderViewControllerDelegate> delegate;

- (CGFloat)getHeight:(CGSize)totalSize;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (strong,nonatomic) NSArray *productResizeImagesModelReceived;
@property (strong,nonatomic)EDImageViewerController * innerController;
@property (nonatomic ,strong) NSString *selectedSmallImageString;
@property BOOL isIndexChanged;
@property NSInteger currentPageIndex;
- (DetailPageContentViewController *)viewControllerAtIndex:(NSInteger)index;

@end
