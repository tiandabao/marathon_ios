//
//  ReminderViewController.m
//  marathon
//
//  Created by Ryan on 13-10-16.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import "ReminderViewController.h"

@interface ReminderViewController ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ReminderViewController
@synthesize dataArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = BASE_PAGE_BG_COLOR;
    
    //drink
    UILabel *drinkLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 160, 18)];
    drinkLabel.backgroundColor = [UIColor clearColor];
    drinkLabel.font = HEI_(12);
    drinkLabel.textColor = LIGHT_GRAY_TEXT_COLOR;
    drinkLabel.text = @"Drinking Reminder";
    [self.view addSubview:drinkLabel];
    
    UILabel *drink20Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 85, 20)];
    drink20Label.backgroundColor = [UIColor clearColor];
    drink20Label.font = HEI_(14);
    drink20Label.textColor = [UIColor whiteColor];
    drink20Label.text = @"every 20 min";
    [self.view addSubview:drink20Label];
    
    UISwitch *drink20Switch = [[UISwitch alloc] initWithFrame:CGRectMake(95, 57, 0, 0)];
    drink20Switch.tag = 10000;
    drink20Switch.frame = CGRectMake(190-10-drink20Switch.frame.size.width, drink20Switch.frame.origin.y, drink20Switch.frame.size.width, drink20Switch.frame.size.height);
    [drink20Switch addTarget:self action:@selector(drink_switch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:drink20Switch];
    
    UILabel *drink30Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 85, 20)];
    drink30Label.backgroundColor = [UIColor clearColor];
    drink30Label.font = HEI_(14);
    drink30Label.textColor = [UIColor whiteColor];
    drink30Label.text = @"every 30 min";
    [self.view addSubview:drink30Label];
    
    UISwitch *drink30Switch = [[UISwitch alloc] initWithFrame:CGRectMake(95, 97, 0, 0)];
    drink30Switch.tag = 10001;
    drink30Switch.frame = CGRectMake(190-10-drink30Switch.frame.size.width, drink30Switch.frame.origin.y, drink30Switch.frame.size.width, drink30Switch.frame.size.height);
    [drink30Switch addTarget:self action:@selector(drink_switch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:drink30Switch];
    
    UILabel *drink60Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, 85, 20)];
    drink60Label.backgroundColor = [UIColor clearColor];
    drink60Label.font = HEI_(14);
    drink60Label.textColor = [UIColor whiteColor];
    drink60Label.text = @"every 60 min";
    [self.view addSubview:drink60Label];
    
    UISwitch *drink60Switch = [[UISwitch alloc] initWithFrame:CGRectMake(95, 137, 0, 0)];
    drink60Switch.tag = 10002;
    drink60Switch.frame = CGRectMake(190-10-drink60Switch.frame.size.width, drink60Switch.frame.origin.y, drink60Switch.frame.size.width, drink60Switch.frame.size.height);
    [drink60Switch addTarget:self action:@selector(drink_switch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:drink60Switch];
    
    // energy
    UILabel *energyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 160, 18)];
    energyLabel.backgroundColor = [UIColor clearColor];
    energyLabel.font = HEI_(12);
    energyLabel.textColor = LIGHT_GRAY_TEXT_COLOR;
    energyLabel.text = @"Energy Bar Reminder";
    [self.view addSubview:energyLabel];
    
    UILabel *energy1Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 240, 85, 20)];
    energy1Label.backgroundColor = [UIColor clearColor];
    energy1Label.font = HEI_(14);
    energy1Label.textColor = [UIColor whiteColor];
    energy1Label.text = @"every 1 hour";
    [self.view addSubview:energy1Label];
    
    UISwitch *energy1Switch = [[UISwitch alloc] initWithFrame:CGRectMake(95, 237, 0, 0)];
    energy1Switch.tag = 10000;
    energy1Switch.frame = CGRectMake(190-10-energy1Switch.frame.size.width, energy1Switch.frame.origin.y, energy1Switch.frame.size.width, energy1Switch.frame.size.height);
    [energy1Switch addTarget:self action:@selector(energy_switch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:energy1Switch];
    
    UILabel *energy15Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 280, 85, 20)];
    energy15Label.backgroundColor = [UIColor clearColor];
    energy15Label.font = HEI_(14);
    energy15Label.textColor = [UIColor whiteColor];
    energy15Label.text = @"every 1.5 hour";
    [self.view addSubview:energy15Label];
    
    UISwitch *energy15Switch = [[UISwitch alloc] initWithFrame:CGRectMake(95, 277, 0, 0)];
    energy15Switch.tag = 10001;
    energy15Switch.frame = CGRectMake(190-10-energy15Switch.frame.size.width, energy15Switch.frame.origin.y, energy15Switch.frame.size.width, energy15Switch.frame.size.height);
    [energy15Switch addTarget:self action:@selector(energy_switch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:energy15Switch];
    
    UILabel *energy2Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 320, 85, 20)];
    energy2Label.backgroundColor = [UIColor clearColor];
    energy2Label.font = HEI_(14);
    energy2Label.textColor = [UIColor whiteColor];
    energy2Label.text = @"every 2 hour";
    [self.view addSubview:energy2Label];
    
    UISwitch *energy2Switch = [[UISwitch alloc] initWithFrame:CGRectMake(95, 317, 0, 0)];
    energy2Switch.tag = 10002;
    energy2Switch.frame = CGRectMake(190-10-energy2Switch.frame.size.width, energy2Switch.frame.origin.y, energy2Switch.frame.size.width, energy2Switch.frame.size.height);
    [energy2Switch addTarget:self action:@selector(energy_switch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:energy2Switch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Method
- (void)drink_switch:(id)sender{
    
}

- (void)energy_switch:(id)sender{
    
}

@end
