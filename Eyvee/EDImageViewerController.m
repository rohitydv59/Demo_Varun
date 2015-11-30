 //
//  EDImageViewerController.m
//  EazyDiner
//
//  Created by Shubham Mandal on 03/06/15.
//  Copyright (c) 2015 Pulkit Arora. All rights reserved.
//

#import "EDImageViewerController.h"
#import "EDImageInnerController.h"
#import "ProductDetailViewController.h"
#import "EYConstant.h"
#import "UIImageView+AFNetworking.h"
#import "EYTabContainer.h"
#import "EYHomeViewController.h"
#import "EYGridTableViewController.h"
#import "EYUtility.h"

@interface EDImageViewerController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, EDImageInnerControllerDelegate>
{
   BOOL _shouldHideNavBar;
}
@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIButton *crossBtn;

@end

@implementation EDImageViewerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withCurrentIndex:(NSInteger)currentIndex
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.selectedIndex = currentIndex;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configurePageController];
    self.modalPresentationCapturesStatusBarAppearance = YES;
    
    self.crossBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.crossBtn setTintColor:[UIColor blackColor]];
    [self.crossBtn addTarget:self action:@selector(crossBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.crossBtn setImage:[UIImage imageNamed:@"cross_img"] forState:UIControlStateNormal];
    [self.view addSubview:_crossBtn];
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationNone;
}

- (BOOL)prefersStatusBarHidden
{
    return _shouldHideNavBar;
}

- (void)configurePageController
{
    _shouldHideNavBar = YES;

    if (_pageController)
    {
        [_pageController willMoveToParentViewController:nil];
        [_pageController.view removeFromSuperview];
        [_pageController removeFromParentViewController];
    }
    
    NSDictionary *dict = @{UIPageViewControllerOptionInterPageSpacingKey : @(10.0)};
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:dict];
    
    self.pageController.view.backgroundColor = [UIColor whiteColor];
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    [self addChildViewController:self.pageController];
    
    self.pageController.view.frame = self.view.bounds;
    [self.view addSubview:self.pageController.view];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    [self.pageControl setBackgroundColor:[UIColor clearColor]];
    self.pageControl.numberOfPages = self.imageArray.count;
    [self.view addSubview:self.pageControl];
    
    self.pageControl.currentPage = _selectedIndex;
    [self.pageController setViewControllers:@[[self viewControllerForIndex:_selectedIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [self.pageController didMoveToParentViewController:self];
}

- (EDImageInnerController *)viewControllerForIndex:(NSInteger)index
{
    if (index < 0)
    {
        return nil;
    }
    
    if (index >= _imageArray.count)
    {
        return nil;
    }
    
    EDImageInnerController *controller = [[EDImageInnerController alloc] initWithNibName:nil bundle:nil];
    controller.imageStr = [self gettingImageUrlString:self.imageArray withIndex:index];
    controller.largeImageStr = [self gettingImageUrlString:self.largeImageArray withIndex:index];
    controller.delegate = self;
    controller.view.tag = index;

    return controller;
}

-(NSString *) gettingImageUrlString:(NSArray *)array withIndex:(NSInteger)index
{
    NSMutableDictionary * dict = (NSMutableDictionary *) [array objectAtIndex:index];
    return [dict objectForKey:@"imageUrl"];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGRect rect = self.view.bounds;
    self.crossBtn.frame = (CGRect){rect.size.width - 44.0, 0.0, 44.0, 44.0};
    self.crossBtn.frame = CGRectInset(self.crossBtn.frame, -20, -20);
    self.pageController.view.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    [self.pageControl setFrame:CGRectMake(self.pageController.view.frame.origin.x, self.pageController.view.frame.size.height - kPageControlHeight, self.pageController.view.frame.size.width, kPageControlHeight)];
}

#pragma mark - uipageview datasource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = viewController.view.tag;
//    NSLog(@"viewControllerBeforeViewController index is %ld", (long)index);
    self.pageControl.currentPage = index;
    UIViewController *controller = [self viewControllerForIndex:index - 1];
    return controller;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = viewController.view.tag;
    NSLog(@"viewControllerAfterViewController index is %ld", (long)index);
    self.pageControl.currentPage = index;
    UIViewController *controller = [self viewControllerForIndex:index + 1];
    return controller;
}


//- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
//{
//    return [self.imageArray count];
//}
//- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
//{
////    if (self.isIndexChanged)
////    {
////        return self.currentPageIndex;
////    }
//    return 0;
//}

#pragma mark - UIPageViewController delegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    NSArray * controllerList = self.pageController.viewControllers;
    _selectedIndex = [controllerList[0] view].tag;
}

