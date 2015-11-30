//
//  EYThankyouViewController.m
//  Eyvee
//
//  Created by Disha Jain on 18/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYThankyouViewController.h"
#import "EYBottomButton.h"
#import "EYConstant.h"
#import "EYCartModel.h"
#import "EYSyncCartMtlModel.h"
#import "EYUtility.h"

@interface EYThankyouViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic,strong) EYBottomButton *bottomView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UILabel *footerLabel;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIImageView *headerImage;
@property (nonatomic, strong) UIView * separatorLine;
@end

@implementation EYThankyouViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self =  [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        
//        _isSwitchON = NO;
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.hidesBackButton = YES;
    // Do any additional setup after loading the view.
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, kBottomBarHeight, 0);
    
    
   // EYSyncCartProductDetails *productDetails = [[EYCartModel sharedManager].cartModel.cartProducts objectAtIndex:0];
    
    [self.view addSubview:_tableView];
    
    _bottomView = [[EYBottomButton alloc]initWithFrame:(CGRectZero) image:@"" ButtonText:@"DONE" andFont:AN_BOLD(13.0)];
    [self.bottomView addTarget:self action:@selector(doneBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bottomView];
    
    //footer view
    _footerView = [[UIView alloc]initWithFrame:CGRectZero];
    _footerLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _footerLabel.numberOfLines = 0;
    _footerLabel.attributedText = [self getAttributedTextForFooterLabel];

    [self.footerView addSubview:_footerLabel];
    
    //header view
    _headerView = [[UIView alloc]initWithFrame:CGRectZero];
    _headerLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _headerLabel.numberOfLines = 0;
    _headerLabel.attributedText = [self getAttributedTextForHeaderLabelWithOrderDate:nil orderNumber:self.transactionId];
    [self.headerView addSubview:_headerLabel];
    
    //header image view
    _headerImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    _headerImage.image = [UIImage imageNamed:@"confirmation_success"];
    [self.headerView addSubview:_headerImage];
    
    _separatorLine = [[UIView alloc]initWithFrame:CGRectZero];
     _separatorLine.backgroundColor = kSeparatorColor;
    [self.headerView addSubview:_separatorLine];
}

