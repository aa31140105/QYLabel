//
//  QYLabel.h
//  QYLabel
//
//  Created by 天佑 on 16/4/24.
//  Copyright © 2016年 天佑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYLabel : UILabel
typedef  void(^QYTapHandler)(QYLabel *label,NSString * string,NSRange range,NSInteger matchCount);

//闭包属性用于回调
@property (nonatomic, strong) QYTapHandler userStringTapHandler;

//用于修改匹配的字体颜色
@property (nonatomic, strong) UIColor *matchTextColor;

//保存用户需要匹配的字符串
@property (nonatomic, strong) NSMutableArray *addStringM;

//匹配的字符串个数
@property (nonatomic, assign) NSInteger matchCount;

//是否匹配@ ## http链接
@property (nonatomic, assign) BOOL showTopic;
@property (nonatomic, assign) BOOL showLink;
@property (nonatomic, assign) BOOL showUser;
@end
