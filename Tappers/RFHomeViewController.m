//
//  RFHomeViewController.m
//  ReactFast
//
//  Created by Ben Rosen on 3/20/15.
//  Copyright (c) 2015 Ben Rosen. All rights reserved.
//

#import "RFHomeViewController.h"
#import "CompactConstraint.h"
#import "UIImage+ReactFast.h"
#import "RFGameViewController.h"

@interface RFHomeViewController ()

@property (strong, nonatomic) UILabel *gameTitleLabel;
@property (strong, nonatomic) UILabel *highScoreLabel;
@property (strong, nonatomic) UIButton *playButton;

@end

@implementation RFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:179.0/255.0 blue:255.0/256.0 alpha:1.0];
    
    _gameTitleLabel = [[UILabel alloc] init];
    _gameTitleLabel.textAlignment = NSTextAlignmentCenter;

    NSAttributedString *gameTitleAttributedString = [[NSAttributedString alloc] initWithString:@"Tappers" attributes:@{NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-Heavy" size:65.0], NSForegroundColorAttributeName : [UIColor whiteColor], NSKernAttributeName : @(-2.5f)}];
    
    _gameTitleLabel.attributedText = gameTitleAttributedString;

    [self.view addSubview:_gameTitleLabel];

    _highScoreLabel = [[UILabel alloc] init];
    _highScoreLabel.textAlignment = NSTextAlignmentCenter;

    NSString *highScoreString = [NSString stringWithFormat:@"High Score: %@", @([[NSUserDefaults standardUserDefaults] integerForKey:@"me.benrosen.tappers/highscore"])];
    NSAttributedString *highScoreAttributedString = [[NSAttributedString alloc] initWithString:highScoreString attributes:@{NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-DemiBold" size:30.0], NSForegroundColorAttributeName : [UIColor whiteColor], NSKernAttributeName : @(-1.8f)}];
    _highScoreLabel.attributedText = highScoreAttributedString;
    
    [self.view addSubview:_highScoreLabel];
    
    _playButton = [[UIButton alloc] init];
    [_playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [_playButton addTarget:self action:@selector(presentGameScreen:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playButton];
    
    _gameTitleLabel.translatesAutoresizingMaskIntoConstraints =
    _highScoreLabel.translatesAutoresizingMaskIntoConstraints =
    _playButton.translatesAutoresizingMaskIntoConstraints =
    NO;
    
    [self.view addCompactConstraints:@[@"gameTitleLabel.centerX = view.centerX",
                                       @"gameTitleLabel.bottom = highScoreLabel.top+10",
                                       @"highScoreLabel.centerX = view.centerX",
                                       @"highScoreLabel.centerY = view.centerY-15",
                                       @"playButton.centerX = view.centerX",
                                       @"playButton.centerY = view.centerY+50",
                                       @"playButton.width = 65",
                                       @"playButton.height = 74"]
                             metrics:nil
                               views:@{@"view": self.view,
                                       @"gameTitleLabel": _gameTitleLabel,
                                       @"highScoreLabel": _highScoreLabel,
                                       @"playButton": _playButton}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)presentGameScreen:(UIButton *)sender {
    RFGameViewController *gameViewController = [[RFGameViewController alloc] init];
    [self presentViewController:gameViewController animated:YES completion:nil];
}

@end
