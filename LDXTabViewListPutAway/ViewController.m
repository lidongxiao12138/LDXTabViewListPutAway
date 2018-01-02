//
//  ViewController.m
//  LDXTabViewListPutAway
//
//  Created by 李东晓 on 2016/12/16.
//  Copyright © 2016年 blank. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger arrayOf;//数组第几个
    NSMutableArray * NumberOneArray;//装载1的数组

}
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *sectionArray;//section标题
@property(nonatomic, strong)NSMutableArray *rowInSectionArray;//section中的cell个数
@property(nonatomic, strong)NSMutableArray *selectedArray;//是否被点击
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0 ,20 , self.view.frame.size.width, self.view.frame.size.height)style:UITableViewStylePlain];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    
    _sectionArray = [NSMutableArray arrayWithObjects:@"标题1",@"标题2",@"标题3",@"标题4", nil];//每个分区的标题
    _rowInSectionArray = [NSMutableArray arrayWithObjects:@"4",@"2",@"5",@"6", nil];//每个分区中cell的个数
    _selectedArray = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0", nil];//这个用于判断展开还是缩回当前section的cell
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark cell的内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = _sectionArray[indexPath.section];
    return cell;
}

#pragma mark cell的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //判断section的标记是否为1,如果是说明为展开,就返回真实个数,如果不是就说明是缩回,返回0.
    if ([_selectedArray[section] isEqualToString:@"1"]) {
        return [_rowInSectionArray[section]integerValue];
    }
    return 0;
}
#pragma mark section的个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionArray.count;
}

#pragma cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

#pragma mark - section内容
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //每个section上面有一个button,给button一个tag值,用于在点击事件中改变_selectedArray[button.tag - 1000]的值
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375, 40)];
    sectionView.backgroundColor = [UIColor greenColor];
    UIButton *sectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sectionButton.frame = sectionView.frame;
    [sectionButton setTitle:[_sectionArray objectAtIndex:section] forState:UIControlStateNormal];
    [sectionButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    sectionButton.tag = 1000 + section;
    [sectionView addSubview:sectionButton];
    return sectionView;
}
#pragma mark button点击方法
-(void)buttonAction:(UIButton *)button
{
    //判断展开的样式为第几个
    arrayOf = [_selectedArray indexOfObject:@"1"];
    NumberOneArray = [[NSMutableArray alloc]init];
    //如果有1的样式就装到数组里
    for (NSString * str in _selectedArray) {
        if ([str isEqualToString:@"1"]) {
            [NumberOneArray addObject:str];
        }
    }
    //如果展开的位置与button的tag值不相等，并且数组里有1。走以下方法，点开其它列表时关闭别的展开列表
    if (button.tag-1000 != arrayOf && NumberOneArray.count != 0) {
        if ([_selectedArray[arrayOf] isEqualToString:@"0"]) {
            
            //如果当前点击的section是缩回的,那么点击后就需要把它展开,是_selectedArray对应的值为1,这样当前section返回cell的个数就变为真实个数,然后刷新这个section就行了
            
            [_selectedArray replaceObjectAtIndex:arrayOf withObject:@"1"];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:arrayOf] withRowAnimation:UITableViewRowAnimationMiddle];
            //            [_tableView reloadData];
        }
        else
        {
            
            //如果当前点击的section是展开的,那么点击后就需要把它缩回,使_selectedArray对应的值为0,这样当前section返回cell的个数变成0,然后刷新这个section就行了

            [_selectedArray replaceObjectAtIndex:arrayOf withObject:@"0"];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:arrayOf] withRowAnimation:UITableViewRowAnimationMiddle];

//            [_tableView reloadData];
            
        }
        
    }
    
    //当点击自己时可触发自己展开收回的方法
    if ([_selectedArray[button.tag - 1000] isEqualToString:@"0"]) {
        
        //如果当前点击的section是缩回的,那么点击后就需要把它展开,是_selectedArray对应的值为1,这样当前section返回cell的个数就变为真实个数,然后刷新这个
        
        [_selectedArray replaceObjectAtIndex:button.tag - 1000 withObject:@"1"];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:button.tag - 1000] withRowAnimation:UITableViewRowAnimationMiddle];
        //        [_tableView reloadData];
    }
    else
    {
        
        //如果当前点击的section是展开的,那么点击后就需要把它缩回,使_selectedArray对应的值为0,这样当前section返回cell的个数变成0,然后刷新这个section就行了
        
        [_selectedArray replaceObjectAtIndex:button.tag - 1000 withObject:@"0"];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:button.tag - 1000] withRowAnimation:UITableViewRowAnimationMiddle];
        
//        [_tableView reloadData];
    }
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
