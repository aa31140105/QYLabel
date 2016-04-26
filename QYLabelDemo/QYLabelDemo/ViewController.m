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

//匹配话题
- (IBAction)matchTopic:(id)sender {
    self.myLabel.showTopic = YES;
}
//取消匹配话题
- (IBAction)cancelTopic:(id)sender {
    self.myLabel.showTopic = NO;
}
//取消匹配用户
- (IBAction)cancelUser:(id)sender {
    self.myLabel.showUser = NO;
}
//匹配用户
- (IBAction)matchUser:(id)sender {
    self.myLabel.showUser = YES;
}
//取消匹配链接
- (IBAction)cancelLink:(id)sender {
    self.myLabel.showLink = NO;
}
//匹配链接
- (IBAction)matchLink:(id)sender {
    self.myLabel.showLink = YES;
}
//设置随机颜色
- (IBAction)matchTextColor:(id)sender {
    self.myLabel.matchTextColor = QYRandomColor;
}


//添加自定义字符匹配
- (IBAction)addMyString:(id)sender {
    
    if (self.myTextFidle.text.length > 0 && ![self.myTextFidle.text isEqual: @""]) {
        [self.myLabel.addStringM addObject:self.myTextFidle.text];
        self.myLabel.text = [NSString stringWithFormat:@"%@%@",self.myTextFidle.text,self.myLabel.text];
        
    }
}


@end
