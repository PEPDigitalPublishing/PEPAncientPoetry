//
//  PoetryModel.m
//  PEPRead
//
//  Created by liudongsheng on 2018/7/4.
//  Copyright © 2018年 PEP. All rights reserved.
//

#import "PoetryModel.h"

@implementation PoetryModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"fascicule": @"register"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"img": ImgModel.class};
}


@end
@implementation ImgModel

@end


@implementation MusicTestListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"children": MusicTestListSubModel.class};
}

@end

@implementation MusicTestListSubModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"children": MusicTestChildrenItem.class};
}

@end


@implementation MusicTestChildrenItem

@end
