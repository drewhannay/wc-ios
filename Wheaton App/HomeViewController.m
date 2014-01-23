//
//  HomeViewController.m
//  Wheaton App
//
//  Created by Chris Anderson on 11/11/13.
//
//

#import "HomeViewController.h"
#import "WhosWhoDetailViewController.h"
#import "WhoswhoTableCell.h"
#import "Person.h"


@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize switchViewControllers, allViewControllers, currentViewController, viewContainer, searchResults;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIViewController *pVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PastHome"];
    
    pVC.view.frame = CGRectMake(0,
                                0,
                                CGRectGetWidth(self.viewContainer.bounds),
                                CGRectGetHeight(self.viewContainer.bounds));
    
    [self addChildViewController:pVC];
    [self.viewContainer addSubview:pVC.view];
    
    
//    // Add A and B view controllers to the array
//    self.allViewControllers = [[NSArray alloc] initWithObjects:pVC,pVC,pVC, nil];
//    
//    // Ensure a view controller is loaded
//    self.switchViewControllers.selectedSegmentIndex = priorSegmentIndex = 0;
//    [self cycleFromViewController:self.currentViewController toViewController:[self.allViewControllers objectAtIndex:self.switchViewControllers.selectedSegmentIndex] direction:YES];
//    [self.switchViewControllers addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
//    
//    UISwipeGestureRecognizer *leftRecognizer;
//    leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
//    [leftRecognizer setDirection: UISwipeGestureRecognizerDirectionLeft];
//    [[self view] addGestureRecognizer:leftRecognizer];
//    
//    UISwipeGestureRecognizer *rightRecognizer;
//    rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
//    [rightRecognizer setDirection: UISwipeGestureRecognizerDirectionRight];
//    [[self view] addGestureRecognizer:rightRecognizer];
    
    self.searchDisplayController.searchBar.placeholder = @"Who's Who";
    self.searchDisplayController.searchBar.clipsToBounds = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UITextView *searchTextField = [self.searchDisplayController.searchBar valueForKey:@"_searchField"];
    searchTextField.textColor = [UIColor whiteColor];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    if (![MTReachabilityManager isReachableViaWiFi]) {
        [self.searchDisplayController.searchBar setUserInteractionEnabled:NO];
        [self.searchDisplayController.searchBar setPlaceholder:@"Please Connect to Campus Network"];
    }
}

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}


#pragma mark - View controller switching and saving

- (void)cycleFromViewController:(UIViewController*)oldVC toViewController:(UIViewController*)newVC direction:(BOOL)dir {
    
    int distance = 0;
    
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
                                      -distance,
                                      CGRectGetWidth(self.viewContainer.bounds),
                                      CGRectGetHeight(self.viewContainer.bounds)+distance);
        
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
                                                                      -distance,
                                                                      CGRectGetWidth(self.viewContainer.bounds),
                                                                      CGRectGetHeight(self.viewContainer.bounds)+distance);
                                    }
                                    completion:^(BOOL finished) {
                                        // Finish both the view controller transitions
                                        [oldVC removeFromParentViewController];
                                        [newVC didMoveToParentViewController:self];
                                        // Store a reference to the current controller
                                        self.currentViewController = newVC;
                                    }];
            
        } else {
            
            newVC.view.frame = CGRectMake(CGRectGetMinX(self.viewContainer.bounds),
                                          -distance,
                                          CGRectGetWidth(self.viewContainer.bounds),
                                          CGRectGetHeight(self.viewContainer.bounds)+distance);
            
            
//            NSLog(@"%@", newVC.view);
//            NSLog(@"%f", ((UIScrollView *)newVC.view).contentSize.height);
//
//            
//            NSLog(@"%@", [((UIScrollView *)newVC.view).subviews objectAtIndex:0]);
//            NSLog(@"%f", ((UIScrollView *)newVC.view).contentSize.height);
//            
//            
//            NSLog(@"%@", newVC.view);
            
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




- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [LVDebounce fireAfter:0.5 target:self selector:@selector(performSearch:) userInfo:searchString];
    return YES;
}

- (void)performSearch:(NSTimer *)timer
{
    NSString *searchString = [timer userInfo];
    
    //NSLog(@"Perform Search");
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{ @"name": searchString, @"limit": @"20" };
    [manager GET:c_Whoswho parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *resultsArray = responseObject;
        searchResults = [[NSMutableArray alloc] init];
        
        //NSLog(@"Got Results %d", [resultsArray count]);
        
        for (NSDictionary* dic in resultsArray) {
            NSDictionary *name = [dic objectForKey:@"name"];
            
            Person *person = [[Person alloc] init];
            person.firstName = [name objectForKey:@"first"];
            person.prefName = [name objectForKey:@"preferred"];
            person.lastName = [name objectForKey:@"last"];
            person.email = [dic objectForKey:@"email"];
            person.classification = @"N/A";
            if (![person.classification isEqual:[NSNull null]]) {
                person.classification = [dic objectForKey:@"classification"];
            }
            person.photo = [[[dic objectForKey:@"image"] objectForKey:@"url"] objectForKey:@"medium"];
            [searchResults addObject:person];
        }
        
        [self.searchDisplayController.searchResultsTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}





- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardWillHide
{
    UITableView *tableView = [[self searchDisplayController] searchResultsTableView];
    
    [tableView setContentInset:UIEdgeInsetsZero];
    [tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"WhoswhoTableCell";
    WhoswhoTableCell *cell = (WhoswhoTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Person *person = (Person *)[searchResults objectAtIndex:indexPath.row];
    
    cell.firstName.text = [NSString stringWithFormat:@"%@", [person fullName]];
    
    NSString *imagename = person.photo;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imagename]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:60.0];
    
    [cell.profileImage setImageWithURLRequest:request
                     placeholderImage:[UIImage imageNamed:@"default-image"]
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                  cell.profileImage.image = image;
                              }
                              failure:nil];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        Person *selectedPerson = (Person *)[self.searchResults objectAtIndex:indexPath.row];
            
        WhosWhoDetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"WhosWhoDetail"];
        detail.title = selectedPerson.firstName;
        detail.person = selectedPerson;
            
        [self.navigationController pushViewController:detail animated:YES];
    }
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
