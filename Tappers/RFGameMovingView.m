//
//  RFGameMovingView.m
//  ReactFast
//
//  Created by Ben Rosen on 3/29/15.
//  Copyright (c) 2015 Ben Rosen. All rights reserved.
//

#import "RFGameMovingView.h"
#import "CompactConstraint.h"

@interface RFGameMovingView ()

@property (strong, nonatomic) UIView *smallerInnerView;

@end

@implementation RFGameMovingView

- (id)init {
    if (self = [super initWithFrame:CGRectMake(0.0, 0.0, 75.0, 75.0)]) {
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.frame.size.height/2;
        
        self.backgroundColor = [UIColor colorWithRed:33/255.0 green:145/255.0 blue:216/255.0 alpha:1.0];
        
        _smallerInnerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 57.5, 57.5)];
        _smallerInnerView.backgroundColor = [UIColor colorWithRed:28/255.0 green:128.0/255.0 blue:191.0/255.0 alpha:1.0];
        _smallerInnerView.layer.masksToBounds = YES;
        _smallerInnerView.layer.cornerRadius = _smallerInnerView.frame.size.height/2;
        _smallerInnerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_smallerInnerView];
        
        self.userInteractionEnabled = YES;
        
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
        _tapGestureRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:_tapGestureRecognizer];
        
        [self addCompactConstraints:@[@"smallerInnerView.height = 57.5",
                                      @"smallerInnerView.width = 57.5",
                                      @"smallerInnerView.centerX = view.centerX",
                                      @"smallerInnerView.centerY = view.centerY"]
                            metrics:nil
                              views:@{@"view": self,
                                      @"smallerInnerView": _smallerInnerView}];
        
        
    }
    return self;
}

@end