#pragma mark - EDImageInnerControllerDelegate

- (void)didSingleTapInViewController:(EDImageInnerController *)controller
{
    [self setNeedsStatusBarAppearanceUpdate];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.pageController.view.backgroundColor = [UIColor whiteColor];
        [self setNeedsStatusBarAppearanceUpdate];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark animation
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];

    if ([[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] isKindOfClass:[EYTabContainer class]])
    {
        EYTabContainer * tabViewController = (EYTabContainer*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        ProductDetailViewController *fromViewController;
        for (UINavigationController * nav in tabViewController.controllers)
        {
            for (UIViewController * vc in nav.viewControllers)
            {
                if ([vc isKindOfClass:[ProductDetailViewController class]])
                {
                    fromViewController = (ProductDetailViewController *) vc;
                }
            }
        }
        if ([[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] isKindOfClass:[EDImageViewerController class]])
        {
            EDImageViewerController *toViewController = (EDImageViewerController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
 
            NSTimeInterval duration = [self transitionDuration:transitionContext];
            NSString *img_URL;
            img_URL = [self gettingImageUrlString:self.imageArray withIndex:self.selectedIndex];
            
            UIImageView *  imgView = [[UIImageView alloc] init];
            [imgView setImageWithURL:[NSURL URLWithString:img_URL]];
            
            CGRect newFrame = [self settingFrame:imgView.image];
            CGRect headerRectFrame = fromViewController.header.view.frame;
            
            CGRect headerRectInSuperView = [fromViewController.tbView convertRect:headerRectFrame toView:[fromViewController.tbView superview]];
            
            UIImageView *cellImageSnapshot = [[UIImageView alloc] initWithFrame:CGRectMake(headerRectInSuperView.origin.x, headerRectInSuperView.origin.y, fromViewController.header.view.frame.size.width, fromViewController.header.view.frame.size.height - kPageControlHeight)];
            
            UIView * tempView = [[UIView alloc] initWithFrame:cellImageSnapshot.frame];
            [tempView setBackgroundColor:[UIColor whiteColor]];
            [containerView addSubview:tempView];
            
            [cellImageSnapshot setBackgroundColor:[UIColor whiteColor]];
            //    cellImageSnapshot.contentMode = UIViewContentModeScaleAspectFit;
            
            UIImageView *imgV = [[UIImageView alloc]initWithImage:imgView.image];
            [cellImageSnapshot setImage:imgV.image];
            [self.view addSubview:cellImageSnapshot];
            
            toViewController.view.alpha = 0;
            
            [containerView addSubview:toViewController.view];
            [containerView addSubview:cellImageSnapshot];
            
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                CGRect rect = toViewController.pageController.view.frame;
                tempView.frame = rect;
                cellImageSnapshot.frame = newFrame;
            } completion:^(BOOL finished)
             {
                 toViewController.view.alpha = 1.0;
                 cellImageSnapshot.hidden = YES;
                 [cellImageSnapshot removeFromSuperview];
                 [tempView removeFromSuperview];
                 [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
             }];

        }
    }
    else if ([[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] isKindOfClass:[EDImageViewerController class]])         // zoom and scroll animation dismissal
    {
        EDImageViewerController *fromViewController = (EDImageViewerController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

        if ([[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] isKindOfClass:[EYTabContainer class]])
        {
            //here
            EYTabContainer * tabViewController = (EYTabContainer*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            for (UINavigationController * nav in tabViewController.controllers)
            {
                for (UIViewController * vc in nav.viewControllers)
                {
                    if ([vc isKindOfClass:[ProductDetailViewController class]])
                    {
                        //hereee
                        ProductDetailViewController *toViewController = (ProductDetailViewController *) vc;
                        [toViewController.bottomView setHidden:YES];
                        NSTimeInterval duration = [self transitionDuration:transitionContext];
                        NSString *img_URL;
                        img_URL = [self gettingImageUrlString:toViewController.header.innerController.imageArray withIndex:self.selectedIndex];
                        
                        UIImageView *imageView = [[UIImageView alloc]init];
                        [imageView setImageWithURL:[NSURL URLWithString:img_URL]];
                        
                        toViewController.header.isIndexChanged = YES;
                        toViewController.header.currentPageIndex = fromViewController.selectedIndex;
                        [toViewController.header.pageViewController setViewControllers:@[[toViewController.header viewControllerAtIndex:fromViewController.selectedIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
                        
                        CGRect headerRectFrame = toViewController.header.view.frame;
                        
                        CGRect headerRectInSuperView = [toViewController.tbView convertRect:headerRectFrame toView:[toViewController.tbView superview]];
                        
                        CGRect newFrame = [self settingFrame:imageView.image];
                        UIImageView *cellImageSnapshot;
                        
                        cellImageSnapshot = [[UIImageView alloc] initWithFrame:CGRectMake(newFrame.origin.x, newFrame.origin.y, newFrame.size.width, newFrame.size.height)];

                        [cellImageSnapshot setBackgroundColor:[UIColor whiteColor]];
                        cellImageSnapshot.image = imageView.image;
                        
                        [containerView addSubview:cellImageSnapshot];
                        
                        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            fromViewController.view.alpha = 0.0;
                            if (cellImageSnapshot.image.size.width / cellImageSnapshot.image.size.height < 1)
                            {
                                cellImageSnapshot.frame = CGRectMake(headerRectInSuperView.origin.x, headerRectInSuperView.origin.y + 20, newFrame.size.width , newFrame.size.height );     // 20 is for status bar
                            }
                            else
                            {
                                CGFloat hh = ((self.view.frame.size.height + 64) - cellImageSnapshot.image.size.height) / 2;
                                NSLog(@"to be checked ");
                                cellImageSnapshot.frame = CGRectMake(0, hh, newFrame.size.width , newFrame.size.height - kPageControlHeight);
                            }

                        } completion:^(BOOL finished)
                         {
                             [toViewController.bottomView setHidden:NO];
                             [cellImageSnapshot removeFromSuperview];
                             [transitionContext completeTransition:YES];
                             
                         }];
                        
                    }
                }
            }
        }
    }
}


-(CGRect)settingFrame:(UIImage *) image
{
    CGSize imgSize;
// img size remain constant
//    if (mainSize.height > 568.0f && mainSize.width > 375)                          // for 6+
    if ([EYUtility isDeviceGreaterThanSix])                          // for 6+
    {
        imgSize = CGSizeMake(480 , 720);
    }
    else
    {
        imgSize = CGSizeMake(360 , 540);
    }
    UIImageView *imgView = [[UIImageView alloc] init];
    CGSize boundsSize = self.view.bounds.size;

    imgView.frame = (CGRect) {0.0, 0.0, imgSize};
    CGRect contentsFrame = imgView.frame;
    
    if (contentsFrame.size.width < boundsSize.width)
    {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    }
    else
    {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height)
    {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    }
    else
    {
        contentsFrame.origin.y = 0.0f;
    }
    
    imgView.frame = contentsFrame;
    CGFloat xScale = boundsSize.width / imgSize.width;
    CGFloat yScale = boundsSize.height / imgSize.height;
    CGFloat minScale = MIN(xScale, yScale);
    
    float newHeight = 0.0 , newWidth = 0;
    
    newWidth = imgView.frame.size.width * minScale;
    newHeight = imgView.frame.size.height * minScale;
    
    imgView.frame = CGRectMake( imgView.frame.origin.x,  imgView.frame.origin.y, newWidth, newHeight);
    
    contentsFrame = imgView.frame;
    
    if (contentsFrame.size.width < boundsSize.width)
    {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    }
    else
    {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height)
    {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    }
    else
    {
        contentsFrame.origin.y = 0.0f;
    }
    imgView.frame = contentsFrame;
//    NSLog(@"imgView.frame is %@", NSStringFromCGRect(imgView.frame));
    return imgView.frame;
}

- (void)crossBtnTapped:(id)sender
{
    _shouldHideNavBar = NO;

    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
