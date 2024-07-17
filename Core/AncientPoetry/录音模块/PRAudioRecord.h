//
//  PRAudioRecord.h
//  PEPRead
//
//  Created by sunShine on 2024/3/4.
//  Copyright © 2024 PEP. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, AudioFormatType) {
    AudioFormatLinearPCM,
    AudioFormatMPEG4AAC,
};

NS_ASSUME_NONNULL_BEGIN

@protocol PRAudioRecordDelegate <NSObject>
- (void)audioRecorderDidReceiveData:(NSData *)audioData;
- (void)audioRecorderRealTimeVolume:(double)volume;
@end

@interface PRAudioRecord : NSObject
@property (nonatomic, assign, readonly) BOOL isRecording;
@property(nonatomic,weak)id<PRAudioRecordDelegate> delegate;/**<  */


/// 设置音频数据属性
/// @param audioFormatType 音频格式 AudioFormatType
/// @param sampleRate 采样率
/// @param channels 声道
/// @param bitsPerChannel 位深度
- (instancetype)initAudioFormatType:(AudioFormatType)audioFormatType
                         sampleRate:(Float64)sampleRate
                           channels:(UInt32)channels
                     bitsPerChannel:(UInt32)bitsPerChannel;

- (void)startRecordWithFilePath:(NSString*)filePath;
- (void)startR;
- (void)stopRecord;

- (void)sendRecordData:(NSData *)data;
- (void)convertToMp3WithWavpath:(NSString*)wavPath toMp3path:(NSString*)mp3path;
- (void)requestRecordPermissionWithCompletion:(void (^)(BOOL granted))completion;
@end

NS_ASSUME_NONNULL_END
