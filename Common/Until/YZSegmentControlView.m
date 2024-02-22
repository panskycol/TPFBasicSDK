//
//  YZSegmentControlView.m
//  YZSegmentControlViewTest
//
//  Created by 大春 on 2016/12/14.
//  Copyright © 2016年 yazhai. All rights reserved.
//

#import "YZSegmentControlView.h"

#define UNDERLINE_WIDTH_SCALE   1

static const NSInteger kBtnRedPointTag = 233333;

typedef enum :NSInteger{
    YZSegmentDefault,
    YZSegmentUnderNone,         //都不显示
    YZSegmentUnderline,         //下划线（默认显示下划线）
    YZSegmentUnderImageView,    //底部的选择图片
    YZSegmentbackgroundView     //按钮的背景图
}YZSegmentSelectedViewType;


@interface YZSegmentControlView ()

@property (nonatomic, strong) NSMutableArray<NSString *> *items;                //显示的选项按钮
@property (nonatomic, strong) NSMutableArray<UIButton *> *itemBtns;             //创建的点击按钮
@property (nonatomic, assign) CGFloat btnTotalLength;               //按键的实际长度
@property (nonatomic, assign) CGFloat btnX;                         //记录上一个按钮的x值
@property (nonatomic, assign) NSInteger insertIndex;                //插入下标
@property (nonatomic, strong) NSArray<NSString *> *insertArr;       //插入数组
@property (nonatomic, strong) UIButton *selectedBgImgBtn;      //选中背景图片(只用于显示背景)
@property (nonatomic, strong) UIImageView *selectedImgView;         //选中的图片
@property (nonatomic, strong) CAKeyframeAnimation *moveAnimation;   //移动动画
@property (nonatomic, strong) UIButton *rightBtn;                   //靠右按钮
@property (nonatomic, strong) UIButton *lastBtn;                    //最后被选中的按钮

@property (nonatomic, assign) BOOL isAddItem;                       //在末尾插入
@property (nonatomic, assign) BOOL isInsertItem;                    //根据下标插入
@property (nonatomic, assign) BOOL isRemoveItem;                    //是否有删除Item
@property (nonatomic, strong) UIScrollView *bgScrollView;           //背景滑动View

@property (nonatomic, strong) NSTimer *changeTimer;                 //修改过状态按钮

@property (nonatomic, strong) UIView *selectBgView;                 //选中的背景view

@property (nonatomic, assign) YZSegmentSelectedViewType selectedViewType;  //当前选中的下标的显示方式

@property (nonatomic, assign) BOOL isCancelAllSelcetedButton;       //当前是否为取消所有选中按钮

// button 未读的红点
@property (nonatomic, strong) NSMutableDictionary<NSNumber *,UIColor *> *unreadDotDict;

//字体颜色信息
@property (nonatomic, strong) NSMutableDictionary *colorInfo;

// 下对齐的标准线
@property (nonatomic, assign) CGFloat buttonBaseLine;

@end

@implementation YZSegmentControlView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.items = [NSMutableArray array];
        [self initProperties];
        [self initSegmentControl];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withItems:(NSArray *)items {
    self = [self initWithFrame:frame];
    if (self) {
        self.items = [items mutableCopy];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initProperties];
    }
    
    return self;
}

- (void)setItems:(NSMutableArray<NSString *> *)items {
    _items = items;
    [self initSegmentControl];
}

#pragma mark - 自定义方法
/**
 初始化属性
 */
- (void)initProperties {
    self.clipsToBounds = YES;
    self.userInteractionEnabled = YES;
    self.selectedImgViewAlignment = YZSegmentControlAlignmentCenter;
    _items = [NSMutableArray array];
    _itemBtns = [NSMutableArray array];
    _isAddItem = NO;
    _isEqualSpace = NO;
    _isRemoveItem = NO;
    _isInsertItem = NO;
    _isAnimatedSlide = NO;
    _isAnimatedClick = NO;
    _isCancelAllSelcetedButton = NO;
    _alignment = YZSegmentControlAlignmentCenter;
    _verticalAlignment = YZSegmentBtnVerticalAlignmentBottom;
    _itemFont = kFont(16); //默认字体和大小
    _itemSelectedFont = _itemFont;
    _btnTotalLength = 0.0;
    _space = 9.0;
    _miniSpace = 9.0;
    _btnX = 0.0;
    _maxSegmentWidth = 0.0;
    _selectedViewType = YZSegmentUnderline;
    _colorInfo = [NSMutableDictionary dictionary];
    
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    _bgScrollView.clipsToBounds = NO;
    if (@available(iOS 11.0, *)) {
        _bgScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } 
    [self addSubview:_bgScrollView];
    
    _colorInfo[@(UIControlStateNormal).description] = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    _colorInfo[@(UIControlStateSelected).description] = [UIColor whiteColor];
    
    //选中的下划线
    _underLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 2)];
    _underLine.backgroundColor = [UIColor blackColor];
    _underLine.hidden = NO;  //默认隐藏
//    _underLine.layer.cornerRadius = _underLine.height/2.0;
//    _underLine.clipsToBounds = YES;
    
    //选中的下标图片
    _selectedImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
