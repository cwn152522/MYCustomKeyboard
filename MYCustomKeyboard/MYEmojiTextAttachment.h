//
//  MYEmojiTextAttachment.h
//  MYCustomKeyboard
//
//  Created by chenweinan on 17/6/5.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYEmojiTextAttachment : NSTextAttachment

@property (strong, nonatomic) NSString *Id;//图片英文名
@property (strong, nonatomic) NSString *tag;//图片html标签
@property (strong, nonatomic) NSString *name;//图片中文名

@end
