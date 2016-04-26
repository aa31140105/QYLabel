# QYLabel
匹配出UILabel的@用户、#话题#、http链接等
#pragma mark - 代码创建的QYLabel
    QYLabel *label = [[QYLabel alloc]init];
    label.frame = CGRectMake(0 ,200, 400, 100);
    label.text = @"作者:@aa31140105 话题:#Label字符串识别# 网址:https://github.com/aa31140105/QYLabel";
    label.matchTextColor = [UIColor redColor];
    
    //block回调
    label.linkTapHandler = ^(UILabel *label,NSString *string,NSRange range){
        
        NSLog(@"label = %@,string = %@,range.location = %lu,range.length = %lu",label,string,range.location,range.length);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
        
    };
    
    label.userTapHandler = ^(UILabel *label,NSString *string,NSRange range){
        NSLog(@"label = %@,string = %@,range.location = %lu,range.length = %lu",label,string,range.location,range.length);
    };
    
    label.topicTapHandler = ^(UILabel *label,NSString *string,NSRange range){
        NSLog(@"label = %@,string = %@,range.location = %lu,range.length = %lu",label,string,range.location,range.length);
    };
    [self.view addSubview:label];
    
    
    
#pragma mark - storyboard创建的QYLabel
    
    self.demoLabel.linkTapHandler = ^(UILabel *label,NSString *string,NSRange range){
        
        NSLog(@"label = %@,string = %@,range.location = %lu,range.length = %lu",label,string,range.location,range.length);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
        
    };
    
    self.demoLabel.userTapHandler = ^(UILabel *label,NSString *string,NSRange range){
        NSLog(@"label = %@,string = %@,range.location = %lu,range.length = %lu",label,string,range.location,range.length);
    };
    
    self.demoLabel.topicTapHandler = ^(UILabel *label,NSString *string,NSRange range){
        NSLog(@"label = %@,string = %@,range.location = %lu,range.length = %lu",label,string,range.location,range.length);
    };
