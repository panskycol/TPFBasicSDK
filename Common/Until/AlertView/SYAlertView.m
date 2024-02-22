//
//  SYAlertView.m
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/9/15.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#import "SYAlertView.h"
#import "TPFBasicMacro.h"

#define BTN_HEIGHT  50   // 按钮的高度
#define VIEW_MARGIN 15   // 上下左右的边距
#define TITLE_DETAIL_SPACE  0 // 标题和内容的间距
#define DETAIL_BUTTON_SACE 10  // 内容到下面按钮的距离

@interface SYAlertView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, assign) CGSize titleStrSize;
@property (nonatomic, assign) CGSize detailStrSize;

@property (nonatomic, strong) NSMutableArray *confirmBtnArr;
@property (nonatomic, strong) NSMutableArray *separatorArr;

@property (nonatomic, assign) CGFloat maxBtnWidth;    //最长的按钮长度

@property (nonatomic, copy) void(^sureHandler)(NSInteger);
@property (nonatomic, copy) void(^cancelHandler)(void);

@end

@implementation SYAlertView

+ (instancetype)shareAletView{
    
    static SYAlertView *alertView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alertView = [[SYAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        alertView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        [alertView initUI];
    });
    return alertView;
}

- (void)initUI{

    _bgView = [[UIView alloc] init];
    [self addSubview:_bgView];
    
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.image = [UIImage imageNamed:@"common_alert_bg_img"];
    _bgImageView.backgroundColor = [UIColor whiteColor];
    _bgImageView.layer.cornerRadius = 8.0;
    _bgImageView.layer.masksToBounds = YES;
    [_bgView addSubview:_bgImageView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textColor = kRGB(10, 10, 10, 1);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_titleLabel];

    _detailLabel = [[UILabel alloc] init];
    _detailLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    _detailLabel.numberOfLines = 0;
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    _detailLabel.textColor = kRGB(10, 10, 10, 1);
    [_bgView addSubview:_detailLabel];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    [_cancelBtn setTitleColor:kRGB(255, 134, 82, 1) forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.tag = 0;
    [_bgView addSubview:_cancelBtn];
    
    _confirmBtnArr = [NSMutableArray array];
    _separatorArr = [NSMutableArray array];
}


- (void)setConfirmBtnWithArray:(NSArray *)titlesArray {
    
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    [_cancelBtn setTitleColor:kRGB(255, 134, 82, 1) forState:UIControlStateNormal];
    
    [_cancelBtn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.tag = 0;
    [_bgView addSubview:_cancelBtn];
    
    
    if([NSObject isNullArray:titlesArray]){
        [self.confirmBtnArr removeAllObjects];
        return;
    }
    
    for (UIButton *btn in self.confirmBtnArr) {
        [btn removeFromSuperview];
    }
    
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = 0; i < titlesArray.count; i++) {
        UIButton *btn = nil;
        //每次都重新创建，因为如按钮前后显示的内容不同时，drawrect 会闪一下
//        if (i < self.confirmBtnArr.count) {
//            btn = self.confirmBtnArr[i];
//        }else{
            btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
//        }
        
        NSString *btnTitle = titlesArray[i];
        [btn setTitle:btnTitle forState:UIControlStateNormal];
        [btn setTitleColor:kRGB(0, 180, 255, 1) forState:UIControlStateNormal];
        [btn sizeToFit];
        btn.tag = i+1;
        
        [btn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [tempArr addObject:btn];
        [self addSubview:btn];
        
        if (btn.width > _maxBtnWidth) {
            _maxBtnWidth = btn.width + 5;
        }
    }
    
    self.confirmBtnArr = tempArr;
}

/// 重新排列
- (void)sy_layoutSubviews{
    
    CGFloat widthScale = [UIScreen mainScreen].bounds.size.width/375.0;
    widthScale > 1.0 ? widthScale = 1.0 : widthScale; //6和6plus显示的一样
    CGFloat alertViewW = ceil(295 * widthScale);
    
    self.titleLabel.top = VIEW_MARGIN;
    self.titleLabel.size = _titleStrSize;
    
    self.detailLabel.size = CGSizeMake(_detailStrSize.width, _detailStrSize.height);
    self.detailLabel.top = CGRectGetMaxY(self.titleLabel.frame) + TITLE_DETAIL_SPACE;

    CGRect aboveBtnFrame = CGRectZero;
    aboveBtnFrame = self.detailLabel.frame;
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(aboveBtnFrame) + DETAIL_BUTTON_SACE, alertViewW, 0.5)];
    separatorView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
    [self.bgView addSubview:separatorView];
    [self.separatorArr addObject:separatorView];

    // 只显示一行的情况
     CGFloat btnWholeH = BTN_HEIGHT;
    if ((self.confirmBtnArr.count == 1 || ([NSObject isNullString:self.cancelBtn.titleLabel.text]&&self.confirmBtnArr.count == 2))
        && _maxBtnWidth < alertViewW/2.0 - 10) {
        
        CGFloat btnWholeW = alertViewW;
        CGFloat btnW = btnWholeW/2.0;

        if (![NSObject isNullString:self.cancelBtn.titleLabel.text]) {
            [self.confirmBtnArr insertObject:self.cancelBtn atIndex:0];
        }
        
        CGFloat btnX = 0;
        btnW = btnWholeW/self.confirmBtnArr.count;
        
        for (int i = 0; i < self.confirmBtnArr.count; i++) {
            UIButton *btn = self.confirmBtnArr[i];
            btn.frame = CGRectMake(btnX, CGRectGetMaxY(aboveBtnFrame) + DETAIL_BUTTON_SACE, btnW, BTN_HEIGHT);
            [self.bgView addSubview:btn];
            btn.tag = i;
            if (i < self.confirmBtnArr.count - 1) {
               UIView *separatorCenterView = [[UIView alloc] init];
               separatorCenterView.frame = CGRectMake(CGRectGetMaxX(btn.frame), btn.top, 0.5, btn.height);
               separatorCenterView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
               [self.separatorArr addObject:separatorCenterView];
               [self.bgView addSubview:separatorCenterView];
            }
           
            btnX += btn.width;
        }

    // 按钮显示多行
    }else{
        
        CGFloat nextY = CGRectGetMaxY(aboveBtnFrame) + DETAIL_BUTTON_SACE;
        CGFloat  btnX = 0;
        CGFloat  btnW = alertViewW;
        for (int i = 0;i < self.confirmBtnArr.count;i++) {
            UIButton *btn = self.confirmBtnArr[i];
            btn.frame = CGRectMake(btnX, nextY, btnW, BTN_HEIGHT);
            nextY += BTN_HEIGHT;
            [self.bgView addSubview:btn];
            
            CGFloat separatorCenterViewY = btn.top;
            if ([NSObject isNullString:_cancelBtn.titleLabel.text]) {
                btn.tag = i;
            }else{
                btn.tag = i+1;
                separatorCenterViewY = btn.top + btn.height;
            }
            
            UIView *separatorCenterView = [[UIView alloc] initWithFrame:CGRectMake(separatorView.left, separatorCenterViewY, btnW +2 , 0.5)];
            separatorCenterView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
            [self.separatorArr addObject:separatorCenterView];
            [self.bgView addSubview:separatorCenterView];
        }
        
        if (_cancelBtn.titleLabel.text.length > 0) {
             self.cancelBtn.frame = CGRectMake(btnX, nextY , btnW, BTN_HEIGHT);
        }else{
            self.cancelBtn.frame = CGRectMake(btnX, nextY, btnW, 0);
        }
        btnWholeH = BTN_HEIGHT * self.confirmBtnArr.count + self.cancelBtn.height;
    }
    
    self.bgView.width = alertViewW;
    self.bgView.height = btnWholeH + self.titleLabel.height + self.detailLabel.height + VIEW_MARGIN + TITLE_DETAIL_SPACE + DETAIL_BUTTON_SACE; //10为那张图片底部的阴影渐变范围
    
    self.bgView.centerX = kScreenWidth/2.0;
    self.bgView.centerY = kScreenHeight/2.0;
    
    self.bgImageView.frame = self.bgView.bounds;
    
    self.titleLabel.centerX = self.bgView.width/2.0;
    self.detailLabel.centerX = self.bgView.width/2.0;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.bgView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    
    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:20.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.bgView.transform = CGAffineTransformMakeScale(1, 1);
        self.bgView.alpha = 1;
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}


