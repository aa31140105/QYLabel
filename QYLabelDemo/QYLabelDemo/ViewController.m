//
//  ViewController.m
//  QYLabelDemo
//
//  Created by 天佑 on 16/4/26.
//  Copyright © 2016年 天佑. All rights reserved.
//

#import "ViewController.h"
#import "QYLabel.h"
/** 设置颜色的RGB值 */
#define QYColor(r,g,b) [UIColor colorWithRed:(r) / 256.0 green:(g) / 256.0 blue:(b) / 256.0 alpha:1]
#define QYRandomColor QYColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))
@interface ViewController ()

@property (weak, nonatomic) IBOutlet QYLabel *myLabel;
@property (weak, nonatomic) IBOutlet UITextField *myTextFidle;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //闭包回调打印
    self.myLabel.userStringTapHandler = ^(UILabel *label,NSString *string,NSRange range){
        NSLog(@"string = %@,range.location = %lu,range.length = %lu",string,range.location,range.length);
    };

}


- (IBAction)matchTopic:(id)sender {
    self.myLabel.showTopic = YES;
}

- (IBAction)cancelTopic:(id)sender {
    self.myLabel.showTopic = NO;
}

- (IBAction)cancelUser:(id)sender {
    self.myLabel.showUser = NO;
}

- (IBAction)matchUser:(id)sender {
    self.myLabel.showUser = YES;
}

- (IBAction)cancelLink:(id)sender {
    self.myLabel.showLink = NO;
}

- (IBAction)matchLink:(id)sender {
    self.myLabel.showLink = YES;
}

- (IBAction)matchTextColor:(id)sender {
    self.myLabel.matchTextColor = QYRandomColor;
}



- (IBAction)addMyString:(id)sender {
    
    if (self.myTextFidle.text.length > 0 && ![self.myTextFidle.text isEqual: @""]) {
        [self.myLabel.addStringM addObject:self.myTextFidle.text];
        self.myLabel.text = [NSString stringWithFormat:@"%@%@",self.myTextFidle.text,self.myLabel.text];
        
    }
}


@end
