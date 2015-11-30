//
//  RangeSlider.m
//  EyveeFilterView
//
//  Created by Varun Kapoor on 12/08/15.
//  Copyright (c) 2015 Varun Kapoor. All rights reserved.
//

#import "RangeSlider.h"
#import "EYConstant.h"

@interface RangeSlider () {
    BOOL _maxThumbOn;
    BOOL _minThumbOn;
    float _padding;

    UIImageView * _minThumb;
    UIImageView * _maxThumb;
    UIView * _track;
    UIView * _trackBackground;
}

@property(nonatomic) float minimumValue;
@property(nonatomic) float maximumValue;
@property(nonatomic) float minimumRange;

@end

@implementation RangeSlider
@synthesize minimumValue, maximumValue, minimumRange, selectedMinimumValue, selectedMaximumValue;


//-(instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self)
//    {
//        [self creatingView];
//
//    }
//    return  self;
//}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self creatingView];
//        [self updateTrackHighlight];
    }
    return self;
}


-(void) creatingView
{
    self.minimumRange = 100;

    _trackBackground = [[UIView alloc] initWithFrame:CGRectZero];
    [_trackBackground setBackgroundColor:kSeparatorColor];
    _trackBackground.layer.cornerRadius = 2;
    [self addSubview:_trackBackground];
    [_trackBackground setUserInteractionEnabled:NO];
    
    _track = [[UIView alloc] initWithFrame:CGRectZero];
    [_track setBackgroundColor:kAppGreenColor];
    _track.layer.cornerRadius = 2;
    [_track setUserInteractionEnabled:NO];
    [self addSubview:_track];

    _minThumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider"] highlightedImage:[UIImage imageNamed:@"slider_tap"]];
    [self addSubview:_minThumb];
    
    _maxThumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider"] highlightedImage:[UIImage imageNamed:@"slider_tap"]];
    [self addSubview:_maxThumb];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.bounds;
    float trackBgHeight = 4;
    _trackBackground.frame = CGRectMake(kTableViewLargePadding , (rect.size.height * .5) - (trackBgHeight * .5) , [UIScreen mainScreen].bounds.size.width - 2 * kTableViewLargePadding, trackBgHeight);

    _track.frame = CGRectMake(
                              _minThumb.center.x,
                              _trackBackground.frame.origin.y,
                              _maxThumb.center.x - _minThumb.center.x,
                              _trackBackground.frame.size.height
                              );
}

-(void) settingMinAndMaxThumb:(float) minValue withMaxValue:(float)maxValue withSelectedMinValue:(float)selectedMinValue withSelectedMaxValue:(float)selectedMaxValue
{
    self.minimumValue = minValue;
    self.maximumValue = maxValue;
    self.selectedMinimumValue = selectedMinValue;
    self.selectedMaximumValue = selectedMaxValue;
    
    _minThumbOn = false;
    _maxThumbOn = false;

    _minThumb.center = CGPointMake([self xForValue:self.selectedMinimumValue],  self.frame.size.height / 2);
    _maxThumb.center = CGPointMake([self xForValue:self.selectedMaximumValue],  self.frame.size.height / 2);

    [self updateTrackHighlight];
    [self gettingValuesForSlider:self.selectedMinimumValue withMaxValue:self.selectedMaximumValue];
}


-(void)updateTrackHighlight
{
    _track.frame = CGRectMake(
                              _minThumb.center.x,
                              _trackBackground.frame.origin.y,
                              _maxThumb.center.x - _minThumb.center.x,
                              _trackBackground.frame.size.height
                              );
}



-(float)xForValue:(float)value
{
    if (maximumValue != minimumValue)
    {
        return (([UIScreen mainScreen].bounds.size.width - (2 * kTableViewLargePadding)) )*((value - minimumValue) / (maximumValue - minimumValue)) + kTableViewLargePadding;
 
    }
    return (([UIScreen mainScreen].bounds.size.width - (2 * kTableViewLargePadding)) )*((value - minimumValue) / ((maximumValue+150) - minimumValue)) + kTableViewLargePadding;

}

-(float) valueForX:(float)x
{
    return minimumValue + (x - kTableViewLargePadding) / ([UIScreen mainScreen].bounds.size.width - (2 * kTableViewLargePadding)) * (maximumValue - minimumValue);
}

-(BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    if(CGRectContainsPoint(_minThumb.frame, touchPoint))
    {
        _minThumbOn = true;
        _minThumb.highlighted = YES;
    }
    else if(CGRectContainsPoint(_maxThumb.frame, touchPoint))
    {
        _maxThumbOn = true;
        _maxThumb.highlighted = YES;
    }
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    _minThumbOn = false;
    _maxThumbOn = false;
    _minThumb.highlighted = NO;
    _maxThumb.highlighted = NO;

}

-(void) gettingValuesForSlider:(float)minValue withMaxValue:(float)maxValue
{
    if ([self.delegate respondsToSelector:@selector(gettingValuesForSlider:withMaxValue:)])
    {
        [self.delegate gettingValuesForSlider:minValue withMaxValue:maxValue];
    }
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if(!_minThumbOn && !_maxThumbOn)
    {
        return YES;
    }
    
    CGPoint touchPoint = [touch locationInView:self];
    if(_minThumbOn)
    {
        _minThumb.center = CGPointMake(MAX([self xForValue:minimumValue],MIN(touchPoint.x, [self xForValue:self.selectedMaximumValue - minimumRange])), _minThumb.center.y);
        self.selectedMinimumValue = [self valueForX:_minThumb.center.x];
        
    }
    if(_maxThumbOn)
    {
        _maxThumb.center = CGPointMake(MIN([self xForValue:maximumValue], MAX(touchPoint.x, [self xForValue:self.selectedMinimumValue + minimumRange])), _maxThumb.center.y);
        self.selectedMaximumValue = [self valueForX:_maxThumb.center.x];
    }
    [self gettingValuesForSlider:self.selectedMinimumValue withMaxValue:self.selectedMaximumValue];
    [self updateTrackHighlight];
    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];

    
    return YES;
}
@end
