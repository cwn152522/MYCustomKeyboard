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

@implementation UITextField (getSelectRange)

- (NSRange)selectRange{
    UITextPosition *beginingPosition = self.beginningOfDocument;
    UITextRange *selectRange = self.selectedTextRange;
    UITextPosition *selectStartPosition = selectRange.start;
    UITextPosition *selectEndPosition = selectRange.end;
    NSRange range = NSMakeRange([self offsetFromPosition:beginingPosition toPosition:selectStartPosition], [self offsetFromPosition:selectStartPosition toPosition:selectEndPosition]);
    return range;
}

- (void)setSelectRange:(NSRange)selectRange{
    UITextPosition *beginingPosition = self.beginningOfDocument;
    UITextPosition *selectStartPosition = [self positionFromPosition:beginingPosition offset:selectRange.location];
    UITextPosition *selectEndPosition = [self positionFromPosition:beginingPosition offset:selectRange.location + selectRange.length];
    self.selectedTextRange = [self textRangeFromPosition:selectStartPosition toPosition:selectEndPosition];
}

@end


@interface  MYKeyboardToolBar()

@property (assign, nonatomic) NSInteger numberOfItems;

@property (strong, nonatomic) UIButton *downBtn;//关闭键盘按钮
@property (strong, nonatomic) NSMutableArray <UIButton *> *leftBtns;//键盘按钮除外

@end

@implementation MYKeyboardToolBar

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.leftBtns = [NSMutableArray array];
        
        [self addSubview:self.downBtn];
        
        [self.downBtn cwn_makeConstraints:^(UIView *maker) {
            maker.rightToSuper(0).topToSuper(0).bottomToSuper(0).width(ShiPei(75));
        }];
    }
    return self;
}

- (void)setItemTitles:(NSArray<NSString *> *)itemTitles{
    _numberOfItems = [itemTitles count];
    
    __weak typeof(self) weakSelf = self;
    if([_leftBtns count] == 0){
       
        for (int i = 0; i < _numberOfItems; i ++) {
            UIButton *button = [[UIButton alloc] init];
            [button setTitle:itemTitles[i] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [button setBackgroundImage:[self changeColorToImage:HexColor(0xCCD0D7)] forState:UIControlStateSelected];
            [button setAccessibilityIdentifier:[NSString stringWithFormat:@"%d", i]];
            [button addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self addSubview:button];
            [self.leftBtns addObject:button];
        }
        
        [self.leftBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj cwn_makeConstraints:^(UIView *maker) {
                if(idx == 0){
                    maker.leftToSuper(0).topToSuper(0).bottomToSuper(0).width(ShiPei(75));
                }else{
                    maker.leftTo(weakSelf.leftBtns[idx - 1], 1, 0).topToSuper(0).bottomToSuper(0).width(ShiPei(75));
                }
            }];
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
        
        for(int i = 0; i < _numberOfItems; i ++){
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = HexColor(0xaaaaaa);
            [self addSubview:line];
            
            [line cwn_makeConstraints:^(UIView *maker) {
                maker.topToSuper(0).bottomToSuper(0).leftTo(weakSelf.leftBtns[i], 1, 0).width(1.0 / [UIScreen mainScreen].scale);
            }];
        }
    }
}

#pragma mark 事件处理

- (void)onClickButton:(UIButton *)sender{
    if(self.selectIndex == [sender.accessibilityIdentifier integerValue])
        return;
    
    if([sender.accessibilityIdentifier integerValue] != 10)
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
    [_leftBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setSelected:NO];
    }];
    
    if(_selectIndex != 10 && [_leftBtns count] > selectIndex){
        _selectIndex =selectIndex;
        [_leftBtns[selectIndex] setSelected:YES];
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

@property (assign, nonatomic) BOOL needToolBar;

@property (assign, nonatomic) NSInteger numberOfKeyboards;
@property (strong, nonatomic) NSMutableArray <MYCustomKeyboard *> *customKeyBoards;//自定义键盘，高度为基于iphone6进行适配的246高度

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
        
        _toolBar = [[MYKeyboardToolBar alloc] init];
        _toolBar.backgroundColor = RGBColor(232, 235, 240, 1);
        [self addSubview:self.toolBar];
        
        self.toolBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
        
        self.toolBar.toolBarBtnClickBlock = ^(NSInteger index){//toolbar按钮点击事件
            KeyboardType type = [weakSelf.datasource customKeyboardAtIndex:index];
            switch (index) {
                case 10://关闭键盘
                    [weakSelf.textField resignFirstResponder];
                    break;
                default:
                    [weakSelf changeKeyBoardTo:type];
                    break;
            }
        };
    }
    return self;
}

