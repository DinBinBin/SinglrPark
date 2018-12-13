//
//  SPSelectDelegate.h
//  SinglePark
//
//  Created by chensw on 2018/12/7.
//  Copyright © 2018 DBB. All rights reserved.
//

#ifndef SPSelectDelegate_h
#define SPSelectDelegate_h

@protocol SPSelectDelegate <NSObject>
@optional
- (void)selectJobName:(NSString *)name;
- (void)selectAreaName:(NSString *)areaName;
- (void)goVideoClick;
@end

#endif /* SPSelectDelegate_h */
