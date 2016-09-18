//
//  SDRotationLoopProgressView.h
//  SDProgressView
//
//  Created by aier on 15-2-20.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDBaseProgressView.h"

@interface SDRotationLoopProgressView : SDBaseProgressView
@property (nonatomic, strong)     CATextLayer * text, * unitText ;
@property (nonatomic, strong)     CALayer *imageLayer;
- (void)createUIRect:(CGRect)rect;
@end
