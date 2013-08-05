//
//  GameOptionsViewController.m
//  Bull Run
//
//  Created by Dave Townsend on 7/11/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "GameOptionsViewController.h"
#import "MenuController.h"

@interface GameOptionsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnDone;

@end

@implementation GameOptionsViewController

- (IBAction)btnDoneTouched:(id)sender {
    NSLog(@"Yo, Done!");
    [[MenuController sharedInstance] popController];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
