//
//  PEPAudioClassPlayerPopupViewController.m
//  PEPRead
//
//  Created by 韩帅 on 2021/12/2.
//  Copyright © 2021 PEP. All rights reserved.
//

#import "PEPAudioClassPlayerPopupViewController.h"
#import "UIColor+AudioAncientPoetry.h"
#import <Masonry/Masonry.h>
#import <ChameleonFramework/Chameleon.h>

@interface PEPAudioClassListTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *titleL;/**<  */
@property (nonatomic, strong) AudioModel *data;

@property(nonatomic,strong)UIView *line;/**<  */
// 免费体验
@property (nonatomic, strong) UILabel *tiyanLabel;
@property (nonatomic, assign) BOOL isBuy;
// 锁
@property (nonatomic, strong) UIImageView * lockImageView;
//播放进度
@property (nonatomic, strong) UILabel *playProportion;
@property(nonatomic,assign)NSInteger playProportionValue;/**<  */
@end
@implementation PEPAudioClassListTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}
-(void)configUI{
    UILabel *titleLabel = [[UILabel alloc] init];
    self.titleL = titleLabel;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = UIColor.textThemeColorBlack;
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
    UIView * line = [[UIView alloc] init];
    self.line = line;
    line.backgroundColor = [UIColor colorWithHexString:@"#DAE2E0"];
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:line];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.superview).offset(16);
        make.right.equalTo(titleLabel.superview).offset(-64);
        make.centerY.equalTo(titleLabel.superview);
//        make.right.equalTo(titleLabel.superview).offset(-16);

    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.superview).offset(16);
        make.right.bottom.equalTo(line.superview);
        make.height.equalTo(@(0.5));
    }];
    UILabel *tiyanLabel = [[UILabel alloc] init];
    tiyanLabel.textAlignment = NSTextAlignmentRight;
    tiyanLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    tiyanLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
    tiyanLabel.text = @"免费体验";
    self.tiyanLabel = tiyanLabel;
    UIImageView * imageView = [[UIImageView alloc] init];
    self.lockImageView = imageView;
    imageView.image = [UIImage imageNamed:@"lock"];
    [self.contentView addSubview:imageView];
    [self.contentView addSubview:tiyanLabel];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imageView.superview).offset(-16);
        make.centerY.equalTo(imageView.superview);
    }];
    [tiyanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tiyanLabel.superview).offset(-16);
        make.centerY.equalTo(tiyanLabel.superview);
    }];
    
    self.playProportion = [[UILabel alloc] init];
    self.playProportion.textAlignment = NSTextAlignmentRight;
    self.playProportion.textColor = [UIColor colorWithHexString:@"#DAE2E0"];
    self.playProportion.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular];
    self.playProportion.text = @"进度100%";
    [self.contentView addSubview:self.playProportion];
    [self.playProportion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.playProportion.superview).offset(-16);
        make.centerY.equalTo(self.playProportion.superview);
    }];
}
-(void)setData:(AudioModel *)data{
    self.playProportionValue = data.audioProgress;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.line.hidden = NO;
    _titleL.font = [UIFont systemFontOfSize:17];
    _titleL.textColor = UIColor.textThemeColorBlack;
    _titleL.text = data.title;
    if(data.isSel){
        
        _titleL.textColor = UIColor.themeColor;

    }else{
        
        _titleL.textColor = UIColor.textThemeColorBlack;

    }
    if (self.playProportionValue > 0) {
        _tiyanLabel.hidden = YES;
        _lockImageView.hidden = YES;
        _playProportion.hidden = NO;
        _playProportion.text = [NSString stringWithFormat:@"已播%ld%%",self.playProportionValue];
    }else{
        _playProportion.hidden = YES;
        if(_isBuy || data.isAuth){
            
            _tiyanLabel.hidden = YES;
            _lockImageView.hidden = YES;
            
        }else{
            
            if(data.isFree){
            
                _tiyanLabel.hidden = NO;
                _lockImageView.hidden = YES;
                
            }else{
                
                _tiyanLabel.hidden = YES;
                _lockImageView.hidden = NO;
                
            }
        }
    }
    
    if (data.is_fakeHeader) {
        self.contentView.backgroundColor = [UIColor themeColor];
        _titleL.font = [UIFont systemFontOfSize:16];
        _titleL.textColor = UIColor.whiteColor;
        self.line.hidden = YES;
        _tiyanLabel.hidden = YES;
        _lockImageView.hidden = YES;
        _playProportion.hidden = YES;
    }
    
    
}
@end
@interface PEPAudioClassCountDownModel : NSObject
@property(nonatomic,strong)NSString *optionStr;/**<  */
@property(nonatomic,assign)BOOL is_sel;/**<  */
@property(nonatomic,assign)NSInteger time;/**<  */
@end
@implementation PEPAudioClassCountDownModel

