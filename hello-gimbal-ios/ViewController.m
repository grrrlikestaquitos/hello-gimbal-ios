
#import "ViewController.h"

@interface ViewController ()
@property (nonatomic) NSMutableArray *placeEvents;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.placeEvents = [NSMutableArray new];
}


# pragma mark - Table View methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.placeEvents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}


@end
