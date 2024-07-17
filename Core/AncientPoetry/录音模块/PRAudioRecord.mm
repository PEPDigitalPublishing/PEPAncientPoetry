//
//  PRAudioRecord.m
//  PEPRead
//
//  Created by sunShine on 2024/3/4.
//  Copyright © 2024 PEP. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "PRAudioRecord.h"
#import <AudioToolbox/AudioToolbox.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AVFoundation/AVFoundation.h>
#import "lame.h"
#import "CommonFunction.h"

#define kDefaultSampleRate 16000.0
#define kDefaultChannels 1
#define kDefaultBitsPerChannel 16
/// 自定义结构体
static const int kNumberBuffers = 3;
typedef struct PRRecorderState {
    AudioStreamBasicDescription  mDataFormat;
    AudioQueueRef                mQueue;
    AudioQueueBufferRef          mBuffers[kNumberBuffers];
    AudioFileID                  mAudioFile;
    UInt32                       bufferByteSize;
    SInt64                       mCurrentPacket;
    bool                         mIsRunning;
    __weak PRAudioRecord  *record;
} PRRecorderState;

/// 处理回调函数
static void PRHandleInputBuffer (
    void                                 *aqData,
    AudioQueueRef                        inAQ,
    AudioQueueBufferRef                  inBuffer,
    const AudioTimeStamp                 *inStartTime,
    UInt32                               inNumPackets,
    const AudioStreamPacketDescription   *inPacketDesc
) {
    PRRecorderState *pAqData = (PRRecorderState *)aqData;
    
    
    if (inNumPackets == 0 && pAqData->mDataFormat.mBytesPerPacket != 0) {
        inNumPackets = inBuffer->mAudioDataByteSize / pAqData->mDataFormat.mBytesPerPacket;
    }
 
    OSStatus writeStatus = AudioFileWritePackets(pAqData->mAudioFile,
                                                 false,
                                                 inBuffer->mAudioDataByteSize,
                                                 inPacketDesc,
                                                 pAqData->mCurrentPacket,
                                                 &inNumPackets,
                                                 inBuffer->mAudioData);
    if (writeStatus == noErr) {
        pAqData->mCurrentPacket += inNumPackets;
    }
    
    if (pAqData->mIsRunning == false) {
        return;
    }
// 获取录音数据
    if (pAqData->record){
        NSData *audioData = [NSData dataWithBytes:inBuffer->mAudioData length:inBuffer->mAudioDataByteSize];
        [pAqData->record sendRecordData:audioData];
       
    }
   
    AudioQueueEnqueueBuffer(pAqData->mQueue,
                            inBuffer,
                            0,
                            NULL);
}

/// 设置缓冲区大小
void DeriveBufferSize (AudioQueueRef audioQueue,
                       AudioStreamBasicDescription &ASBDescription,
                       Float64  seconds,
                       UInt32   *outBufferSize) {
    
    int packets, frames, bytes = 0;
    
    frames = (int)ceil(seconds * ASBDescription.mSampleRate);
    
    if (ASBDescription.mBytesPerFrame > 0)
        bytes = frames * ASBDescription.mBytesPerFrame;
    else {
        UInt32 maxPacketSize;
        if (ASBDescription.mBytesPerPacket > 0)
            maxPacketSize = ASBDescription.mBytesPerPacket;    // constant packet size
        else {
            UInt32 propertySize = sizeof(maxPacketSize);
            AudioQueueGetProperty(audioQueue,
                                  kAudioQueueProperty_MaximumOutputPacketSize,
                                  &maxPacketSize,
                                  &propertySize);
        }
        if (ASBDescription.mFramesPerPacket > 0)
            packets = frames / ASBDescription.mFramesPerPacket;
        else
            packets = frames;    // worst-case scenario: 1 frame in a packet
        if (packets == 0)        // sanity check
            packets = 1;
        bytes = packets * maxPacketSize;
    }
    
    *outBufferSize = bytes;
}

OSStatus SetMagicCookieForFile (
    AudioQueueRef inQueue,
    AudioFileID   inFile
) {
    OSStatus result = noErr;
    UInt32 cookieSize;
 
    if (
            AudioQueueGetPropertySize (
                inQueue,
                kAudioQueueProperty_MagicCookie,
                &cookieSize
            ) == noErr
    ) {
        char* magicCookie =
            (char *) malloc (cookieSize);
        if (
                AudioQueueGetProperty (
                    inQueue,
                    kAudioQueueProperty_MagicCookie,
                    magicCookie,
                    &cookieSize
                ) == noErr
        )
            result =    AudioFileSetProperty (
                            inFile,
                            kAudioFilePropertyMagicCookieData,
                            cookieSize,
                            magicCookie
                        );
        free (magicCookie);
    }
    return result;
}
@interface PRAudioRecord (){
    PRRecorderState aqData;
    
}
@property(nonatomic,strong)NSString *tempFilePath;/**<  */


