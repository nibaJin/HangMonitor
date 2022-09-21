//
//  FJViewController.m
//  HangMonitor
//
//  Created by jin fu on 09/21/2022.
//  Copyright (c) 2022 jin fu. All rights reserved.
//

#import "FJViewController.h"

@interface FJViewController ()

@end

@implementation FJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIButton *stuckBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stuckBtn.frame = CGRectMake(40, 100, 100, 44);
    stuckBtn.backgroundColor = UIColor.redColor;
    [stuckBtn setTitle:@"测试卡顿" forState:UIControlStateNormal];
    [stuckBtn addTarget:self action:@selector(testStuck:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stuckBtn];
    
    
    UIButton *deadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deadBtn.frame = CGRectMake(40, 160, 100, 44);
    deadBtn.backgroundColor = UIColor.redColor;
    [deadBtn setTitle:@"测试卡死" forState:UIControlStateNormal];
    [deadBtn addTarget:self action:@selector(testDead:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deadBtn];
}

- (void)testStuck:(UIButton *)sender
{
    for (NSInteger i = 0; i<9999; i++) {
        NSLog(@"%zd", i);
    }
}

- (void)testDead:(UIButton *)sender
{
    for (NSInteger i = 0; i<9999*4; i++) {
        NSLog(@"%zd", i);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
