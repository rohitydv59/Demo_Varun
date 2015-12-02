//
//  AppDelegate.m
//  Eyvee
//
//  Created by Neetika Mittal on 10/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import "AppDelegate.h"
#import "EYTabContainer.h"
#import "EYFacebookLogin.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "EYWebServiceManager.h"
#import "EYWishlistModel.h"
#import "EYCartModel.h"
#import "EYAccountManager.h"
#import "EYPaymentOptionsController.h"
#import "EYCacheManager.h"
#import "EYConstant.h"
#import "EYUtility.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    EYTabContainer *tabVC = [[EYTabContainer alloc] initWithNibName:nil bundle:nil];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = tabVC;
    [self.window makeKeyAndVisible];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
    
    UIImage *myImage = [UIImage imageNamed:@"back"]; //set your backbutton imagename
    UIImage *backButtonImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [[UINavigationBar appearance] setBackIndicatorImage:backButtonImage];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backButtonImage];
    
//    [EYFacebookLogin sharedManger];
//    [[FBSDKApplicationDelegate sharedInstance] application:application
//                             didFinishLaunchingWithOptions:launchOptions];
//    
    [[EYAccountManager sharedManger]updateUserAccountInfo];
//
//    [EYWebServiceManager sharedManager];
//    
//    [[EYWishlistModel sharedManager] updateWishListModel];
//    [[EYWishlistModel sharedManager] updateProductIdsOfWishlist];
    
    // get wishlist 
//    EYWishlistModel *wishlistModel = [EYWishlistModel sharedManager];
//    wishlistModel.wishlistRequestState = wishlistRequestNeedToSend;
//    [wishlistModel  getWishlistItemsWithCompletionBlock:nil];
    
//    EYCartModel * cartManager = [EYCartModel sharedManager];
//    cartManager.cartRequestState = cartRequestNeedToSend;
   
    // Override point for customization after application launch.
    
    if (![EYAccountManager sharedManger].isUserLoggedIn && ![EYAccountManager sharedManger].isGuestMode)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"LaunchScreen" owner:self options:nil];
        self.splashView = [array objectAtIndex:0];
        self.splashView.frame = self.window.bounds;
        [self.window addSubview:self.splashView];
        self.shouldShowOnboarding = YES;
    }
    
    NSString *timeStamp = [[NSUserDefaults standardUserDefaults]objectForKey:kCacheClearedTime];
    if (timeStamp) {
        if ([EYUtility cacheNeedsToBeCleared:timeStamp]){
            [self clearCache];
        }
    }
    else
    {
        [self clearCache];
    }
    
    // fabric
    [Fabric with:@[[Crashlytics class]]];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
}

- (void)applicationWillResignActive:(UIApplication *)application {
//     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

//- (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible {
//    static NSInteger NumberOfCallsToSetVisible = 0;
//    if (setVisible)
//        NumberOfCallsToSetVisible++;
//    else
//        NumberOfCallsToSetVisible--;
//    
//    // The assertion helps to find programmer errors in activity indicator management.
//    // Since a negative NumberOfCallsToSetVisible is not a fatal error,
//    // it should probably be removed from production code.
//    NSAssert(NumberOfCallsToSetVisible >= 0, @"Network Activity Indicator was asked to hide more often than shown");
//    
//    // Display the indicator as long as our static counter is > 0.
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:(NumberOfCallsToSetVisible > 0)];
//}
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.appstreet.Eyvee" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Eyvee" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Eyvee.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - clear cache - 
- (void)clearCache
{
    [[EYCacheManager manager]clearCache:^{
        NSString *timeStamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
        [[NSUserDefaults standardUserDefaults] setObject:timeStamp forKey:kCacheClearedTime];
    }];
}

@end
