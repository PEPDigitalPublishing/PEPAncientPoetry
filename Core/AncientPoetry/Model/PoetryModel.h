//
//  PoetryModel.h
//  PEPRead
//
//  Created by liudongsheng on 2018/7/4.
//  Copyright © 2018年 PEP. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ImgModel;



@interface PoetryModel : NSObject


@property(nonatomic,strong)NSString *book_id;/**<  */

/**图片*/
@property (nonatomic, copy) NSArray<ImgModel *> *img;

/**实体资源*/
@property (nonatomic, copy) NSString *path;

/**签名后的真实资源地址*/
@property (nonatomic, copy) NSString *signedPath;


/**书名*/
@property (nonatomic, copy) NSString *book_name;

/**朗诵者*/
@property (nonatomic, copy) NSString *recite;

/**册别*/
@property (nonatomic, copy) NSString *fascicule;

/**标题*/
@property (nonatomic, copy) NSString *title;

@property(nonatomic,strong)NSString *duration;/**<  时长 单位s*/
//自己加的，标识是否是当前播放
@property (nonatomic, assign) BOOL isPlay;
/**<  新增标志位--假section头*/
@property(nonatomic,assign)BOOL is_fakeHeader;

@property(nonatomic,strong)NSString *chapter_id;/**<  */
@property(nonatomic,strong)NSString *poemId;/**<  */
//@property(nonatomic,strong)NSString *register;/**<  年级*/

@property(nonatomic,strong)NSString *fileName;/**<  */
@property(nonatomic,strong)NSString *bgImgUrl;/**<  */
@property(nonatomic,assign)NSInteger genre;/**<  */

//听课文权限
@property (nonatomic, assign) BOOL isAuth;
@property(nonatomic,assign)NSInteger start_page;/**<  */
@property(nonatomic,assign)NSInteger end_page;/**<  */

@end

@interface ImgModel: NSObject
/**调换时间秒*/
@property (nonatomic, assign) long time;
/**图片地址*/
@property (nonatomic, copy) NSString *url;


@end



@class MusicTestListSubModel,MusicTestChildrenItem;

@interface MusicTestListModel :NSObject
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , strong) NSArray <MusicTestListSubModel *> * children;

@end



@interface MusicTestListSubModel :NSObject
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , strong) NSArray <MusicTestChildrenItem *>   * children;

@end


@interface MusicTestChildrenItem :NSObject
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * author;
@property (nonatomic , copy) NSString              * res_url;

// 标识是否是当前播放
@property (nonatomic, assign) BOOL isPlay;

@end



