//
//  EYMoreItemsViewController.m
//  Eyvee
//
//  Created by Disha Jain on 08/10/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYMoreItemsViewController.h"
#import "TableViewCellWithSeparator.h"
#import "EYUtility.h"
#import "EYConstant.h"
#import "EYGridProductController.h"
#import "CheckBoxTableViewCell.h"


@interface EYMoreItemsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *allItemsNameArray;
@property (nonatomic, strong) NSMutableArray *allItemsIdArray;
@property (nonatomic, strong) NSMutableArray *allItemsDataPathArray;
@property (strong,nonatomic)NSIndexPath *indexPathSelected;
@end

@implementation EYMoreItemsViewController
static NSString *cellIdentifier = @"CheckBoxTableViewCellIdentifier";


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self =  [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"More";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]init];
    _allItemsNameArray = [[NSMutableArray alloc]init];
    _allItemsIdArray = [[NSMutableArray alloc]init];
    _allItemsDataPathArray = [[NSMutableArray alloc]init];
    [self.tableView registerClass:[TableViewCellWithSeparator class] forCellReuseIdentifier:cellIdentifier];
    
    for (NSString* str in _itemsReceived)
    {
        NSArray* arrayWithColon = [str componentsSeparatedByString:@":"];
        [_allItemsNameArray addObject:arrayWithColon[1]];
        [_allItemsIdArray addObject:arrayWithColon[0]];
        [_allItemsDataPathArray addObject:arrayWithColon[2]];
    }
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarShowNotification object:nil];

}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGRect rect = self.view.bounds;
    
    self.tableView.frame = (CGRect){rect.origin, rect.size.width,rect.size.height-kTabBarHeight};
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark table view data source and delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _itemsReceived.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCellWithSeparator *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell setIsFilterMode:NO];
    [cell updateTextOfLabel:self.allItemsNameArray[indexPath.row]];
    [cell updateCellFont:AN_REGULAR(14.0)];
    [cell updateCellFontColor:kRowLeftLabelColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EYGridProductController *productCont = [[EYGridProductController alloc] initWithNibName:nil bundle:nil];
    productCont.productCategory = GetProductsFromSlider;
    productCont.sliderNameReceived = _sliderName;
    productCont.sliderValueReceived = _sliderId;
    productCont.sliderType = _sliderType;
    productCont.titleForNavigationBar = _allItemsNameArray[indexPath.row];
    productCont.filePathForData = _allItemsDataPathArray[indexPath.row];
    productCont.subcategoryIdReceived = [NSArray arrayWithObject:_allItemsIdArray[indexPath.row]];
    [self.navigationController pushViewController:productCont animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.0;
}



@end
