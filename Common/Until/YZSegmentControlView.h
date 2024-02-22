//
//  YZSegmentControlView.h
//  YZSegmentControlViewTest
//
//  Created by 大春 on 2016/12/14.
//  Copyright © 2016年 yazhai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum :NSInteger{
    YZSegmentBtnTypeRight = 100008,         //靠右按钮
}YZSegmentBtnType;

@interface YZSegmentControlItemModel : NSObject

// 标题
@property (nonatomic, copy) NSString *title;

// 图片
@property (nonatomic, copy) NSString *imageName;

// 选中图片
@property (nonatomic, copy) NSString *selectedImageName;

// 图片是否右往左
@property (nonatomic, assign) BOOL leftTitleAndRightImage;

@end

@class YZSegmentControlView;

typedef NS_ENUM(NSInteger, YZSegmentControlAlignment) {
    YZSegmentControlAlignmentLeft,        //左对齐
    YZSegmentControlAlignmentRight,       //右对齐
    YZSegmentControlAlignmentCenter       //居中
};


typedef NS_ENUM(NSInteger, YZSegmentBtnVerticalAlignment) {
    YZSegmentBtnVerticalAlignmentCenter,       //居中
    YZSegmentBtnVerticalAlignmentTop,        //上对齐
    YZSegmentBtnVerticalAlignmentBottom       //下对齐
};

typedef NS_ENUM(NSInteger, YZSegmentControlSlideType) {
    YZSegmentControlSlideToRight,
    YZSegmentControlSlideToLeft
};

//titleView点击回调
@protocol YZSegmentControlViewDelegate<NSObject>

//点击选中
- (void)segmentControl:(YZSegmentControlView *)segmentView didSelectSegmentControlItemIndex:(NSInteger)index itemText:(NSString *)text;

@end

@interface YZSegmentControlView : UIView

//按钮字体，默认平方medium 16.0
@property (nonatomic, strong) UIFont *itemFont;

//按钮选中字体，默认平方medium 16.0
@property (nonatomic, strong) UIFont *itemSelectedFont;

//最长的宽度（默认为0，如果设置为0时，segmentView的长度是固定的，为初始化设置的宽度，如果大于0，宽度则适配实际的长度，靠左显示，最大不超过最长的长度）
//设置了最长的长度，原frame的width无效
@property (nonatomic, assign) CGFloat maxSegmentWidth;

//下划线，默认黑色
@property (nonatomic, strong) UIView *underLine;

//设置所有按钮居中（平分整个 segmentView 的宽度）
@property (nonatomic, assign) BOOL isEqualSpace;

//按钮间的空隙，默认9.0
@property (nonatomic, assign) CGFloat space;

//按钮间最小的空隙，默认9.0
@property (nonatomic, assign) CGFloat miniSpace;

//下划线是否动画滑动(弹簧效果)，默认关闭
@property (nonatomic, assign) BOOL isAnimatedSlide;

//点击按钮是否有动画效果，默认关闭
@property (nonatomic, assign) BOOL isAnimatedClick;

//是否平分间距居中(两个选项居中显示)，默认不是
@property (nonatomic, assign) BOOL isDivideSpace;

//是否显示下滑线，默认显示
@property (nonatomic, assign) BOOL isShowUnderLine;

//是否显示选中背景，默认不是显示
@property (nonatomic, assign) BOOL isShowSelectedBgImgView;

//是否需要将选中的item居中
@property (nonatomic, assign) BOOL alignSelectedItemToCenter;

// 选中图片的便宜
@property (nonatomic, assign) YZSegmentControlAlignment selectedImgViewAlignment;

//当前选中的按钮
@property (nonatomic, strong, readonly) UIButton *selectedButton;

//当前的所有按钮的标题
@property (nonatomic, strong, readonly) NSArray<NSString *> *currentItemTitles;

//点击协议
@property (nonatomic, weak) id<YZSegmentControlViewDelegate> segmentDelegate;

//按钮对齐方式
@property (nonatomic, assign) YZSegmentControlAlignment alignment;

//按钮对齐方式
@property (nonatomic, assign) YZSegmentBtnVerticalAlignment verticalAlignment;

//内容实际长度（scrollView 的contentSize）
@property (nonatomic, assign, readonly) CGFloat contentSizeWidth;

//点击回调（建议在有复杂操作时，使用上面的协议）
@property (nonatomic, strong) void(^selectItemBlock)(NSInteger index, NSString *itemText);

