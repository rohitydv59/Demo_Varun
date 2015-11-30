//
//  EYFAQViewController.m
//  Eyvee
//
//  Created by Disha Jain on 20/10/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYFAQViewController.h"
#import "EYFAQCell.h"
@interface EYFAQViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tbView;
@property (nonatomic, strong) NSArray *question;
@property (nonatomic, strong) NSArray *answer;

@end

@implementation EYFAQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Table View
    _tbView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbView.delegate = self;
    _tbView.dataSource = self;
    [self.view addSubview:_tbView];
    [self.tbView registerClass:[EYFAQCell class] forCellReuseIdentifier:@"faqCell"];
    _question = [[NSArray alloc]initWithObjects:@"How does it work?",@"How do I choose the perfect dress?",@"How long is a rental?",@"More questions will follow",nil];
    _answer = [[NSArray alloc]initWithObjects:@"", nil];
    
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationItem.title = @"FAQs";
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];

    }
    return self;
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
   
    CGSize size = self.view.bounds.size;
    
    _tbView.frame = CGRectMake(0, 0, size.width, size.height);
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1.0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"faqCell";
    
    EYFAQCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[EYFAQCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell updateTopLabelText:_question[indexPath.row] bottomText:_answer[indexPath.row]];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
