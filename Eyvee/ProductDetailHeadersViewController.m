//
//  ProductDetailHeadersViewController.m
//  Eyvee
//
//  Created by Varun Kapoor on 02/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "ProductDetailHeadersViewController.h"
#import "DetailPageContentViewController.h"
#import "EYUtility.h"
#import "EYConstant.h"
#import "UIImageView+AFNetworking.h"


@interface ProductDetailHeadersViewController ()
{
}
@property (strong, nonatomic) NSMutableArray *pageImages;
@property (strong, nonatomic) NSMutableArray *largeImagesArray;

@end

@implementation ProductDetailHeadersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after xloading the view.
    
    self.pageImages = [[NSMutableArray alloc] init];
    self.largeImagesArray = [[NSMutableArray alloc] init];
    
    for (EYProductResizeImages * productResizeImage in self.productResizeImagesModelReceived)
    {
//        if (mainSize.height > 568.0f && mainSize.width > 375)                          // for 6+
//        if ([EYUtility isDeviceGreaterThanSix])
        {
            if ([productResizeImage.imageTag isEqual:@"front"] )
            {
                if ([productResizeImage.imageSize isEqual:@"large"])
                {
                    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                    [dict setObject:productResizeImage.image forKey:@"imageUrl"];
                    [dict setObject:productResizeImage.imageTag forKey:@"imageTag"];
                    [self.pageImages addObject:dict];
//                    break;
                }
            }
        }
//        else
//        {
//            if ([productResizeImage.imageTag isEqual:@"front"] )
//            {
//                if ([productResizeImage.imageSize isEqual:@"medium"])
//                {
//                    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
//                    [dict setObject:productResizeImage.image forKey:@"imageUrl"];
//                    [dict setObject:productResizeImage.imageTag forKey:@"imageTag"];
//                    [self.pageImages addObject:dict];
////                    break;
//                }
//            }
//        }
        
        
        if ([productResizeImage.imageTag isEqual:@"front"] )
        {
            if ([productResizeImage.imageSize isEqual:@"large"])
            {
                NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                [dict setObject:productResizeImage.image forKey:@"imageUrl"];
                [dict setObject:productResizeImage.imageTag forKey:@"imageTag"];
                [self.largeImagesArray addObject:dict];
//                break;
            }
        }
        
    }
    
    for (EYProductResizeImages * productResizeImage in self.productResizeImagesModelReceived)
    {
//        if ([EYUtility isDeviceGreaterThanSix])
        {
            if (![productResizeImage.imageTag isEqual:@"front"] )
            {
                if ([productResizeImage.imageSize isEqual:@"large"])
                {
                    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                    [dict setObject:productResizeImage.image forKey:@"imageUrl"];
                    [dict setObject:productResizeImage.imageTag forKey:@"imageTag"];
                    [self.pageImages addObject:dict];
                }
            }
        }
//        else
//        {
//            if (![productResizeImage.imageTag isEqual:@"front"] )
//            {
//                if ([productResizeImage.imageSize isEqual:@"medium"])
//                {
//                    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
//                    [dict setObject:productResizeImage.image forKey:@"imageUrl"];
//                    [dict setObject:productResizeImage.imageTag forKey:@"imageTag"];
//                    [self.pageImages addObject:dict];
//                }
//            }
//        }
//        
        if (![productResizeImage.imageTag isEqual:@"front"] )
        {
            if ([productResizeImage.imageSize isEqual:@"large"])
            {
                NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                [dict setObject:productResizeImage.image forKey:@"imageUrl"];
                [dict setObject:productResizeImage.imageTag forKey:@"imageTag"];
                [self.largeImagesArray addObject:dict];
            }
        }
        
    }
    
    // Create page view controller
    
    NSDictionary *dict = @{UIPageViewControllerOptionInterPageSpacingKey : @(10.0)};
    self.pageViewController =  [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:dict];
    self.pageViewController.dataSource = self;
    
    DetailPageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (CGFloat)getHeight:(CGSize)totalSize
{
    CGFloat h = 0.0;

    //computing imageHeight dynamically: 64 is for status+navigation bar
    CGFloat heightOfHeaderImageView = totalSize.width * reverseAspectRatio;
    h = heightOfHeaderImageView;
    return h;
}

- (DetailPageContentViewController *)viewControllerAtIndex:(NSInteger)index
{
    if (index < 0)
    {
        return nil;
    }
    if (([self.pageImages count] == 0) || (index >= [self.pageImages count]))
    {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.

    DetailPageContentViewController *pageContentViewController = [[DetailPageContentViewController alloc] initWithNibName:nil bundle:nil];
    [pageContentViewController.view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    UIImage *placeholder = nil;
//    if (index == 0 && self.selectedSmallImageString.length > 0) {
//        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.selectedSmallImageString]];
//        placeholder = [[UIImageView sharedImageCache] cachedImageForRequest:request];
//    }
//    
//    placeholder = [UIImage imageNamed:<#(nonnull NSString *)#>]

    [pageContentViewController setImageURL:[self gettingImageUrlString:self.pageImages withIndex:index] placeHolderImage:placeholder];
    
    pageContentViewController.pageIndex = index;
    pageContentViewController.delegate = self;
    pageContentViewController.view.tag = index;

    return pageContentViewController;
}


-(NSString *) gettingImageUrlString:(NSArray *)array withIndex:(NSInteger)index
{
    NSMutableDictionary * dict = (NSMutableDictionary *) [array objectAtIndex:index];
    return [dict objectForKey:@"imageUrl"];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = viewController.view.tag;
    UIViewController *controller = [self viewControllerAtIndex:index - 1];
    return controller;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = viewController.view.tag;
    UIViewController *controller = [self viewControllerAtIndex:index + 1];
    return controller;
}

#pragma mark - Page indicator

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageImages count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    if (self.isIndexChanged)
    {
        return self.currentPageIndex;
    }
    return 0;
}

- (void)didSingleTapInDetailPageContentViewController:(DetailPageContentViewController *)controller
{
    if ([self.delegate respondsToSelector:@selector(didSingleTapInProductDetail:withCurrentIndex:withImageArray:withLargeImageArray:)])
    {
        [self.delegate didSingleTapInProductDetail:self withCurrentIndex:controller.pageIndex withImageArray:self.pageImages withLargeImageArray:self.largeImagesArray];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
