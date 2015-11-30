//
//  EYStaticViewController.m
//  Eyvee
//
//  Created by Naman Singhal on 15/10/15.
//  Copyright © 2015 Neetika Mittal. All rights reserved.
//

#import "EYStaticViewController.h"

@interface EYStaticViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation EYStaticViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webView];

    if (self.link.length > 0) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.link]];
        [self.webView loadRequest:request];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = self.titleText;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.webView.frame = self.view.bounds;
}

@end
