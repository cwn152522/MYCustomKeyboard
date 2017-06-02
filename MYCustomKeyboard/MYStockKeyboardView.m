//
//  MYKeyboardView.m
//  MYKeyboardDemo
//
//  Created by chenweinan on 17/5/24.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import "MYStockKeyboardView.h"
#import "UIView+CWNView.h"
#define HexColor(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0]
#define RGBColor(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface  MYKeyboardToolBar()

@property (strong, nonatomic) UIButton *numberBtn;//数字123按钮
@property (strong, nonatomic) UIButton *firstCharacterBtn;//首字母按钮
@property (strong, nonatomic) UIButton *chineseBtn;//中文按钮
@property (strong, nonatomic) UIButton *emojiBtn;//表情按钮
@property (strong, nonatomic) UIButton *downBtn;//关闭键盘按钮

@property (strong, nonatomic) NSArray <UIButton *> *leftBtns;//以上三个按钮，关闭键盘按钮除外

@end

@implementation MYKeyboardToolBar

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self addSubview:self.numberBtn];
        [self addSubview:self.firstCharacterBtn];
        [self addSubview:self.chineseBtn];
        [self addSubview:self.downBtn];
        [self addSubview:self.emojiBtn];
        
        self.leftBtns = @[self.numberBtn, self.firstCharacterBtn, self.chineseBtn, self.emojiBtn];
        self.selectIndex = 1;
        
        __weak typeof(self) weakSelf = self;
        
        [self.numberBtn cwn_makeConstraints:^(UIView *maker) {
            maker.leftToSuper(0).topToSuper(0).bottomToSuper(0).width(ShiPei(75));
        }];
        
        [self.firstCharacterBtn cwn_makeConstraints:^(UIView *maker) {
            maker.leftTo(weakSelf.numberBtn, 1, 0).topToSuper(0).bottomToSuper(0).width(ShiPei(75));
        }];
        
        [self.chineseBtn cwn_makeConstraints:^(UIView *maker) {
            maker.leftTo(weakSelf.firstCharacterBtn, 1, 0).topToSuper(0).bottomToSuper(0).width(ShiPei(75));
        }];
        
        [self.emojiBtn cwn_makeConstraints:^(UIView *maker) {
            maker.leftTo(weakSelf.chineseBtn, 1, 0).topToSuper(0).bottomToSuper(0).width(ShiPei(75));
        }];
        
        [self.downBtn cwn_makeConstraints:^(UIView *maker) {
            maker.rightToSuper(0).topToSuper(0).bottomToSuper(0).width(ShiPei(75));
        }];
        
        
        //分割线
        UIView *topLine = [[UIView alloc] init];
        topLine.backgroundColor = HexColor(0xaaaaaa);
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = HexColor(0xaaaaaa);
        [self addSubview:topLine];
        [self addSubview:bottomLine];
        
        [topLine cwn_makeConstraints:^(UIView *maker) {
            maker.topToSuper(0).leftToSuper(0).rightToSuper(0).height(1.0 / [UIScreen mainScreen].scale);
        }];
        [bottomLine cwn_makeConstraints:^(UIView *maker) {
            maker.bottomToSuper(0).leftToSuper(0).rightToSuper(0).height(1.0 / [UIScreen mainScreen].scale);
        }];
        
        for(int i = 0; i < 4; i ++){
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = HexColor(0xaaaaaa);
            [self addSubview:line];
            
            [line cwn_makeConstraints:^(UIView *maker) {
                switch (i) {
                    case 0:{
                        [line cwn_makeConstraints:^(UIView *maker) {
                            maker.topToSuper(0).bottomToSuper(0).leftTo(weakSelf.numberBtn, 1, 0).width(1.0 / [UIScreen mainScreen].scale);
                        }];
                    }
                        break;
                    case 1:{
                        [line cwn_makeConstraints:^(UIView *maker) {
                            maker.topToSuper(0).bottomToSuper(0).leftTo(weakSelf.firstCharacterBtn, 1, 0).width(1.0 / [UIScreen mainScreen].scale);
                        }];
                    }
                        break;
                    case 2:{
                        [line cwn_makeConstraints:^(UIView *maker) {
                            maker.topToSuper(0).bottomToSuper(0).leftTo(weakSelf.chineseBtn, 1, 0).width(1.0 / [UIScreen mainScreen].scale);
                        }];
                    }
                        break;
                    case 3:{
                        [line cwn_makeConstraints:^(UIView *maker) {
                            maker.topToSuper(0).bottomToSuper(0).leftTo(weakSelf.emojiBtn, 1, 0).width(1.0 / [UIScreen mainScreen].scale);
                        }];
                    }
                    default:
                        break;
                }
            }];
        }
    }
    return self;
}

