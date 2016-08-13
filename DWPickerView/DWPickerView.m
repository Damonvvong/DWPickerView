//
//  DWPickerView.m
//  DWPickerView
//
//  Created by Damon on 16/3/13.
//  Copyright © 2016年 damonwong. All rights reserved.
//

#import "DWPickerView.h"
#import "DWPickerTableView.h"

#define DEFAULT_HIGHLIGHTCOLOR [UIColor redColor]

@interface DWPickerView ()<DWPickerTableViewDataSource,DWPickerTableViewDelegate>

@property (nonatomic, assign) BOOL didLoad;/**< 完成加载 */

@property (nonatomic, strong) NSMutableArray *pickerTableViews;/**< 选择列表数组 */



@end

@implementation DWPickerView


#pragma mark - life cycle
-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {

        [self setUp];
    }

    return self;
}

-(void)awakeFromNib{

    [self setUp];
}

/**
 *  一些初始化
 */
-(void)setUp{
    self.didLoad = NO;
    [self addSubview:self.selectedView];
    self.highlightColor = DEFAULT_HIGHLIGHTCOLOR;
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1;
}

#pragma mark - public method 


- (void)reloadComponent:(NSInteger)component
{
    if(!self.didLoad){ [self layoutSubviews]; }

    if(component >= 0 && component < self.pickerTableViews.count){
        DWPickerTableView *picker = self.pickerTableViews[component];
        [picker reload];
    }
}

- (void)reload{

    for (DWPickerTableView *picker in self.pickerTableViews) {
        [picker reload];
    }
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
//    if(!self.didLoad){ [self layoutSubviews]; }


    if(component >= 0 && component < self.pickerTableViews.count){
        DWPickerTableView *picker = self.pickerTableViews[component];
        [picker selectRow:row animated:animated];
    }
}

- (NSInteger)selectedRowInComponent:(NSInteger)component
{

    if(component >= 0 && component < self.pickerTableViews.count){
        DWPickerTableView *picker = self.pickerTableViews[component];
        return picker.selectRow;
    }
    return 0;
}

#pragma mark - private method

- (CGFloat)widthForComponent:(NSInteger)component
{
    if([self.delegate respondsToSelector:@selector(pickerView:widthForComponent:)]){
        return [self.delegate pickerView:self widthForComponent:component];
    }
    return 0;
}

#pragma mark- view layout
-(void)layoutSubviews{

    [super layoutSubviews];

    self.selectedView.frame = CGRectMake(0, (self.frame.size.height  - self.rowHeight) / 2, self.frame.size.width, self.rowHeight);

    if (self.didLoad) return;
    NSInteger number = [self.dataSource numberOfComponentsInPickerView:self];
    CGFloat pickerX = 0;

    for(NSInteger i = 0; i < number; ++i ){
        CGFloat pickerWidth = [self widthForComponent:i];
        if( pickerWidth == 0){ pickerWidth = self.frame.size.width / number;}


        DWPickerTableView *picker = nil;
        if (i < self.pickerTableViews.count) {
            picker = self.pickerTableViews[i];
            picker.frame = CGRectMake(pickerX, 0, pickerWidth, self.frame.size.height);
        } else {
            picker = [[DWPickerTableView alloc] initWithFrame:CGRectMake(pickerX, 0, pickerWidth, self.frame.size.height)];
            picker.highlightColor = self.highlightColor;
            [self.pickerTableViews addObject:picker];
            [self addSubview:picker];
        }

        picker.delegate = self;
        picker.dataSource = self;
        picker.indexOfComponents = i;
        [picker reload];
        picker.rowHeight = self.rowHeight;

        pickerX += pickerWidth;

    }
    for(NSInteger i = self.pickerTableViews.count - 1; i >= number; --i){
        DWPickerTableView *picker = [self.pickerTableViews objectAtIndex:i];
        [picker removeFromSuperview];
        [self.pickerTableViews removeObject:picker];
    }

    [self bringSubviewToFront:self.selectedView];


    _didLoad = YES;

    

}


#pragma mark - DWPickerTableViewDelegate,DWPickerTableViewDataSource

-(NSInteger)numberOfRowsInpickerTableView:(DWPickerTableView *)pickerTableView{

    if([self.dataSource respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)]){
        return [self.dataSource pickerView:self numberOfRowsInComponent:pickerTableView.indexOfComponents];
    }
    return 0;
}

-(NSString *)pickerTableView:(DWPickerTableView *)pickerTableView titleForRow:(NSInteger)row{


    if([self.delegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)]){
        return [self.delegate pickerView:self titleForRow:row forComponent:pickerTableView.indexOfComponents];
    }
    return [NSString stringWithFormat:@"%ld - %ld", (long)pickerTableView.indexOfComponents, (long)row];

}

-(void)pickerTableView:(DWPickerTableView *)pickerTableView didSelectRow:(NSInteger)row{

    if([self.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]){
        [self.delegate pickerView:self didSelectRow:row inComponent:pickerTableView.indexOfComponents];
    }

}


#pragma mark - getter && setter 

- (NSMutableArray *)pickerTableViews{

    if (!_pickerTableViews) {
        NSMutableArray *array = [NSMutableArray array];
        _pickerTableViews = array;

    }
    return  _pickerTableViews;
}


- (UIView *)selectedView{


    if (!_selectedView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        view.layer.borderWidth = 1;
        view.userInteractionEnabled = NO;
        _selectedView = view;
    }

    return _selectedView;
}

@end
