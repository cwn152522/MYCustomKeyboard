//
//  MYCustomKeyboard.h
//  GuDaShi
//
//  Created by 伟南 陈 on 2017/5/24.
//  Copyright © 2017年 songzhaojie. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ShiPei(a)  [UIScreen mainScreen].bounds.size.width/375.0*a
#define HexColor(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0]

typedef NS_ENUM(NSUInteger, KeyboardType){
    KeyboardTypeUnKnow,//未知
    KeyboardTypeChinese,//中文键盘
    KeyboardType123,//股票数字键盘
    KeyboardTypeABC,//首字母键盘
    KeyboardTypeEmoji//表情键盘
};

@protocol MYCustomKeyboardDelegate <NSObject>

- (void)onClickKeyboardButtonTypeInputString:(UIButton *)inputStringBtn;//点击会输入字符串的按钮
- (void)onClickKeyboardButtonTypeCommand:(UIButton *)commandBtn;//点击会执行指定命令的按钮

@end

//-----------------------------------------------------------------MYCustomKeyboard-----------------------------------------------------------------

@interface MYCustomKeyboard : UIView//自定义键盘基类，高度基于ihpne6进行适配的216高度，即ShiPei(216)

@property (assign, nonatomic) id <MYCustomKeyboardDelegate> delegate;

@property (assign, nonatomic) KeyboardType type;

+ (instancetype)customKeyBoardWithType:(KeyboardType)type;

@end


//-------------------------------------------MYCustomKeyboardChinese-------------------------------------------

@interface MYCustomKeyboardChinese : MYCustomKeyboard//中文键盘

@end


//-------------------------------------------MYCustomKeyboard123-------------------------------------------

@interface MYCustomKeyboard123 : MYCustomKeyboard//数字键盘

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *numberBtns;//数字按钮，如600、1、2等
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *commandBtns;//命令按钮，如删除、清空、搜索等

@end


//-----------------------------------MYCustomKeyboardFirstCharacter---------------------------------------

@interface MYCustomKeyboardFirstCharacter : MYCustomKeyboard//首字母键盘

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *firstCharacterBtns;//首字母按钮，如A、B、C等
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *commandBtns;//命令按钮，如中文，空格，搜索等

@end


//-----------------------------------MYCustomKeyboardEmoji---------------------------------------

@interface MYCustomKeyboardEmoji : MYCustomKeyboard//表情键盘

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *emojiButns;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *commandBtns;//命令按钮，如中文，空格，搜索等

@end