/// 添加关键字带颜色的弹窗
/// @param title 标题的Attribute
/// @param message 内容的attribute
+ (SYAlertView *)showAlertWithTitle:(NSString *)title
                       message:(NSString *)message
             cancelButtonTitle:(NSString *)cancelTitle
             otherButtonTitles:(NSArray *)titlesArray
                    clickBlock:(void (^)(NSInteger))clickBlock {
    
    [[SYAlertView shareAletView] showAlertWithTitle:title
                                            message:message
                                  cancelButtonTitle:cancelTitle
                                  otherButtonTitles:titlesArray
                                         clickBlock:clickBlock];
    
    return [SYAlertView shareAletView];
}

+ (void)dismissAllAlertViewWithAnimate:(BOOL)animate{
    [self dismissAllAlertViewWithAnimate:animate];
}

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
         cancelButtonTitle:(NSString *)cancelTitle
         otherButtonTitles:(NSArray *)titlesArray
                clickBlock:(void (^)(NSInteger))clickBlock{
    
    [self dismissAllAlertViewWithAnimate:NO];
    
    _titleStr = title;
    // 同样的弹窗、如果当前正在显示。则不再显示了
    if (self.alpha > 0
        && self.superview
        && [title isEqualToString:self.titleLabel.text]
        && [message isEqualToString:self.detailLabel.text]) {
        _sureHandler = clickBlock;
        return;
    }
        _sureHandler = clickBlock;
        
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];

        CGFloat widthScale = [UIScreen mainScreen].bounds.size.width/375.0;
        widthScale > 1.0 ? widthScale = 1.0 : widthScale; //6和6plus显示的一样
        CGFloat alertViewW = ceil(270 * widthScale);
        if (![NSObject isNullString:title]) {
            _titleStrSize = [title boundingRectWithSize:CGSizeMake(alertViewW - VIEW_MARGIN*2.0, kScreenHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size;
            _titleStrSize.height = ceil(_titleStrSize.height) + 10;
            _titleStrSize.width = ceil(alertViewW - VIEW_MARGIN*2.0);
        }else{
            _titleStrSize = CGSizeZero;
        }
        
        if (![NSObject isNullString:message]) {
            _detailStrSize= [message boundingRectWithSize:CGSizeMake(alertViewW - VIEW_MARGIN*2.0, kScreenHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName:self.detailLabel.font} context:nil].size;
            _detailStrSize.width = ceil(alertViewW - VIEW_MARGIN*2.0);
            _detailStrSize.height = ceil(_detailStrSize.height + 20);
        }else{
            _detailStrSize = CGSizeZero;
        }
        
        self.titleLabel.text = title;
        
        self.detailLabel.text = message;
        [self.cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
        [self.cancelBtn sizeToFit];
        _maxBtnWidth = _cancelBtn.width;
    
        [self setConfirmBtnWithArray:titlesArray];
        
        [self sy_layoutSubviews];
}



/**
撤回 ALertView
*/
- (void)dismissAllAlertViewWithAnimate:(BOOL)animate {
    
    if (animate) {

        [UIView animateWithDuration:.2 animations:^{
            self.alpha = 0;
        }completion:^(BOOL finished) {
            
            [self clearAllBlock];
            
            for (UIView *view in self.separatorArr) {  //移除分割线
                [view removeFromSuperview];
            }
            for (UIView *btn in self.confirmBtnArr) {
                [btn removeFromSuperview];
            }
            [self removeFromSuperview];
            [self.cancelBtn removeFromSuperview];
        }];
        
    }else{
        self.alpha = 0;
        [self.cancelBtn removeFromSuperview];
        for (UIView *view in self.separatorArr) {
            [view removeFromSuperview];
        }
        for (UIView *btn in self.confirmBtnArr) {
            [btn removeFromSuperview];
        }
        [self removeFromSuperview];
        
        [self clearAllBlock];
    }
}

- (void)onClickBtn:(UIButton *)sender{

    [self dismissAllAlertViewWithAnimate:YES];
    
    if (sender.tag == 0 && ![NSObject isNullString:self.cancelBtn.titleLabel.text]) {
        if (_cancelHandler) {
            _cancelHandler();
            return;
        }
    }
    
    if (_sureHandler) {
        _sureHandler(sender.tag);
    }
}

- (void)clearAllBlock {
    _cancelHandler = nil;
    _sureHandler = nil;
    
    _titleLabel.text = nil;
    _titleLabel.attributedText = nil;
    _titleLabel.textColor = kRGB(10, 10, 10, 1);
    _titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    _titleLabel.textAlignment = NSTextAlignmentCenter;

    _detailLabel.text = nil;
    _detailLabel.attributedText = nil;
    _detailLabel.textColor = [UIColor blackColor];
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    _detailLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
}


/**
*  显示AlertView
*
*  @param title       富文本标题
*  @param message     富文本提示信息
*  @param cancelTitle 取消按钮的标题
*  @param titlesArray 每个按钮的标题
*/
+ (void)showAlertWithAttributeTitle:(NSAttributedString *)title
                      attributeMessage:(NSAttributedString *)message
                     cancelButtonTitle:(NSString *)cancelTitle
                     otherButtonTitles:(NSArray *)titlesArray
                           sureHandler:(void (^)(NSInteger))sureHandler
                         cancelHandler:(void (^)(void))cancelHandler{
    
    [[SYAlertView shareAletView] showAlertWithAttributeTitle:title
                                               attributeMessage:message
                                              cancelButtonTitle:cancelTitle
                                              otherButtonTitles:titlesArray
                                                    sureHandler:sureHandler
                                                  cancelHandler:cancelHandler];
}

- (void)showAlertWithAttributeTitle:(NSAttributedString *)title
                      attributeMessage:(NSAttributedString *)message
                     cancelButtonTitle:(NSString *)cancelTitle
                     otherButtonTitles:(NSArray *)titlesArray
                           sureHandler:(void (^)(NSInteger))sureHandler
                         cancelHandler:(void (^)(void))cancelHandler{
    
        [self dismissAllAlertViewWithAnimate:NO];
        _sureHandler = sureHandler;
        _cancelHandler = cancelHandler;
        
        NSMutableAttributedString *tempTitle = [title mutableCopy];
        tempTitle.yy_alignment = NSTextAlignmentCenter;
        
        NSMutableAttributedString *tempMsg = [message mutableCopy];
        tempMsg.yy_alignment = NSTextAlignmentCenter;
        
        [UIView animateWithDuration:.1 animations:^{
            self.bgView.alpha = 0;
        }];
        
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        CGFloat widthScale = [UIScreen mainScreen].bounds.size.width/375.0;
        widthScale > 1.0 ? widthScale = 1.0 :widthScale; //6和6plus显示的一样
        CGFloat alertViewW = ceil(270 * widthScale);
        
        if (![NSObject isNullString:tempTitle.string]) {
            _titleStrSize = [tempTitle.string boundingRectWithSize:CGSizeMake(alertViewW - VIEW_MARGIN*2.0, kScreenHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size;
            _titleStrSize.width = ceil(alertViewW - VIEW_MARGIN*2.0);
            _titleStrSize.height = ceil(_titleStrSize.height) + 10;
        }else{
            _titleStrSize = CGSizeZero;
        }

        if (![NSObject isNullString:tempMsg.string]) {
            _detailStrSize= [tempMsg.string boundingRectWithSize:CGSizeMake(alertViewW - VIEW_MARGIN*2.0, kScreenHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName:self.detailLabel.font} context:nil].size;
            _detailStrSize.width = ceil(alertViewW - VIEW_MARGIN*2.0);
            _detailStrSize.height = ceil(_detailStrSize.height + 20);
        }else{
            _detailStrSize = CGSizeZero;
        }
        
        self.titleLabel.attributedText = tempTitle;
        self.detailLabel.attributedText = tempMsg;
        [self.cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
        [self.cancelBtn sizeToFit];
        _maxBtnWidth = _cancelBtn.width;

        [self setConfirmBtnWithArray:titlesArray];
        
        [self sy_layoutSubviews];
}


@end
