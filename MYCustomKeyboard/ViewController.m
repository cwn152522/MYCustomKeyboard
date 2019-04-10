//
//  ViewController.m
//  MYCustomKeyboard
//
//  Created by 伟南 陈 on 2017/5/30.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import "ViewController.h"
#import "MYStockKeyboardView.h"
#import "MYEmojiTextAttachment.h"

@interface ViewController ()<MYStockKeyboardViewDelegate, MYStockKeyboardViewDatasource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
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

- (IBAction)getMessageFormat:(UIButton *)sender {//获取textview中代发送的消息格式
    //正则匹配替换，得到最终消息格式
    NSMutableAttributedString *str = [self.textView.attributedText mutableCopy];
    BOOL containImageAttachs = [str containsAttachmentsInRange:NSMakeRange(0, str.length)];
    if(containImageAttachs == YES){//含有表情
        NSLog(@"含有表情");
        [str enumerateAttributesInRange:NSMakeRange(0, str.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
            if([attrs[@"NSAttachment"] isKindOfClass:[MYEmojiTextAttachment class]]){
//                NSTextAttachment *attachment = attrs[@"NSAttachment"];//最好使用自定义子类的话可以直接获取到映射的值
                MYEmojiTextAttachment *attachment = attrs[@"NSAttachment"];
                [str replaceCharactersInRange:range withString:[attachment.tag length] > 0 ? attachment.tag : @""];
            }
        }];
    }
    
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:[str mutableString] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)sendMessage:(UIButton *)sender {//将消息在textview中显示
    if([self.textField.text length] > 0){
        //正则匹配和替换后进行图文混排的显示
        __block NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.textField.text];
        
        NSRegularExpression *expresion = [NSRegularExpression regularExpressionWithPattern:@"\\[[\\u4e00-\\u9fa5]{2}\\]" options:0 error:nil];

        NSMutableArray *ranges = [NSMutableArray array];
        NSArray *result = [expresion matchesInString:self.textField.text options:NSMatchingReportCompletion range:NSMakeRange(0, self.textField.text.length)];
        [result enumerateObjectsUsingBlock:^(NSTextCheckingResult *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [ranges insertObject:NSStringFromRange(obj.range) atIndex:0];
        }];
        
        NSArray *emojis = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Emoji" ofType:@"plist"]];
            [ranges enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSRange range = NSRangeFromString(obj);
                MYEmojiTextAttachment *imageAttach = [[MYEmojiTextAttachment alloc] init];
                imageAttach.image = [UIImage imageNamed:@"1"];
                imageAttach.bounds = CGRectMake(0, 0, 20, 20);
                NSString *pattern = [[str attributedSubstringFromRange:range] string];
                NSDictionary *dic = [[emojis filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@", pattern]] firstObject];
                if(dic){
                    imageAttach.Id = dic[@"id"];
                    imageAttach.name = dic[@"name"];
                    imageAttach.tag = dic[@"tag"];
                    imageAttach.image = [UIImage imageNamed:dic[@"id"]];
                }
                NSAttributedString *image = [NSAttributedString attributedStringWithAttachment:imageAttach];
                [str deleteCharactersInRange:range];
                [str insertAttributedString:image atIndex:range.location];
            }];
        
        
        [self.textView setAttributedText:str];
        CGRect rect = [str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 32, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil];
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"消息高度为%lf", rect.size.height] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [controller addAction:action];
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [controller addAction:action];
        [self presentViewController:controller animated:YES completion:nil];
    }
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