@end
@interface PEPAudioClassCountDownTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *titleL;/**<  */
@property (nonatomic, strong) UIImageView * chooseImg;
@property(nonatomic,strong)PEPAudioClassCountDownModel *model;/**<  */
@end
@implementation PEPAudioClassCountDownTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}
-(void)configUI{
    UILabel *titleLabel = [[UILabel alloc] init];
    self.titleL = titleLabel;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = UIColor.textThemeColorBlack;
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
    [self.contentView addSubview:titleLabel];
   
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#DAE2E0"];
    [self.contentView addSubview:line];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.superview).offset(50);
        make.centerY.equalTo(titleLabel.superview);
        make.right.equalTo(titleLabel.superview).offset(-16);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.superview).offset(16);
        make.right.bottom.equalTo(line.superview);
        make.height.equalTo(@(0.5));
    }];
    UIImageView * imageView = [[UIImageView alloc] init];
    self.chooseImg = imageView;
    imageView.image = [UIImage imageNamed:@"pep_icon_signCheckBox"];
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.mas_left).offset(1);
        make.centerY.equalTo(imageView.superview);
        make.size.mas_equalTo(CGSizeMake(17,17));
    }];
}
-(void)setModel:(PEPAudioClassCountDownModel *)model{
    _model = model;
    
    self.titleL.text = model.optionStr;
    if (model.is_sel) {
        self.chooseImg.image = [UIImage imageNamed:@"pep_icon_signCheckBoxSel"];
    }else{
        self.chooseImg.image = [UIImage imageNamed:@"pep_icon_signCheckBox"];
    }
}
@end


@interface PEPAudioClassPlayerPopupViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIView *topView;/**<  */
@property(nonatomic,strong)UITableView *listTableView;/**<  */
@property(nonatomic,strong)NSArray *countDownOption;/**<  */
//@property(nonatomic,assign)NSInteger countDownIndex;/**<  */
@end

@implementation PEPAudioClassPlayerPopupViewController

+(instancetype)initwithType:(AudioPlayerPopupMode)mode{
    PEPAudioClassPlayerPopupViewController *popupVC = [[PEPAudioClassPlayerPopupViewController alloc]init];
    popupVC.mode = mode;
    return popupVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTopUI];
    if (self.mode == AudioPlayerPopupList) {
        [self configListUI];
    }else if(self.mode == AudioPlayerPopupCountDownOption){
        [self configCountDownUI];
    }
    
}
-(void)configTopUI{
    UIView *view = [[UIView alloc]init];
    self.topView = view;
    self.topView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:self.topView];
    CGFloat height;
    if (self.mode == AudioPlayerPopupList) {
        height = [UIScreen mainScreen].bounds.size.height * 0.35;
    }else {
        height = 450;
    }
    self.topView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height);
    UITapGestureRecognizer *panGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickOtherArea)];
    [self.topView addGestureRecognizer:panGR];

    
}
-(void)setDataSource:(VoiceCourseModel *)dataSource{
    _dataSource = dataSource;
    if (self.mode == AudioPlayerPopupList) {
        [self countProgress];
        [self.listTableView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
        //在此处操作
            [self.listTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:dataSource.currentAudioIndex inSection:0] atScrollPosition:(UITableViewScrollPositionMiddle) animated:NO];
        });
    }else if(self.mode == AudioPlayerPopupCountDownOption){
        
    }
}

-(void)countProgress{
    //计算进度
    for (AudioModel *tempModel in self.dataSource.audios) {
        [tempModel countAudioProgress];
    }
    
}
-(void)configListUI{
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = UIColor.redColor;
    [self.view addSubview:bottomView];
    bottomView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height * 0.35, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 0.65);
    self.listTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [bottomView addSubview:self.listTableView];
    self.listTableView.backgroundColor = UIColor.whiteColor;
    self.listTableView.frame = bottomView.bounds;
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.tableFooterView = [UIView new];
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.listTableView.bounces = NO;
    [self.listTableView registerClass:[PEPAudioClassListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([PEPAudioClassListTableViewCell class])];
    
    

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:bottomView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.frame = bottomView.bounds;
    bottomView.layer.mask = shapeLayer;
}


