//
//  RFGameViewController.m
//  ReactFast
//
//  Created by Ben Rosen on 3/20/15.
//  Copyright (c) 2015 Ben Rosen. All rights reserved.
//

#import "RFGameViewController.h"
#import "CompactConstraint.h"
#import "RFGameMovingView.h"
#import "UIImage+ReactFast.h"
#import "UIViewController+HCPushBackAnimation.h"
#import "RFGameoverViewController.h"

@interface RFGameViewController ()

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIImageView *timeImageView, *pointsImageView;
@property (strong, nonatomic) UILabel *timeLabel, *pointsLabel;
@property (strong, nonatomic) RFGameMovingView *gameMovingView;
@property (strong, nonatomic) UITapGestureRecognizer *gameOverRecognizer;

@property (strong, nonatomic) NSTimer *gameTimer;

@property (nonatomic, readwrite) NSInteger timeLeft;
@property (nonatomic, readwrite) NSInteger points;
           
@end

@implementation RFGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _timeLeft = 15;
    
    self.view.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:179.0/255.0 blue:255.0/256.0 alpha:1.0];
    
    _topView = [[UIView alloc] init];
    _topView.backgroundColor = [UIColor colorWithRed:33/255.0 green:145/255.0 blue:216/255.0 alpha:1.0];
    _topView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_topView];
    
    _timeImageView = [[UIImageView alloc] init];
    _timeImageView.image = [[UIImage imageNamed:@"alarm"] imageWithTint:[UIColor colorWithRed:0/255.0 green:77.0/255.0 blue:106.0/255.0 alpha:1.0]];
    _timeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_timeImageView];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableAttributedString *timeLabelAttributedString = [[NSMutableAttributedString alloc] initWithString:@"15s" attributes:@{NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-DemiBold" size:30.0], NSKernAttributeName : @(-1.5f), NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:77.0/255.0 blue:106.0/255.0 alpha:1.0]}];
    _timeLabel.attributedText = timeLabelAttributedString;
    [self.view addSubview:_timeLabel];
    
    _pointsImageView = [[UIImageView alloc] init];
    _pointsImageView.image = [[UIImage imageNamed:@"target"] imageWithTint:[UIColor colorWithRed:0/255.0 green:77.0/255.0 blue:106.0/255.0 alpha:1.0]];
    _pointsImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_pointsImageView];
    
    _pointsLabel = [[UILabel alloc] init];
    _pointsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableAttributedString *pointsLabelAttributedString = [[NSMutableAttributedString alloc] initWithString:@"0" attributes:@{NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-DemiBold" size:30.0], NSKernAttributeName : @(-1.5f), NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:77.0/255.0 blue:106.0/255.0 alpha:1.0]}];
    _pointsLabel.attributedText = pointsLabelAttributedString;
    [self.view addSubview:_pointsLabel];
    
    _gameMovingView = [[RFGameMovingView alloc] init];
    _gameMovingView.center = self.view.center;
    [_gameMovingView.tapGestureRecognizer addTarget:self action:@selector(gameMovingViewTapped:)];
    [self.view addSubview:_gameMovingView];
    
    _gameOverRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
    _gameOverRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:_gameOverRecognizer];
    
    [self.view addCompactConstraints:@[@"topView.height = 58.5",
                                       @"topView.width = view.width",
                                       @"topView.top = view.top",
                                       @"timeImageView.right = view.right/2-60",
                                       @"timeImageView.width = 29.5",
                                       @"timeImageView.height = 29.5",
                                       @"timeImageView.centerY = topView.centerY",
                                       @"timeLabel.centerY = topView.centerY",
                                       @"timeLabel.left = timeImageView.right+7.0",
                                       @"pointsImageView.left = view.right/2+22.5",
                                       @"pointsImageView.width = 29.5.0",
                                       @"pointsImageView.height = 27.0",
                                       @"pointsImageView.centerY = topView.centerY",
                                       @"pointsLabel.centerY = topView.centerY",
                                       @"pointsLabel.left = pointsImageView.right+5.5"]
                             metrics:nil
                               views:@{@"view": self.view,
                                       @"topView": _topView,
                                       @"timeImageView": _timeImageView,
                                       @"timeLabel": _timeLabel,
                                       @"pointsImageView": _pointsImageView,
                                       @"pointsLabel": _pointsLabel}];
    

}

- (void)gameMovingViewTapped:(UIGestureRecognizer *)gestureRecognizer {
    
    _gameMovingView.center = CGPointZero;
    
    // generate random numbers, make sure they are within proper region
    
    
    CGFloat randomX = arc4random_uniform(self.view.frame.size.width);
    CGFloat randomY = arc4random_uniform(self.view.frame.size.height);
    
    BOOL dotCanMove = NO;
    
    while (!dotCanMove) {
        if (randomY <= 58.5 || randomY+75>=self.view.frame.size.height || randomX+75>=self.view.frame.size.width) {
            // we can't move the dot, get new random dots
            randomX = arc4random_uniform(self.view.frame.size.width);
            randomY = arc4random_uniform(self.view.frame.size.height);

            dotCanMove = NO;
        } else {
            // we can move the dot
            
            CGRect frame = self.gameMovingView.frame;
            frame.origin = CGPointMake(randomX, randomY);
            
            [UIView transitionWithView:_gameMovingView duration:0.15 options: UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionCurveEaseIn animations:^{
                _gameMovingView.frame = frame;
            } completion:nil];
            dotCanMove = YES;

            
            [self addToPoints];
        }
    
    }

}

- (void)addToPoints {
    _points++;
    NSString *pointsString = [NSString stringWithFormat:@"%li", (long)_points];
    NSMutableAttributedString *pointsLabelAttributedString = [[NSMutableAttributedString alloc] initWithString:pointsString attributes:@{NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-DemiBold" size:30.0], NSKernAttributeName : @(-1.5f), NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:77.0/255.0 blue:106.0/255.0 alpha:1.0]}];
    _pointsLabel.attributedText = pointsLabelAttributedString;

}

- (void)backgroundTapped:(UIGestureRecognizer *)gestureRecognizer {
    [self gameOver];
}

- (void)gameOver {
    [_gameTimer invalidate];
    
    BOOL isHighScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"me.benrosen.tappers/highscore"] < _points;
    
    if (isHighScore) {
        [[NSUserDefaults standardUserDefaults] setInteger:_points forKey:@"me.benrosen.tappers/highscore"];
    }
    
    RFGameoverViewController *gameOverViewController = [[RFGameoverViewController alloc] initWithScore:_points isHighScore:isHighScore];
    [self presentViewController:gameOverViewController animated:YES completion:nil];
    [self animationPushBackScaleDown];
}

- (void)handleTimer:(NSTimer *)timer {
    _timeLeft--;
    NSString *timeString = [NSString stringWithFormat:@"%lis", (long)_timeLeft];
    NSMutableAttributedString *timeLabelAttributedString = [[NSMutableAttributedString alloc] initWithString:timeString attributes:@{NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-DemiBold" size:30.0], NSKernAttributeName : @(-1.5f), NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:77.0/255.0 blue:106.0/255.0 alpha:1.0]}];
    _timeLabel.attributedText = timeLabelAttributedString;
    if (_timeLeft == 0) {
        [self gameOver];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    _gameTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                  target: self
                                                selector: @selector(handleTimer:)
                                                userInfo: nil
                                                 repeats: YES];
    
    _gameMovingView.frame = CGRectMake(0.0, 0.0, _gameMovingView.frame.size.width, _gameMovingView.frame.size.height);
    _gameMovingView.center = self.view.center;
    _timeLeft = 15;
    _points = 0;
    
    NSString *pointsString = [NSString stringWithFormat:@"%li", (long)_points];
    NSMutableAttributedString *pointsLabelAttributedString = [[NSMutableAttributedString alloc] initWithString:pointsString attributes:@{NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-DemiBold" size:30.0], NSKernAttributeName : @(-1.5f), NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:77.0/255.0 blue:106.0/255.0 alpha:1.0]}];
    _pointsLabel.attributedText = pointsLabelAttributedString;
    NSString *timeString = [NSString stringWithFormat:@"%lis", (long)_timeLeft];
    NSMutableAttributedString *timeLabelAttributedString = [[NSMutableAttributedString alloc] initWithString:timeString attributes:@{NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-DemiBold" size:30.0], NSKernAttributeName : @(-1.5f), NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:77.0/255.0 blue:106.0/255.0 alpha:1.0]}];
    _timeLabel.attributedText = timeLabelAttributedString;
    
}

@end
