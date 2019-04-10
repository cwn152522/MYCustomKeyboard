//
//  MYKeyboardView.h
//  MYKeyboardDemo
//
//  Created by chenweinan on 17/5/24.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYCustomKeyboard.h"


@interface UITextField(getSelectRange)//获取当前选中文本范围或光标当前位置

@property (assign, nonatomic) NSRange selectRange;

@end


//-------------------------------------------MYKeyboardToolBar------------------------------------------

@class MYKeyboardToolBar;

@interface MYKeyboardToolBar : UIView

@property (assign, nonatomic) NSInteger selectIndex;//当前选中的Item，如0数字，1首字母，2中文；
@property (copy, nonatomic) void(^toolBarBtnClickBlock)(NSInteger index);

- (void)setSelectIndex:(NSInteger)selectIndex;//将指定按钮选中
- (void)setItemTitles:(NSArray<NSString *> *)itemTitles;//设置按钮标题

@end



//-------------------------------------------MYStockKeyboardView------------------------------------------

@class MYStockKeyboardView;

@protocol MYStockKeyboardViewDatasource <NSObject>

- (NSInteger)numberOfCustomKeyboards;
- (KeyboardType)customKeyboardAtIndex:(NSInteger)index;

@end


@protocol MYStockKeyboardViewDelegate <NSObject>

@optional;
- (void)customKeyboardChangedTextFieldDidChanged:(UITextField *)textField;
- (BOOL)customKeyboardWillDeleteCharacters:(NSString *)characters atRange:(NSRange)range;//返回是否执行删除操作

@end


@interface MYStockKeyboardView : UIView//基于;进行适配的246键盘高度+固定的44工具栏高度

@property (assign, nonatomic) id <MYStockKeyboardViewDatasource> datasource;
@property (assign, nonatomic) id <MYStockKeyboardViewDelegate> delegate;

@property (strong, nonatomic) MYKeyboardToolBar *toolBar;//工具栏, 固定44高度

- (void)combinedTextField:(UITextField *)textField inController:(UIViewController *)controller  withToolBarItems:(NSArray <NSString *>*)items;

- (void)changeKeyBoardTo:(KeyboardType)index;//切换键盘

@end
