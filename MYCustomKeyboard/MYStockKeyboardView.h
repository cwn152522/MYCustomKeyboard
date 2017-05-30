//
//  MYKeyboardView.h
//  MYKeyboardDemo
//
//  Created by chenweinan on 17/5/24.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYCustomKeyboard.h"

@interface MYKeyboardToolBar : UIView

@property (assign, nonatomic) NSInteger selectIndex;//当前选中的键盘，0数字，1首字母，2中文；设置方法的时候会将指定按钮选中
@property (copy, nonatomic) void(^toolBarBtnClickBlock)(NSInteger index);

@end



@interface MYStockKeyboardView : UIView//基于iphone6进行适配的246高度+固定的44高度

@property (strong, nonatomic) MYKeyboardToolBar *toolBar;//工具栏, 固定44高度
@property (strong, nonatomic) NSMutableArray <MYCustomKeyboard *> *customKeyBoards;//自定义键盘，高度为基于iphone6进行适配的246高度
@property (copy, nonatomic) void(^customKeyboardChangedTextFieldBlock)();//自定义键盘修改了文本输入回调

- (void)combinedTextField:(UITextField *)textField inController:(UIViewController *)controller;

@end
