//
//  SYAlertTipView.m
//  TPFAccountSDK
//
//  Created by 呼啦 on 2022/11/17.
//

#import "SYAlertTipView.h"
#import "SYAlertTipViewFrameModel.h"

@interface SYAlertTipView ()

@property (nonatomic, strong) UIView *boxView;

@property (nonatomic, strong) UILabel *contentLb;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, copy) void(^callback)(void);

@property (nonatomic, strong) SYAlertTipViewFrameModel *frameModel;
@end

@implementation SYAlertTipView

+ (instancetype)shareInstance{
    
    static SYAlertTipView *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[SYAlertTipView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [obj initUI];
    });
    
    return obj;
}

+ (void)showAlertWithTip:(NSString *)tip confirmTitle:(NSString *)title callback:(void (^)(void))callback{
    SYAlertTipView *tipView = [SYAlertTipView shareInstance];
    tipView.contentLb.text = tip;
    [tipView.contentLb sizeToFit];
    [tipView.confirmBtn setTitle:title forState:UIControlStateNormal];
    tipView.hidden = NO;
    tipView.callback = callback;
    [[NSObject getCurrentViewController].view addSubview:tipView];
}

- (void)initUI{
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    
    _boxView = [[UIView alloc] init];
    _boxView.backgroundColor = [UIColor whiteColor];
    _boxView.layer.cornerRadius = 8;
    _boxView.clipsToBounds = YES;
    
    _contentLb = [[UILabel alloc] init];
    _contentLb.numberOfLines = 0;
    _contentLb.font = kFont(13);
    _contentLb.textColor = [UIColor blackColor];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_confirmBtn setBackgroundColor:kDefaultColor];
    _confirmBtn.titleLabel.font = kFont(15);
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(onClickClose) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_boxView];
    [_boxView addSubview:_contentLb];
    [_boxView addSubview:_confirmBtn];
    
    SYWeakSelf(weakSelf);
    [self setDefaultModelClass:[SYAlertTipViewFrameModel class] callback:^(id  _Nonnull frameModel) {
        weakSelf.frameModel = frameModel;
        [weakSelf layoutIfNeeded];
    }];
    
    [self initMASConstraint];
}

- (void)initMASConstraint{

    SYWeakSelf(weakSelf);
    [_boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make = weakSelf.frameModel.boxViewMASConstraintBlock(make,weakSelf,nil,nil,nil,nil);
    }];
    
    [_contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make = weakSelf.frameModel.contentViewMASConstraintBlock(make,weakSelf.boxView,nil,nil,weakSelf.confirmBtn,nil);
    }];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make = weakSelf.frameModel.confirmBtnMASConstraintBlock(make,weakSelf.boxView,weakSelf.contentLb,nil,nil,nil);
    }];
    [self layoutIfNeeded];
}

- (void)onClickClose{
    
    self.hidden = YES;
    
    if(self.callback){
        self.callback();
    }
}
@end
