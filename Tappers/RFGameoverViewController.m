//
//  RFGameoverViewController.m
//  ReactFast
//
//  Created by Ben Rosen on 4/6/15.
//  Copyright (c) 2015 Ben Rosen. All rights reserved.
//

#import "RFGameoverViewController.h"
#import "CompactConstraint.h"
#import "RFHomeViewController.h"
#import "UIViewController+HCPushBackAnimation.h"
#import "UIImage+ReactFast.h"
#import <Twitter/Twitter.h>

@interface RFGameoverViewController ()

@property (strong, nonatomic) UILabel *gameOverLabel;
@property (strong, nonatomic) UIView *gameOverSmallerView;
@property (strong, nonatomic) UILabel *actionLabel;
@property (strong, nonatomic) UILabel *gameMessageView;
@property (strong, nonatomic) UILabel *scoresLabel;
@property (strong, nonatomic) UIButton *facebookButton;
@property (strong, nonatomic) UIButton *twitterButton;

@property (strong, nonatomic) UISwipeGestureRecognizer *upGestureRecognizer;
@property (strong, nonatomic) UISwipeGestureRecognizer *downGestureRecognizer;

@property (readwrite, nonatomic) NSInteger score;

@end

@implementation RFGameoverViewController

- (id)initWithScore:(NSInteger)score isHighScore:(BOOL)isHighScore {
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:179.0/255.0 blue:255.0/256.0 alpha:1.0];
        _score = score;
        
        _gameOverLabel = [[UILabel alloc] init];
        _gameOverLabel.text = @"GAME OVER";
        _gameOverLabel.font = [UIFont fontWithName:@"AvenirNext-Heavy" size:self.view.frame.size.width*0.1466666667];
        _gameOverLabel.textAlignment = NSTextAlignmentCenter;
        _gameOverLabel.textColor = [UIColor whiteColor];
        _gameOverLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_gameOverLabel];
        
        _gameOverSmallerView = [[UIView alloc] init];
        _gameOverSmallerView.backgroundColor = [UIColor colorWithRed:55.0/255.0 green:153.0/255.0 blue:215.0/255.0 alpha:1.0];
        _gameOverSmallerView.layer.masksToBounds = YES;
        _gameOverSmallerView.layer.cornerRadius = 9.0;
        _gameOverSmallerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_gameOverSmallerView];
        
        _actionLabel = [[UILabel alloc] init];
        _actionLabel.numberOfLines = 2;
        _actionLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:18.0];
        _actionLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:77.0/255.0 blue:106.0/255.0 alpha:1.0];
        _actionLabel.textAlignment = NSTextAlignmentCenter;
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineSpacing:-5.0];
        [style setParagraphSpacing:-5.0];
        [style setAlignment:NSTextAlignmentCenter];
        NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:@"swipe up for home\nswipe down to try again" attributes:@{NSParagraphStyleAttributeName: style}];

        _gameMessageView = [[UILabel alloc] init];
        _gameMessageView.backgroundColor = [UIColor colorWithRed:47.0/255.0 green:132.0/255.0 blue:186.0/255.0 alpha:1.0];
        _gameMessageView.layer.masksToBounds = YES;
        _gameMessageView.layer.cornerRadius = 5.0;
        _gameMessageView.textAlignment = NSTextAlignmentCenter;
        _gameMessageView.textColor = [UIColor whiteColor];
        _gameMessageView.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:24.0];
        
        _gameMessageView.text = isHighScore ? @"new high score" : @"better luck next time";
        _gameMessageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_gameMessageView];
        
        _actionLabel.attributedText = attrString;
        _actionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_actionLabel];
        
        _scoresLabel = [[UILabel alloc] init];
        _scoresLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:30.0];
        _scoresLabel.textAlignment = NSTextAlignmentCenter;
        _scoresLabel.numberOfLines = 2;
        _scoresLabel.text = [NSString stringWithFormat:@"score: %@\nhigh score: %@", @(score), @([[NSUserDefaults standardUserDefaults] integerForKey:@"me.benrosen.tappers/highscore"])];
        _scoresLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:84.0/255.0 blue:115.0/255.0 alpha:1.0];
        _scoresLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_scoresLabel];
        
        _twitterButton = [[UIButton alloc] init];
        [_twitterButton setImage:[[UIImage imageNamed:@"twitter"] imageWithTint:[UIColor colorWithRed:0.0/255.0 green:103.0/255.0 blue:141.0/255.0 alpha:1.0]] forState:UIControlStateNormal];
        _twitterButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_twitterButton];
        [_twitterButton addTarget:self action:@selector(twitterTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        _facebookButton = [[UIButton alloc] init];
        [_facebookButton setImage:[[UIImage imageNamed:@"facebook"] imageWithTint:[UIColor colorWithRed:0.0/255.0 green:103.0/255.0 blue:141.0/255.0 alpha:1.0]] forState:UIControlStateNormal];
        _facebookButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_facebookButton];
        [_facebookButton addTarget:self action:@selector(facebookTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        _upGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureUp:)];
        _upGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
        [self.view addGestureRecognizer:_upGestureRecognizer];
        
        _downGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureDown:)];
        _downGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
        [self.view addGestureRecognizer:_downGestureRecognizer];
        
        [self.view addCompactConstraints:@[@"gameOverLabel.centerX = view.centerX",
                                           @"gameOverLabel.top = view.top+52",
                                           @"gameOverSmallerView.left = view.left+20.0",
                                           @"gameOverSmallerView.right = view.right-20.0",
                                           @"gameOverSmallerView.top = gameOverLabel.bottom+27.5",
                                           @"gameOverSmallerView.bottom = view.bottom-62.5",
                                           @"actionLabel.bottom = gameOverSmallerView.bottom-18.0",
                                           @"actionLabel.centerX = view.centerX",
                                           @"gameMessageView.left = gameOverSmallerView.left+17.0",
                                           @"gameMessageView.right = gameOverSmallerView.right-17.0",
                                           @"gameMessageView.top = gameOverSmallerView.top+12.5",
                                           @"gameMessageView.height = 45.0",
                                           @"scoresLabel.centerX = view.centerX",
                                           @"scoresLabel.bottom = gameOverSmallerView.centerY-10",
                                           @"twitterButton.right = view.centerX-10",
                                           @"twitterButton.height = 60.0",
                                           @"twitterButton.width = 60.0",
                                           @"twitterButton.top = gameOverSmallerView.centerY+10",
                                           @"facebookButton.left = view.centerX+10",
                                           @"facebookButton.height = 54.0",
                                           @"facebookButton.width = 54.0",
                                           @"facebookButton.centerY = twitterButton.centerY"]
                                 metrics:nil
                                   views:@{@"view": self.view,
                                           @"gameOverLabel": _gameOverLabel,
                                           @"gameOverSmallerView": _gameOverSmallerView,
                                           @"actionLabel": _actionLabel,
                                           @"gameMessageView": _gameMessageView,
                                           @"scoresLabel": _scoresLabel,
                                           @"twitterButton": _twitterButton,
                                           @"facebookButton": _facebookButton}];
        
     }
    return self;
}

