//
//  ViewController.m
//  IMP
//
//  Created by 赵海亭 on 2018/1/2.
//  Copyright © 2018年 赵海亭. All rights reserved.
//

#import "ViewController.h"
#import "Car.h"
//#import "NSDictionary+Safe.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Car *car = [Car new];
    [car run:100];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:nil forKey:@"key"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
