 //
//  EYMyOrdersViewController.m
//  Eyvee
//
//  Created by Disha Jain on 21/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYMyOrdersViewController.h"
#import "EYOrderDetailsViewController.h"
#import "EYUtility.h"
#import "EYConstant.h"
#import "EYAllOrdersMtlModel.h"
#import "EYAllAPICallsManager.h"
#import "EYMyOrdersCell.h"
#import "EYAccountManager.h"
#import "EYUserInfo.h"
#import "EDLoaderView.h"
#import "EYEmptyView.h"
#import "EYError.h"
#import "EYShippingAddressMtlModel.h"
#import "EYShippingAddressModel.h"
@interface EYMyOrdersViewController ()
@property (nonatomic, strong) NSArray *allOrdersArray;
@property (nonatomic, strong) NSMutableArray *pastOrdersArray;
@property (nonatomic, strong) NSMutableArray *currentOrdersArray;
@property (nonatomic, strong) EYAllAddressMtlModel *localAddModel;
@end

@implementation EYMyOrdersViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationItem.title = @"Orders";
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"Support" style:UIBarButtonItemStylePlain target:self action:@selector(actionSupport:)];
        self.navigationItem.rightBarButtonItem = rightBtn;
        NSDictionary *barButtonAttributes = @{NSFontAttributeName : AN_REGULAR(16.0),
                                              NSForegroundColorAttributeName : kTextFieldTypingColor};
        [rightBtn setTitleTextAttributes:barButtonAttributes forState:UIControlStateNormal];
        [rightBtn setEnabled:NO];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[EYMyOrdersCell class] forCellReuseIdentifier:@"orderCell"];
    self.tableView.backgroundColor = kSectionBgColor;
    _allOrdersArray = @[]; 
    
    _pastOrdersArray = [[NSMutableArray alloc]init];
    _currentOrdersArray = [[NSMutableArray alloc]init];
    
    [[EYShippingAddressModel sharedManager]apiCallForAllAddress:nil requestPath:kGetAllUserAddressesRequestPath withCompletionBlock:^(id responseObject, EYError *error)
    {
        _localAddModel= (EYAllAddressMtlModel*)responseObject;
    }];
  
   
   [self makeApiCall];
}

-(void)makeApiCall
{
    self.tableView.tableHeaderView = [[EDLoaderView alloc] init];
    
     NSString *userIdStr = [NSString stringWithFormat:@"%@",[EYAccountManager sharedManger].loggedInUser.userId];
    NSString * userId = userIdStr ? userIdStr:@"-1";
    
    __weak typeof (self) weakSelf = self;
    
    [[EYAllAPICallsManager sharedManager] getAllOrdersRequestWithParameters:@{@"userid": userId} withRequestPath:kGetAllOrdersRequestPath cache:NO payload:nil withCompletionBlock:^(id responseObject, EYError *error) {
      
        [weakSelf processAllOrders:responseObject withError:error];
    
        }];
    }

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

#pragma mark Table View Data source and delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return _pastOrdersArray.count+ _currentOrdersArray.count;
        
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"orderCell";
    
    EYMyOrdersCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[EYMyOrdersCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section<self.currentOrdersArray.count)
    {
        [cell setCurrentProduct:_currentOrdersArray[indexPath.section] andOrderType:EYOrderCurrent];
        
    }
    else
    {
        [cell setCurrentProduct:_pastOrdersArray[indexPath.section - _currentOrdersArray.count] andOrderType:EYOrderPast];
    }
    
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.0)];
    

    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,0, 0)];
    lbl.font = AN_BOLD(12.0);
    lbl.textColor = kBlackTextColor;
    [view addSubview:lbl];
  
        if (section == 0)
        {
            view.frame = CGRectMake(0, 0, self.view.frame.size.width, 44.0);
            view.backgroundColor = kSectionBgColor;
            lbl.text = @"CURRENT ORDERS";
            CGSize lblSize = lbl.intrinsicContentSize;
            lbl.frame = (CGRect){kProductDescriptionPadding,(view.frame.size.height - lblSize.height)/2, lblSize};
        }
        else if(section == _currentOrdersArray.count)
        {
            view.frame = CGRectMake(0, 0, self.view.frame.size.width, 44.0);
            view.backgroundColor = kSectionBgColor;
            lbl.text = @"PAST ORDERS";
            CGSize lblSize = lbl.intrinsicContentSize;
            lbl.frame = (CGRect){kProductDescriptionPadding,(view.frame.size.height - lblSize.height)/2,lblSize};
        
        }
        else
        {
             view.frame = CGRectMake(0, 0, self.view.frame.size.width, 4.0);
            view.backgroundColor = kFooterColor;
        }
   
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0)
    {
        return 44.0;
    }
    else if (section == _currentOrdersArray.count)
    {
        return 44.0;
    }
    else
    {
        return 4.0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.width, 0, 1.0)];
    view.backgroundColor = kSeparatorColor;
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = 0.0;
    
    if (indexPath.section<self.currentOrdersArray.count)
    {
        h = [EYMyOrdersCell getHeightForCellWithWidth:self.view.frame.size.width cellData:_currentOrdersArray[indexPath.section] andOrderType:EYOrderCurrent];
    }
    else
    {
        h = [EYMyOrdersCell getHeightForCellWithWidth:self.view.frame.size.width cellData:_pastOrdersArray[indexPath.section - _currentOrdersArray.count] andOrderType:EYOrderPast];
    }
   
    return h;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     EYOrderDetailsViewController *orderDetailsVC = [[EYOrderDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    if (indexPath.section<self.currentOrdersArray.count)
    {
        orderDetailsVC.orderModelReceived = _currentOrdersArray[indexPath.section];
        orderDetailsVC.orderTypeReceived = EYOrderCurrent;
        orderDetailsVC.allAddressesReceived = _localAddModel;
    }
    else
    {
        orderDetailsVC.orderModelReceived = _pastOrdersArray[indexPath.section - _currentOrdersArray.count];
        orderDetailsVC.orderTypeReceived = EYOrderPast;
        orderDetailsVC.allAddressesReceived = _localAddModel;
    }
    [self.navigationController pushViewController:orderDetailsVC animated:YES];
}


-(void)actionSupport:(id)sender
{
    NSLog(@"buttonSupport Pressed");
}

#pragma mark - process Response -
- (void) processAllOrders:(id)responseObject withError :(EYError *)error{
    self.tableView.tableHeaderView = nil;
    if (!error)
    {
        _allOrdersArray = responseObject;
        
        for (EYAllOrdersMtlModel *ordersModel in _allOrdersArray)
        {
            if (ordersModel.expectedPickUpDate.length>0 || ordersModel.expectedDeliveryDate.length > 0)
            {
                [_currentOrdersArray addObject:ordersModel];
            }
            else
            {
                [_pastOrdersArray addObject:ordersModel];
            }
        }
        
        [self.tableView reloadData];
        
    }
    else
    {
        self.tableView.tableHeaderView = [self showEmptyViewWithMessage:error.errorMessage withImage:nil andRetryBtnHidden:YES];
    }
    
}

#pragma mark - show empty/error view

- (EYEmptyView *)showEmptyViewWithMessage:(NSString *)messageText withImage:(UIImage *)image andRetryBtnHidden:(BOOL)hidden
{
    CGSize size = self.view.bounds.size;
    EYEmptyView *emptyView = [[EYUtility shared] errorViewWithText:messageText withImage:image andRetryBtnHidden:hidden];
    emptyView.frame = (CGRect){0.0,64.0,size.width, size.height-kTabBarHeight};
    return emptyView;
}


@end
