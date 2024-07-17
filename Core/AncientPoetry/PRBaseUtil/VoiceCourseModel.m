//
//  VoiceCourseModel.m
//  PEPRead
//
//  Created by liudongsheng on 2018/9/28.
//  Copyright © 2018年 PEP. All rights reserved.
//

#import "VoiceCourseModel.h"
#import "PRHttpUtil.h"
#import "PRUserDefaultManager.h"


@implementation VoiceCourseModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"audios": AudioModel.class,@"audios2": Audio2Model.class,@"chapters": ChapterModel.class,@"abs": AbsModel.class,@"catalog": UnitModel.class};
}
@end


@implementation AudioModel
- (NSString *)url{
    if(_url.length <= 0){
        return nil;
    }
    if(_trueUrl.length > 0){
        return _trueUrl;
    }
    if ([_url hasPrefix:@"https"] || [_url hasPrefix:@"http"] || _is_trueUrl == YES) {
        return _url;
    }else{
        if (_url.length > 0) {
            NSString *trueUrl = [PRHttpUtil rsaWithCiphertext:_url];
            return trueUrl;
        }else{
            return nil;
        }

    }

}
-(void)obtainTrueUrl{
    _trueUrl = self.url;
    _trueBZUrl = self.bz_url;
    _trueMVUrl = self.mv_url;
}
-(NSString *)mv_url{
    if(_mv_url.length <= 0){
        return nil;
    }
    if(_trueMVUrl.length > 0){
        return _trueMVUrl;
    }
    if ([_mv_url hasPrefix:@"https"] || [_mv_url hasPrefix:@"http"]) {
        return _mv_url;
    }else{
        NSString *trueUrl = [PRHttpUtil rsaWithCiphertext:_mv_url];
        return trueUrl;
    }
}
-(NSString *)bz_url{
    if(_bz_url.length <= 0){
        return nil;
    }
    if(_trueBZUrl.length > 0){
        return _trueBZUrl;
    }
    if ([_bz_url hasPrefix:@"https"] || [_bz_url hasPrefix:@"http"]) {
        return _bz_url;
    }else{
        NSString *trueUrl = [PRHttpUtil rsaWithCiphertext:_bz_url];
        return trueUrl;
    }
}
-(BOOL)countAudioProgress{
    BOOL is_change = NO;
    if (!_is_fakeHeader) {
//        PRCountProgressModel *model = [[PRUserDefaultManager shareInstance]countAudioProgressWithKey:self.audioId duration:[_duration integerValue] previousProgress:(NSInteger)_audioProgress];
//        
//        is_change = model.is_change;
//        _audioProgress =  model.progress;
    }
    return is_change;
}
-(BOOL)countVideoProgress{
    BOOL is_change = NO;
//    PRCountProgressModel *model = [[PRUserDefaultManager shareInstance]countVideoProgressWithKey:self.audioId duration:[_mv_duration integerValue] previousProgress:(NSInteger)_videoProgress];
//
//    is_change = model.is_change;
//    _videoProgress =  model.progress;
    return is_change;
}
- (NSString *)getTimeFromDuration{
    int durationT = [_duration intValue];
    NSInteger minutes = durationT / 60;
    NSInteger remainingSeconds = durationT % 60;
    if (minutes <= 0){
        return [NSString stringWithFormat:@"%ld秒", (long)remainingSeconds];
    }else{
        return [NSString stringWithFormat:@"%ld分钟%ld秒", (long)minutes, (long)remainingSeconds];
    }
}
@end
@implementation Audio2ChildModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"audio2ChildId":@"id"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"children":Audio2ChildModel.class};
}
@end
@implementation Audio2Model
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"children":Audio2ChildModel.class};
}
@end
@implementation AbsModel
@end

@implementation ChapterModel
@end




@implementation PracticeModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"id":@[@"id", @"chapter_id"],@"userAnswerDetails":@"details"};
}
@end

@implementation StationModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"id":@[@"id", @"chapter_id"],@"userFinalTestAnswerDetails":@"details"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"children":PracticeModel.class};
}
@end

@implementation UnitModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"id":@[@"id", @"chapter_id"]};
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"children":StationModel.class};
}
@end