- (void)combinedTextField:(UITextField *)textField inController:(UIViewController *)controller withToolBarItems:(NSArray<NSString *> *)items{
    self.textField = textField;
    self.controller = controller;
    self.needToolBar = [items count] == 0 ? NO : YES;
    self.toolBar.itemTitles = items;
    textField.inputView = self;
    
    if(self.needToolBar == NO){
        [self.toolBar removeFromSuperview];
        self.toolBar = nil;
        CGRect frame = self.frame;
        frame.size.height -= 44;
        self.frame = frame;
    }
    
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
    
}

- (void)setDatasource:(id<MYStockKeyboardViewDatasource>)datasource{
    _datasource = datasource;
    _numberOfKeyboards = [_datasource numberOfCustomKeyboards];
    
    if([_customKeyBoards count] == 0){
        _customKeyBoards = [NSMutableArray array];
        
        for (int i = 0; i < _numberOfKeyboards; i ++) {
            KeyboardType type = [_datasource customKeyboardAtIndex:i];
            if(type == KeyboardTypeUnKnow)
                return;
            
            MYCustomKeyboard *view = [MYCustomKeyboard customKeyBoardWithType:type];
            view.delegate = self;
            CGRect frame = view.frame;
            if(type == KeyboardType123){
                frame.origin.y = self.needToolBar == YES ? (44 - 1.0 / [UIScreen mainScreen].scale) : 0;
            }else{
                frame.origin.y = self.needToolBar == YES ? 44 : 0;
            }
                view.frame = frame;
                [self addSubview:view];
                view.hidden = i == 0 ? NO : YES;
             [self.customKeyBoards addObject:view];
        }
    }
}

#pragma mark 键盘切换

- (void)changeKeyBoardTo:(KeyboardType)type{
     __block NSInteger index = 0;
    [self.customKeyBoards enumerateObjectsUsingBlock:^(MYCustomKeyboard * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.type == type)
            index = idx;
    }];
    
    if(index != self.toolBar.selectIndex)
        self.toolBar.selectIndex = index;
    
    [self.customKeyBoards enumerateObjectsUsingBlock:^(MYCustomKeyboard * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = YES;
    }];
    
    if(type == KeyboardTypeChinese){//中文键盘
        self.textField.inputView = nil;
        
        if(self.textField.isFirstResponder == YES){//当前键盘已显示
            UITextRange *range = self.textField.selectedTextRange;
            [CATransaction begin];//事务，执行指定coreAnimation动画时取消动画时间
            [CATransaction setDisableActions:YES];
            [self.textField resignFirstResponder];
            [CATransaction commit];
            
            [self.toolBar removeFromSuperview];
            [self.controller.view addSubview:self.toolBar];
            self.toolBar.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.toolBar.frame.size.width, self.toolBar.frame.size.height);
            [self.textField becomeFirstResponder];
            self.textField.selectedTextRange = range;
        }else{//当前键盘未显示
            [self.toolBar removeFromSuperview];
            [self.controller.view addSubview:self.toolBar];
            self.toolBar.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.toolBar.frame.size.width, self.toolBar.frame.size.height);
        }
    }else{//其它键盘
        self.textField.inputView = self;
         if(self.textField.isFirstResponder == YES){//当前键盘已显示
             UITextRange *range = self.textField.selectedTextRange;
            [self.textField resignFirstResponder];
            [self.toolBar removeFromSuperview];
            [self addSubview:self.toolBar];
            self.toolBar.frame =CGRectMake(0, 0, self.toolBar.frame.size.width, self.toolBar.frame.size.height);
            self.customKeyBoards[index].hidden = NO;
            [self.textField becomeFirstResponder];
              self.textField.selectedTextRange = range;
         }else{//当前键盘未显示
             [self.toolBar removeFromSuperview];
             [self addSubview:self.toolBar];
             self.toolBar.frame =CGRectMake(0, 0, self.toolBar.frame.size.width, self.toolBar.frame.size.height);
             self.customKeyBoards[index].hidden = NO;
         }
    }
}

#pragma mark MYCustomKeyboardDelegate