//    _selectedImgView.centerX = _underLine.width/2.0;
//    _selectedImgView.centerY = _underLine.height/2.0-4;
    _selectedImgView.contentMode = UIViewContentModeScaleAspectFit;
    _selectedImgView.image = [UIImage imageNamed:@"common_icon_segment_selected"];
    _selectedImgView.hidden = YES;
    
    //选中按钮的大背景
    _selectBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, self.height)];
    _selectBgView.clipsToBounds = NO;
    _selectedBgImgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, self.height)];
    _selectedBgImgBtn.clipsToBounds = NO;
    _selectBgView.hidden = YES;
    
    [_bgScrollView addSubview:_selectBgView];     //选中按钮背后的大背景View（不同的样式，添加到上面去即可）
    [_selectBgView addSubview:_selectedBgImgBtn]; //选中的大背景上显示的自定义View（这里是个默认的View）
    [_bgScrollView addSubview:_underLine];        //选中按钮下面的横线
    [_underLine addSubview:_selectedImgView];     //在横线上添加一个imageView，用图片显示自定义样式（默认隐藏，当设置图片的时候才显示）
}

/**
 初始化控件
 */
- (void)initSegmentControl {
    
    if (_items.count == 0) return;
    for (UIView *btn in _itemBtns) {
        [btn removeFromSuperview];
    }
    [_itemBtns removeAllObjects];
    
    self.selectedImgView.hidden = YES;
    self.underLine.hidden = YES;
    
    for (int i = 0; i < self.items.count; i++) {
        
        //之前创建过的不在创建
        if (i < self.itemBtns.count && _isAddItem) {
            continue;
        }
        if (!(i >= _insertIndex && i < _insertIndex+_insertArr.count) && _isInsertItem) {
            continue;
        }

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIColor *normalColor = _colorInfo[@(UIControlStateNormal).description];
        if (!normalColor) {
            normalColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        }
        
        UIColor *selectedColor = _colorInfo[@(UIControlStateSelected).description];
        if (!selectedColor) {
            selectedColor = [UIColor whiteColor];
        }
        
        [btn setTitleColor:normalColor forState:UIControlStateNormal];
        [btn setTitleColor:selectedColor forState:UIControlStateSelected];
        btn.titleLabel.font = _itemFont;
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(clickToSelectItem:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setTitle:self.items[i] forState:UIControlStateNormal];
        [self setBtnSizeToFit:btn];
        
        //计算所有按钮的长度
        _btnTotalLength += btn.frame.size.width;
        
        if (_isInsertItem) {
            [self.itemBtns insertObject:btn atIndex:i];
        }else{
            if (self.itemBtns.count == 0) {
                _lastBtn = btn;
            }
            [_itemBtns addObject:btn];
        }
        
        [_bgScrollView addSubview:btn];
        
        //第一次创建的时候默认选中第一个
        if (i == 0 && !_isAddItem && !_isInsertItem && !_isRemoveItem) {
            _lastBtn = btn;
            _lastBtn.selected = YES;
            _lastBtn.titleLabel.font = _itemSelectedFont;
        }
    }

    [self resetContentSize];
    [self layoutContentViews];
}

/**
 点击选中按钮
 
 @param sender 按钮
 */
- (void)clickToSelectItem:(UIButton *)sender{
    
    [self setSelectedItem:sender.tag autoCallBack:YES];
}

/**
 代码设置选中哪一个按钮
 
 @param index 选中的下标
 */
- (void)setSelectedItem:(NSInteger)index{
    
//    [self clickToSelectItem:(UIButton *)_itemBtns[index]];
    [self setSelectedItem:index autoCallBack:YES];
    
//    _lastBtn.selected = NO;
//    UIButton *sender = (UIButton *)_itemBtns[index];
//    _lastBtn = sender;
}

- (void)setRightButtonState:(UIControlState)state{
    
//    self.rightBtn.state = state;
    if (state == UIControlStateSelected) {
        self.rightBtn.selected = YES;
    }else{
        self.rightBtn.selected = NO;
    }
}

/**
 改变选中的按钮

 @param isCallBack 是否回调
 */
