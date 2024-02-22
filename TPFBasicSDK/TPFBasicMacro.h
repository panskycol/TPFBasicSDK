//
//  TPFBasicMacro.h
//  TPFBasicSDK
//
//  Created by 呼啦 on 2022/8/23.
//  Copyright © 2022 尚游网络. All rights reserved.
//

#ifndef TPFBasicMacro_h
#define TPFBasicMacro_h

//#import "UIColor+Conver.h"
//#import "NSObject+Null.h"
//#import "UIView+YYAdd.h"
//#import "YYText.h"

///屏幕的全部宽度
#define kScreenWidth   [[UIScreen mainScreen] bounds].size.width
///屏幕的全部高度
#define kScreenHeight   [[UIScreen mainScreen] bounds].size.height
#define KScreenSize  [[UIScreen mainScreen] bounds].size

///RGB
#define kRGB(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
///普通字体大小
#define kFont(s) [UIFont systemFontOfSize:s]
///加粗字体大小
#define kFontBold(s) [UIFont fontWithName:@"Helvetica-Bold" size:s]


#define kDefaultColor [UIColor colorWithHex:@"167DDC"]
#define kDefaultHightlightColor  kRGB(22, 125, 220, 1)

#define kNiHongDefaultColor  kRGB(255, 12, 246, 1)
#define kNiHongHightlightColor kRGB(42, 253, 255, 1)

#define kDefaultTextFieldColor [[UIColor grayColor] colorWithAlphaComponent:0.2]

// 安全区
#define SAFE_AREA_BOTTOM    ([UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom)
#define SAFE_AREA_TOP       ([UIApplication sharedApplication].keyWindow.safeAreaInsets.top < 20 ? 20 : [UIApplication sharedApplication].keyWindow.safeAreaInsets.top)
#define SAFE_AREA_LEFT      ([UIApplication sharedApplication].keyWindow.safeAreaInsets.left)
#define SAFE_AREA_RIGHT     ([UIApplication sharedApplication].keyWindow.safeAreaInsets.right)

// 引用
#define SYWeakSelf(weakSelf)   __weak  typeof(self) weakSelf  = self
#define SYBlockSelf(blockSelf) __block typeof(self) blockSelf = self

// 拼接完整的域名
#define DOMAINPROXY(url) [NSString stringWithFormat:@"%@%@",[TPFBasicConfig shareInstance].proxy,url]

#endif /* TPFBasicMacro_h */
