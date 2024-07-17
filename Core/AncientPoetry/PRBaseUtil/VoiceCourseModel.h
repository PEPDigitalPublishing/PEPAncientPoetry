//
//  VoiceCourseModel.h
//  PEPRead
//
//  Created by liudongsheng on 2018/9/28.
//  Copyright © 2018年 PEP. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AudioModel,AbsModel,ChapterModel,UnitModel,Audio2Model;

@interface VoiceCourseModel : NSObject

/**教材id*/
@property (nonatomic, copy) NSString *bookId;

/**教材名称 */
@property (nonatomic, copy) NSString *bookName;

/**原定价(元/年) */
@property (nonatomic, copy) NSString *price;

/**优惠价(元/年) */
@property (nonatomic, copy) NSString *priceRight;

/**教材缩略图地址 */
@property (nonatomic, copy) NSString *img;

/**描述信息 */
@property (nonatomic, copy) NSString *des;

/**title ---数学用 */
@property (nonatomic, copy) NSString *title;
//三方地址
@property (nonatomic, copy) NSString *threeUrl;


/**图文混排 */
@property (nonatomic, strong) NSArray<AbsModel *> *abs;


/**音频*/
@property (nonatomic, strong) NSArray<AudioModel *> *audios;


/**红歌用-音频*/
@property (nonatomic, strong) NSArray<Audio2Model *> *audios2;


/**数学用*/
@property (nonatomic, strong) NSArray<ChapterModel *> *chapters;


/// 数学思维课程目录
@property (nonatomic, strong) NSArray<UnitModel *> *catalog;

/** 当前的音频索引位置 */
@property (nonatomic, assign) NSUInteger currentAudioIndex;

//md5校验值
@property (nonatomic, copy) NSString *md5;
@end



@interface ChapterModel : NSObject

@property (nonatomic, assign) BOOL isFree;
@property (nonatomic, copy) NSString *chapterName;
@property (nonatomic, copy) NSString *url;

@end


@interface AudioModel : NSObject

@property (nonatomic, assign) BOOL isFree;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *theme;
@property (nonatomic, copy) NSString *url;
//新增播放地址预解密字段
@property (nonatomic, copy) NSString *trueUrl;
@property (nonatomic, copy) NSString *trueMVUrl;
@property (nonatomic, copy) NSString *trueBZUrl;
@property (nonatomic, assign) BOOL isSel;
@property (nonatomic, copy) NSString *audioId;
@property (nonatomic, copy) NSString *des_url;
@property (nonatomic, copy) NSString *img_url;
@property(nonatomic,strong)NSString *duration;/**<  时长 单位s*/
/**<  新增标志位--假section头*/
@property(nonatomic,assign)BOOL is_fakeHeader;
@property(nonatomic,assign)int levelNumber;
@property(nonatomic,assign)BOOL is_ending;//层级的尾部标记
/**<  新增标志位--不需要rsa解密*/
@property(nonatomic,assign)BOOL is_trueUrl;

//唱响百年新增字段
@property (nonatomic, copy) NSString *mv_url;
@property(nonatomic,strong)NSString *mv_duration;/**<  */

@property (nonatomic, copy) NSString *bz_url;
@property (nonatomic, copy) NSString *bz_duration;

@property(nonatomic,assign)CGFloat audioProgress;/**<  */
@property(nonatomic,assign)CGFloat videoProgress;/**<  */
@property (nonatomic, copy) NSString *start_page;
@property (nonatomic, copy) NSString *end_page;
-(BOOL)countAudioProgress;
-(BOOL)countVideoProgress;
-(void)obtainTrueUrl;
- (NSString *)getTimeFromDuration;

//听课文权限
@property (nonatomic, assign) BOOL isAuth;
@end


/// 音频--红歌模块数据解析模型


@interface Audio2ChildModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *audio2ChildId;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *start_page;
@property (nonatomic, copy) NSString *end_page;
@property (nonatomic, strong) NSArray<Audio2ChildModel *> *children;//听课文新增

@end

@interface Audio2Model : NSObject

@property (nonatomic, copy) NSString *audioId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray<Audio2ChildModel *> *children;

@end

@interface AbsModel : NSObject

@property (nonatomic, copy) NSString *profilesImg;
@property (nonatomic, copy) NSString *profiles;

@end

typedef NS_ENUM(NSInteger,PracticeStatus) {
    PracticeLock,
    PracticeOpen,
    PracticeFinish
};

// 思维课程

@interface PracticeModel :NSObject
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * practice_url;
@property (nonatomic , copy) NSString              * url;
@property (nonatomic , copy) NSString              * describe;
@property (nonatomic, strong) NSDictionary         * details;
@property (nonatomic, strong) NSArray              * userAnswerDetails;
@property (nonatomic, assign) BOOL                 state; 
// 解锁状态
@property (nonatomic, assign) PracticeStatus practiceStatus;

@end


@interface StationModel :NSObject
@property (nonatomic , copy) NSString              * isFree;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , strong) NSArray <PracticeModel *>              * children;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * describe;
@property (nonatomic , copy) NSString              * is_practice;
@property (nonatomic , copy) NSString              * practice_url;
@property (nonatomic , copy) NSString              * url;
@property (nonatomic , copy) NSString              * progress;
@property (nonatomic, strong) NSArray              * userFinalTestAnswerDetails;// 期中期末考试的已答题目
@property (nonatomic, assign) BOOL                 state;

@end


@interface UnitModel :NSObject
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * url;
@property (nonatomic , strong) NSArray <StationModel *>              * children;

@end



