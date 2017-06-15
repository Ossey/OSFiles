//
//  UITextField+Blocks.h
//  FileDownloader
//
//  Created by Ossey on 2017/6/15.
//  Copyright © 2017年 Ossey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Blocks)

@property (copy, nonatomic) BOOL (^shouldBegindEditingBlock)(UITextField *textField);
@property (copy, nonatomic) BOOL (^shouldEndEditingBlock)(UITextField *textField);

@property (copy, nonatomic) void (^didBeginEditingBlock)(UITextField *textField);
@property (copy, nonatomic) void (^didEndEditingBlock)(UITextField *textField);

@property (copy, nonatomic) BOOL (^shouldChangeCharactersInRangeBlock)(UITextField *textField, NSRange range, NSString *replacementString);

@property (copy, nonatomic) BOOL (^shouldReturnBlock)(UITextField *textField);
@property (copy, nonatomic) BOOL (^shouldClearBlock)(UITextField *textField);

- (void)setShouldBegindEditingBlock:(BOOL (^)(UITextField *textField))shouldBegindEditingBlock;
- (void)setShouldEndEditingBlock:(BOOL (^)(UITextField *textField))shouldEndEditingBlock;

- (void)setDidBeginEditingBlock:(void (^)(UITextField *textField))didBeginEditingBlock;
- (void)setDidEndEditingBlock:(void (^)(UITextField *textField))didEndEditingBlock;

- (void)setShouldChangeCharactersInRangeBlock:(BOOL (^)(UITextField *textField, NSRange range, NSString *string))shouldChangeCharactersInRangeBlock;

- (void)setShouldClearBlock:(BOOL (^)(UITextField *textField))shouldClearBlock;
- (void)setShouldReturnBlock:(BOOL (^)(UITextField *textField))shouldReturnBlock;

@end
