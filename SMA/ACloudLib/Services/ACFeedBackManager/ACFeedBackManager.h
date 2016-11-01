//
//  ACFeedBackManager.h
//  ac-service-ios-Demo
//
//  Created by __zimu on 16/2/25.
//  Copyright © 2016年 OK. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FEEDBACK_SERVICE @"zc-feedback"
@class ACFeedBack;
@interface ACFeedBackManager : NSObject

///  提交用户意见反馈
+ (void)submitFeedBack:(ACFeedBack *)feedback
              callback:(void(^)(BOOL isSuccess, NSError *error))callback;


@end
