//
//  YSAudioUserModel.m
//  YSAudioDemo
//
//  Created by ran cui on 2024/7/15.
//

#import "YSAudioUserModel.h"


@implementation YSAudioUserInfoModel

//重写解归档方法，把属性赋值给新对象的对应属性
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
     self = [super init];
     if (self) {
         self.sex_txt  = [aDecoder decodeObjectForKey:@"sex_txt"];
         self.reg_name = [aDecoder decodeObjectForKey:@"reg_name"];
         self.grade_txt  = [aDecoder decodeObjectForKey:@"grade_txt"];
         self.sex = [aDecoder decodeObjectForKey:@"sex"];
         self.fascicule  = [aDecoder decodeObjectForKey:@"fascicule"];
         self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
         self.head_image  = [aDecoder decodeObjectForKey:@"head_image"];
         self.age = [aDecoder decodeObjectForKey:@"age"];
         self.user_id  = [aDecoder decodeObjectForKey:@"user_id"];
         self.fascicule_txt = [aDecoder decodeObjectForKey:@"fascicule_txt"];
         self.eng_ver  = [aDecoder decodeObjectForKey:@"eng_ver"];
         self.point = [aDecoder decodeObjectForKey:@"point"];
         self.nickname  = [aDecoder decodeObjectForKey:@"nickname"];
         self.grade = [aDecoder decodeObjectForKey:@"grade"];
         self.name = [aDecoder decodeObjectForKey:@"name"];
     }
     return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.sex_txt forKey:@"sex_txt"];
    [aCoder encodeObject:self.reg_name forKey:@"reg_name"];
    [aCoder encodeObject:self.grade_txt forKey:@"grade_txt"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.fascicule forKey:@"fascicule"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.head_image forKey:@"head_image"];
    [aCoder encodeObject:self.age forKey:@"age"];
    [aCoder encodeObject:self.user_id forKey:@"user_id"];
    [aCoder encodeObject:self.fascicule_txt forKey:@"fascicule_txt"];
    [aCoder encodeObject:self.eng_ver forKey:@"eng_ver"];
    [aCoder encodeObject:self.point forKey:@"point"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.grade forKey:@"grade"];
    [aCoder encodeObject:self.name forKey:@"name"];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end

@implementation YSAudioUserModel

//重写解归档方法，把属性赋值给新对象的对应属性
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
     self = [super init];
     if (self) {
         self.errcode  = [aDecoder decodeObjectForKey:@"errcode"];
         self.active_time = [aDecoder decodeObjectForKey:@"active_time"];
         self.user_info  = [aDecoder decodeObjectForKey:@"user_info"];
         self.errmsg = [aDecoder decodeObjectForKey:@"errmsg"];
         self.access_token  = [aDecoder decodeObjectForKey:@"access_token"];
     }
     return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.errcode forKey:@"errcode"];
    [aCoder encodeObject:self.active_time forKey:@"active_time"];
    [aCoder encodeObject:self.user_info forKey:@"user_info"];
    [aCoder encodeObject:self.errmsg forKey:@"errmsg"];
    [aCoder encodeObject:self.access_token forKey:@"access_token"];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
