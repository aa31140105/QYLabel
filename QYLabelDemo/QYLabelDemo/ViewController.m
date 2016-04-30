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

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet QYLabel *zan;
@property (nonatomic, strong) NSString *str1;


@property (nonatomic, assign) NSInteger count;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //闭包回调打印 
    self.myLabel.userStringTapHandler = ^(UILabel *label,NSString *string,NSRange range,NSInteger matchCount){
        NSLog(@"string = %@,range.location = %lu,range.length = %lu,matchCount = %lu",string,range.location,range.length,matchCount);
    };
    
    self.zan.userStringTapHandler = ^(UILabel *label,NSString *string,NSRange range,NSInteger matchCount){
        NSLog(@"string = %@,range.location = %lu,range.length = %lu,matchCount(匹配到的个数) = %lu",string,range.location,range.length,matchCount);
        self.count = matchCount;
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
    
    if (self.textField.text.length > 0 && ![self.textField.text isEqual: @""]) {
        [self.zan.addStringM addObject:[NSString stringWithFormat:@"%@、",self.textField.text]];
        self.str1 = self.str1 == nil? self.textField.text : [NSString stringWithFormat:@"%@、%@",self.textField.text,self.str1];

        self.zan.text = [NSString stringWithFormat:@"%@、觉得很赞",self.str1];

        
    }
}


@end
