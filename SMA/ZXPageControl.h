//
//  ZXPageControl.h
//  AAAA
//
//  Created by 有限公司 深圳市 on 2016/10/19.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXPageControl : UIView
@property (nonatomic, assign)   NSUInteger              currentPage;
@property (nonatomic, assign)   NSUInteger              numberOfPages;
@property (nonatomic, strong)   UIImage                 *pageIndicatorImage;
@property (nonatomic, strong)   UIImage                 *currentPageIndicatorImage;
@property (nonatomic, assign)   BOOL                    hidesForSinglePage;
@property (nonatomic, strong)   NSMutableArray <UIImageView *> *imgViews;
- (ZXPageControl *)initWithPageIndicatorImage:(UIImage *)pageIndicatorImage
                    currentPageIndicatorImage:(UIImage *)currentPageIndicatorImage;
@end