- (void)setSelectedItem:(NSInteger)index autoCallBack:(BOOL)isCallBack{
    
    if (_rightBtn && index == _rightBtn.tag) {
        if (_didClickRightBtnBlock) {
            _didClickRightBtnBlock();
        } else if (_selectItemBlock&&isCallBack) {
            _selectItemBlock(_rightBtn.tag, _rightBtn.titleLabel.text);
        }
        return;
    }
    
    if (index >= _itemBtns.count || _itemBtns.count == 0) {
        return;
    }
   
    //选中背景随按钮大小改变
    UIButton *sender = (UIButton *)_itemBtns[index];
    
    [[sender viewWithTag:kBtnRedPointTag] removeFromSuperview];
    [_unreadDotDict removeObjectForKey:@(index)];
    
    _selectBgView.width = sender.width + _space;
    _selectedBgImgBtn.width = _selectBgView.width;
    _underLine.width = sender.width/UNDERLINE_WIDTH_SCALE;

    if (_isDivideSpace) {
        _underLine.width = self.width;
    }
    
    if(_lastBtn.tag != sender.tag){
        _lastBtn.selected = NO;
        _lastBtn.titleLabel.font = _itemFont;
    }
    
    if (_selectedViewType != YZSegmentDefault && _selectedViewType == YZSegmentbackgroundView) {
        _selectBgView.hidden = NO;
    }else if (_selectedViewType != YZSegmentDefault){
        _underLine.hidden = NO;
    }
    
    if (_selectedViewType == YZSegmentUnderNone) {
        _underLine.hidden = YES;
        _selectBgView.hidden = YES;
    }
    
    //当前为设置选中按钮
    _isCancelAllSelcetedButton = NO;
    
    if (![sender isEqual:_rightBtn]) { //如果不是固定在右边显示的按钮，则执行选中背景移动
        if (_itemBtns.count>0) {
            if (_isAnimatedSlide) {//弹簧效果
                _lastBtn.selected = NO;
                _lastBtn.titleLabel.font = _itemFont;
                _lastBtn = sender;
                if (_isCancelAllSelcetedButton) {
                    _lastBtn.selected = NO;
                }else{
                    _lastBtn.selected = YES;
                }
                _lastBtn.titleLabel.font = _itemSelectedFont;
                [self setBtnSizeToFit:_lastBtn];
                [self resetContentSize];
                [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    if(self.lastBtn.tag == sender.tag)return ;
                    self.selectBgView.centerX = [self.itemBtns[sender.tag] centerX];
                    [self setUnderLineCenterXWithBtn:self.itemBtns[sender.tag]];
                    [self setSetupBtnVerticalAlignment:self.lastBtn];
                    [self resetContentOffSet];
                    self.selectedImgView.centerX = self.underLine.width/UNDERLINE_WIDTH_SCALE;
                    self.selectedImgView.centerY = self.underLine.height/2.0-4;
                    
                } completion:^(BOOL finished) {
                    
                    self.selectBgView.centerX = [self.itemBtns[self.lastBtn.tag] centerX];
                    [self setUnderLineCenterXWithBtn:self.itemBtns[self.lastBtn.tag]];
                    self.selectedImgView.centerX = self.underLine.width/2.0;
                    self.selectedImgView.centerY = self.underLine.height/2.0-4;
                    
                    [self addAnimationShakeToView:self.lastBtn];
                }];
                
            }else{
                
                _lastBtn.selected = NO;
                _lastBtn.titleLabel.font = _itemFont;
                _lastBtn = sender;
                if (_isCancelAllSelcetedButton) {
                    _lastBtn.selected = NO;
                }else{
                    _lastBtn.selected = YES;
                }
                _lastBtn.titleLabel.font = _itemSelectedFont;
                [self setBtnSizeToFit:_lastBtn];
                [self resetContentSize];
                [UIView animateWithDuration:0.2 animations:^{
                    
                   if(self.lastBtn.tag == sender.tag)return;
                   self.selectBgView.centerX = [self.itemBtns[sender.tag] centerX];
                   [self setUnderLineCenterXWithBtn:self.itemBtns[sender.tag]];
                   
                   self.selectedImgView.centerX = self.underLine.width/2.0;
                   self.selectedImgView.centerY = self.underLine.height/2.0-4;
                    [self setSetupBtnVerticalAlignment:self.lastBtn];
                    [self resetContentOffSet];
                } completion:^(BOOL finished) {
                    
                    if (!self.itemBtns.count) {
                        return;
                    }
                    self.selectBgView.centerX = [self.itemBtns[self.lastBtn.tag] centerX];
                    [self setUnderLineCenterXWithBtn:self.itemBtns[self.lastBtn.tag]];
                    self.selectedImgView.centerX = self.underLine.width/2.0;
                    self.selectedImgView.centerY = self.underLine.height/2.0-4;
                    if (self.isCancelAllSelcetedButton) {
                        self.lastBtn.selected = NO;
                    }else{
                        self.lastBtn.selected = YES;
                    }
                    self.lastBtn.titleLabel.font = self.itemSelectedFont;
                    [self setBtnSizeToFit:self.lastBtn];
                    [self setSetupBtnVerticalAlignment:self.lastBtn];
                    [self resetContentSize];
                    [self resetContentOffSet];
                    [self addAnimationShakeToView:self.lastBtn];
                }];
            }
        }
    }
    
    if (self.itemFont.pointSize != self.itemSelectedFont.pointSize) {
        [self layoutContentViews];
    }
    
    if (_selectItemBlock&&isCallBack) {
        _selectItemBlock(sender.tag, sender.titleLabel.text);
    }
    
    if (isCallBack&&_segmentDelegate && [_segmentDelegate respondsToSelector:@selector(segmentControl:didSelectSegmentControlItemIndex:itemText:)]) {
        [_segmentDelegate segmentControl:self didSelectSegmentControlItemIndex:sender.tag itemText:sender.titleLabel.text];
    }
    
    if (_selectItemBlock&&isCallBack) {
        _selectItemBlock(sender.tag, sender.titleLabel.text);
    }
}


- (void)setSetupBtnVerticalAlignment:(UIButton *)btn {
    switch (_verticalAlignment) {
        case YZSegmentBtnVerticalAlignmentCenter:
            btn.centerY = self.height / 2.0f;
            break;
        case YZSegmentBtnVerticalAlignmentTop:
            btn.y = self.buttonBaseLine;
            break;
        case YZSegmentBtnVerticalAlignmentBottom:
            if (btn == _lastBtn) {
                btn.y = self.buttonBaseLine - btn.height + (self.itemSelectedFont.pointSize - self.itemFont.pointSize) / 2.0f;
            } else {
                btn.y = self.buttonBaseLine - btn.height;
            }
            break;
    }
}

//设置按钮的字体颜色
- (void)setItemTitleColor:(UIColor *)color forState:(UIControlState)state{
    
    _colorInfo[@(state).stringValue] = color;
    
    for (UIButton *btn in _itemBtns) {
        [btn setTitleColor:color forState:state];
        
        if (state == UIControlStateSelected) {
            [btn setTitleColor:color forState:UIControlStateHighlighted];
        }
    }
//    _underLine.backgroundColor = color;
}