// 当前的所有标签
@property (nonatomic, strong, readonly) NSArray *itemTitles;
// 宽度改变的协议回调
@property (nonatomic, strong) void(^widthDidChangedBlock)(void);


@property (nonatomic, strong) void(^didClickRightBtnBlock)(void);


/**
 初始化segmentControl

 @param frame frame
 @param items 显示的选项
 @param segmentType 显示类型（宽度）
 @return
 */
- (instancetype)initWithFrame:(CGRect)frame withItems:(NSArray<NSString *> *)items;

//设置items
- (void)setItems:(NSMutableArray<NSString *> *)items;

/**
 设置按钮颜色

 @param color 颜色
 @param state 显示的状态
 */
- (void)setItemTitleColor:(UIColor *)color forState:(UIControlState)state;

/**
 设置靠右按钮图片

 @param image 图片
 */
- (void)setRightButtonImage:(UIImage *)image;


/**
 设置选中按钮底部的小图片

 @param image 图片
 */
- (void)setUnderLineSelectedImage:(UIImage *)image;

/**
 设置选中按钮底部的小图片的大小

 @param imageSize 图片大小
 */
- (void)setUnderLineSelectedImageSize:(CGSize)imageSize;


//设置靠右按钮选择状态
- (void)setRightButtonState:(UIControlState)state;

/**
 设置靠右按钮的文字和图片

 @param title 文字
 @param image 图片
 */
- (void)setRightButtonTitle:(NSString *)title
               withNormalImage:(UIImage *)image
               hightlightImage:(UIImage *)imageHl
                   normalColor:(UIColor *)color
               hightlightColor:(UIColor *)color2;


/**
  设置按钮的靠左图片

 @param images 按钮的普通状态的图片
 @param selectedImages 按钮的选中状态的图片
 @param titles 需要设置左图片的按钮的title
 */
- (void)setButtonLeftNormalImages:(NSArray<UIImage *> *)images selectedImages:(NSArray<UIImage *> *)selectedImages withTitles:(NSArray<NSString *> *)titles;

/**
 设置选中的选项（自动回调点击协议）

 @param index 选中的下标
 */
- (void)setSelectedItem:(NSInteger)index;

/**
 设置选中的选项,是否有回调

 @param index 选中的下标
 @param isCallBack 是否回调
 */
- (void)setSelectedItem:(NSInteger)index autoCallBack:(BOOL)isCallBack;

/// 设置按钮文案
/// @param index 按钮的index
/// @param title 标题
- (void)setImageForIndex:(NSInteger)index title:(NSString *)title;

/// 设置按钮图片
/// @param index 按钮的index
/// @param title 标题
/// @param imageName 图片名称
/// @param imageRight 图片是否放在右边
- (void)setImageForIndex:(NSInteger)index title:(NSString *)title imageName:(NSString *)imageName imageRight:(BOOL)imageRight;

/**
 末尾添加可选按钮

 @param itemTitles 可选的按钮
 */
- (void)addSegmentSelectedItems:(NSArray<NSString *> *)itemTitles;


/**
 任意下标添加可选按钮

 @param itemTitles 插入的按钮
 @param index 插入的下标
 */
- (void)insertSegmentSelectedItems:(NSArray<NSString *> *)itemTitles atIndex:(NSInteger)index;

/**
 删除指定内容的的Item

 @param itemTitles Item的标题（删除的按钮可以不是连在一起的）
 */
- (void)removeSegmentSelectedItems:(NSArray<NSString *> *)itemTitles;


/**
 替换指定内容的的Item(这个数据源替换，目前不支持某个 Item 单独替换)
 
 @param itemTitles Item的标题（删除的按钮可以不是连在一起的）
 */
- (void)removeSegmentSelectedItems:(NSArray<NSString *> *)itemTitles withReplaceItems:(NSArray<NSString *> *)replaceTitles;

/**
 取消所有按钮的选中
 */
- (void)cancelAllSelectedItem;


/**
 segment滑动到左边或者右边

 @param slideType
 */
- (void)setSegmentSlidePositionType:(YZSegmentControlSlideType)slideType;

/// 给某个tab按钮添加一个未读点
/// @param index 按钮的index
/// @param color 未读点的颜色
- (void)addUnreadPointAtIndex:(NSInteger)index withColor:(UIColor *)color;

@end
