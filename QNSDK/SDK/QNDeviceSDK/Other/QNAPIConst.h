
//
//  QNAPIConst.h
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2018/3/7.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#ifndef QNAPIConst_h
#define QNAPIConst_h

#define QNWeak(obj) __weak typeof(obj) weakSelf = obj;
#define QNDelegate(delegate,method) (delegate && [delegate respondsToSelector:@selector(method)])

#endif /* QNAPIConst_h */
