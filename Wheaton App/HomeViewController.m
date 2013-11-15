//
//  HomeViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 11/11/13.
//
//

#import "HomeViewController.h"
#import "MasterTabViewController.h"
#import "Person.h"


@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize switchViewControllers, allViewControllers, currentViewController, people, searchController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIViewController *pVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PastHome"];
    
    // Add A and B view controllers to the array
    self.allViewControllers = [[NSArray alloc] initWithObjects:pVC,pVC,pVC, nil];
    
    // Ensure a view controller is loaded
    self.switchViewControllers.selectedSegmentIndex = priorSegmentIndex = 0;
    [self cycleFromViewController:self.currentViewController toViewController:[self.allViewControllers objectAtIndex:self.switchViewControllers.selectedSegmentIndex] direction:YES];
    [self.switchViewControllers addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    
    UISwipeGestureRecognizer *leftRecognizer;
    leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [leftRecognizer setDirection: UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:leftRecognizer];
    
    UISwipeGestureRecognizer *rightRecognizer;
    rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [rightRecognizer setDirection: UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:rightRecognizer];
    
}


#pragma mark - View controller switching and saving

- (void)cycleFromViewController:(UIViewController*)oldVC toViewController:(UIViewController*)newVC direction:(BOOL)dir {
    
    // Do nothing if we are attempting to swap to the same view controller
    if (newVC == oldVC) return;
    
    // Check the newVC is non-nil otherwise expect a crash: NSInvalidArgumentException
    if (newVC) {
        int newStartX = CGRectGetMinX(self.viewContainer.bounds) - CGRectGetWidth(self.viewContainer.bounds);
        int oldEndX = CGRectGetMinX(self.viewContainer.bounds) + CGRectGetWidth(self.viewContainer.bounds);
        if (dir) {
            newStartX = CGRectGetWidth(self.viewContainer.bounds) + CGRectGetMinX(self.viewContainer.bounds);
            oldEndX = CGRectGetMinX(self.viewContainer.bounds) - CGRectGetWidth(self.viewContainer.bounds);
        }
        
        newVC.view.frame = CGRectMake(newStartX,
                                      CGRectGetMinY(self.viewContainer.bounds),
                                      CGRectGetWidth(self.viewContainer.bounds),
                                      CGRectGetHeight(self.viewContainer.bounds)-self.tabBarController.tabBar.frame.size.height);
        
        // Check the oldVC is non-nil otherwise expect a crash: NSInvalidArgumentException
        if (oldVC) {
            
            // Start both the view controller transitions
            [oldVC willMoveToParentViewController:nil];
            [self addChildViewController:newVC];
            
            // Swap the view controllers
            // No frame animations in this code but these would go in the animations block
            [self transitionFromViewController:oldVC
                              toViewController:newVC
                                      duration:0.15
                                       options:UIViewAnimationOptionLayoutSubviews
                                    animations:^{
                                        newVC.view.frame = oldVC.view.frame;
                                        oldVC.view.frame = CGRectMake(oldEndX,
                                                                      CGRectGetMinY(self.viewContainer.bounds),
                                                                      CGRectGetWidth(self.viewContainer.bounds),
                                                                      CGRectGetHeight(self.viewContainer.bounds)-self.tabBarController.tabBar.frame.size.height);
                                    }
                                    completion:^(BOOL finished) {
                                        // Finish both the view controller transitions
                                        [oldVC removeFromParentViewController];
                                        [newVC didMoveToParentViewController:self];
                                        // Store a reference to the current controller
                                        self.currentViewController = newVC;
                                    }];
            
        } else {
            
            newVC.view.frame = CGRectMake(CGRectGetMinX(self.viewContainer.bounds), CGRectGetMinY(self.viewContainer.bounds), CGRectGetWidth(self.viewContainer.bounds), CGRectGetHeight(self.viewContainer.bounds)-10);
            
            
            NSLog(@"%@", newVC.view);
            NSLog(@"%f", ((UIScrollView *)newVC.view).contentSize.height);

            
            NSLog(@"%@", [((UIScrollView *)newVC.view).subviews objectAtIndex:0]);
            NSLog(@"%f", ((UIScrollView *)newVC.view).contentSize.height);
            
            
            NSLog(@"%@", newVC.view);
            
            // Otherwise we are adding a view controller for the first time
            // Start the view controller transition
            [self addChildViewController:newVC];
            
            [self.viewContainer addSubview:newVC.view];
            
            // End the view controller transition
            [newVC didMoveToParentViewController:self];
            
            // Store a reference to the current controller
            self.currentViewController = newVC;
        }
    }
}

- (void)handleSwipeRight:(id)swipe {
    NSUInteger index = self.switchViewControllers.selectedSegmentIndex;
    index = priorSegmentIndex = self.switchViewControllers.selectedSegmentIndex = (index - 1) % 3;
    UIViewController *incomingViewController = [self.allViewControllers objectAtIndex:index];
    [self cycleFromViewController:self.currentViewController toViewController:incomingViewController direction:NO];
}

- (void)handleSwipeLeft:(id)swipe {
    NSUInteger index = self.switchViewControllers.selectedSegmentIndex;
    index = priorSegmentIndex = self.switchViewControllers.selectedSegmentIndex = (index + 1) % 3;
    UIViewController *incomingViewController = [self.allViewControllers objectAtIndex:index];
    [self cycleFromViewController:self.currentViewController toViewController:incomingViewController direction:YES];
}

- (IBAction)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender {
    
    NSUInteger index = sender.selectedSegmentIndex;
    
    if (UISegmentedControlNoSegment != index) {
        BOOL direction = NO;
        if (priorSegmentIndex < index)
            direction = YES;
        
        UIViewController *incomingViewController = [self.allViewControllers objectAtIndex:index];
        [self cycleFromViewController:self.currentViewController toViewController:incomingViewController direction:direction];
    }
    priorSegmentIndex = index;
    
}









- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [people count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [(Person *)[people objectAtIndex:indexPath.row] fullName]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"SELECTED");
}

- (void)makeSearch:(NSString *)filter
{
    NSString *searchParameter = [filter stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    searchParameter = [searchParameter stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    if([searchParameter isEqualToString:@""]) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@",c_Whoswho, searchParameter]]];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}


- (void)fetchedData:(id)responseData
{
    if (responseData == nil) {
        return;
    }
    NSError* error;
    NSArray *resultsArray = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    people = [[NSMutableArray alloc] init];
    
    for (NSDictionary* dic in resultsArray) {
        
        Person *person = [[Person alloc] init];
        
        NSDictionary *name = [dic objectForKey:@"name"];
        
        person.firstName = [name objectForKey:@"first"];
        person.lastName = [name objectForKey:@"last"];
        person.email = [dic objectForKey:@"email"];
        
        NSLog(@"%@", [name objectForKey:@"last"]);
        
        [people addObject:person];
    }
    [searchController.searchResultsTableView reloadData];
}

#pragma mark - UISearchDisplayController delegate methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self makeSearch:searchString];
    
    return YES;
}








- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
