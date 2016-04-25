#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@implementation UIAlertController (Additions)

static const char *HANDLER_KEY = "com.microsoft.adal.alertviewHandler";

static UIAlertController *alert;

+ (void)presentCredentialAlert:(void (^)(NSUInteger))handler {
    
    alert = [UIAlertController
             alertControllerWithTitle:@"Enter your credentials"
             message:nil
             preferredStyle:UIAlertViewStyleLoginAndPasswordInput];
   
    
    
  /*
    alert = [[UIAlertController alloc] initWithTitle:NSLocalizedString(@"Enter your credentials", nil)
                                       message:nil
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                             otherButtonTitles: nil];
    */
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Login" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //do something when click button
        
       
        
    
        
    }];
    [alert addAction:okAction];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //do something when click button
        
        
    }];
    [alert addAction:noAction];
    
    
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    
    [alert addButtonWithTitle:NSLocalizedString(@"Login", nil)];
    [alert setDelegate:alert];
    
    if (handler)
        objc_setAssociatedObject(alert, HANDLER_KEY, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        [vc presentViewController:alert animated:YES completion:nil];
        
        //[alert show];
    });
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    id handler = objc_getAssociatedObject(alertView, HANDLER_KEY);
    
    if (handler)
        ((void(^)())handler)(buttonIndex);
}

+ (id) getAlertInstance
{
    return alert;
}

@end