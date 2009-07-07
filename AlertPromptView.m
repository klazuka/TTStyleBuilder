//
//  AlertPromptView.m
//  mJob
//
//  Created by Jeff Lamarche
//  see http://iphonedevelopment.blogspot.com/2009/02/alert-view-with-prompt.html
//

#import "AlertPromptView.h"

@implementation AlertPromptView

@synthesize textField;
@synthesize enteredText;

- (id)initWithTitle:(NSString *)title message:(NSString *)message placeholder:(NSString *)placeholder text:(NSString *)text delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okayButtonTitle
{
    if (self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okayButtonTitle, nil]) {
        
        UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 28.0)]; 
        [theTextField setBackgroundColor:[UIColor whiteColor]];
        if (text)
            [theTextField setText:text];
        else
            [theTextField setPlaceholder:placeholder];
        [theTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [theTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [theTextField setBorderStyle:UITextBorderStyleBezel];
        [self addSubview:theTextField];
        self.textField = theTextField;
        [theTextField release];
        // move it above the keyboard instead of centered on-screen
        CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 110.0); 
        [self setTransform:translate];
    }
    return self;
}

- (void)show
{
    [textField becomeFirstResponder];
    [super show];
}

- (NSString *)enteredText
{
    return textField.text;
}

- (void)dealloc
{
    [textField release];
    [super dealloc];
}

@end