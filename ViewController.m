//
//  ViewController.m
//  CMoeDataBase
//
//  Created by CMoe on 16/8/21.
//  Copyright © 2016年 CMoe. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+CMoeSQLite.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Person *per = [[Person alloc] init];
    per.name = @"CMoe";
    per.age = 111;
    per.height = 1.23;
    [per saveToSQLite:@"CMoeDataBase"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
