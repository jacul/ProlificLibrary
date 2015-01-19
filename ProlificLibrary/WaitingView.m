//
//  WaitingView.m
//  ProlificLibrary
//
//  Created by zxd on 15/1/19.
//
//

#import "WaitingView.h"
static WaitingView* _instance;

@implementation WaitingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        
        [label setTranslatesAutoresizingMaskIntoConstraints:NO];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:20];
        label.text = @"Loading..";
        [self addSubview:label];
        NSLayoutConstraint* horizonConstraint = [NSLayoutConstraint constraintWithItem:label
                                                                            attribute:NSLayoutAttributeCenterX
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self
                                                                            attribute:NSLayoutAttributeCenterX
                                                                           multiplier:1.0
                                                                             constant:0.0];
        
        [self addConstraint:horizonConstraint];
        
        NSLayoutConstraint* verticalContraint = [NSLayoutConstraint constraintWithItem:label
                                                                             attribute:NSLayoutAttributeCenterY
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self
                                                                             attribute:NSLayoutAttributeCenterY
                                                                            multiplier:1.0 constant:0.0];
        [self addConstraint:verticalContraint];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

+(void)showBlockIndicatorIn:(UIView *)view{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [WaitingView new];
        
    });
    
    if (_instance && _instance.superview) {
        [_instance removeFromSuperview];
    }
    
    double min = MIN(view.frame.size.width, view.frame.size.height);
    _instance.frame = CGRectMake(0, 0, min/2, min/2);
    _instance.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
    [_instance.layer setCornerRadius:min/10];
    [_instance.layer setMasksToBounds:YES];
    [view addSubview:_instance];
}

+(void)dismissCurrentIndicator{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (_instance && _instance.superview) {
            [_instance removeFromSuperview];
        }
    });
}
@end
