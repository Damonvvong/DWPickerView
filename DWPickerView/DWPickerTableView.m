//
//  DWPickerTableView.m
//  DWPickerView
//
//  Created by Damon on 16/3/11.
//  Copyright © 2016年 damonwong. All rights reserved.
//

#import "DWPickerTableView.h"
#import <AudioToolbox/AudioToolbox.h>

@interface DWPickerViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *pikerLabel;/**< 选择内容 */

@end


@implementation DWPickerViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.pikerLabel];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];

    self.pikerLabel.frame = self.contentView.bounds;
}

-(UILabel *)pikerLabel{

    if (!_pikerLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Helvetica Neue-Bold" size:14];
        _pikerLabel = label;
    }
    return _pikerLabel;
}


@end

#define NUM_OF_SECTION 0
#define MAX_NUM_OF_ROW [self.tableView numberOfRowsInSection:NUM_OF_SECTION]
#define MIN_NUM_OF_ROW 0
#define MIN_HEIGHT_OF_ROW 0.0


@interface DWPickerTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;/**< 选择列表*/

@property (nonatomic, assign) NSInteger selectRow;/**< 被选中的行 */

@property (nonatomic, strong) DWPickerViewCell *colorCell;/**< 变色的cell */



@end

@implementation DWPickerTableView

static NSString *DWPickerViewCellID = @"DWPickerViewCell";

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.rowHeight = MIN_HEIGHT_OF_ROW;
        [self addSubview:self.tableView];
    }

    return self;
}

#pragma mark - public method

- (void)selectRow:(NSInteger)row animated:(BOOL)animated{

    NSInteger count = row < MIN_NUM_OF_ROW ? MIN_NUM_OF_ROW : row;
    count = count > (MAX_NUM_OF_ROW - 1) ? (MAX_NUM_OF_ROW - 1) : count;
    self.selectRow = count;
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:NUM_OF_SECTION] atScrollPosition:UITableViewScrollPositionTop animated:animated];

}

-(void)reload{

    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if([self.dataSource respondsToSelector:@selector(numberOfRowsInpickerTableView:)]){
        return [self.dataSource numberOfRowsInpickerTableView:self];
    }
    return MIN_NUM_OF_ROW;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.rowHeight;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    DWPickerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DWPickerViewCellID];
    NSString *titleString = [self.delegate respondsToSelector:@selector(pickerTableView:titleForRow:)] ? [self.delegate pickerTableView:self titleForRow:indexPath.row] : @"";
    cell.pikerLabel.text = titleString;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == 0 && !self.colorCell) {
        self.colorCell = cell;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    self.selectRow = indexPath.row;
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

}


#pragma mark - scrollview

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat endOffset = (scrollView.contentOffset.y +(self.tableView.frame.size.height - self.rowHeight)/2);
    CGFloat before    = self.selectRow * self.rowHeight;

    CGFloat position = (scrollView.contentOffset.y +(self.tableView.frame.size.height - self.rowHeight)/2) / self.rowHeight;
    position = position < MIN_NUM_OF_ROW ? MIN_NUM_OF_ROW : position;
    NSInteger count  = (NSInteger)MAX(fabs(position-0.5), fabs(position+0.5));
    count = count >  (MAX_NUM_OF_ROW - 1) ? (MAX_NUM_OF_ROW - 1) : count;



    if(fabs(before - endOffset) * 2 > self.rowHeight){

        if ( self.colorCell != [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:NUM_OF_SECTION]]) {
            self.colorCell.pikerLabel.textColor = [UIColor blackColor];
            self.colorCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:NUM_OF_SECTION]];
            AudioServicesPlaySystemSound(1105);
        }
    } else {
        self.colorCell.pikerLabel.textColor = [UIColor blackColor];
        self.colorCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectRow inSection:NUM_OF_SECTION]];

    }



}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self adjustContentOffset:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) [self adjustContentOffset:scrollView];
}

/**
 *  滑动结束使 cell 滑动到最中央
 *
 *  @param scrollView 需要滑动的 scrollView （用来获取滑动距离）
 */
-(void)adjustContentOffset:(UIScrollView *)scrollView{

    if ([self.tableView numberOfRowsInSection:NUM_OF_SECTION] == 0) return;

    CGFloat position = (scrollView.contentOffset.y +(self.tableView.frame.size.height - self.rowHeight)/2) / self.rowHeight;
    position = position < MIN_NUM_OF_ROW ? MIN_NUM_OF_ROW : position;
    NSInteger count  = (NSInteger)MAX(fabs(position-0.5), fabs(position+0.5));
    count = count >  (MAX_NUM_OF_ROW - 1) ? (MAX_NUM_OF_ROW - 1) : count;
    self.selectRow = count;
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - getter && setter

-(void)setRowHeight:(CGFloat)rowHeight{
    _rowHeight = rowHeight;
    CGFloat offsetY = (self.tableView.frame.size.height - self.rowHeight)/2;
    self.tableView.contentOffset  = CGPointMake(0,offsetY);
    self.tableView.contentInset   = UIEdgeInsetsMake(offsetY, 0, offsetY, 0);

}

-(void)setColorCell:(DWPickerViewCell *)colorCell{

    _colorCell = colorCell;
    colorCell.pikerLabel.textColor = self.highlightColor;
}

-(void)setSelectRow:(NSInteger)selectRow{
    _selectRow = selectRow;
    if ([self.delegate respondsToSelector:@selector(pickerTableView:didSelectRow:)]) {
        [self.delegate pickerTableView:self didSelectRow:selectRow];
    }
}

-(UITableView *)tableView{

    if (!_tableView) {

        UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];

        tableView.showsHorizontalScrollIndicator = NO;
        tableView.showsVerticalScrollIndicator   = NO;
        tableView.pagingEnabled                  = NO;

        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[DWPickerViewCell class] forCellReuseIdentifier:DWPickerViewCellID];
        tableView.delegate = self;
        tableView.dataSource = self;
        _tableView = tableView;
        tableView.backgroundColor = [UIColor clearColor];
    }
    
    return _tableView;
}



@end





