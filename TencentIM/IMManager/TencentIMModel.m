//
//  TencentIMModel.m
//  MiniBuKe
//
//  Created by chenheng on 2019/1/10.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "TencentIMModel.h"

@implementation TencentIMModel
-(NSString *)description
{
    return [NSString stringWithFormat:@"Identity:%@ - sendImg:%@ - audiourl:%@ - imtime:%@",self.Identity,self.sendImg,self.audiourl,self.imtime];
}
@end
