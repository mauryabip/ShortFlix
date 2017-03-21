/*

*/

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface RearViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>{
    NSArray *lblArr;
    NSArray *lblArr2;
    NSArray *lblArr3;
    NSArray *lblArr4;
    NSArray *lblArr5;
    NSArray *lblArr31;
    NSMutableArray *arr;
    NSString *colorChangedStr;
}

@property (weak, nonatomic) IBOutlet UITableView *rearTableView;


@end