//设置靠右按钮
- (void)setRightButtonImage:(UIImage *)image{
    if(!image)return;
    [self addSubview:self.rightBtn];
    [_rightBtn setTitle:nil forState:UIControlStateNormal];
    [_rightBtn setImage:image forState:UIControlStateNormal];
    [_rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [_rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    _rightBtn.tag = YZSegmentBtnTypeRight;
}

//设置靠右按钮的文字
- (void)setRightButtonTitle:(NSString *)title{
    if([NSString isNullString:title])return;
    [self addSubview:self.rightBtn];
    [_rightBtn setImage:nil forState:UIControlStateNormal];
    [_rightBtn setTitle:title forState:UIControlStateNormal];
    [_rightBtn sizeToFit];
    _rightBtn.frame = CGRectMake(self.width - _rightBtn.width-10 , 0, _rightBtn.width + 10, self.height);
    [_rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [_rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

//设置靠右按钮的文字和图片
- (void)setRightButtonTitle:(NSString *)title withNormalImage:(UIImage *)image hightlightImage:(UIImage *)imageHl normalColor:(UIColor *)color hightlightColor:(UIColor *)color2 {
    if([NSString isNullString:title] && !image){
        [self.rightBtn removeFromSuperview];
        return;
    }
    [self addSubview:self.rightBtn];
    [_rightBtn setTitle:title forState:UIControlStateNormal];
    [_rightBtn sizeToFit];
    _rightBtn.frame = CGRectMake(self.width - _rightBtn.width-10 , 0, _rightBtn.width + 10, self.height);
    [_rightBtn setImage:image forState:UIControlStateNormal];
    [_rightBtn setImage:imageHl forState:UIControlStateHighlighted];
    [_rightBtn setTitleColor:color forState:UIControlStateNormal];
    [_rightBtn setTitleColor:color2 forState:UIControlStateHighlighted];
    
    [_rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_rightBtn.imageView.width-2, 0, _rightBtn.imageView.width+2)];
    [_rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _rightBtn.titleLabel.width, 0, -_rightBtn.titleLabel.width)];
}

/**
 点击的动画
 
 @param target 目标View
 */
- (void)addAnimationShakeToView:(UIView *)target
{
    if (![target isKindOfClass:[UIView class]]) {
        return;
    }

    if (!_isAnimatedClick) return;
    CAKeyframeAnimation *shakeAni = [CAKeyframeAnimation animation];
    shakeAni.keyPath = @"transform.scale";
    shakeAni.values = @[@(1.05), @(1.1),@(0.90), @(1.175), @(0.925), @(1.05), @(0.95), @(1.025), @(0.975), @(1.01), @(0.99), @(1)];
    shakeAni.duration = 1;
    shakeAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    shakeAni.repeatCount = 1;
    [target.layer addAnimation:shakeAni forKey:nil];
}

/**
 选中背景图超出当前视图范围
 */
- (void)resetContentSize {
    self.bgScrollView.contentSize = CGSizeMake([self contentWidth], self.height);
}

- (CGFloat)contentWidth {
    _btnTotalLength = 0;
    for (UIButton *btn in self.itemBtns) {
        _btnTotalLength += btn.width;
    }
       
    //所有按钮和间距的长度
    CGFloat wholeWidth = _btnTotalLength+_space*self.itemBtns.count;
    return wholeWidth;
}

/**
 选中背景图超出当前视图范围
 */
- (void)resetContentOffSet{
    if (!self.alignSelectedItemToCenter) {
        if(CGRectGetMaxX(_selectBgView.frame) > self.bgScrollView.contentOffset.x +self.width) { //超出右边
            CGFloat off_x = CGRectGetMaxX(_selectBgView.frame) - (self.bgScrollView.contentOffset.x +self.width);
            [UIView animateWithDuration:.1 animations:^{
                self.bgScrollView.contentOffset = CGPointMake(self.bgScrollView.contentOffset.x+off_x, 0);
            }];
            
        }else if(_selectBgView.x < self.bgScrollView.contentOffset.x){ //超出左边
            CGFloat off_x = self.bgScrollView.contentOffset.x - _selectBgView.x;
            [UIView animateWithDuration:.1 animations:^{
                self.bgScrollView.contentOffset = CGPointMake(self.bgScrollView.contentOffset.x-off_x, 0);
            }];
        }
    } else {
     
        CGFloat moveContentOffset = _selectBgView.centerX - self.bgScrollView.width / 2;
        if (moveContentOffset < 0) {
            moveContentOffset = 0;
        } else if (moveContentOffset > self.contentWidth - self.bgScrollView.width) {
            moveContentOffset = self.contentWidth - self.bgScrollView.width;
        }
        
        if (moveContentOffset < 0) {
            moveContentOffset = 0;
        }
        [UIView animateWithDuration:.1 animations:^{
            self.bgScrollView.contentOffset = CGPointMake(moveContentOffset, 0);
        }];
    }
}

- (void)cancelAllSelectedItem{
    
    _isCancelAllSelcetedButton = YES;
    _selectBgView.hidden = YES;
    _underLine.hidden = YES;
    _underLine.hidden = YES;
    
    _lastBtn.selected = NO;
}

/**
 设置按钮的靠左图片
 
 @param images 按钮的普通状态的图片
 @param selectedImages 按钮的选中状态的图片
 @param titles 需要设置左图片的按钮的title
 */
- (void)setButtonLeftNormalImages:(NSArray<UIImage *> *)images selectedImages:(NSArray<UIImage *> *)selectedImages withTitles:(NSArray<NSString *> *)titles{
    
    if (images.count != titles.count || images.count != selectedImages.count) {
        NSLog(@"====>设置的图片数量和标题数量不一样");
        return;
    }
    
    NSInteger count = 0;
    for (NSString *title in titles) {
        if ([_items containsObject:title]) {
            NSInteger index = [_items indexOfObject:title];
            UIButton *btn = [_itemBtns objectAtIndex:index];
            _btnTotalLength -= btn.width;
            UIImage *image = images[count];
            UIImage *selcetImage = selectedImages[count];
            [btn setImage:image forState:UIControlStateNormal];
            [btn setImage:selcetImage forState:UIControlStateSelected];
            [self setBtnSizeToFit:btn];
            _btnTotalLength += btn.width;
        }
        count++;
    }
    
    [self layoutContentViews];
}

/// 设置按钮文案
/// @param index 按钮的index
/// @param title 标题
- (void)setImageForIndex:(NSInteger)index title:(NSString *)title {
    [self setImageForIndex:index title:title imageName:nil imageRight:NO];
}

/// 设置按钮图片
/// @param index 按钮的index
/// @param title 标题
/// @param imageName 图片名称
/// @param imageRight 图片是否放在右边
- (void)setImageForIndex:(NSInteger)index title:(NSString *)title imageName:(NSString *)imageName imageRight:(BOOL)imageRight {
    if (index < 0 && index >= _items.count) {
        return;
    }
    
    UIButton *btn = [_itemBtns objectAtIndex:index];
    _btnTotalLength -= btn.width;
    
    if (![NSString isNullString:imageName]) {
        UIImage *image = [UIImage imageNamed:imageName];
        [btn setImage:image forState:UIControlStateNormal];
        if (image) {
            if (imageRight) {
                if ([UIView appearance].semanticContentAttribute == UISemanticContentAttributeForceRightToLeft) {
                    btn.semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
                } else {
                    btn.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
                }
            }
        }
    }
    
    [_items replaceObjectAtIndex:index withObject:title];
    [btn setTitle:title forState:UIControlStateNormal];
    
    [self setBtnSizeToFit:btn];
    _btnTotalLength += btn.width;
    btn.centerY = self.height / 2.0f;
    
    [self layoutContentViews];
}


/// 解决如果设置了图片，sizetofit 按钮的大小会变小的问题
- (void)setBtnSizeToFit:(UIButton *)btn {
    
    if (btn.imageView.image) {
        UIImage *image = btn.imageView.image;
        [btn setImage:nil forState:UIControlStateNormal];
        [btn sizeToFit];
        CGSize size = btn.size;
        [btn setImage:image forState:UIControlStateNormal];
        [btn sizeToFit];
        btn.width = MAX(size.width, btn.width) + 8;
        btn.height = MAX(size.height, btn.height);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4);
    } else {
        [btn sizeToFit];
    }
}


/**
 segment滑动到左边或者右边
 */
- (void)setSegmentSlidePositionType:(YZSegmentControlSlideType)slideType{
    
    if (slideType == YZSegmentControlSlideToRight) {
        CGFloat maxContentOffX = _bgScrollView.contentSize.width - _bgScrollView.width;
        if (maxContentOffX > 0) {
            [_bgScrollView setContentOffset:CGPointMake(maxContentOffX, 0) animated:YES];
        }
    }else if(slideType == YZSegmentControlSlideToLeft){
        [_bgScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

/// 给某个tab按钮添加一个未读点
/// @param index 按钮的index
/// @param color 未读点的颜色
- (void)addUnreadPointAtIndex:(NSInteger)index withColor:(UIColor *)color {
    
    if (!self.unreadDotDict) {
        self.unreadDotDict = [NSMutableDictionary dictionary];
    }
    [self.unreadDotDict setObject:color forKey:@(index)];
    [self layoutContentViews];
}

#pragma mark - 布局
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self layoutContentViews];
}

- (void)layoutContentViews {
    
    self.selectBgView.hidden = !self.isShowSelectedBgImgView;
    
    //如果设置了最长度，靠左显示
    if (_maxSegmentWidth > 0.0 && _maxSegmentWidth < self.width) {  //如果最长宽度比原来frame宽度要小，则以设定的最长宽度为准
        _alignment = YZSegmentControlAlignmentLeft;
        self.width = _maxSegmentWidth;
        if (self.widthDidChangedBlock) {
            self.widthDidChangedBlock();
        }
    }
    
    _bgScrollView.width = self.width;
    _bgScrollView.height = self.height;
    
    //所有按钮和间距的长度
    CGFloat wholeWidth = _btnTotalLength+_space*self.itemBtns.count;
    
    //当Item被删完时
    if (_itemBtns.count == 0) {
        _bgScrollView.hidden = YES;
        return;
    }else{
        _bgScrollView.hidden = NO;
    }
    
    _space = _miniSpace > _space?_miniSpace:_space;
    
    if (_isEqualSpace) { //自动居中
        _bgScrollView.scrollEnabled = NO;
//        _space = (self.width - _btnTotalLength)/self.itemBtns.count-(3.0/(self.itemBtns.count-1));  //有问题，观察一段时间可删除
//        _btnX = _space/2 + 3;
        _space = (self.width - _btnTotalLength)/self.itemBtns.count;
        if (_space < 0) {
            _bgScrollView.scrollEnabled = YES;
        }else{
            _bgScrollView.scrollEnabled = NO;
        }
        
        _space = _miniSpace > _space?_miniSpace:_space;
        _btnX = _space/2;
    }else{ //根据设置的space来布局
        if (wholeWidth < self.width) {//是否有超出屏幕宽度
            _btnX = self.frame.size.width/2.0 - _btnTotalLength/2.0 - (_items.count-1)*_space/2.0;
            _bgScrollView.scrollEnabled = NO;
        }else {
            _space = _miniSpace > _space?_miniSpace:_space;
            if (self.alignment == YZSegmentControlAlignmentCenter) {
                _btnX = _space/2.0;
            } else {
                _btnX = 0;
            }
            _bgScrollView.scrollEnabled = YES;
        }
    }
    
    //如果设置了最长度，靠左显示
    if (_maxSegmentWidth > 0.0 && !_isEqualSpace) {
        _alignment = YZSegmentControlAlignmentLeft;
    }
    
    //对齐方式
    if (_alignment == YZSegmentControlAlignmentLeft) {
        if (self.alignment == YZSegmentControlAlignmentCenter) {
            _btnX = _space/2.0;
        } else {
            _btnX = 0;
        }
    }else if(_alignment == YZSegmentControlAlignmentRight){
        _btnX = self.width - _btnTotalLength - self.itemBtns.count*_space;
    }
    
    //设置选中按钮
    switch (self.selectedImgViewAlignment) {
        case YZSegmentControlAlignmentCenter: {
            _underLine.centerX = self.lastBtn.centerX;
            break;
        }
            
        case YZSegmentControlAlignmentLeft: {
            _underLine.centerX = self.lastBtn.left;
            break;
        }
            
        case YZSegmentControlAlignmentRight: {
            _underLine.centerX = self.lastBtn.right;
            break;
        }
    }
    _selectBgView.x = _btnX - _space/2.0;
    if (_itemBtns.count > 0) {
        _selectBgView.width = [(UIButton *)_itemBtns[0] width]+_space;
        _selectedBgImgBtn.width = _selectBgView.width;
        _selectedBgImgBtn.height = (NSInteger)_selectBgView.height*0.9;
        _selectedBgImgBtn.centerY = _selectBgView.height*0.5;
        _selectedBgImgBtn.backgroundColor = [UIColor whiteColor];
        _selectedBgImgBtn.layer.cornerRadius = _selectedBgImgBtn.height/2.0;
        _selectedBgImgBtn.clipsToBounds = YES;
        
        if (self.lastBtn.tag < _itemBtns.count) {
            _underLine.width = ([(UIButton *)_itemBtns[self.lastBtn.tag] width])/UNDERLINE_WIDTH_SCALE;
        }else{
            NSLog(@"segmentView occur error");
        }

        //平分
        if (_isDivideSpace) {
            _btnX = 0;
            _space = 0;
            _underLine.width = self.width;
        }
    }else{
        _underLine.hidden = YES;
        _selectBgView.hidden = YES;
    }
    
    for (int i = 0; i < _itemBtns.count; i++) {
        UIButton *btn = _itemBtns[i];
        [self setBtnSizeToFit:btn];
        
        btn.tag = i;
        if (_isAddItem || _isInsertItem) {
            [UIView animateWithDuration:.1 animations:^{
                btn.centerY = self.height/2.0;
                btn.left = self.btnX;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.1 animations:^{
                    btn.alpha = 1.0;
                }];
            }];
        }else{
            btn.centerY = self.height/2.0;
            btn.left = _btnX;
        }
        _btnX += btn.width + _space;
        
        if (_unreadDotDict[@(i)]) {
            UIView *redPointView = [btn viewWithTag:kBtnRedPointTag];
            if (!redPointView) {
                redPointView = [[UIView alloc] init];
                redPointView.tag = kBtnRedPointTag;
                [btn addSubview:redPointView];
            }

            CGFloat len = 4;
            redPointView.frame = CGRectMake(btn.width - len, 0, len, len);
            redPointView.backgroundColor = _unreadDotDict[@(i)];
            redPointView.layer.cornerRadius = len / 2;
            redPointView.layer.masksToBounds = YES;
        } else {
            UIView *redPointView = [btn viewWithTag:kBtnRedPointTag];
            [redPointView removeFromSuperview];
        }
    }

    //选中的背景，下划线
    _selectBgView.centerX = _lastBtn.centerX;
    switch (self.selectedImgViewAlignment) {
        case YZSegmentControlAlignmentCenter: {
            _underLine.centerX = self.lastBtn.centerX;
            break;
        }
            
        case YZSegmentControlAlignmentLeft: {
            _underLine.centerX = self.lastBtn.left;
            break;
        }
            
        case YZSegmentControlAlignmentRight: {
            _underLine.centerX = self.lastBtn.right;
            break;
        }
    }
    _selectedImgView.centerX = _underLine.width/2.0;
    _selectedImgView.centerY = _underLine.height/2.0-4;
    
    _bgScrollView.contentSize = CGSizeMake(wholeWidth, self.height);
    
    _lastBtn.titleLabel.font = _itemSelectedFont;
    _underLine.y = self.lastBtn.bottom - 4;
    [self setBtnSizeToFit:_lastBtn];
    [self setSetupBtnVerticalAlignment:_lastBtn];
    [self resetContentSize];
    
//    _underLine.layer.cornerRadius = _underLine.height/2.0;
//    _underLine.layer.masksToBounds = YES;
    //解决设置圆角显示不圆的问题
    if (!_underLine.hidden && !_selectedImgView.image) {
        UIRectCorner rectCorner = UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight ;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_underLine.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(_underLine.height/2.0, _underLine.height/2.0)];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = self.bounds;
        shapeLayer.path = path.CGPath;
        _underLine.layer.mask = shapeLayer;
    }
    
    //实际长度小于最长长度，self的宽度自适应
    if (wholeWidth < _maxSegmentWidth && !_isEqualSpace) {
        self.width = wholeWidth;
        if (self.widthDidChangedBlock) {
            self.widthDidChangedBlock();
        }
        _bgScrollView.width = wholeWidth;
    }else if(_maxSegmentWidth > 0.0){
        self.width = _maxSegmentWidth;
        if (self.widthDidChangedBlock) {
            self.widthDidChangedBlock();
        }
    }
}

- (void)setUnderLineCenterXWithBtn:(UIButton *)btn {
    switch (self.selectedImgViewAlignment) {
        case YZSegmentControlAlignmentCenter: {
            _underLine.centerX = btn.centerX;
            break;
        }
            
        case YZSegmentControlAlignmentLeft: {

            _underLine.centerX = btn.left;
            
            break;
        }
            
        case YZSegmentControlAlignmentRight: {
            _underLine.centerX = btn.right;
            break;
        }
    }
}

#pragma mark - 添加按钮
/**
 直接在尾部添加按钮

 @param itemTitles 按钮title数组
 */
- (void)addSegmentSelectedItems:(NSArray *)itemTitles{
    
    _isAddItem = YES;
    _isInsertItem = NO;
    
    BOOL isAddAll = NO; //是否是添加全部按钮
    if ([NSArray isNullString:_items]) {
        isAddAll = YES;
    }
    
    for (NSString *title in itemTitles) {
        if (![_items containsObject:title]) {
            [self.items addObject:title];
        }else{
            NSLog(@"=====>>>segmentView不能插入相同的Item<<<===== : %@", title);
        }
    }
    
    [self initSegmentControl];
    
    if (isAddAll) {
        [self setSelectedItem:0];
    }
}


/**
 在指定位置添加按钮

 @param itemTitles 按钮文字数组
 @param index 插入下标
 */
- (void)insertSegmentSelectedItems:(NSArray *)itemTitles atIndex:(NSInteger)index{
    
    if (index >= _itemBtns.count) {
        NSLog(@"=====>>>segmentView插入Item越界<<<=====");
        return;
    }
    
    NSMutableArray *addTitles = [itemTitles mutableCopy];
    for (NSString *title in itemTitles) {
        if ([_items containsObject:title]) {
            NSLog(@"=====>>>segmentView不能插入相同的Item<<<===== : %@", title);
            [addTitles removeObject:title];
        }
    }
    
    _isAddItem = NO;
    _isInsertItem = YES;
    _insertArr = itemTitles;
    _insertIndex = index;
    [self.items insertObjects:addTitles atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, addTitles.count)]];
    [self initSegmentControl];
}

