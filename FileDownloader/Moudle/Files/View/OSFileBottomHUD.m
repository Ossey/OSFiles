//
//  OSFileBottomHUD.m
//  FileDownloader
//
//  Created by Swae on 2017/10/29.
//  Copyright © 2017年 Ossey. All rights reserved.
//

#import "OSFileBottomHUD.h"

@interface OSFileBottomHUDButton : UIButton

@property (nonatomic) CGFloat imageTitleSpace;

@end


@interface OSFileBottomHUDItem ()

@property (nonatomic, assign) NSInteger buttonIdx;;

@end

@interface OSFileBottomHUD ()

@property (nonatomic, strong) UIWindow *xy_parentWindow;
@property (nonatomic, assign) CGRect hideRect;
@property (nonatomic, weak) UIView *toView;
@property (nonatomic, strong) NSArray<OSFileBottomHUDItem *> *items;
@property (nonatomic, strong) NSArray<UIButton *> *buttons;

@end

@implementation OSFileBottomHUD

- (instancetype)initWithItems:(NSArray<OSFileBottomHUDItem *> *)items toView:(UIView *)view {
    if (self = [super initWithFrame:CGRectZero]) {
        NSAssert(view, @"view do not nil");
        self.toView = view;
        self.items = items;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(0, self.toView.frame.size.height, self.toView.frame.size.width, self.frame.size.height)];
    _xy_parentWindow = window;
    UIViewController *vc = [[UIViewController alloc] init];
    window.rootViewController = vc;
    [vc.view addSubview:self];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [vc.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[view]|" options:kNilOptions metrics:nil views:@{@"view": self}]];
    [vc.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:kNilOptions metrics:nil views:@{@"view": self}]];
    self.backgroundColor = [UIColor whiteColor];
    vc.view.backgroundColor = [UIColor whiteColor];
    window.hidden = NO;
    
    [self setupViews];
}

- (void)setupViews {
    NSMutableArray *btnlist =@[].mutableCopy;
     NSInteger i = 0;
    for (OSFileBottomHUDItem *item in self.items) {
        OSFileBottomHUDButton *btn = [OSFileBottomHUDButton buttonWithType:UIButtonTypeSystem];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        btn.contentMode = UIViewContentModeScaleAspectFit;
        [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [btn setTitle:item.title forState:UIControlStateNormal];
        [btn setImage:item.image forState:UIControlStateNormal];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        btn.hidden = NO;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        item.buttonIdx = i;
        btn.tag = i;
        [self addSubview:btn];
        [btnlist addObject:btn];
        i++;
    }
    self.buttons = btnlist;
    
    [self updateSubViewsConstraints];
}

- (void)updateSubViewsConstraints {
    
    NSMutableDictionary *subviewDict = @{}.mutableCopy;
    NSMutableString *verticalFormat = [NSMutableString new];
    
    NSInteger i = 0;
    UIButton *previousBtn = nil;
    for (UIButton *btn in self.buttons) {
        NSString *btnKey = [NSString stringWithFormat:@"btn%ld", i];
        subviewDict[btnKey] = btn;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[%@]|", btnKey] options:kNilOptions metrics:nil views:subviewDict]];
        if (previousBtn) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:previousBtn attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
        }
        [verticalFormat appendFormat:@"-(%.f@1000)-[%@]", 0.0, btnKey];
        if (i == self.buttons.count - 1) {
            // 最后一个控件把距离父控件底部的约束值也加上
            [verticalFormat appendFormat:@"-(%.f@1000)-", 0.0];
        }
        previousBtn = btn;
        i++;
    }
    
    if (verticalFormat.length) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"|%@|", verticalFormat] options:kNilOptions metrics:nil views:subviewDict]];
    }
    
    [UIView performWithoutAnimation:^{
        [self layoutIfNeeded];
    }];
}

- (void)showHUDWithFrame:(CGRect)frame completion:(void (^)(void))completion {
    [UIView animateWithDuration:0.2 animations:^{
        self.xy_parentWindow.hidden = NO;
        CGRect hudFrame = self.xy_parentWindow.frame;
        if (CGRectIsEmpty(frame)) {
            hudFrame = self.frame;
        }
        else {
            hudFrame = frame;
        }
        
        self.xy_parentWindow.frame = hudFrame;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
   
}

- (void)hideHudCompletion:(void (^)(void))completion {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.xy_parentWindow.frame;
        frame.origin.y = self.toView.frame.size.height;
        self.xy_parentWindow.frame =  frame;
    } completion:^(BOOL finished) {
        self.xy_parentWindow.hidden = YES;
        if (completion) {
            completion();
        }
    }];
    
}

- (void)btnClick:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(fileBottomHUD:didClickItem:)]) {
        OSFileBottomHUDItem *item = [self.items objectAtIndex:btn.tag];
        [self.delegate fileBottomHUD:self didClickItem:item];
    }
}

@end


@implementation OSFileBottomHUDItem

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image {
    if (self = [super init]) {
        self.title = title;
        self.image = image;
    }
    return self;
}
@end


@implementation OSFileBottomHUDButton {
    CGSize _titleLabelSize;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}


// 图片太大，文本显示不出来，控制button中image的尺寸
// imageRectForContentRect:和titleRectForContentRect:不能互相调用imageView和titleLael,不然会死循环
- (CGRect)imageRectForContentRect:(CGRect)bounds {
    if (CGSizeEqualToSize(_titleLabelSize, CGSizeZero)) {
        return CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);
    }
    return CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height-_titleLabelSize.height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    if (self.imageView.image) {
        return CGRectMake(0.0, self.imageView.bounds.size.height, self.bounds.size.width, self.bounds.size.height-self.imageView.bounds.size.height);
    }
    return CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);
    
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    _titleLabelSize = [title sizeWithMaxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) font:self.titleLabel.font];
}


@end

