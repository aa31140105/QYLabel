//
//  QYLabel.h
//  QYLabel
//
//  Created by 天佑 on 16/4/24.
//  Copyright © 2016年 天佑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYLabel : UILabel
typedef  void(^QYTapHandler)(QYLabel *label,NSString * string,NSRange range);

//闭包属性用于回调
@property (nonatomic, strong) QYTapHandler linkTapHandler;
@property (nonatomic, strong) QYTapHandler topicTapHandler;
@property (nonatomic, strong) QYTapHandler userTapHandler;

//用于修改匹配的字体颜色
@property (nonatomic, strong) UIColor *matchTextColor;
@end