/**
 删除指定内容的的Item
 
 @param itemTitles Item的标题（删除的内容不用是连在一起的）
 */
- (void)removeSegmentSelectedItems:(NSArray *)itemTitles{
    
    if ([NSArray isNullArray:itemTitles]) {
        return;
    }
    
    NSInteger removeCount = 0;
    NSInteger finalRemoveIndex = 0;
    
//    NSArray *originalTitles = [_items copy];
    for (NSString *removeTitle in itemTitles) {
        if (![_items containsObject:removeTitle]) {
            NSLog(@"====>>>要删除的Item不在segmentView的Item中，请检查<<<=====");
            return;
        }
        NSInteger index = [_items indexOfObject:removeTitle];
        if (index >= 1) {
            [self setSelectedItem:index-1 autoCallBack:NO];
        }
        UIButton *removeBtn = [_itemBtns objectAtIndex:index];

        [_itemBtns removeObjectAtIndex:index];
        [_items removeObjectAtIndex:index];
        [removeBtn removeFromSuperview];

        removeCount++;
        finalRemoveIndex = index;
        _btnTotalLength -= removeBtn.width;     //改变按钮总长度

        [self layoutContentViews];
        
//        for (NSString *originalTitle in originalTitles) {
//            if ([removeTitle isEqualToString:originalTitle]) {
//                NSInteger index = [_items indexOfObject:removeTitle];
//                if (index >= 1) {
//                    [self setSelectedItem:index-1 autoCallBack:NO];
//                }
//                UIButton *removeBtn = [_itemBtns objectAtIndex:index];
//
//                [_itemBtns removeObjectAtIndex:index];
//                [_items removeObjectAtIndex:index];
//                [removeBtn removeFromSuperview];
//
//                removeCount++;
//                finalRemoveIndex = index;
//                _btnTotalLength -= removeBtn.width;     //改变按钮总长度
//
//                [self layoutContentViews];
//            }
//        }
    }
    
    if (removeCount == 0) {
        NSLog(@"====>>>要删除的Item不在segmentView的Item中，请检查<<<=====");
        return;
    }
    
    if (finalRemoveIndex >= 1) {
        [self setSelectedItem:finalRemoveIndex-1 autoCallBack:YES];
    }else{
        [self setSelectedItem:0 autoCallBack:YES];
    }
}


