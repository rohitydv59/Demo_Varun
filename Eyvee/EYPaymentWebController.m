//
//  EYPaymentWebController.m
//  Eyvee
//
//  Created by Neetika Mittal on 07/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYPaymentWebController.h"
#import "EYThankyouViewController.h"
#import "PayUWebServiceManager.h"
#import "EYOrderPlacedVC.h"
#import "PayUConstant.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "EYUtility.h"
#import "EYConstant.h"

@interface EYPaymentWebController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic,strong) NSString *loadingUrl;
@property (nonatomic, strong) NSString *errorString;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation EYPaymentWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Pay & Finish";
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.webView loadRequest:self.request];
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    
    
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:self.activityIndicator];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.webView.frame = self.view.bounds;
    CGSize size = self.view.bounds.size;
    CGFloat kActivityIndicatorHeight = 40.0;
    self.activityIndicator.frame = (CGRect){(size.width/2-kActivityIndicatorHeight/2),64.0,kActivityIndicatorHeight,kActivityIndicatorHeight};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebView delegate

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
    BOOL isUrlMatchFound = NO;
    NSArray *pgList = [PayUWebServiceManager sharedManger].pgUrlList;
    for(NSString *pgUrl in pgList){
        if([_loadingUrl isEqualToString:pgUrl] || [_loadingUrl rangeOfString:pgUrl options:NSCaseInsensitiveSearch].location != NSNotFound){
            isUrlMatchFound = YES;
            break;
        }
    }
    
    if ([_loadingUrl containsString:kSuccessUrl]) {
        NSString *sourceCodeString = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
        if ([sourceCodeString containsString:@"failure://"]) {
            [self processFailureWhilePayment:sourceCodeString];
        }
        else if ([sourceCodeString containsString:@"success://"])
        {
            EYThankyouViewController *thanksVC = [[EYThankyouViewController alloc]initWithNibName:nil bundle:nil];
            thanksVC.transactionId = self.transactionId;
            [[EYUtility shared]removeCartId];
             [[NSNotificationCenter defaultCenter] postNotificationName:kCartUpdatedNotification object:nil userInfo:@{@"count" : @(0)}];
            
            [self.navigationController pushViewController:thanksVC animated:YES];
        }
    }
    else if ([_loadingUrl containsString:kFailureUrl]) {
        NSString *sourceCodeString = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
        if ([sourceCodeString containsString:@"failure://"]) {
            [self processFailureWhilePayment:sourceCodeString];
            }
    }
    
    if (!isUrlMatchFound && pgList && !webView.isLoading)
    {
// hide activity indicator
    }

    if ([[webView stringByEvaluatingJavaScriptFromString:@"document.readyState"] isEqualToString:@"complete"]) {
        NSLog(@"Pageloaded completely-------");
    }
    
    if (!webView.isLoading) {
        NSLog(@"webView.isLoading-------");
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
    [self.activityIndicator stopAnimating];
    NSLog(@"did fail with error : %@",error.localizedDescription);
   // [EYUtility showAlertView:@"EYVEE" message:error.localizedDescription];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)naavigationType {
    
     [self.activityIndicator startAnimating];
    NSURL *url = request.URL;
    _loadingUrl = url.absoluteString;
    
    NSString *bodyStr = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    NSLog(@"request ur :%@",_loadingUrl);
    NSLog(@"request body : %@",  bodyStr);
    NSLog(@"request method : %@",request.HTTPMethod);
    NSLog(@"request headers : %@",request.allHTTPHeaderFields);
    
    if ([[url scheme] isEqualToString:@"ios"]) {
        NSString *responseStr = [url  absoluteString];
        NSString *search = @"success";
        
        if([responseStr rangeOfString:search options:NSCaseInsensitiveSearch].location != NSNotFound){
            NSDictionary *InfoDict = [NSDictionary dictionaryWithObject:responseStr forKey:INFO_DICT_RESPONSE];
            [[NSNotificationCenter defaultCenter] postNotificationName:PAYMENT_SUCCESS_NOTIFICATION object:InfoDict];
            NSLog(@"success block with infoDict = %@",InfoDict);
        }
        
        search = @"failure";
        if([responseStr rangeOfString:search options:NSCaseInsensitiveSearch].location != NSNotFound){
            NSDictionary *InfoDict = [NSDictionary dictionaryWithObject:responseStr forKey:INFO_DICT_RESPONSE];;
            [[NSNotificationCenter defaultCenter] postNotificationName:PAYMENT_FAILURE_NOTIFICATION object:InfoDict];
            NSLog(@"failure block with infoDict = %@",InfoDict);
        }
        search = @"cancel";
        
        if([responseStr rangeOfString:search options:NSCaseInsensitiveSearch].location != NSNotFound){
            NSDictionary *InfoDict = [NSDictionary dictionaryWithObject:responseStr forKey:INFO_DICT_RESPONSE];;
            [[NSNotificationCenter defaultCenter] postNotificationName:PAYMENT_CANCEL_NOTIFICATION object:InfoDict];
            NSLog(@"cancel block with infoDict = %@",InfoDict);
        }
    }
    return YES;
}

// Reachability methods
- (void)reachabilityDidChange:(NSNotification *)notification {
    Reachability *reach = [notification object];
    
    if ([reach isReachable]) {
        
    } else {
        [Utils startPayUNotificationForKey:PAYU_ERROR intValue:PInternetNotReachable object:self];
    }
}


- (void)processFailureWhilePayment:(NSString *)sourceCodeString
{
    NSRange range = [sourceCodeString rangeOfString:kPaymentFailureString];
    if (range.location != NSNotFound) {
        _errorString = [sourceCodeString substringFromIndex:(range.location+range.length)];
        NSRange endRange = [_errorString rangeOfString:@"</pre>"];
        _errorString = [_errorString substringToIndex:endRange.location];
        
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        EYOrderPlacedVC *orderPlacedVC = [delegate.storyboard instantiateViewControllerWithIdentifier:@"EYOrderPlacedVC"];
        orderPlacedVC.message = _errorString;
        [self.navigationController pushViewController:orderPlacedVC animated:YES];
    }
}


@end