- (void)onClickKeyboardButtonTypeInputString:(UIButton *)inputStringBtn{//点击字符串输入按钮
    NSRange range = _textField.selectRange;
     self.textField.text = [self.textField.text stringByReplacingCharactersInRange:range withString:inputStringBtn.titleLabel.text];//替换选中字符串或在光标处插入字符串
    self.textField.selectRange = NSMakeRange(range.location + inputStringBtn.titleLabel.text.length, 0);

    if([self.delegate respondsToSelector:@selector(customKeyboardChangedTextFieldDidChanged:)]){
        [self.delegate customKeyboardChangedTextFieldDidChanged:self.textField];
    }
}

- (void)onClickKeyboardButtonTypeCommand:(UIButton *)commandBtn{
    NSString *command = commandBtn.titleLabel.text;//获取命令
    if([command isEqualToString:@"删除"]){
        if([self.textField.text length] > 0){
            BOOL shouldDelete = YES;
            NSRange range = _textField.selectRange;
            if(range.length > 0){//当前选择了部分文本
                NSRange shouldDeleteRange = range;
                if([self.delegate respondsToSelector:@selector(customKeyboardWillDeleteCharacters:atRange:)]){
                   shouldDelete = [self.delegate customKeyboardWillDeleteCharacters:[self.textField.text substringWithRange:shouldDeleteRange] atRange:shouldDeleteRange];
                }
                if(shouldDelete == YES){
                    self.textField.text = [self.textField.text stringByReplacingCharactersInRange:shouldDeleteRange withString:@""];
                    [self.textField setSelectRange:NSMakeRange(range.location, 0)];
                }
            }
            else{//当前未选择文本
                NSRange shouldDeleteRange = NSMakeRange(range.location - 1, 1);
                if([self.delegate respondsToSelector:@selector(customKeyboardWillDeleteCharacters:atRange:)]){
                   shouldDelete = [self.delegate customKeyboardWillDeleteCharacters:[self.textField.text substringWithRange:shouldDeleteRange] atRange:shouldDeleteRange];
                }
                if(shouldDelete == YES){
                    self.textField.text = [self.textField.text stringByReplacingCharactersInRange:shouldDeleteRange withString:@""];
                    [_textField setSelectRange:NSMakeRange(range.location - 1, 0)];
                }
            }
        
            
            if([self.delegate respondsToSelector:@selector(customKeyboardChangedTextFieldDidChanged:)]){
                [self.delegate customKeyboardChangedTextFieldDidChanged:self.textField];
            }
        }else{
            return;
        }
    }else if([command isEqualToString:@"清空"]){
            self.textField.text = @"";
        if([self.delegate respondsToSelector:@selector(customKeyboardChangedTextFieldDidChanged:)]){
            [self.delegate customKeyboardChangedTextFieldDidChanged:self.textField];
        }
    }else if([command isEqualToString:@"ABC"]){
        [self.toolBar setSelectIndex:KeyboardTypeABC];
        [self changeKeyBoardTo:KeyboardTypeABC];
    }else if([command isEqualToString:@"中文"]){
        [self.toolBar setSelectIndex:KeyboardTypeChinese];
        [self changeKeyBoardTo:KeyboardTypeChinese];
    }else if([command isEqualToString:@"搜索"]){
        [self.textField resignFirstResponder];
    }else if([command isEqualToString:@"123"]){
        [self.toolBar setSelectIndex:KeyboardType123];
        [self changeKeyBoardTo:KeyboardType123];
    }else if([command length] == 0){
        self.textField.text = [self.textField.text stringByAppendingString:@" "];
    }
}

- (void)onClickKeyboardButtonTypeInputEmoj:(UIButton *)emojBtn{

    
    self.textField.text = [self.textField.text stringByAppendingString:emojBtn.titleLabel.text];
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
    
    KeyboardType type = [[self.customKeyBoards objectAtIndex:self.toolBar.selectIndex] type];
    if(type == KeyboardTypeChinese){
        self.toolBar.frame = CGRectMake(0, keyboardFrameNew.origin.y - 44 + 1.0 / [UIScreen mainScreen].scale, [UIScreen mainScreen].bounds.size.width, 44);
    }
    [UIView commitAnimations];
    
    [self.toolBar setSelectIndex:self.toolBar.selectIndex];

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
    
    KeyboardType type = [[self.customKeyBoards objectAtIndex:self.toolBar.selectIndex] type];
    if(type == KeyboardTypeChinese){
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
@end