/**
 替换指定内容的的Item(这个数据源替换，目前不支持某个 Item 单独替换)
 
 @param itemTitles Item的标题（删除的按钮可以不是连在一起的）
 */
- (void)removeSegmentSelectedItems:(NSArray<NSString *> *)itemTitles withReplaceItems:(NSArray<NSString *> *)replaceTitles{
    
    BOOL needUpdate = NO;
    
    //个数不一样，直接更新
    if (itemTitles.count != replaceTitles.count) {
        needUpdate = YES;
    }
    
    //判断 新Item 和 原Item 顺序和内容是否是一样的
    if (!needUpdate) {
        for (int i = 0; i < itemTitles.count; i++) {
            NSString *oldStr = itemTitles[i];
            NSString *newStr = replaceTitles[i];
            if (![oldStr isEqualToString:newStr]) {
                needUpdate = YES;
                break;
            }
        }
    }

    if (needUpdate) {
        [self removeSegmentSelectedItems:itemTitles];
        [self addSegmentSelectedItems:replaceTitles];
    }
    
}

- (void)setUnderLineSelectedImage:(UIImage *)image{
    _selectBgView.hidden = YES;
    _underLine.backgroundColor = [UIColor clearColor];
    _underLine.clipsToBounds = NO;
    _selectedImgView.image = image;
    _selectedImgView.hidden = NO;
    
    _selectedViewType = YZSegmentUnderImageView;
    _underLine.hidden = NO;
}