#pragma mark 事件处理

- (void)onClickButton:(UIButton *)sender{
    if(self.selectIndex == [sender.accessibilityIdentifier integerValue])
        return;
    
    [self.leftBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setSelected:NO];
        if(obj == sender){
            obj.selected = YES;
            _selectIndex = [sender.accessibilityIdentifier integerValue];
        }else{
            obj.selected = NO;
        }
    }];
    
    if(self.toolBarBtnClickBlock){
        self.toolBarBtnClickBlock([sender.accessibilityIdentifier integerValue]);
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex{
    switch (selectIndex) {
        case 0:
        case 1:
        case 2:
            [self onClickButton:_leftBtns[selectIndex]];
            break;
            
        default:
            break;
    }
}

#pragma mark private methods

- (UIImage *)changeColorToImage:(UIColor *)color{
    UIImage *image;
    CGRect rect = CGRectMake(0, 0, 10, 10);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)preventFlicker:(UIButton *)button {
    button.highlighted = NO;
}

#pragma mark 控件get方法

- (UIButton *)numberBtn{
    if(!_numberBtn){
        _numberBtn = [[UIButton alloc] init];
        [_numberBtn setTitle:@"123" forState:UIControlStateNormal];
        [_numberBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_numberBtn setBackgroundImage:[self changeColorToImage:HexColor(0xCCD0D7)] forState:UIControlStateSelected];
        [_numberBtn setAccessibilityIdentifier:@"0"];
        [_numberBtn addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_numberBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _numberBtn;
}

- (UIButton *)firstCharacterBtn{
    if(!_firstCharacterBtn){
        _firstCharacterBtn = [[UIButton alloc] init];
        [_firstCharacterBtn setTitle:@"首字母" forState:UIControlStateNormal];
        [_firstCharacterBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_firstCharacterBtn setBackgroundImage:[self changeColorToImage:HexColor(0xCCD0D7)] forState:UIControlStateSelected];
        [_firstCharacterBtn setAccessibilityIdentifier:@"1"];
        [_firstCharacterBtn addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_firstCharacterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _firstCharacterBtn;
}

- (UIButton *)chineseBtn{
    if(!_chineseBtn){
        _chineseBtn = [[UIButton alloc] init];
        [_chineseBtn setTitle:@"中文" forState:UIControlStateNormal];
        [_chineseBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_chineseBtn setBackgroundImage:[self changeColorToImage:HexColor(0xCCD0D7)] forState:UIControlStateSelected];
        [_chineseBtn setAccessibilityIdentifier:@"2"];
        [_chineseBtn addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_chineseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _chineseBtn;
}

- (UIButton *)emojiBtn{
    if(!_emojiBtn){
        _emojiBtn = [[UIButton alloc] init];
        [_emojiBtn setTitle:@"表情" forState:UIControlStateNormal];
        [_emojiBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_emojiBtn setBackgroundImage:[self changeColorToImage:HexColor(0xCCD0D7)] forState:UIControlStateSelected];
        [_emojiBtn setAccessibilityIdentifier:@"3"];
        [_emojiBtn addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_emojiBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _emojiBtn;
}

- (UIButton *)downBtn{
    if(!_downBtn){
        _downBtn = [[UIButton alloc] init];
        [_downBtn setImage:[UIImage imageNamed:@"keyboard_down"] forState:UIControlStateNormal];
        [_downBtn setAccessibilityIdentifier:@"10"];
        [_downBtn addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_downBtn addTarget:self action:@selector(preventFlicker:) forControlEvents:UIControlEventAllEvents];
    }
    return _downBtn;
}

@end


@interface MYStockKeyboardView ()<MYCustomKeyboardDelegate>

@property (weak, nonatomic) UITextField *textField;
@property (weak, nonatomic) UIViewController *controller;

@end

@implementation MYStockKeyboardView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, ShiPei(216) + 44);
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        __weak typeof(self) weakSelf = self;
        
        [self addSubview:self.toolBar];
        
        self.toolBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
        
        self.toolBar.toolBarBtnClickBlock = ^(NSInteger index){//toolbar按钮点击事件
            switch (index) {
                case 0://数字123
                    [weakSelf changeKeyBoardTo:0];
                    break;
                case 1://首字母
                    [weakSelf changeKeyBoardTo:1];
                    break;
                case 2://中文
                    [weakSelf changeKeyBoardTo:2];
                    break;
                case 3://中文
                    [weakSelf changeKeyBoardTo:3];
                    break;
                case 10://关闭键盘
                    [weakSelf.textField resignFirstResponder];
                    break;
                default:
                    break;
            }
        };
    }
    return self;
}

- (void)combinedTextField:(UITextField *)textField inController:(UIViewController *)controller{
    self.textField = textField;
    self.controller = controller;
    textField.inputView = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShow:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(applicationWillResignActive)
     
                                                 name:UIApplicationWillResignActiveNotification object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(applicationWillEnterForeground)
     
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    
    if([_customKeyBoards count] == 0){
        _customKeyBoards = [NSMutableArray array];
    
        MYCustomKeyboard *view = [MYCustomKeyboard customKeyBoardWithType:KeyboardType123];
        view.delegate = self;
        CGRect frame = view.frame;
        frame.origin.y = 44 - 1.0 / [UIScreen mainScreen].scale;
        view.frame = frame;
        [self addSubview:view];
        view.hidden = YES;
        
        MYCustomKeyboard *view1 = [MYCustomKeyboard customKeyBoardWithType:KeyboardTypeABC];
        view1.delegate = self;
        frame = view1.frame;
        frame.origin.y = 44;
        view1.frame = frame;
        [self addSubview:view1];
        view1.hidden = NO;
        
        MYCustomKeyboard *view2 = [MYCustomKeyboard customKeyBoardWithType:KeyboardTypeEmoji];
        view2.delegate = self;
        frame = view2.frame;
        frame.origin.y = 44;
        view2.frame = frame;
        [self addSubview:view2];
        view2.hidden = YES;
        
        [self.customKeyBoards addObject:view];
        [self.customKeyBoards addObject:view1];
        [self.customKeyBoards addObject:view2];
    }
}

#pragma mark 键盘切换

- (void)changeKeyBoardTo:(NSInteger)index{//0数字，1首字母，2中文，3表情
    self.customKeyBoards[0].hidden = YES;
    self.customKeyBoards[1].hidden = YES;
    self.customKeyBoards[2].hidden = YES;
    switch (index) {
        case 0:
            self.textField.inputView = self;
            [self.textField resignFirstResponder];
            [self.toolBar removeFromSuperview];
            [self addSubview:self.toolBar];
            self.toolBar.frame =CGRectMake(0, 0, self.toolBar.frame.size.width, self.toolBar.frame.size.height);
            self.customKeyBoards[0].hidden = NO;
            [self.textField becomeFirstResponder];
            break;
        case 1:
            self.textField.inputView = self;
            [self.textField resignFirstResponder];
            [self.toolBar removeFromSuperview];
            [self addSubview:self.toolBar];
            self.toolBar.frame =CGRectMake(0, 0, self.toolBar.frame.size.width, self.toolBar.frame.size.height);
            self.customKeyBoards[1].hidden = NO;
            [self.textField becomeFirstResponder];
            break;
        case 2:{
            self.textField.inputView = nil;
            
            [CATransaction begin];//事务，执行指定coreAnimation动画时取消动画时间
            [CATransaction setDisableActions:YES];
                [self.textField resignFirstResponder];
            [CATransaction commit];
            
            [self.toolBar removeFromSuperview];
            [self.controller.view addSubview:self.toolBar];
            self.toolBar.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.toolBar.frame.size.width, self.toolBar.frame.size.height);
            [self.textField becomeFirstResponder];
        }
            break;
        case 3:{
            self.textField.inputView = self;
            [self.textField resignFirstResponder];
            [self.toolBar removeFromSuperview];
            [self addSubview:self.toolBar];
            self.toolBar.frame =CGRectMake(0, 0, self.toolBar.frame.size.width, self.toolBar.frame.size.height);
            self.customKeyBoards[2].hidden = NO;
            [self.textField becomeFirstResponder];
        }
            break;
        default:
            break;
    }
}

#pragma mark MYCustomKeyboardDelegate

- (void)onClickKeyboardButtonTypeInputString:(UIButton *)inputStringBtn{//点击字符串输入按钮
    self.textField.text = [self.textField.text stringByAppendingString:inputStringBtn.titleLabel.text];
    if(self.customKeyboardChangedTextFieldBlock){
        self.customKeyboardChangedTextFieldBlock();
    }
}

- (void)onClickKeyboardButtonTypeCommand:(UIButton *)commandBtn{
    NSString *command = commandBtn.titleLabel.text;//获取命令
    if([command isEqualToString:@"删除"]){
        if([self.textField.text length] > 0)
            self.textField.text = [self.textField.text substringToIndex:[self.textField.text length] - 1];
        if(self.customKeyboardChangedTextFieldBlock){
            self.customKeyboardChangedTextFieldBlock();
        }
    }else if([command isEqualToString:@"清空"]){
            self.textField.text = @"";
        if(self.customKeyboardChangedTextFieldBlock){
            self.customKeyboardChangedTextFieldBlock();
        }
    }else if([command isEqualToString:@"ABC"]){
        [self.toolBar setSelectIndex:1];
    }else if([command isEqualToString:@"中文"]){
        [self.toolBar setSelectIndex:2];
    }else if([command isEqualToString:@"搜索"]){
        [self.textField resignFirstResponder];
    }else if([command isEqualToString:@"123"]){
        [self.toolBar setSelectIndex:0];
    }else if([command length] == 0){
        self.textField.text = [self.textField.text stringByAppendingString:@" "];
    }
}

- (void)onClickKeyboardButtonTypeInputEmoj:(UIButton *)emojBtn{
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.textField.text];
//
//        
//        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init] ;
//        textAttachment.image = [UIImage imageNamed:@"45.png"]; //要添加的图片
//        textAttachment.bounds = CGRectMake(0, 0, 20, 20);
//        NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
//    
//        [str insertAttributedString:textAttachmentString atIndex:str.length];
//        
//        [self.textField setAttributedText:str];
    
    
//        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 375, 21)];
//        [lable setTextAlignment:NSTextAlignmentCenter];
//        lable.textColor = [UIColor redColor];
//        [self.textField.superview addSubview:lable];
    
        UITextView *lable = [[UITextView alloc] initWithFrame:CGRectMake(0, 100, 375, 41)];
        lable.textColor = [UIColor redColor];
        [lable setTextAlignment:NSTextAlignmentCenter];
    
        [self.textField.superview addSubview:lable];
    
        //富文本
        NSString *message = @"我是哈哈哈哈哈哈~";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:message attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        
        NSTextAttachment *attachment = [[NSTextAttachment alloc]initWithData:nil ofType:nil];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.png", emojBtn.tag]];
        attachment.image = image;
        attachment.bounds = CGRectMake(0, 0, 20, 20);
        
        NSAttributedString *text = [NSAttributedString attributedStringWithAttachment:attachment];
        [str insertAttributedString:text atIndex:5];
        
        lable.attributedText = str;
}

#pragma mark 通知监听

- (void)keyboardWillShow:(NSNotification*)aNotification{
    //键盘坐标发生变化，_inputView的坐标要跟着变 和tableView的高度也要变
    // NSLog(@"%@",noti.userInfo);
    
    NSDictionary *dic =aNotification.userInfo;
    
    //NSNumber:NSValue  数字类
    //从字典中取出的值 肯定是对象类型
    //1.获取键盘动画结束位置frame
    NSNumber *keyboardFrame= dic[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect keyboardFrameNew = keyboardFrame.CGRectValue;
    
    //2.获取动画时间
    float animationTime =   [dic[@"UIKeyboardAnimationDurationUserInfoKey"]floatValue];
    //3.获取动画的速度
    int animationCurve =[dic[@"UIKeyboardAnimationCurveUserInfoKey"]intValue];

    
    //4.改变_inputView和tableView的坐标
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationTime];
    [UIView setAnimationCurve:animationCurve];
    if(self.toolBar.selectIndex == 2){
        self.toolBar.frame = CGRectMake(0, keyboardFrameNew.origin.y - 44 + 1.0 / [UIScreen mainScreen].scale, [UIScreen mainScreen].bounds.size.width, 44);
    }
    [UIView commitAnimations];
    
    switch (self.toolBar.selectIndex) {
        case 0:
            [self.toolBar.numberBtn setSelected:YES];
            break;
        case 1:
            [self.toolBar.firstCharacterBtn setSelected:YES];
            break;
        case 2:
            [self.toolBar.chineseBtn setSelected:YES];
            break;
        default:
            break;
    }
}

-(void)keyboardWillBeHidden:(NSNotification*)aNotification{
    NSDictionary *dic =aNotification.userInfo;
    
    //NSNumber:NSValue  数字类
    //从字典中取出的值 肯定是对象类型
    
    //2.获取动画时间
    float animationTime =   [dic[@"UIKeyboardAnimationDurationUserInfoKey"]floatValue];
    //3.获取动画的速度
    int animationCurve =[dic[@"UIKeyboardAnimationCurveUserInfoKey"]intValue];
    
    //4.改变_inputView和tableView的坐标
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationTime];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDidStopSelector:@selector(keyboardDidHidden)];
    
    if(self.toolBar.selectIndex == 2){
        self.toolBar.frame =CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.toolBar.frame.size.width, self.toolBar.frame.size.height);
    }
    
    [UIView commitAnimations];
    
}

- (void)keyboardDidHidden{
    [self.toolBar removeFromSuperview];
}

- (void)applicationWillResignActive{
    if(self.textField.resignFirstResponder == YES){
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [self.textField resignFirstResponder];
        [CATransaction commit];
    }
}

- (void)applicationWillEnterForeground{
    if(self.textField.becomeFirstResponder == YES){
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [self.textField resignFirstResponder];
        [CATransaction commit];
    }
}

#pragma mark 控件get方法

- (MYKeyboardToolBar *)toolBar{
    if(!_toolBar){
        _toolBar = [[MYKeyboardToolBar alloc] init];
        _toolBar.backgroundColor = RGBColor(232, 235, 240, 1);
//        _toolBar.layer.shadowColor = GLOBAL_TABLSECTION_LINECOLOR.CGColor;
//        _toolBar.layer.shadowRadius = 1.0 / [UIScreen mainScreen].scale *0.5;
//        _toolBar.layer.shadowOffset = CGSizeMake(0, 1.0 / [UIScreen mainScreen].scale *0.5);
//        _toolBar.layer.shadowOpacity = 1;
    }
    return _toolBar;
}

@end
