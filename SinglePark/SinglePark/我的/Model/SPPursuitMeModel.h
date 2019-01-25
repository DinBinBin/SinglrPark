//
//  SPPursuitMeModel.h
//  SinglePark
//
//  Created by chensw on 2019/1/21.
//  Copyright © 2019 DBB. All rights reserved.
//

#import "SGBaseModel.h"
#import "SPPersonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPPursuitMeModel : SGBaseModel
@property (nonatomic, assign) int itemId;
@property (nonatomic, assign) int froms;
@property (nonatomic, assign) int tos;
@property (nonatomic, assign) int status;

@property (nonatomic, copy) NSString *voice;
@property (nonatomic, strong) SPPersonModel *from_user;
@property (nonatomic, strong) SPPersonModel *to_user;

@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *updated_at;

@end

NS_ASSUME_NONNULL_END
