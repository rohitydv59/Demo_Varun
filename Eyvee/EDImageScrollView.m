//
//  EDImageScrollView.m
//  EazyDiner
//
//  Created by Naman Singhal on 10/07/15.
//  Copyright (c) 2015 Pulkit Arora. All rights reserved.
//

#import "EDImageScrollView.h"
#import "UIImageView+AFNetworking.h"
#import "EYUtility.h"

@interface EDImageScrollView () <UIScrollViewDelegate>
{
    bool isLargeImage;
    bool isSetupDone;
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSString *normalImageURL;

@end

@implementation EDImageScrollView

- (id)initWithFrame:(CGRect)frame
{
    isLargeImage = NO;
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.clipsToBounds = YES;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
      
        [self addSubview:_imageView];
        [super setDelegate:self];
    }
    return self;
}

- (void)setLargeImageStr:(NSString *)largeImageStr
{
    _largeImageStr = largeImageStr;
}

- (void)centerScrollViewContents
{
    if (!self.imageView.image)
    {
        return;
    }
    
    CGSize boundsSize = self.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
}


- (void)setInternalImageAtURL:(NSString *)imageURL
{
    if (!imageURL) {
        return;
    }
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageURL]];
    
    __weak typeof (self) weakself = self;
    [self.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
     {
         [weakself processImageResponse:image];
         
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
         [weakself processImageResponse:nil];
         
     }];
}

- (void)setImageURL:(NSString *)imageURL
{
    self.normalImageURL = imageURL;
    [self setInternalImageAtURL:imageURL];
}

- (void)resetView
{
    self.contentSize = CGSizeZero;
    self.contentOffset = CGPointZero;
    self.minimumZoomScale = 1.0;
    self.maximumZoomScale = 1.0;
    self.zoomScale = 1.0;
    
    _imageView.frame = CGRectZero;
    _imageView.hidden = YES;
    isSetupDone = NO;
}

- (void)processImageResponse:(UIImage *)image
{
    if (!image)
    {
        return;
    }
    
    self.imageView.image = image;
    [self setupInitialZoomAndFrame];
}

- (void)setupInitialZoomAndFrame
{
    if (isSetupDone) {
        return;
    }
    
    if (!self.imageView.image) {
        [self resetView];
        return;
    }
    
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = self.imageView.image.size;
    
    CGFloat xScale = boundsSize.width / imageSize.width;
    CGFloat yScale = boundsSize.height / imageSize.height;
    
    CGFloat minScale = MIN(xScale, yScale);
    CGFloat maxScale = 3.0;
    
    self.minimumZoomScale = minScale;
    self.maximumZoomScale = maxScale;
    
    self.imageView.hidden = NO;
    self.imageView.frame = (CGRect) {0.0, 0.0, imageSize};
    self.contentSize = imageSize;

    [self centerScrollViewContents];
    self.zoomScale = minScale;
    self.scrollEnabled = NO;
    
    isSetupDone = YES;
}

#pragma mark - Scroll view delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (![EYUtility isDeviceGreaterThanSix])
    {
        if (scrollView.zoomScale >= 1.5)
        {
            if (!isLargeImage) {
                isLargeImage = YES;
                [self setInternalImageAtURL:self.largeImageStr];
            }
        }
        else {
            if (isLargeImage) {
                isLargeImage = NO;
                [self setInternalImageAtURL:self.normalImageURL];
            }
        }
    }
    [self centerScrollViewContents];

    if (scrollView.zoomScale == self.minimumZoomScale)
    {
        scrollView.scrollEnabled = NO;
    }
    else
    {
        scrollView.scrollEnabled = YES;
    }
}

- (void)setDelegate:(id)delegate
{
    // Empty to ensure that nobody sets the delegate to this scroll view
}

#pragma mark - Gesture

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer *)recognizer
{
    CGPoint pointInView = [recognizer locationInView:self.imageView];
    CGFloat newZoomScale;
    if (self.zoomScale - self.minimumZoomScale > self.maximumZoomScale - self.zoomScale) {
        newZoomScale = self.minimumZoomScale;
    }
    else {
        newZoomScale = self.maximumZoomScale;
    }
 
    CGSize scrollViewSize = self.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    [self zoomToRect:rectToZoomTo animated:YES];
}

@end