/**
 设置选中按钮底部的小图片的大小

 @param imageSize 图片大小
 */
- (void)setUnderLineSelectedImageSize:(CGSize)imageSize {
    self.selectedImgView.size = imageSize;
    self.underLine.height = imageSize.height + 4;
    self.underLine.y = self.lastBtn.bottom - 4;
}

#pragma mark - getter

- (CGFloat)buttonBaseLine {
    
    if (self.itemBtns.count == 1) {
        return self.height;
    }
    
    for (UIButton *btn in self.itemBtns) {
        if (btn != _lastBtn) {
            switch (_verticalAlignment) {
                case YZSegmentBtnVerticalAlignmentBottom:
                    return btn.bottom;
                    break;
                case YZSegmentBtnVerticalAlignmentTop:
                    return btn.top;
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    return _lastBtn.bottom;
}

- (UIButton *)rightBtn{
    
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _rightBtn.frame = CGRectMake(self.width - self.height-10 , 0, self.height + 10, self.height);
        _rightBtn.tag = YZSegmentBtnTypeRight;
        [_rightBtn addTarget:self action:@selector(clickToSelectItem:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _rightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rightBtn;
}

- (UIButton *)selectedButton{
    
    return _lastBtn;
}

- (NSArray *)currentItems{
    
    return [_itemBtns copy];
}

- (NSArray *)currentItemTitles
{
    return [_items copy];
}


- (CGFloat)contentSizeWidth{
    
    return _bgScrollView.contentSize.width;
}

#pragma mark - setter
- (void)setItemFont:(UIFont *)itemFont{
    _itemFont = itemFont;
    _itemSelectedFont = _itemFont;
    
    _btnTotalLength = 0;
    for (UIButton *btn in self.itemBtns) {
        btn.titleLabel.font = itemFont;
        
        [self setBtnSizeToFit:btn];
        //计算所有按钮的长度
        _btnTotalLength += btn.frame.size.width;
    }
    [self layoutSubviews];
}

- (void)setSpace:(CGFloat)space{
    _space = space;
    [self layoutSubviews];
}

- (void)setMiniSpace:(CGFloat)miniSpace{
    
    _miniSpace = miniSpace;
    [self layoutSubviews];
}


/**
 只有两个选项

 @param isDivideSpace 选中横线是否占一半
 */
- (void)setIsDivideSpace:(BOOL)isDivideSpace{
    _isDivideSpace = isDivideSpace;
    
    if (_isDivideSpace) {
        for (int i = 0; i < self.itemBtns.count; i++) {
            UIButton *btn = self.itemBtns[i];
            btn.width = self.width/2;
            btn.x = i*btn.width;
        }
        if (_itemBtns.count == 0) {
            _bgScrollView.hidden = YES;
            return;
        }else{
            _bgScrollView.hidden = NO;
        }
        _underLine.width = self.width/self.itemBtns.count;
        _underLine.x = 0;
    }
}

- (void)setIsShowUnderLine:(BOOL)isShowUnderLine{
    _isShowUnderLine = isShowUnderLine;
    
    _underLine.hidden = !isShowUnderLine;
    _selectBgView.hidden = isShowUnderLine;
    
    if (isShowUnderLine) {
        _selectedViewType = YZSegmentUnderline;
    }
}

- (void)setIsShowSelectedBgImgView:(BOOL)isShowSelectedBgImgView{
    _isShowSelectedBgImgView = isShowSelectedBgImgView;
    
    _selectBgView.hidden = !isShowSelectedBgImgView;
    _selectedBgImgBtn.hidden = !isShowSelectedBgImgView;
    _underLine.hidden = isShowSelectedBgImgView;
    
    if (isShowSelectedBgImgView) {
        _selectedViewType = YZSegmentbackgroundView;
    }
}

- (void)setMaxSegmentWidth:(CGFloat)maxSegmentWidth{
    _maxSegmentWidth = maxSegmentWidth;
    
    [self layoutContentViews];
}


- (void)setAlignment:(YZSegmentControlAlignment)alignment{
    
    _alignment = alignment;
    
    //如果手动设置了alignment，那么控件就不会自动的平分所有间距，间距以用户手动设置的为准
    _isEqualSpace = NO;
}

- (void)setSelectedImgViewAlignment:(YZSegmentControlAlignment)selectedImgViewAlignment {
    _selectedImgViewAlignment = selectedImgViewAlignment;
    
    [self layoutContentViews];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
}

@end
