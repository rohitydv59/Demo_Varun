//
//  ColourTableViewCell.m
//  EyveeFilterView
//
//  Created by Varun Kapoor on 12/08/15.
//  Copyright (c) 2015 Varun Kapoor. All rights reserved.
//

#import "ColourTableViewCell.h"
#import "EYConstant.h"
#import "EYCustomButton.h"
#import "EYCustomCollectionViewCell.h"

static NSString * const reuseIdentifier = @"Cell";

@interface ColourTableViewCell()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    int numButtons;
}
@property (nonatomic, strong) UICollectionView *collectionView;

@end


@implementation ColourTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setupp];
    }
    return self;
}

-(void) setupp
{
    UICollectionViewFlowLayout *aFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    aFlowLayout.minimumLineSpacing = kLineAndTextSpacing;
    [aFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:aFlowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.contentView addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[EYCustomCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];

}

-(void) setColorFilterModel:(EYProductFilters *)colorFilterModel
{
    _colorFilterModel = colorFilterModel;
    [self setupp];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.collectionView setContentInset:UIEdgeInsetsMake(0, kTableViewLargePadding, 0, kTableViewLargePadding)];
    [self.collectionView setFrame:self.contentView.frame];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.colorFilterModel.values.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kSizeCell, kSizeCell);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EYCustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.isCircled = NO;
    [cell.colorBtn setUserInteractionEnabled:NO];

    NSString * str = [self.colorFilterModel.values objectAtIndex:indexPath.row];
    [cell updatingColor:str];    
    
    for (int i = 0; i < self.cellArray.count; i++)
    {
        NSNumber * num = [self.cellArray objectAtIndex:i];
        {
            if (num.intValue == indexPath.row)
            {
                cell.isCircled = 1;
            }
        }
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EYCustomCollectionViewCell * cell = (EYCustomCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
    cell.isCircled = !cell.isCircled;
    if (cell.isCircled)
    {
        if(![self.cellArray containsObject:[NSNumber numberWithInteger:indexPath.row]])
        {
            [self.cellArray addObject:[NSNumber numberWithInteger:indexPath.row]];
        }
    }
    else
    {
        if([self.cellArray containsObject:[NSNumber numberWithInteger:indexPath.row]])
        {
            [self.cellArray removeObject:[NSNumber numberWithInteger:indexPath.row]];
        }

    }
    [self.delegate colorButtonClicked:cell.isCircled andSelectedIndex:indexPath.row];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