-(void)viewWillLayoutSubviews
{
    //Table View
    CGSize size = self.view.bounds.size;
    
    _bottomView.frame = (CGRect){0,size.height - kBottomBarHeight,size.width,kBottomBarHeight};
    
    
    NSAttributedString *strHeader = _headerLabel.attributedText;
//    NSLog(@"strHeader %@", strHeader);
    
    CGSize sizeOfHeaderLabel = [EYUtility sizeForAttributedString:strHeader width:size.width ]; // no side padding in available width???
    CGSize sizeOfImageView = (CGSize){64,64};
    
    NSLog(@"sizeOfHeaderLabel %@", NSStringFromCGSize(sizeOfHeaderLabel));

    CGFloat heightOfHeaderView = 72 + sizeOfImageView.height + 22 + sizeOfHeaderLabel.height + 52 +1.0;
    NSLog(@"heightOfHeaderView %f", heightOfHeaderView);

    //header view frame
    _headerView.frame = (CGRect){0, 0, size.width, heightOfHeaderView};
    NSLog(@"_headerView.frame %@", NSStringFromCGRect(_headerView.frame));
    _tableView.tableHeaderView = _headerView;
    
    CGFloat headerImageX = (size.width - sizeOfImageView.width) / 2;
    _headerImage.frame = (CGRect){headerImageX , 72, sizeOfImageView};
    CGFloat headerLabelX = (size.width - sizeOfHeaderLabel.width) / 2;
    _headerLabel.frame = (CGRect){headerLabelX, _headerImage.frame.origin.y + _headerImage.frame.size.height + 22,sizeOfHeaderLabel};
    
    //footer view frame
    
    _footerView.frame = (CGRect){0, _headerView.frame.size.height ,size.width, (size.height - _headerView.frame.size.height - _bottomView.frame.size.height)};
    _tableView.tableFooterView = _footerView;
    NSLog(@"_footerLabel.frame %@", NSStringFromCGRect(_footerLabel.frame));

    //bottom label size
    NSAttributedString *str = [self getAttributedTextForFooterLabel];
    CGSize sizeOfBottomLabel = [EYUtility sizeForAttributedString:str width:size.width - kProductDescriptionPadding * 2];
    CGFloat footerLabelX = (size.width - sizeOfBottomLabel.width) / 2;
    
    CGFloat thickness = 1;
    _separatorLine.frame = CGRectMake(kProductDescriptionPadding, _headerView.frame.size.height - thickness, _headerView.frame.size.width -kProductDescriptionPadding * 2, thickness);

    _footerLabel.frame = (CGRect){footerLabelX, 56, sizeOfBottomLabel};
    NSLog(@"_footerLabel.frame %@", NSStringFromCGRect(_footerLabel.frame));
//    
   
    _tableView.frame = CGRectMake(0, 0, size.width, size.height - _bottomView.frame.size.height);
// _tableView.frame = CGRectMake(0, 0, size.width, (_headerView.frame.size.height + _footerView.frame.size.height) - _bottomView.frame.size.height);
   
//
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   // self.navigationController.navigationBarHidden = NO;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

-(NSAttributedString*)getAttributedTextForFooterLabel
{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    style.lineSpacing = 4;
    
    NSDictionary *dict1 = @{NSFontAttributeName : AN_REGULAR(12),
                            NSForegroundColorAttributeName : kRowLeftLabelColor,
                            NSParagraphStyleAttributeName : style
                            };
    
    NSDictionary *dict2 = @{NSFontAttributeName : AN_REGULAR(12),
                            NSForegroundColorAttributeName : kBlackTextColor,
                            NSParagraphStyleAttributeName : style
                            };

    
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"We have sent rest of the details to your registered email. Before delivery we will reach you to update about order status. For any help we are always available on " attributes:dict1];
    [attr appendAttributedString:str];
    
    str = [[NSAttributedString alloc] initWithString:@"support@eyvee.com" attributes:dict2];
    [attr appendAttributedString:str];
    
    str = [[NSAttributedString alloc] initWithString:@"or 9988882222" attributes:dict1];
    [attr appendAttributedString:str];
    
    
    return attr;
    
}
-(NSAttributedString*)getAttributedTextForHeaderLabelWithOrderDate:(NSString*)date orderNumber:(NSString*)number
{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 10;
    style.alignment = NSTextAlignmentCenter;
    NSMutableParagraphStyle *styleThankyou = [[NSMutableParagraphStyle alloc] init];
    styleThankyou.alignment = NSTextAlignmentCenter;
    
    
    NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
    style1.alignment = NSTextAlignmentCenter;
    style1.paragraphSpacingBefore = 4.0;
 
    NSDictionary *thanksDict = @{NSFontAttributeName : AN_MEDIUM(18.0),
                            NSForegroundColorAttributeName : kBlackTextColor,
                            NSParagraphStyleAttributeName : styleThankyou,
                            };
    
   /* NSDictionary *dict2 = @{NSFontAttributeName : AN_REGULAR(18.0),
                            NSForegroundColorAttributeName : kRowLeftLabelColor,
                            NSParagraphStyleAttributeName : style1
                            };*/
    
    NSDictionary *dict3 = @{NSFontAttributeName : AN_REGULAR(18.0),
                            NSForegroundColorAttributeName : kRowLeftLabelColor,
                            NSParagraphStyleAttributeName : style1
                            };
    
   /* NSDictionary *dict4 = @{NSFontAttributeName : AN_MEDIUM(18.0),
                            NSForegroundColorAttributeName : kBlackTextColor,
                            NSParagraphStyleAttributeName : style1,
                            NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)
                            };*/

    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Thank you for your order!\n" attributes:thanksDict];
    [attr appendAttributedString:str];
    
    //str = [[NSAttributedString alloc] initWithString:@"Expected delivery on " attributes:dict2];
    //[attr appendAttributedString:str];
    
    //str = [[NSAttributedString alloc] initWithString:date attributes:dict4];
    //[attr appendAttributedString:str];
    
   // [attr addAttribute:date value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:(NSRange){0,[date length]}];
    
    str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\nYour order No. is %@",number ] attributes:dict3];
    [attr appendAttributedString:str];
    
    return attr;
  
}


#pragma mark - date with month -
- (NSString *)getDateWithMonthFromString:(NSString *)dateStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    [dateFormatter setDateFormat:@"dd MMMM"];
    NSString *finalDateStr = [dateFormatter stringFromDate:date];
    return finalDateStr;
}

#pragma mark - IBActions -
- (IBAction)doneBtnClicked:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