-(void)configCountDownUI{
    PEPAudioClassCountDownModel *model1 = [[PEPAudioClassCountDownModel alloc]init];
    PEPAudioClassCountDownModel *model2 = [[PEPAudioClassCountDownModel alloc]init];
    PEPAudioClassCountDownModel *model3 = [[PEPAudioClassCountDownModel alloc]init];
    PEPAudioClassCountDownModel *model4 = [[PEPAudioClassCountDownModel alloc]init];
    PEPAudioClassCountDownModel *model5 = [[PEPAudioClassCountDownModel alloc]init];
    PEPAudioClassCountDownModel *model6 = [[PEPAudioClassCountDownModel alloc]init];
    PEPAudioClassCountDownModel *model7 = [[PEPAudioClassCountDownModel alloc]init];
    PEPAudioClassCountDownModel *model8 = [[PEPAudioClassCountDownModel alloc]init];
    model1.optionStr = @"不开启";
    model1.time = 0;
    model1.is_sel = NO;
    model2.optionStr = @"播放完当前课";
    model2.time = 0;
    model2.is_sel = NO;
    model3.optionStr = @"播完2集声音";
    model3.time = 0;
    model3.is_sel = NO;
    model4.optionStr = @"播完3集声音";
    model4.time = 0;
    model4.is_sel = NO;
    model5.optionStr = @"10分钟";
    model5.time = 10*60;
    model5.is_sel = NO;
    model6.optionStr = @"20分钟";
    model6.time = 20*60;
    model6.is_sel = NO;
    model7.optionStr = @"30分钟";
    model7.time = 30*60;
    model7.is_sel = NO;
    model8.optionStr = @"60分钟";
    model8.time = 60*60;
    model8.is_sel = NO;
    self.countDownOption = @[model1,model2,model3,model4,model5,model6,model7,model8];
    PEPAudioClassCountDownModel *model = self.countDownOption[self.countDownIndex];
    model.is_sel = YES;
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:bottomView];
    bottomView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height- 450, [UIScreen mainScreen].bounds.size.width, 450);
    self.listTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [bottomView addSubview:self.listTableView];
    self.listTableView.backgroundColor = UIColor.whiteColor;
    self.listTableView.frame = CGRectMake(0,40, [UIScreen mainScreen].bounds.size.width, 410);
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.tableFooterView = [UIView new];
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.listTableView.bounces = NO;
    [self.listTableView registerClass:[PEPAudioClassCountDownTableViewCell class] forCellReuseIdentifier:NSStringFromClass([PEPAudioClassCountDownTableViewCell class])];
    
    UILabel *titleL = [[UILabel alloc]init];
    titleL.font = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
    titleL.textColor = [UIColor colorWithHexString:@"#666666"];
    titleL.text = @"关闭音频时间设定";
    [bottomView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomView);
        make.top.equalTo(bottomView).offset(10);
    }];

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:bottomView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.frame = bottomView.bounds;
    bottomView.layer.mask = shapeLayer;
}

#pragma mark Delegate Datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.mode == AudioPlayerPopupList) {
        AudioModel *model = self.dataSource.audios[indexPath.row];
        PEPAudioClassListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PEPAudioClassListTableViewCell class]) forIndexPath:indexPath];
        if (indexPath.row == self.dataSource.currentAudioIndex) {
            model.isSel = YES;
        }else{
            model.isSel = NO;
        }
        
        cell.isBuy = self.isBuy;
        cell.data = model;
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        PEPAudioClassCountDownModel *model = self.countDownOption[indexPath.row];
        PEPAudioClassCountDownTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PEPAudioClassCountDownTableViewCell class]) forIndexPath:indexPath];
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.mode == AudioPlayerPopupList) {
        return self.dataSource.audios.count;
    }else{
        //倒计时
        return self.countDownOption.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.mode == AudioPlayerPopupList) {
        
        if (self.dataSource.audios[indexPath.row].is_fakeHeader) {
            return 35;
        }else{
            return 50;
        }
    }else {
        //倒计时
        return 50;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.mode == AudioPlayerPopupList) {
        //目录
        if (self.dataSource.audios[indexPath.row].is_fakeHeader) {
            return;
        }
        AudioModel *oldModel = self.dataSource.audios[self.dataSource.currentAudioIndex];
        oldModel.isSel = NO;
        
        if (self.block) {
            self.block(indexPath.row);
        }
    }else{
    //倒计时

        if (self.countDownBlock) {
            PEPAudioClassCountDownModel *newModel = self.countDownOption[indexPath.row];
            self.countDownBlock(newModel.time,indexPath.row);
             
        }
    }
    
    
}

-(void)clickOtherArea{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)dealloc{
    NSLog(@"");
}

@end