- (void)gestureUp:(UIGestureRecognizer *)gestureRecognizer {
    RFHomeViewController *homeViewController = [[RFHomeViewController alloc] init];
    [self presentViewController:homeViewController animated:YES completion:nil];
    [self animationPushBackScaleDown];
}

- (void)gestureDown:(UIGestureRecognizer *)gestureRecognizer {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self animationPushBackScaleDown];
}

- (void)twitterTapped:(UIButton *)sender {
    
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
        [controller dismissViewControllerAnimated:YES completion:Nil];
    };
    controller.completionHandler = myBlock;
    
    [controller setInitialText:[NSString stringWithFormat:@"I just scored %li on Tappers. Download it now on the app store!", (long)_score]];
    
    [controller addURL:[NSURL URLWithString:@"http://benrosen.me/tappers"]];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)facebookTapped:(UIButton *)sender {
   
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
        [controller dismissViewControllerAnimated:YES completion:Nil];
    };
    controller.completionHandler = myBlock;
    
    [controller setInitialText:[NSString stringWithFormat:@"I just scored %li on Tappers. Download it now on the app store!", (long)_score]];
    
    [controller addURL:[NSURL URLWithString:@"http://benrosen.me/tappers"]];
    
    [self presentViewController:controller animated:YES completion:nil];
}

@end
