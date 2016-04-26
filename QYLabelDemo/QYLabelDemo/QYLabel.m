//
//  QYLabel.m
//  QYLabel
//
//  Created by 天佑 on 16/4/24.
//  Copyright © 2016年 天佑. All rights reserved.
//

#import "QYLabel.h"

typedef enum {
    noneHandle = 0,
    userHandle = 1,
    topicHandle = 2,
    linkHandle = 3
    
}TapHandlerType;

@interface QYLabel ()
@property (nonatomic, strong) NSTextStorage *textStorage;
@property (nonatomic, strong) NSLayoutManager *layoutManager;
@property (nonatomic, strong) NSTextContainer *textContainer;

//用于记录下标值(NSTextCheckingResult数组)
@property (nonatomic, strong) NSArray *linkRanges;
@property (nonatomic, strong) NSArray *userRanges;
@property (nonatomic, strong) NSArray *topicRanges;

//记录用户选择的range
@property (nonatomic, assign) NSRange selectRange;

//记录点击还是松开
@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, assign) TapHandlerType tapHandlerType;


//重写父类属性

@end

@implementation QYLabel

//懒加载
- (TapHandlerType)tapHandlerType {
    if (!_tapHandlerType) {
        _tapHandlerType = noneHandle;
    }
    return _tapHandlerType;
}

- (NSTextStorage *)textStorage {
    if (_textStorage == nil) {
        _textStorage = [[NSTextStorage alloc]init];
    }
    return _textStorage;
}

- (NSLayoutManager *)layoutManager {
    if (_layoutManager == nil) {
        _layoutManager = [[NSLayoutManager alloc]init];
        
    }
    return _layoutManager;
}

- (NSTextContainer *)textContainer {
    if (_textContainer == nil) {
        _textContainer = [[NSTextContainer alloc]init];
        
    }
    return _textContainer;
}

-(void)setText:(NSString *)text{
    //写super很重要
    [super setText:text];

    [self prepareText];
}


- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self prepareText];
}

- (void)setTextColor:(UIColor *)textColor {
    [super setTextColor:textColor];
    [self prepareText];
    
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self prepareText];
}

- (void)setMatchTextColor:(UIColor *)matchTextColor{
    
    _matchTextColor = matchTextColor;
    [self prepareText];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareTextSystem];
        
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self prepareTextSystem];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textContainer.size = self.frame.size;
}

#pragma mark - 重写drawTextInRect方法
- (void)drawTextInRect:(CGRect)rect {

    if (self.selectRange.length != 0) {
        //确定选中时候的背景颜色
        UIColor *selectedColor = self.isSelected ? [UIColor colorWithWhite:0.8 alpha:0.3] : [UIColor clearColor];
        //设置颜色
        [self.textStorage addAttribute:NSBackgroundColorAttributeName value:selectedColor range:self.selectRange];
        
        //绘制背景
        [self.layoutManager drawBackgroundForGlyphRange:self.selectRange atPoint:CGPointMake(0, 0)];

    }

    //绘制字形
    NSRange range = NSMakeRange(0, self.textStorage.length);
    [self.layoutManager drawGlyphsForGlyphRange:range atPoint:CGPointZero];
}

#pragma mark - 准备文本系统
- (void)prepareTextSystem {
    
    //一开始设置颜色
    if (_matchTextColor == nil) {
        self.matchTextColor = [UIColor blueColor];
    }
    [self prepareText];
    
    //1.将布局添加到storeage中
    [self.textStorage addLayoutManager:self.layoutManager];
    
    // 2.将容器添加到布局中
    [self.layoutManager addTextContainer:self.textContainer];
    
    // 3.让label可以和用户交互
    self.userInteractionEnabled = true;
    
    //4.设置间距为0
    self.textContainer.lineFragmentPadding = 0;
}

- (void)prepareText {
    
 
    NSAttributedString *attrString = [[NSAttributedString alloc]init];
    if (self.attributedText != nil) {
        attrString = self.attributedText;
    } else if (self.text != nil) {
        attrString = [[NSAttributedString alloc]initWithString:self.text];
    } else {
        attrString = [[NSAttributedString alloc]initWithString:@""];
    }
    
    self.selectRange = NSMakeRange(0, 0);
    
    //设置换行模型
    NSMutableAttributedString *attrStringM = [self addLineBreak:attrString];
    
    //设置字体大小(这里字体大小改了,但是界面显示不了)
    [attrStringM addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attrStringM.length)];

//    设置textStorage的内容
    [self.textStorage setAttributedString:attrStringM];

//    匹配URL
    self.linkRanges = [self getLinkRanges];
    for (NSTextCheckingResult *res in self.linkRanges) {
        NSRange range = res.range;
    [self.textStorage addAttribute:NSForegroundColorAttributeName value:self.matchTextColor range:range];

    }
    
    //匹配用户
    self.userRanges = [self getRanges:@"@[\\u4e00-\\u9fa5a-zA-Z0-9_-]*"];
    for (NSTextCheckingResult *res in self.userRanges) {
        NSRange range = res.range;
        [self.textStorage addAttribute:NSForegroundColorAttributeName value:self.matchTextColor range:range];

    }
    
    //匹配话题
    self.topicRanges = [self getRanges:@"#.*?#"];
    for (NSTextCheckingResult *res in self.topicRanges) {
        NSRange range = res.range;
      [self.textStorage addAttribute:NSForegroundColorAttributeName value:self.matchTextColor range:range];
        
    }
    
    //设置多行
    self.numberOfLines = 0;

    [self setNeedsDisplay];

}

