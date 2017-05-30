//
//  MYCustomKeyboard.m
//  GuDaShi
//
//  Created by 伟南 陈 on 2017/5/24.
//  Copyright © 2017年 songzhaojie. All rights reserved.
//

#import "MYCustomKeyboard.h"
//#import "GuDaShiHeader.h"
#import "UIView+CWNView.h"

//-----------------------------------------------------------------MYCustomKeyboard-----------------------------------------------------------------

@implementation MYCustomKeyboard

+ (instancetype)customKeyBoardWithType:(KeyboardType)type{
    MYCustomKeyboard *view;
    switch (type) {
        case KeyboardType123:
            return [[[NSBundle mainBundle] loadNibNamed:@"MYCustomKeyboard" owner:nil options:nil] firstObject];
            break;
        case KeyboardTypeABC:
            return [[[NSBundle mainBundle] loadNibNamed:@"MYCustomKeyboard" owner:nil options:nil] lastObject];
        default:
            break;
    }
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, ShiPei(246));
    }
    return self;
}

@end


//-------------------------------------------MYCustomKeyboard123-------------------------------------------

@implementation MYCustomKeyboard123

- (void)awakeFromNib{
    [super awakeFromNib];
    [self cwn_makeShiPeis:^(UIView *maker) {
        maker.shiPeiSubViews();
    }];
    
    [self.numberBtns enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale * 0.5 ;
        obj.layer.borderColor = HexColor(0xaaaaaa).CGColor;
    }];
    [self.commandBtns enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale * 0.5 ;
        obj.layer.borderColor = HexColor(0xaaaaaa).CGColor;
    }];
}

#pragma mark 事件处理

- (IBAction)onClickNumberButtons:(UIButton *)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onClickKeyboardButtonTypeInputString:)]){
        [self.delegate onClickKeyboardButtonTypeInputString:sender];
    }
}

- (IBAction)onClickCommandButtons:(UIButton *)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onClickKeyboardButtonTypeCommand:)]){
        [self.delegate onClickKeyboardButtonTypeCommand:sender];
    }
}

@end


//------------------------------------MYCustomKeyboardFirstCharacter--------------------------------------

@implementation MYCustomKeyboardFirstCharacter

- (void)awakeFromNib{
    [super awakeFromNib];
    [self cwn_makeShiPeis:^(UIView *maker) {
        maker.shiPeiSubViews();
    }];
    
    [self.firstCharacterBtns enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.titleLabel.text length] < 3){
            obj.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:obj.bounds cornerRadius:4].CGPath;
            obj.layer.cornerRadius = 4;
            obj.layer.shadowColor = [UIColor blackColor].CGColor;
            obj.layer.shadowRadius = 0;
            obj.layer.shadowOffset = CGSizeMake(0, 1);
            obj.layer.shadowOpacity = 0.4;
        }
    }];
    [self.commandBtns enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:obj.bounds cornerRadius:4].CGPath;
        obj.layer.cornerRadius = 4;
        obj.layer.shadowColor = [UIColor blackColor].CGColor;
        obj.layer.shadowRadius = 0;
        obj.layer.shadowOffset = CGSizeMake(0, 1);
        obj.layer.shadowOpacity = 0.4;
    }];
}

#pragma mark 事件处理

- (IBAction)onClickFirstCharacterButtons:(UIButton *)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onClickKeyboardButtonTypeInputString:)]){
        [self.delegate onClickKeyboardButtonTypeInputString:sender];
    }
}

- (IBAction)onClickCommandButtons:(UIButton *)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onClickKeyboardButtonTypeCommand:)]){
        [self.delegate onClickKeyboardButtonTypeCommand:sender];
    }
}

@end
