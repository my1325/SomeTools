//
//  LJLiveUniqueTagCell.m
//  Woohoo
//
//  Created by Mac on 2021/4/13.
//

#import "LJLiveUniqueTagCell.h"


@interface LJLiveUniqueTagCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UIImageView *uniqueImg;
@property (weak, nonatomic) IBOutlet UILabel *titlelb;
@property (weak, nonatomic) IBOutlet UILabel *desclb;
@property (weak, nonatomic) IBOutlet UIImageView *selectImg;
@property (weak, nonatomic) IBOutlet UIButton *dataBtn;

@end
@implementation LJLiveUniqueTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(LJUniqueTag *)model
{
    _model = model;
    [self.uniqueImg sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
    self.titlelb.text = model.title;
    self.desclb.text = model.desc;
    NSInteger day = model.timeInterval / 3600 / 24;
    if (day > 3650) {
        [self.dataBtn setTitle:kLJLocalString(@"Forever") forState:UIControlStateNormal];
    }else if (day >= 0 && day < 3650) {
        
        [self.dataBtn setTitle:[NSString stringWithFormat:kLJLocalString(@"%ld days"), day] forState:UIControlStateNormal];
    }
    
    if (model.selected) {
        self.selectImg.hidden = NO;
        self.bgImg.image = kLJImageNamed(@"lj_live_uni_bg_select");
        self.titlelb.textColor = [UIColor whiteColor];
    }else {
        self.selectImg.hidden = YES;
        self.bgImg.image = kLJImageNamed(@"lj_live_uni_bg");
        self.titlelb.textColor = [UIColor colorWithWhite:1 alpha:0.6];
    }
}

@end
