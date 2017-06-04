//
//  ViewController.m
//  MYCustomKeyboard
//
//  Created by 伟南 陈 on 2017/5/30.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import "ViewController.h"
#import "MYStockKeyboardView.h"

@interface ViewController ()<MYStockKeyboardViewDelegate, MYStockKeyboardViewDatasource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) MYStockKeyboardView *keyboardView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.keyboardView = [[MYStockKeyboardView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , ShiPei(246) + 44)];
    [self.keyboardView combinedTextField:self.textField inController:self withToolBarItems:@[@"123", @"首字母", @"中文", @"表情"]];
    self.keyboardView.datasource = self;
    self.keyboardView.delegate = self;
    self.textField.delegate = self;
    [self.textField addTarget:self action:@selector(customKeyboardChangedTextFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.keyboardView changeKeyBoardTo:KeyboardTypeABC];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([string isEqualToString: @""] && range.length == 1){//条件一：删除一个字符
        if([self isEmojiCharacters:[self.textField.text substringToIndex:range.location + range.length]] == YES){//条件二：从characters开始以前的字符由右向左匹配出来是表情字符串
            //匹配成功，这边执行表情字符串删除操作，并返回NO
            self.textField.text = [self.textField.text stringByReplacingCharactersInRange:NSMakeRange(range.location - 3, 4) withString:@""];
            self.textField.selectRange = NSMakeRange(range.location - 3, 0);
            [self customKeyboardChangedTextFieldDidChanged:textField];
            return NO;
        }
    }
    return YES;
}

#pragma mark MYStockKeyboardViewDatasource

- (NSInteger)numberOfCustomKeyboards{
    return 4;
}

- (KeyboardType)customKeyboardAtIndex:(NSInteger)index{
    switch (index) {
        case 0:
            return KeyboardType123;
            break;
        case 1:
            return KeyboardTypeABC;
            break;
        case 2:
            return KeyboardTypeChinese;
            break;
        case 3:
            return KeyboardTypeEmoji;
            break;
        default:
            break;
    }
    
    return KeyboardTypeUnKnow;
}

#pragma mark MYStockKeyboardViewDelegate

- (void)customKeyboardChangedTextFieldDidChanged:(UITextField *)textField{
    //键盘内容修改时回调
    NSLog(@"当前待搜索内容：%@", textField.text);
}

- (BOOL)customKeyboardWillDeleteCharacters:(NSString *)characters atRange:(NSRange)range{
    //进行正则匹配，如果是表情字符串，就将整个表情字符串删除，并返回NO
    if([characters length] == 1){//条件一：只删一个字符
        if([self isEmojiCharacters:[self.textField.text substringToIndex:range.location + range.length]] == YES){//条件二：从characters开始以前的字符由右向左匹配出来是表情字符串
            //匹配成功，这边执行表情字符串删除操作，并返回NO
            self.textField.text = [self.textField.text stringByReplacingCharactersInRange:NSMakeRange(range.location - 3, 4) withString:@""];
            self.textField.selectRange = NSMakeRange(range.location - 3, 0);
            return NO;
        }
    }
    return YES;
}

#pragma mark 其它方法

- (BOOL)isEmojiCharacters:(NSString *)textStr{//判断删除的字符是否是表情字符串的最后一个字符
    NSRegularExpression *expresion = [NSRegularExpression regularExpressionWithPattern:@"\\[[\\u4e00-\\u9fa5]{2}\\]$" options:0 error:nil];
    NSTextCheckingResult *result = [expresion firstMatchInString:textStr options:NSMatchingReportProgress range:NSMakeRange(0, textStr.length)];
    if(result.range.location == NSNotFound || result == nil){
        return NO;
    }
    return YES;
}

@end
