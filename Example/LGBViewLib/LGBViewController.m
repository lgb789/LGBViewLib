//
//  LGBViewController.m
//  LGBViewLib
//
//  Created by lgb on 05/24/2017.
//  Copyright (c) 2017 lgb. All rights reserved.
//

#import "LGBViewController.h"
#import "LGBHeader.h"

@interface LGBViewController ()

@end

@implementation LGBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIView *v1 = [UIView new];
    v1.backgroundColor = ZA_colorRed;
    
    [self.view addSubview:v1];
    
    v1.lgb_Layout
    .spaceToViewLeft(self.view, 10)
    .spaceToViewTop(self.view, 80)
    .spaceToViewRight(self.view, 40)
    .spaceToViewDown(self.view, 120);
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