#pragma mark - 正则表达式处理
- (NSArray *)getRanges:(NSString *)pattern{
 
    NSError *error = nil;
    NSRegularExpression *regex = [[NSRegularExpression alloc]initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (error != nil) {
        NSLog(@"%@",error);
    }

   return [self getRangesFromResult:regex];
}

- (NSArray *)getLinkRanges {
    NSError *error = nil;
    NSDataDetector *detector = [[NSDataDetector alloc]initWithTypes:NSTextCheckingTypeLink error:&error];

    if (error != nil) {
        NSLog(@"%@",error);
        
    }
    
    return [self getRangesFromResult:(NSRegularExpression *)detector];
    
}

- (NSArray *)getRangesFromResult:(NSRegularExpression *)regex {

    //真正匹配的地方(匹配结果)
  NSArray *results = [regex matchesInString:self.textStorage.string options:0 range:NSMakeRange(0, self.textStorage.length)];

    return results;
}


// 如果用户没有设置lineBreak,则所有内容会绘制到同一行中,因此需要主动设置(用于处理多行显示)
- (NSMutableAttributedString *)addLineBreak:(NSAttributedString *)attrString {
    
   NSMutableAttributedString *attrStringM = [[NSMutableAttributedString alloc]initWithAttributedString:attrString];
    
    if (attrStringM.length == 0) {
        return attrStringM;
    }
    NSRange range = NSMakeRange(0, 0);
    
    NSMutableDictionary *attributes = [attrStringM attributesAtIndex:0 effectiveRange:&range].mutableCopy;
    
    NSMutableParagraphStyle *paragraphStyle =attributes[NSParagraphStyleAttributeName];
    
   NSMutableParagraphStyle *paraM = paragraphStyle.mutableCopy;

    if (paraM != nil) {

       paraM.lineBreakMode = NSLineBreakByWordWrapping;
        attributes[NSParagraphStyleAttributeName] = paraM;

    }else {
        paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        attributes[NSParagraphStyleAttributeName] = paragraphStyle;
       
    }
        [attrStringM setAttributes:attributes range:range];
    return  attrStringM;
    
}

#pragma mark - 交互事件处理
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //1.记录点击
    self.isSelected = YES;
    
    //获取用户点击的点
    UITouch *touch = [touches anyObject];
    CGPoint selectedPoint = [touch locationInView:self];
    
    //获取该点对于的字符串的range
    self.selectRange = [self getSelectRange:selectedPoint];
    
    //是否处理了事件
    if (self.selectRange.length == 0) {
        [super touchesBegan:touches withEvent:event];
    }
    
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   
    if (self.selectRange.length == 0) {
        [super touchesEnded:touches withEvent:event];
        return ;
    }
    
    //松开记录
    self.isSelected = NO;
    
    //重新绘制
    [self setNeedsDisplay];
    
    //取出内容
    NSString * contentText = [self.textStorage.string substringWithRange:self.selectRange];
    
    //回调
    switch (self.tapHandlerType) {
        case linkHandle:
            if (self.linkTapHandler != nil) {
                self.linkTapHandler(self,contentText,self.selectRange);
            }
            break;
        case userHandle:
            if (self.userTapHandler != nil) {
                self.userTapHandler(self,contentText,self.selectRange);
            }
            break;
        case topicHandle:
            if (self.topicTapHandler != nil) {
                self.topicTapHandler(self,contentText,self.selectRange);
            }
            break;
            
        default:
            break;
    }
}

- (NSRange)getSelectRange:(CGPoint)selectedPoint {

    // 0.如果属性字符串为nil,则不需要判断
    if (self.textStorage.length == 0) {
        return NSMakeRange(0, 0);
    }
    // 1.获取选中点所在的下标值(index)
    NSInteger index = [self.layoutManager glyphIndexForPoint:selectedPoint inTextContainer:self.textContainer];
    // 判断是否是一个链接
    for (NSTextCheckingResult *res in self.linkRanges) {
        if (index > res.range.location && index < res.range.location + res.range.length) {
            [self setNeedsDisplay];
            self.tapHandlerType = linkHandle;
            
            return res.range;
        }
    }
    
    //判断是否是一个@用户
    for (NSTextCheckingResult *res in self.userRanges) {
        if (index > res.range.location && index < res.range.location + res.range.length) {
            [self setNeedsDisplay];
            self.tapHandlerType = topicHandle;
            return res.range;
        }
    }
    //判断是否是一个#话题#
    for (NSTextCheckingResult *res in self.topicRanges) {
        if (index > res.range.location && index < res.range.location + res.range.length) {
            [self setNeedsDisplay];
            self.tapHandlerType = topicHandle;
            return res.range;
        }
    }
    return NSMakeRange(0, 0);
}

@end