@end

@implementation PRAudioRecord
- (instancetype)initAudioFormatType:(AudioFormatType)audioFormatType sampleRate:(Float64)sampleRate channels:(UInt32)channels bitsPerChannel:(UInt32)bitsPerChannel {
    self = [super init];
    if (self) {
        [self initRecord];
        
        [self setAudioFormatType:audioFormatType
                      sampleRate:sampleRate
                        channels:channels
                  bitsPerChannel:bitsPerChannel];
    }
    return self;
}

- (void)initRecord {

}

- (void)setAudioFormatType:(AudioFormatType)audioFormatType
                sampleRate:(Float64)sampleRate
                  channels:(UInt32)channels
            bitsPerChannel:(UInt32)bitsPerChannel {
    aqData.mDataFormat.mSampleRate = sampleRate > 0 ? sampleRate : kDefaultSampleRate;
    aqData.mDataFormat.mChannelsPerFrame = channels > 0 ? channels : kDefaultChannels;
    
    if (audioFormatType == AudioFormatLinearPCM) {
        
        aqData.mDataFormat.mFormatID = kAudioFormatLinearPCM;
        aqData.mDataFormat.mBitsPerChannel = bitsPerChannel > 0 ? bitsPerChannel : kDefaultBitsPerChannel;
        aqData.mDataFormat.mBytesPerPacket =
        aqData.mDataFormat.mBytesPerFrame = (aqData.mDataFormat.mBitsPerChannel / 8) * aqData.mDataFormat.mChannelsPerFrame;
        aqData.mDataFormat.mFramesPerPacket = 1;
        aqData.mDataFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
        
    } else if (audioFormatType == AudioFormatMPEG4AAC) {
        
        aqData.mDataFormat.mFormatID = kAudioFormatMPEG4AAC;
        aqData.mDataFormat.mFormatFlags = kMPEG4Object_AAC_Main;
        
    }
}

- (void)startR{
    // 检查录音权限
    [self requestRecordPermissionWithCompletion:^(BOOL granted) {
//            if (!granted) {
//                return;
//            }
        }];

    // 初始化录音队列
    aqData.mCurrentPacket = 0;
    aqData.mIsRunning = true;
    aqData.record = self;

    OSStatus queueStatus = AudioQueueNewInput(&aqData.mDataFormat,
                                              PRHandleInputBuffer,
                                              &aqData,
                                              NULL,
                                              kCFRunLoopCommonModes,
                                              0,
                                              &aqData.mQueue);
    if (queueStatus != noErr) {
        NSLog(@"创建音频队列失败: %d", queueStatus);
        return;
    }

    UInt32 dataFormatSize = sizeof(aqData.mDataFormat);
    AudioQueueGetProperty(aqData.mQueue,
                          kAudioQueueProperty_StreamDescription,
                          &aqData.mDataFormat,
                          &dataFormatSize);

    DeriveBufferSize(aqData.mQueue,
                     aqData.mDataFormat,
                     0.05,
                     &aqData.bufferByteSize);

    for (int i = 0; i < kNumberBuffers; ++i) {
        OSStatus allocBufferStatus = AudioQueueAllocateBuffer(aqData.mQueue,
                                                              aqData.bufferByteSize,
                                                              &aqData.mBuffers[i]);
        if (allocBufferStatus != noErr) {
            NSLog(@"分配缓冲区失败：%d", allocBufferStatus);
            return;
        }

        OSStatus enqueueStatus = AudioQueueEnqueueBuffer(aqData.mQueue,
                                                         aqData.mBuffers[i],
                                                         0,
                                                         NULL);
        if (enqueueStatus != noErr) {
            NSLog(@"缓冲区排队失败：%d", enqueueStatus);
            return;
        }
    }

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];

    OSStatus startStatus = AudioQueueStart(aqData.mQueue, NULL);
    if (startStatus != noErr) {
        NSLog(@"开始录音失败：%d", startStatus);
        return;
    }

}


