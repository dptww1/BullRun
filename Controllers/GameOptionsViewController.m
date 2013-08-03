//
//  GameOptionsViewController.m
//  Bull Run
//
//  Created by Dave Townsend on 7/11/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "GameOptionsViewController.h"

@interface GameOptionsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnDone;

@end

@implementation GameOptionsViewController

- (IBAction)btnDoneTouched:(id)sender {
    NSLog(@"Yo, Done!");
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self view].bounds = CGRectMake(0, 0, 790, 400);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    [[self view] setCenter:CGPointMake(CGRectGetMidX(screenBounds),
                                       CGRectGetMidY(screenBounds))];
    //[[self view] setCenter:CGPointMake(512, 384)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
