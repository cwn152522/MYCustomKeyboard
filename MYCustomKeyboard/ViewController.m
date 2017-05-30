//
//  ViewController.m
//  MYCustomKeyboard
//
//  Created by 伟南 陈 on 2017/5/30.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import "ViewController.h"
#import "MYStockKeyboardView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) MYStockKeyboardView *keyboardView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    
    self.keyboardView = [[MYStockKeyboardView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , ShiPei(246) + 44)];
    [self.keyboardView combinedTextField:self.textField inController:self];
    [self.keyboardView setCustomKeyboardChangedTextFieldBlock:^{
        //键盘内容修改时回调
        NSLog(@"当前待搜索内容：%@", weakSelf.textField.text);
    }];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
}

@end