- (void)startRecordWithFilePath:(NSString*)filePath{
    if (filePath.length <= 0) {
        NSLog(@"文件地址为空");
        return;
    }
    
    [self requestRecordPermissionWithCompletion:^(BOOL granted) {
            if (!granted) {
                return;
            }
        }];
    //检查file Path
    aqData.mCurrentPacket = 0;
    aqData.mIsRunning = true;
    aqData.record = self;
    // 创建音频队列
    OSStatus queueStatus = AudioQueueNewInput(&aqData.mDataFormat,
                                              PRHandleInputBuffer,
                       &aqData,
                       NULL,
                       kCFRunLoopCommonModes,
                       0,
                       &aqData.mQueue);
    if (queueStatus != noErr) {
        NSLog(@"创建音频队列失败: %d", queueStatus);
        return;
    }
    
    UInt32 dataFormatSize = sizeof(aqData.mDataFormat);
    AudioQueueGetProperty(aqData.mQueue,
                          kAudioQueueProperty_StreamDescription,
                          &aqData.mDataFormat,
                          &dataFormatSize);
    
    NSLog(@"文件地址----- %@", filePath);
    self.tempFilePath = filePath;
    CFURLRef audioFileURL = CFURLCreateWithString(kCFAllocatorDefault, (CFStringRef)filePath, NULL);
    OSStatus fileStatus = AudioFileCreateWithURL(audioFileURL,
                                                 kAudioFileCAFType,
                                                 &aqData.mDataFormat,
                                                 kAudioFileFlags_EraseFile,
                                                 &aqData.mAudioFile);
    CFRelease(audioFileURL);
    if (fileStatus != noErr) {
        NSLog(@"创建文件失败：%d", fileStatus);
        return;
    }
    
    // 设置magic cookie
    if (aqData.mDataFormat.mFormatID != kAudioFormatLinearPCM) {
        SetMagicCookieForFile(aqData.mQueue, aqData.mAudioFile);
    }
    
    // 设置缓冲区大小
    DeriveBufferSize(aqData.mQueue,
                     aqData.mDataFormat,
                     0.05,
                     &aqData.bufferByteSize);
        
    // 创建音频队列缓冲区
    for (int i = 0; i < kNumberBuffers; ++i) {
        OSStatus allocBufferStatus = AudioQueueAllocateBuffer(aqData.mQueue,
                                                              aqData.bufferByteSize,
                                                              &aqData.mBuffers[i]);
        if (allocBufferStatus != noErr) {
            NSLog(@"分配缓冲区失败：%d", allocBufferStatus);
            return;
        }
        
        OSStatus enqueueStatus = AudioQueueEnqueueBuffer(aqData.mQueue,
                                                         aqData.mBuffers[i],
                                                         0,
                                                         NULL);
        if (enqueueStatus != noErr) {
            NSLog(@"缓冲区排队失败：%d", enqueueStatus);
            return;
        }
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    // 开始录音
    OSStatus startStatus = AudioQueueStart(aqData.mQueue, NULL);
    if (startStatus != noErr) {
        NSLog(@"开始录音失败：%d", startStatus);
        return;
    }
}

- (void)stopRecord {
//    if (self.time){
//        [self.time stop];
//    }
    aqData.mIsRunning = false;
    AudioQueueStop(aqData.mQueue, true);
    AudioQueueDispose(aqData.mQueue, true);
    
    if (self.tempFilePath.length > 0){
        // 录音结束后再次调用magic cookies，一些编码器会在录音停止后更新magic cookies数据
        if (aqData.mDataFormat.mFormatID != kAudioFormatLinearPCM) {
            SetMagicCookieForFile(aqData.mQueue, aqData.mAudioFile);
        }
        
        AudioFileClose(aqData.mAudioFile);
        
        [self saveAudioFile];
    }
    
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
}
-(BOOL)isQuiet:(NSData *)pcmData {
    if (pcmData == nil) {
        return NO;
    }

    long long pcmAllLength = 0;
    short bufferByte[pcmData.length / 2];

    memcpy(bufferByte, pcmData.bytes, pcmData.length); // frame_size * sizeof(short)

    // 将 buffer 内容取出，进行平方和运算
    for (int i = 0; i < pcmData.length / 2; i++) {
        pcmAllLength += bufferByte[i] * bufferByte[i];
    }

    // 平方和除以数据总长度，得到音量大小
    double mean = pcmAllLength / (double)(pcmData.length / 2);
    double volume = 10 * log10(mean); // volume为分贝数大小

    if (volume >= 0) { // 有效返回值 45分贝 --> 70分贝之间
        if ([self.delegate respondsToSelector:@selector(audioRecorderRealTimeVolume:)]) {
            [self.delegate audioRecorderRealTimeVolume:volume];
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
            NSString *formattedDate = [dateFormatter stringFromDate:[NSDate date]];
            
//         NSLog(@"%@ -=-=-=--=-=%f分贝",formattedDate , volume);
    }

    return YES;
}

- (void)dealloc {
    NSLog(@"--- dealloc ---");
    AudioQueueStop(aqData.mQueue, true);
    AudioQueueDispose(aqData.mQueue, true);
    AudioFileClose(aqData.mAudioFile);
}

- (BOOL)isRecording {
    return aqData.mIsRunning ? YES : NO;
}
-(void)sendRecordData:(NSData*)data{
    if (data.length > 0) {
        [self isQuiet:data];
        // 将录音数据传递给代理
         if ([self.delegate respondsToSelector:@selector(audioRecorderDidReceiveData:)]) {
             [self.delegate audioRecorderDidReceiveData:data];
        }
    }
    
 
}
-(void)saveAudioFile{
    NSString *mp3FilePath = [self.tempFilePath stringByDeletingPathExtension];
    NSString *substringToRemove = @"_temp";
    NSString *audioName = [mp3FilePath stringByReplacingOccurrencesOfString:substringToRemove withString:@""];
    audioName = [audioName stringByAppendingPathExtension:@"mp3"];
    [self convertToMp3WithWavpath:self.tempFilePath toMp3path:audioName];
}
- (void)requestRecordPermissionWithCompletion:(void (^)(BOOL granted))completion {
    
    AVAudioSessionRecordPermission permission = AVAudioSession.sharedInstance.recordPermission;
    if (permission == AVAudioSessionRecordPermissionDenied || permission == AVAudioSessionRecordPermissionUndetermined){
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            
            if (!granted) {
                if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
                    [self showPermissionAlert];
                    
                } else {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self showPermissionAlert];
                    });
                }
            }
            if (completion) {
                completion(NO);
            }
                          

        }];
    }else{
        if (completion) {
            completion(YES);
        }
    }
    
}
-(void)showPermissionAlert{
    
        UIAlertController *alert = [self getPrivacyAlert];
        [[CommonFunction getCurrentUIVC] presentViewController:alert animated:true completion:nil];

}
- (UIAlertController *)getPrivacyAlert {
    NSString *message = @"需要您同意访问麦克风，才能正常获取您的发音";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"麦克风权限未打开" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]options: @{} completionHandler:nil];
        }
        
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    
    return alert;
}
- (void)convertToMp3WithWavpath:(NSString*)wavPath toMp3path:(NSString*)mp3path
{

    NSURL *mp3Url = [NSURL URLWithString:mp3path];
    NSLog(@"");
    @try {
        int read,write;
        //只读方式打开被转换音频文件
        FILE *pcm = fopen([wavPath cStringUsingEncoding:1], "rb");
        fseek(pcm, 4 * 1024, SEEK_CUR);//删除头，否则在前一秒钟会有杂音
        //只写方式打开生成的MP3文件
        FILE *mp3 = fopen([mp3path cStringUsingEncoding:1], "wb");
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE * 2];
        unsigned char mp3_buffer[MP3_SIZE];
        //这里要注意，lame的配置要跟AVAudioRecorder的配置一致，否则会造成转换不成功
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 16000.0);//采样率
        lame_set_num_channels(lame, kDefaultChannels);
        lame_set_brate(lame, 16);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            
            //以二进制形式读取文件中的数据
            read = (int)fread(pcm_buffer, sizeof(short int), PCM_SIZE, pcm);//***双声道第二个参数设置 2*sizeof(shortint)
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write =lame_encode_buffer(lame, pcm_buffer,pcm_buffer, read, mp3_buffer, MP3_SIZE);//***单声道写入

//                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);//双声道写入
            
            //二进制形式写数据到文件中  mp3_buffer：数据输出到文件的缓冲区首地址  write：一个数据块的字节数  1:指定一次输出数据块的个数   mp3:文件指针
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);

    } @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    } @finally {
        NSLog(@"MP3生成成功!!!");
        NSError *error;
        if ([[NSFileManager defaultManager]removeItemAtPath:wavPath error:&error]) {
//                NSLog(@"文件删除成功");
            } else {
//                NSLog(@"文件删除失败：%@", error.localizedDescription);
            }
    }
}
@end
