
@import UserNotifications;
#import "AppDelegate.h"
#import <Gimbal/Gimbal.h>

static NSTimeInterval const NotificationTimeInterval = 30; // Thirty seconds

@interface AppDelegate () <GMBLBeaconManagerDelegate>
@property (nonatomic) GMBLBeaconManager *beaconManager;
@property (nonatomic) UNUserNotificationCenter *center;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.center = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
    [self.center requestAuthorizationWithOptions:options
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (!granted) {
                                  NSLog(@"Something went wrong");
                              }
                          }];
    
    [Gimbal setAPIKey:@"COMPANY_API_KEY" options:nil];
    
    self.beaconManager = [GMBLBeaconManager new];
    self.beaconManager.delegate = self;
    
    [self.beaconManager startListening];
    
    [Gimbal start];
    
    return YES;
}

# pragma mark - Gimbal Beacon Manager Delegate methods
- (void) beaconManager:(GMBLBeaconManager *)manager didReceiveBeaconSighting:(GMBLBeaconSighting *)sighting {
    NSString *beaconID = sighting.beacon.identifier;
    NSLog(@"Beacon Sighted id: %@", beaconID);
    [self createLocalNotification:beaconID];
}

# pragma mark - Send Local Notification
- (void) createLocalNotification: (NSString *)beaconID {
    
    UNMutableNotificationContent *notification = [[UNMutableNotificationContent alloc] init];
    notification.title = @"Gimbal Beacon Sighted";
    notification.body = [NSString stringWithFormat:@"You are receiving a notification for %@", beaconID];
    notification.sound = [UNNotificationSound defaultSound];
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    
    UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier:@"LocalNotification" content:notification trigger:trigger];
    
    [self.center addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"There was an error with the request");
        }
    }];
}


@end
