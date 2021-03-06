//
//  GameViewController.m
//  CrazyRocketManApp
//
//  Created by Regie G. Pinat on 10/18/12.
//  Copyright (c) 2012 Regie G. Pinat. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController
@synthesize arrayOfPlatforms;
@synthesize arrayOfCoins;
@synthesize arrayOfEnemies;

@synthesize arrayOfOil;
@synthesize arrayOfRefinery;
@synthesize arrayOfCoil;
@synthesize arrayOfBattery;
@synthesize arrayOfTesla;





UIView  *viewPause;
UILabel *labelPause;
UIImageView *lives[3];

//G vars
float xpos =0;
float ypos;

float maxDistanceBetweenStep ;
float minDistanceBetweenStep ;
float distanceBetweenSteps=100, distanceyBetweenSteps = 60;
float accelmoveX=0,deltaX=0,deltaY=0;


int coinsCounts;
int platformsFinished;
int rocketDuration = 10,magnetDuration=10,shieldDuration=10;
float life;

int gasNum;
int refNum;
int coilNum;
int batteryNum;
int teslaNum;


int randomizeCoin=1;
int level=1;
int gameFinishLevel=4;


BOOL delayTime = YES;
BOOL NeedsTojump = NO;
BOOL mainJumping = NO;
BOOL gameSuspended = NO;
//Power Ups
BOOL rocketOn =NO;
BOOL magnetOn = NO;
BOOL shieldOn = NO;


//Pause
BOOL pauseOn = NO;


//how quickly should the jump start off
float jumpSpeedLimit = 15;
//the current speed of the jump;
float jumpSpeed;
//platform speed;
float platformSpeedmove;
//Enemy Respawn time
float enemyRespawnTime;
//Oil RespawnRate
float oilRespawnTime;
//refinery RespawnRate
float refineryRespawnTime;

CGPoint rocketManNewPosition;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
     
        
 
        
   
        
        
        
        
        
        
        
        
         //Accelerometer
        accelerometer = [UIAccelerometer sharedAccelerometer];
        accelerometer.delegate = self;
        [accelerometer setUpdateInterval:.07];
        
         //Platforms
          arrayOfPlatforms= [NSMutableArray array];
          CGSize stepRect = CGSizeMake(100, 35);
           ypos= (self.view.bounds.size.height)-stepRect.height;  
          
        for (int i=0; i<kNumOfPlatforms ; i++)
        {
       
           if ([arrayOfPlatforms count]>0)
           {
               
             //Previous Object add to be reference
               UIImageView *before= [arrayOfPlatforms objectAtIndex:i-1];
               
               
               maxDistanceBetweenStep = before.center.x + distanceBetweenSteps;
               minDistanceBetweenStep = before.center.x - distanceBetweenSteps;
               
               if (maxDistanceBetweenStep > [self view].frame.size.width - (stepRect.width)-10)
               {
                   xpos = [self getRandomNumber:minDistanceBetweenStep to:([self view].frame.size.width - (stepRect.width/2)-10) ];
               }
               
               else if(minDistanceBetweenStep <= 10)
               {
                   xpos = [self getRandomNumber:0+stepRect.width to:maxDistanceBetweenStep];
               }
               
               else
               {
                   xpos = [self getRandomNumber:minDistanceBetweenStep to:maxDistanceBetweenStep ];
                   
               }
               
               //Out of bounds xpos
               if (xpos < 0 + stepRect.width/2 )
               {
                   
                   if (xpos <= 0)
                   {
                       xpos = (xpos * -1)+stepRect.width/2 ;
                   }
                   else
                       
                   {
                       xpos = 0 + stepRect.width/2 ;
                   }
                   
                   
                   
               }
               
               if (xpos > 320 - stepRect.width/2 )
               {
                   if (xpos > 320)
                   {
                       xpos =  320 - (xpos-320) - stepRect.width/2;
                   }
                   else
                   {
                       xpos = 320 - stepRect.width/2;
                   }
               }
           }
           
           else
           {
               
             xpos = self.view.frame.size.width/2 - stepRect.width/2;
               
           }
           
           
           //Add image object to Array of platforms
           [arrayOfPlatforms addObject:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"asteroid2.png"]]];
           //platform Object rect
           [[arrayOfPlatforms objectAtIndex:i] setFrame:CGRectMake(xpos, ypos, stepRect.width, stepRect.height)];
       
                    
           
           
           ypos = ypos - distanceyBetweenSteps;
       }
        
       //Add images to View
        for ( UIImageView *steps in  arrayOfPlatforms)
        {
            
            
            [[self view] addSubview: steps];
            
        }
        
        
        
        
        
        //Labels
        [self labelsCreate];
        
        
        //INITIALIZE button Alpha zero
        [rocketOnButton setAlpha:1];
        [magnetOnButton setAlpha:1];
        
    
        
        
        
        
        
        
        
        
        //coins
        arrayOfCoins = [NSMutableArray array];
        
        
        //enemy
        arrayOfEnemies = [NSMutableArray array];
        
        
        
        //oil
        arrayOfOil =  [NSMutableArray array];
        
        //refinery
        arrayOfRefinery =  [NSMutableArray array];
        
        //coil
        arrayOfCoil =  [NSMutableArray array];
        
        //battery
        arrayOfBattery =  [NSMutableArray array];
        
        //tesla
        arrayOfTesla =  [NSMutableArray array];
        
        
        
        
        
        rocketOnButtonBG = [[UIImageView alloc]initWithFrame:CGRectMake(270-80, 420, 30, 30)];
        [rocketOnButtonBG setImage:[UIImage imageNamed:@"jetpack2.png"]];
        [rocketOnButtonBG setAlpha:0.3];
        [[self view] addSubview:rocketOnButtonBG];
        
        // 320x480
        rocketOnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rocketOnButton.frame =CGRectMake(270-80, 420, 30, 30
                                         );
        rocketOnButton.backgroundColor = [UIColor clearColor];
        [rocketOnButton setBackgroundImage:[UIImage imageNamed:@"jetpack2.png"] forState:UIControlStateNormal];
        [rocketOnButton setAlpha: 0];
        [rocketOnButton addTarget:self action:@selector(rocketOnMode) forControlEvents:UIControlEventTouchUpInside];
        [[self view]addSubview:rocketOnButton];
        
        
        
        magnetOnButtonBG = [[UIImageView alloc]initWithFrame:CGRectMake(270-40, 420, 30, 30)];
        [magnetOnButtonBG setImage:[UIImage imageNamed:@"magnet.png"]];
        [magnetOnButtonBG setAlpha:0.3];
        [[self view] addSubview:magnetOnButtonBG];
        // 320x480
        magnetOnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        magnetOnButton.frame =CGRectMake(270-40, 420, 30, 30);
        magnetOnButton.backgroundColor = [UIColor clearColor];
        [magnetOnButton setBackgroundImage:[UIImage imageNamed:@"magnet.png"] forState:UIControlStateNormal];
        [magnetOnButton setAlpha:0];
        [magnetOnButton addTarget:self action:@selector(magnetOnMode) forControlEvents:UIControlEventTouchUpInside];
        [[self view]addSubview:magnetOnButton];
        
        
        
        
        shieldOnButtonBG = [[UIImageView alloc]initWithFrame:CGRectMake(270, 420, 30, 30)];
        [shieldOnButtonBG setImage:[UIImage imageNamed:@"ElectricOrb.png"]];
        [shieldOnButtonBG setAlpha:0.3];
        [[self view] addSubview:shieldOnButtonBG];
        // 320x480
        shieldOnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        shieldOnButton.frame =CGRectMake(270, 420, 30, 30);
        shieldOnButton.backgroundColor = [UIColor clearColor];
        [shieldOnButton setBackgroundImage:[UIImage imageNamed:@"ElectricOrb.png"] forState:UIControlStateNormal];
        [shieldOnButton setAlpha:0];
        [shieldOnButton addTarget:self action:@selector(shieldOnMode) forControlEvents:UIControlEventTouchUpInside];
        [[self view]addSubview:shieldOnButton];
        
        
        
        
        //Lives
        for (int i=0; i<life; i++) {
//            CGRect oilRect = CGRectMake(0, 0, 30, 30);
//            
//            UIImageView  *oilView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"crudeoil.png"]];
//            
//            [oilView setFrame:oilRect];
//            
//            oilView.center = CGPointMake(abs(arc4random()%300)+10 ,0);
            
            
             
            lives[i] = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            [lives[i] setImage:[UIImage imageNamed:@"life.png"]];
            lives[i].center = CGPointMake(i*20+25,480-50);
            // every life is a subview - show it
            [[self view] addSubview:lives[i]];
        }
        
        
        
          UIImageView *first = [arrayOfPlatforms objectAtIndex:0];
    
        
      
    
        
        //ADD Character & shield & magnetized
       electroShield = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ElectricOrb.png"]];
       magnetized = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"magnetized.png"]];
      
        
        
        rocketMan = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buzz.png"]];
        [rocketMan  setFrame:CGRectMake(0, 0, 70, 70)];
        rocketMan.center = CGPointMake(first.center.x, first.frame.origin.y -rocketMan.bounds.size.height/2-5);
         
        
        electroShield.center = CGPointMake(first.center.x, first.frame.origin.y -rocketMan.bounds.size.height/2-5);
        magnetized.center = CGPointMake(first.center.x, first.frame.origin.y -rocketMan.bounds.size.height/2-5);
        
       rocketManNewPosition.x = rocketMan.center.x;
       rocketManNewPosition.y = rocketMan.center.y;
        
        [electroShield setAlpha:0];
        [magnetized setAlpha:0];
        
        
       [[self view] addSubview:electroShield];
        [[self view] addSubview:rocketMan ];
         [[self view] addSubview:magnetized ];
        
       
        
        
        viewPause = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self view].frame.size.width, [self view].frame.size.height)];
       viewPause.alpha = 0;
        viewPause.backgroundColor = [UIColor  blackColor];
        viewPause.layer.zPosition = 3;
        [[self view]addSubview:viewPause];

        labelPause = [[UILabel alloc]init];
        labelPause .text = [NSString stringWithFormat:@"Game Paused"];
        [labelPause setFrame:CGRectMake(self.view.bounds.size.width/2-100, self.view.bounds.size.height/2,200, 20)];
        [labelPause setFont: [UIFont boldSystemFontOfSize:17]];
        [labelPause setTextColor:[UIColor whiteColor]];
        labelPause.textAlignment = UITextAlignmentCenter;
        [labelPause setBackgroundColor:[UIColor grayColor]];
        [viewPause addSubview:labelPause];
        
        
        pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pauseButton.frame =CGRectMake(270, 10, 25, 25);
        pauseButton.backgroundColor = [UIColor clearColor];
        [pauseButton setBackgroundImage:[UIImage imageNamed:@"playpause.png"] forState:UIControlStateNormal];
        [pauseButton setAlpha:1];
        pauseButton.layer.zPosition = 5;
        [pauseButton addTarget:self action:@selector(pauseGame) forControlEvents:UIControlEventTouchUpInside];
        [[self view]addSubview:pauseButton];
        
        
        
        labelScore = [[UILabel alloc]init];
        labelScore.text = [NSString stringWithFormat:@"Score:%.0f",score];
        [labelScore setFrame:CGRectMake(self.view.bounds.size.width-200, self.view.bounds.size.height-20, 100, 20)];
        [labelScore setFont: [UIFont boldSystemFontOfSize:14]];
         [labelScore setTextColor:[UIColor whiteColor]];
         labelScore.textAlignment = UITextAlignmentCenter;
        [labelScore setBackgroundColor:[UIColor clearColor]];
        [[self view] addSubview:labelScore];

        

        NSURL *url4 = [[NSBundle mainBundle] URLForResource:@"crazy_kart_song_wait" withExtension: @"mp3"];
        
        NSError *error4;
        audioplayer4 = [[AVAudioPlayer alloc] initWithContentsOfURL:url4 error:&error4];
    
        
        
        
        

        NSURL *url = [[NSBundle mainBundle] URLForResource:@"increase_agility" withExtension: @"mp3"];
 
        NSError *error;
        audioplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        
      
        
        
        
        
        NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"electric_shock" withExtension: @"mp3"];
        
        NSError *error2;
        audioplayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:&error2];
        
       
        
        
        
        NSURL *url3 = [[NSBundle mainBundle] URLForResource:@"tuning_fork" withExtension: @"mp3"];
        
        NSError *error3;
        audioplayer3 = [[AVAudioPlayer alloc] initWithContentsOfURL:url3 error:&error3];
        
        
        
            [audioplayer4 setNumberOfLoops:-1];

        
         [audioplayer4 prepareToPlay];
        [audioplayer prepareToPlay];
       [audioplayer2 prepareToPlay];
        [audioplayer3 prepareToPlay];
       
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    life = 3;
    timeCounter = 0;
    
    randomizeCoin = randomizeCoin *level;
    
    
    //Jump Speed
    jumpSpeed = jumpSpeedLimit;
    
    
    
    
    
   timerdelay = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(startbouncing) userInfo:nil repeats:YES];
 
    // Do any additional setup after loading the view from its nib.
}


- (void)viewDidUnload
{
    accelerometer.delegate = nil;
    
    
    [timerdelay invalidate];
    timerdelay = nil;
    
    [timerBounce invalidate];    
    timerBounce =nil;
    
    [timerMovePlatform invalidate];
    timerMovePlatform = nil;
    
   
    
    [timerRocket invalidate];
    timerRocket = nil;
   
    [gameTimer invalidate];
    gameTimer =nil;
    
    
    [timerBGmusic invalidate];
    timerBGmusic = nil;
    
    [audioplayer stop];
    audioplayer = nil;
    
    [audioplayer2 stop];
    audioplayer2 = nil;
    
    
    [audioplayer3 stop];
    audioplayer3 = nil;
    
    
    [audioplayer4 stop];
    audioplayer4 = nil;
    
    [self setArrayOfPlatforms:nil];
    [self setArrayOfCoins:nil];
  
    
    
    
    [self setArrayOfOil:nil];
    [self setArrayOfRefinery:nil];
    [self setArrayOfCoil:nil];
    [self setArrayOfBattery:nil];
    
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




-(void )dealloc
{
    
    accelerometer.delegate = nil;
    [timerdelay invalidate];
    timerdelay = nil;
    
    [timerBounce invalidate];
    timerBounce =nil;
    
    [timerMovePlatform invalidate];
    timerMovePlatform = nil;
    
    [timerRocket invalidate];
    timerRocket = nil;
    
    [gameTimer invalidate];
    gameTimer =nil;
    
    [timerBGmusic invalidate];
    timerBGmusic = nil;
    
    [audioplayer stop];
    audioplayer = nil;
 
    [audioplayer2 stop];
    audioplayer2 = nil;
    
    [audioplayer3 stop];
    audioplayer3 = nil;
    
    [audioplayer4 stop];
    audioplayer4 = nil;
    
    [self setArrayOfPlatforms:nil];
    [self setArrayOfCoins:nil];
    
    
    [self setArrayOfOil:nil];
    [self setArrayOfRefinery:nil];
    [self setArrayOfCoil:nil];
    [self setArrayOfBattery:nil];
}









- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

 


-(void)labelsCreate
{

    //initialization
    gasNum = 0;
    refNum = 0;
    coilNum = 0;
    batteryNum = 0;
    teslaNum =0;
    
    
    viewPanelFormItems = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    viewPanelFormItems.backgroundColor = [UIColor grayColor]; 
    [[self view] addSubview:viewPanelFormItems];
    
    
    //gas image
    gasImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"crudeoil.png"]];
    [gasImage setFrame:CGRectMake(10, 10, 30, 35)];
    [gasImage setAlpha:.5];
    [[self view] addSubview:gasImage];
    
    //Gas number label
    numberOfGas = [[UILabel alloc]init];
    numberOfGas.text = [NSString stringWithFormat:@"%i", gasNum];
    [numberOfGas setFrame:CGRectMake(30, 35, 10, 10)];
    [numberOfGas setFont: [UIFont boldSystemFontOfSize:10]];
    [numberOfGas setTextColor:[UIColor whiteColor]];
    numberOfGas.textAlignment = UITextAlignmentCenter;
    [numberOfGas setBackgroundColor:[UIColor blackColor]];
    [numberOfGas setAlpha:.5];
    [[self view] addSubview:numberOfGas];
    
    //refinery image
    refineImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"refinery.png"]];
    [refineImage setFrame:CGRectMake(60, 10, 40, 35)];
    [refineImage setAlpha:.5];
    [[self view] addSubview:refineImage];
    
    //Refinery number label
    numberOfRef = [[UILabel alloc]init];
    numberOfRef.text = [NSString stringWithFormat:@"%i", refNum];
    [numberOfRef setFrame:CGRectMake(90, 35, 10, 10)];
    [numberOfRef setFont:[UIFont boldSystemFontOfSize:10]];
    [numberOfRef setTextColor:[UIColor whiteColor]];
    numberOfRef.textAlignment = UITextAlignmentCenter;
    [numberOfRef setBackgroundColor:[UIColor blackColor]];
    [numberOfRef setAlpha:.5];
    [[self view] addSubview:numberOfRef];
    
    coilImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coil.png"]];
    [coilImage setFrame:CGRectMake(120, 10, 30, 35)];
    [coilImage setAlpha:0.5];
    [[self view] addSubview:coilImage];
    
    numberOfCoil = [[UILabel alloc]init];
    numberOfCoil.text = [NSString stringWithFormat:@"%i", coilNum];
    [numberOfCoil setFrame:CGRectMake(140, 35, 10, 10)];
    [numberOfCoil setFont:[UIFont boldSystemFontOfSize:10]];
    [numberOfCoil setTextColor:[UIColor whiteColor]];
    numberOfCoil.textAlignment = UITextAlignmentCenter;
    [numberOfCoil setBackgroundColor:[UIColor blackColor]];
    [numberOfCoil setAlpha:.5];
    [[self view] addSubview:numberOfCoil];
    
    batteryImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"battery.png"]];
    [batteryImage setFrame:CGRectMake(170, 10, 30, 35)];
    [batteryImage setAlpha:0.5];
    [[self view] addSubview:batteryImage];
    
    numberOfbattery = [[UILabel alloc]init];
    numberOfbattery.text = [NSString stringWithFormat:@"%i", batteryNum];
    [numberOfbattery setFrame:CGRectMake(190, 35, 10, 10)];
    [numberOfbattery setFont:[UIFont boldSystemFontOfSize:10]];
    [numberOfbattery setTextColor:[UIColor whiteColor]];
    numberOfbattery.textAlignment = UITextAlignmentCenter;
    [numberOfbattery setBackgroundColor:[UIColor blackColor]];
    [numberOfbattery setAlpha:.5];
    [[self view] addSubview:numberOfbattery];
    
    
    
    teslaImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tesla.png"]];
    [teslaImage setFrame:CGRectMake(170+50 , 10, 30, 35)];
    [teslaImage setAlpha:0.5];
    [[self view] addSubview:teslaImage];
    
    numberOftesla= [[UILabel alloc]init];
    numberOftesla.text = [NSString stringWithFormat:@"%i", teslaNum];
    [numberOftesla setFrame:CGRectMake(190+50, 35, 10, 10)];
    [numberOftesla setFont:[UIFont boldSystemFontOfSize:10]];
    [numberOftesla setTextColor:[UIColor whiteColor]];
    numberOftesla.textAlignment = UITextAlignmentCenter;
    [numberOftesla setBackgroundColor:[UIColor blackColor]];
    [numberOftesla setAlpha:.5];
    [[self view] addSubview:numberOftesla];
    
    
}




-(int)getRandomNumber:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}



-(void)jump
{
    
     //rocketManNewPosition.x += 2;


    [self getFuel];
    
    if (shieldOnButton.alpha == 1 && magnetOnButton.alpha != 1) {
        [self getElectroMagnet];
        [self getElectroShield];
    }
    
    else if (shieldOnButton.alpha != 1 && magnetOnButton.alpha == 1) {
        [self getElectroShield];
        [self getElectroMagnet];
    }
    
    else
    {
    
        if ([self getRandomNumber:1 to:2] ==1)
        {
        
        [self getElectroMagnet];
        [self getElectroShield];
        }
    
        else
        {
        [self getElectroShield];
        [self getElectroMagnet];
        
        }
    }
   
    
    
    
    if (rocketManNewPosition.x + deltaX*40 >= 0 + rocketMan.frame.size.width/2 && rocketManNewPosition.x + deltaX*40 <= 320 -rocketMan.frame.size.width/2  )
    {
          rocketManNewPosition.x += deltaX*40;
    }
       else
    {
         //restrict movement with bounds Left Right
           if (rocketManNewPosition.x + deltaX*40 < 0 + rocketMan.frame.size.width/2)
           {
               rocketManNewPosition.x = 0 +rocketMan.frame.size.width/2;
           }
           else if (rocketManNewPosition.x + deltaX*40 > 320 - rocketMan.frame.size.width/2)
           {
               rocketManNewPosition.x = 320 - rocketMan.frame.size.width/2;
           }
       
    }

    
    

    
    
    
    
    
    
    //HITS coin
    for (Coins *coins in arrayOfCoins)
    {
        
        //Remove if hit and add score
        if ([self CheckifCoinGet:coins])
        {
            
           
            
         
            [arrayOfCoins removeObject:coins];
           

            [coins removeFromSuperview];
            
            score = score + [coins value];
            NSLog(@"Score:%.0f",score);
             labelScore.text = [NSString stringWithFormat:@"SCORE:%.0f",score];
            [labelScore setNeedsDisplay];
            break;
        }
    }
    
    

    
    //HITS enemy
    for (UIImageView *enemy in arrayOfEnemies)
    {
        
        //Remove if hit and remove life
        if (shieldOn) {
            if ([self CheckifEnemyHitShield:enemy])
             {
                [arrayOfEnemies removeObject:enemy];
               
                
                [enemy removeFromSuperview];
                 break;
            }
        }
        
        
        
       else if ([self CheckifEnemyHit:enemy])
        {
            
            
            [arrayOfEnemies removeObject:enemy];
           
        
            
            [enemy removeFromSuperview];
            
            if (!shieldOn) {
                life--;
                
                [lives[(int)life] removeFromSuperview];
            }
            
            if (life ==0) {
                [self movetoGameOverScene];
            }
            
            
            
            break;
        }
    }
    
    
    
    
    
   //jumping && Rocket on
    
    if (rocketOn)
    {
     
        
        if (rocketManNewPosition.y + deltaY*40 >= 50 + rocketMan.frame.size.height/2 && rocketManNewPosition.y + deltaY*40 <= 480 -rocketMan.frame.size.height/2  )
        {
            rocketManNewPosition.y += deltaY*40;
        }
        else
        {
            //restrict movement with bounds
            if (rocketManNewPosition.y + deltaY*40 < 50 + rocketMan.frame.size.height/2)
            {
                rocketManNewPosition.y = 50 +rocketMan.frame.size.height/2;
            }
            else if (rocketManNewPosition.y + deltaY*40 > 480 - rocketMan.frame.size.height/2)
            {
                rocketManNewPosition.y = 480 - rocketMan.frame.size.height/2;
            }
            
        }
        
    }
    
    
    
    
    //jump
    else
    {
        
        
        
     
        if(!mainJumping)
        {
		//then start jumping
		mainJumping = YES;
		jumpSpeed = jumpSpeedLimit*-1;
		rocketManNewPosition.y += jumpSpeed;
            
        }
    
    
        else
        {
        
        //if  paakyat n
        if(jumpSpeed < 0)
        {
        //Speed up gradually
        jumpSpeed *= 1 - jumpSpeedLimit/75;
          
        //Determine if pababa n
        
             if(jumpSpeed > -jumpSpeedLimit/5 || rocketMan.center.y  <= 50 + rocketMan.frame.size.height/2)
            {
        jumpSpeed *= -1;
            }
		}
        
        //speed up gradually but much faster 
		if(jumpSpeed > 0 && jumpSpeed <= jumpSpeedLimit)
        {
			jumpSpeed *= 1 + jumpSpeedLimit/50;
		}
      

      
        rocketManNewPosition.y += jumpSpeed;
        rocketMan.center = CGPointMake(rocketManNewPosition.x, rocketManNewPosition.y);
        
          
       
 
            
        
	  //if main hits the platform, then stop jumping
     //Check Each Platform if hit
        
     
            if(jumpSpeed >0)
            {
        
               //Jump Again If Collided and moving Down
                for (UIImageView *checkplatform in arrayOfPlatforms)
                {
        
                    //speed up when
                    if (rocketMan.center.y < self.view.bounds.size.height/2 + 30)
                    {
                        platformSpeedmove =4;
                        rocketMan.center = CGPointMake(rocketMan.center.x, rocketMan.center.y- 4);
                    
                    }
                    
                    else
                    {
                        platformSpeedmove =1;
                    }
                    
                    
                 if(rocketManNewPosition.y >=  checkplatform.frame.origin.y - rocketMan.frame.size.height/2 +10  && [self CheckifJump:checkplatform]  &&  jumpSpeed  >0  )
                      {
                          
                          if (platformSpeedmove !=4) {
                              mainJumping = NO;
                              rocketManNewPosition.y = checkplatform.frame.origin.y - rocketMan.frame.size.height/2 +10;
                              rocketMan.center = CGPointMake(rocketManNewPosition.x, rocketManNewPosition.y);
                            
                          }
            
                  
              
   
        
                
                break;
             
            }
                 }
    
            }
        
            
            
        //Check if on Ground
            if (rocketMan.frame.origin.y   > self.view.frame.size.height)
            {
                NSLog(@"aw");
            

              
                [self movetoGameOverScene];
                              
                
                
            }
    
    }
    }
    
    
    
    
    
    
    //move rocketman
     rocketMan.center = CGPointMake(rocketManNewPosition.x, rocketManNewPosition.y);
    electroShield.center =CGPointMake(rocketManNewPosition.x, rocketManNewPosition.y);
    magnetized.center =CGPointMake(rocketManNewPosition.x, rocketManNewPosition.y);
}





-(void)movePlatforms
{
    


//ENEMY
    for (UIImageView   *enemy in arrayOfEnemies)
    {
        if (enemy.center.y <50) {
            enemy.alpha = 0;
        }
        else
        {
            enemy.alpha =1;
        }
        enemy.center = CGPointMake(enemy.center.x, enemy.center.y + platformSpeedmove);
    }
    
    
    //if off screen remove
    for (UIImageView  *enemy in arrayOfEnemies)
    {
        if (enemy.frame.origin.y > self.view.bounds.size.height)
        {
            
            [arrayOfEnemies removeObject:enemy];
            [enemy removeFromSuperview];
            break;
            
        }
        
        
    }
    
    
    
    
    
    
//COINS
    for (Coins   *coins in arrayOfCoins)
    {
        
        float mainDistance = [coins getDistanceFrom:rocketMan].mainDistance;
        float xDistance =[coins getDistanceFrom:rocketMan].xdistance;
        float yDistance =[coins getDistanceFrom:rocketMan].ydistance;
        
        float xMoveMagnetized =4;
        float yMoveMagnetized =4;
        
        
        
        if (coins.center.y <50) {
            coins.alpha = 0;
        }
        else
        {
            coins.alpha =1;
        }
        
        
        
        
        
        
        
        
        
        if (magnetOn && mainDistance < 200)
        {
            
            
            if (xDistance < 0)
            {
                xMoveMagnetized =xMoveMagnetized * 1;
            }
            else if (xDistance > 0)
            {
                xMoveMagnetized = (xMoveMagnetized) *(-1);
               
            }
            else
            {
                xMoveMagnetized = xMoveMagnetized * 0;
            }
        
    
            if (yDistance < 0)
            {
                yMoveMagnetized = yMoveMagnetized * 1;
            }
            else if (xDistance > 0)
            {
                yMoveMagnetized =  (yMoveMagnetized)*(-1);
                
            }
            else
            {
                yMoveMagnetized = yMoveMagnetized * 0;
            }
    
             coins.center = CGPointMake(coins.center.x + xMoveMagnetized, coins.center.y + yMoveMagnetized );
            
        }
        else
        {
        coins.center = CGPointMake(coins.center.x, coins.center.y + platformSpeedmove);
        }
    }
    
    //if off screen remove
    for (Coins   *coins in arrayOfCoins)
    {
        if (coins.frame.origin.y > self.view.bounds.size.height)
        {
            
            [arrayOfCoins removeObject:coins];
            [coins removeFromSuperview];
            break;
            
        }
        
        
    }
    
    
    
    
    
    
      

    
        [self excuteMoveAndRemoveFromArray:arrayOfOil];
        [self excuteMoveAndRemoveFromArray:arrayOfRefinery];
        [self excuteMoveAndRemoveFromArray:arrayOfCoil];
        [self excuteMoveAndRemoveFromArray:arrayOfBattery];
        [self excuteMoveAndRemoveFromArray:arrayOfTesla];
    
    
    
    
    //move platform and reuse if off screen
    for (UIImageView *steps in arrayOfPlatforms)
    {
        steps.center = CGPointMake(steps.center.x, steps.center.y + platformSpeedmove);
    
        
        
        if (steps.frame.origin.y > self.view.bounds.size.height)
        {
            platformsFinished++;
           
            [self resetPlatform:steps];
            
        }
        
        
    }

    
    
    
    
    
}




-(BOOL)CheckifJump:(UIImageView *)platform
{
   
 
    if (rocketMan.center.x >= platform.frame.origin.x && rocketMan.center.x <= (platform.frame.origin.x + platform.bounds.size.width) && CGRectIntersectsRect(platform.frame,rocketMan.frame))
    {
        
        return YES;
      
    }
    

    
    return NO;
}






-(BOOL)CheckifCoinGet:(Coins *)coins
{
    if (CGRectIntersectsRect(rocketMan.frame, coins.frame)) {
    return YES;
    }

    return NO;
}

-(BOOL)CheckifOilGet:(UIImageView *)oil
{
    if (CGRectIntersectsRect(rocketMan.frame, oil.frame)) {
        return YES;
    }
    
    return NO;
}

-(BOOL)CheckifRefineryGet:(UIImageView *)ref
{
    if (CGRectIntersectsRect(rocketMan.frame, ref.frame)) {
        return YES;
    }
    
    return NO;
}

-(BOOL)CheckifCoilGet:(UIImageView *)coil
{
    if (CGRectIntersectsRect(rocketMan.frame, coil.frame)) {
        return YES;
    }
    
    return NO;
}

-(BOOL)CheckifBatteryGet:(UIImageView *)bat
{
    if (CGRectIntersectsRect(rocketMan.frame, bat.frame))
    {
        return YES;
    }
    
    return NO;
}


-(BOOL)CheckifTeslaGet:(UIImageView *)tesla
{
    if (CGRectIntersectsRect(rocketMan.frame, tesla.frame))
    {
        return YES;
    }
    
    return NO;
}


-(BOOL)CheckifEnemyHit:(UIImageView *)enemy
{
    if (CGRectIntersectsRect(rocketMan.frame, enemy.frame)) {
        return YES;
    }
    
    return NO;
}

-(BOOL)CheckifEnemyHitShield:(UIImageView *)enemy
{
    if (CGRectIntersectsRect(electroShield.frame, enemy.frame)) {
        return YES;
    }
    
    return NO;
}






-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	if(gameSuspended) return;
	float accel_filter = 0.1f;
	
    
         deltaX=(acceleration.x *accel_filter ) + (deltaX * (1.0 - accel_filter));
         deltaY=(acceleration.y *accel_filter ) + (deltaY * (1.0 - accel_filter));
}


-(void)startbouncing
{
    platformSpeedmove =1;
    
    
    if (!delayTime) {
        
        gameTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(gameTimeMethod) userInfo:nil repeats:YES];
        timerBounce = [NSTimer scheduledTimerWithTimeInterval:.07 target:self selector:@selector(jump) userInfo:nil repeats:YES];
        
        
        timerMovePlatform = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(movePlatforms) userInfo:nil repeats:YES];

        timerBGmusic = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(bgmusicplay) userInfo:nil repeats:NO];
        
        [timerdelay invalidate];
        timerdelay = nil;
    }


    else
    {
        
        delayTime = NO;
    }
}





-(void)excuteMoveAndRemoveFromArray:(NSMutableArray *)array
{

    for (UIImageView   *imgViewObject in array)
    {
        
        if (imgViewObject.center.y <50) {
            imgViewObject.alpha = 0;
        }
        else
        {
            imgViewObject.alpha =1;
        }
        
    imgViewObject.center = CGPointMake(imgViewObject.center.x, imgViewObject.center.y + platformSpeedmove);
        
        
    }
    
    //if off screen remove
    for (UIImageView   *imgViewObject in array)
    {
        if (imgViewObject.frame.origin.y > self.view.bounds.size.height)
        {
            
            [array removeObject:imgViewObject];
            [imgViewObject removeFromSuperview];
            break;
            
        }
        
        
    }
}







-(void)resetPlatform:(UIImageView*)platform
{
    
    
    
    
    switch (platformsFinished) {
        case 80:
            level++;
            NSLog(@"%d",level);
            break;
            
        case 300:
            level++;
            NSLog(@"%d",level);
            break;
            
//        case 1000:
//            level++;
//            NSLog(@"%d",level);
//            break;
            
        default:
            break;
    }
    
    
    if (level == gameFinishLevel) {
        
        [self movetoGameFinishScene];
        
    }
    
    
    
    
    
    
    
    //Platform RESET
    CGSize stepRect = CGSizeMake(100, 35);
    NSUInteger index;
    
    //get Index of previous Object
    if ([arrayOfPlatforms indexOfObject:platform]== 0)
    {
        index = kNumOfPlatforms-1;
    }
    else
    {
        index = [arrayOfPlatforms indexOfObject:platform]-1;
    }
    
    
    UIImageView *before= [arrayOfPlatforms objectAtIndex:index];
    
    maxDistanceBetweenStep = 0;
    minDistanceBetweenStep = 0;
    
    maxDistanceBetweenStep = before.center.x + distanceBetweenSteps;
    minDistanceBetweenStep = before.center.x -distanceBetweenSteps;
    
    
    //set Coordinate based on previous object
    if (maxDistanceBetweenStep >  [self view].frame.size.width - (stepRect.width)-10)
    {
        xpos = [self getRandomNumber:minDistanceBetweenStep to:([self view].bounds.size.width - (stepRect.width/2)-10) ];
    }
    
    else if(minDistanceBetweenStep <= 0)
    {
        xpos = [self getRandomNumber:10 + stepRect.width to:maxDistanceBetweenStep];
     
    }
    
    else
    {
        xpos = [self getRandomNumber:minDistanceBetweenStep to:maxDistanceBetweenStep ];
        
    }
    
    
    //Out of bounds xpos
    if (xpos < 0 + stepRect.width/2 )
    {
        
        if (xpos <= 0)
        {
        xpos = (xpos * -1)+stepRect.width/2 ;
        }
        else
            
        {
        xpos = 0 + stepRect.width/2 ;
        }
        
       

    }
    
    if (xpos >320 - stepRect.width/2 )
    {
        if (xpos > 320)
        {
            xpos =  320 - (xpos-320) - stepRect.width/2;
        }
        else
        {
            
        xpos = 320 - stepRect.width/2;
        }
    }
    
    

    
    ypos =0;
 
    

    platform.center = CGPointMake (xpos,ypos);

    
    

    
    
    
    
    
    
    
    //CREATE COINS
    
    if (platformsFinished < 20)
    {
        coinsCounts = 1;
    }
    else if (platformsFinished < 50)
    {
        coinsCounts = 3;
    
    }
    
    else if (platformsFinished < 200)
    {
        coinsCounts = 5;
        
    }
    
    else if (platformsFinished > 200)
    {
        coinsCounts = 7;
        
    }
    
    
    
    if ([arrayOfCoins count] < coinsCounts) {
        if ((arc4random() % 3)+1 == 1)
        {
            
            CGRect coinsRect = CGRectMake(0, 0, 20, 20);
            Coins  *coinsView =[[Coins alloc] init];
            [coinsView setFrame:coinsRect];
            
            
            NSString *imageStr;
            
            switch ((arc4random()%(randomizeCoin+3))+1) {
                case 1:
                case 2:
                case 3:
                    imageStr =@"bronzecoin.png";
                    [coinsView setValue:100];
                    
                    break;
                    
                case 4:
                case 5:
                    imageStr =@"silvercoin.png";
                    [coinsView setValue:300];
                    
                    break;
                case 6:
                    imageStr =@"goldcoin.png";
                    [coinsView setValue:500];
                    break;
                    
                default:
                    break;
            }
            

            coinsView.image = [UIImage imageNamed:imageStr];
            coinsView.center = CGPointMake(xpos,platform.frame.origin.y-5);
            
            [arrayOfCoins addObject:coinsView];
            
            [self.view addSubview:coinsView];
            
            
       }
    }
      
    

}







-(void)checkRocketDuration
{
if (rocketDuration <=0)
    {
    [audioplayer stop];
    [timerRocket invalidate];
    timerRocket = nil;
    rocketOn = NO;
    platformSpeedmove = 1;
    rocketMan.image = [UIImage imageNamed:@"buzz.png"];

    }
    
    rocketDuration--;
}



-(void)rocketOnMode
{
[rocketOnButton setAlpha:0];
    
    
    
    if (rocketOn)
    {
    rocketOn = NO;
    platformSpeedmove = 1;
    }
    else
    {
    
    rocketDuration =10;
    rocketOn = YES;
        rocketMan.image = [UIImage imageNamed:@"rocketOn.png"];
        
         [audioplayer play];
    timerRocket = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkRocketDuration) userInfo:nil repeats:YES];
      
    platformSpeedmove = 5;
        
    }
}










-(void)gameTimeMethod
{
    timeCounter++;

    switch (level)
    {
        case 1:
            enemyRespawnTime =30;
            break;
            
        case 2:
            enemyRespawnTime =20;
            break;
        case 3:
            enemyRespawnTime =10;
            break;
            
        default:
            break;
    }
    
    
    
    randomizeCoin = 1 *level;
    
    [self checkMagnetDuration];
    [self checkShieldDuration];
    
   
    
  //  NSLog(@"%d",timeCounter);

   
    
    
    
    
    
    
    


    
    
    
    

    if (timeCounter % 3 ==0)
    {
       
        int randomNumForUps = 0;
        
        randomNumForUps = [self getRandomNumber:1 to:5];
        
        switch (randomNumForUps)
        {
            case 1:
                [self createOil];
                break;
                
             case 2:
                [self createRefinery];
                break;
                
             case 3:
                [self createCoil];
                break;
                
            case 4:
                [self createBattery];
                break;
                
            case 5:
                [self createTesla];
                break;
            default:
                break;
        }
        
        
        
        
        
        


        
        
     


        

    }



    if (timeCounter % (int)enemyRespawnTime == 0)
    {
        NSString *strEnemyStr;
        CGRect EnemyRect = CGRectMake(0, 0, 30, 30);
        
        switch ([self getRandomNumber:1 to:7]) {
            case 1:
                strEnemyStr = @"alien1.png";
                break;
                
            case 2:
                strEnemyStr = @"alien2.png";
                break;
                
            case 3:
                strEnemyStr = @"alien3.png";
                break;
                
            case 4:
                strEnemyStr = @"alien4.png";
                break;
            case 5:
                strEnemyStr = @"alien5.png";
                break;
            case 6:
                strEnemyStr = @"alien6.png";
                break;
            case 7:
                strEnemyStr = @"alien7.png";
                break;
            default:
                break;
        }
        
        
        UIImageView  *enemyView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:strEnemyStr]];
        [enemyView setFrame:EnemyRect];
        
        enemyView.center = CGPointMake(abs(arc4random()%300)+10 ,0);
        
        [arrayOfEnemies addObject:enemyView];
        
        [self.view addSubview:enemyView];
    }
    
    
}




-(void)getFuel
{
    
    //HITS oil
    for (UIImageView *oil in arrayOfOil)
    {
        
        //Remove if hit and add score
        if ([self CheckifOilGet:oil])
        {
            
           
            [numberOfGas setAlpha:1];
            [gasImage setAlpha:1];
            
            numberOfGas.text = [NSString stringWithFormat:@"%i", gasNum = gasNum+1];
          
            [arrayOfOil removeObject:oil];
           
            
            [oil removeFromSuperview];
            
           
            break;
        }
    }
    
   
 
        
    
    //HITS ref
    for (UIImageView *ref in arrayOfRefinery)
    {
        
        //Remove if hit and add count
        if ([self CheckifRefineryGet:ref])
        {
            
           
            [numberOfRef setAlpha:1];
            [refineImage setAlpha:1];
            
            numberOfRef.text = [NSString stringWithFormat: @"%i", refNum = refNum + 1];
            
            [arrayOfRefinery removeObject:ref];
           
            
            [ref removeFromSuperview];
            
          
            break;
        }
    }
    
    
    
    
    
    if (gasNum >= 1 && refNum >= 1 && rocketOnButton.alpha != 1 && !rocketOn)
    {
        numberOfRef.text = [NSString stringWithFormat:@"%i", refNum = refNum - 1];
        numberOfGas.text = [NSString stringWithFormat:@"%i", gasNum = gasNum - 1];
        [rocketOnButton setAlpha:1];
        
    }
    
    
    if (gasNum == 0)
    {
        numberOfGas.alpha = 0.5;
        [gasImage setAlpha:0.5];
    }
    
    if (refNum == 0)
    {
        [numberOfRef setAlpha:0.5];
        [refineImage setAlpha:0.5];
    }
    
}





-(void)getElectroMagnet
{
    
    //HITS COIL
    for (UIImageView *coil in arrayOfCoil)
    {
        
        //Remove if hit and add score
        if ([self CheckifCoilGet:coil])
        {
            
          
            [numberOfCoil setAlpha:1];
            [coilImage setAlpha:1];
            numberOfCoil.text = [NSString stringWithFormat:@"%i", coilNum = coilNum+1];
            
            [arrayOfCoil removeObject:coil];
           
            
            [coil removeFromSuperview];
            
           
            break;
        }
    }
    
    
    
    
    
    
    //HITS Battery
    for (UIImageView *bat in arrayOfBattery)
    {
        
        //Remove if hit and add score
        if ([self CheckifBatteryGet:bat])
        {
            
           
            [numberOfbattery setAlpha:1];
            [batteryImage setAlpha:1];
            numberOfbattery.text = [NSString stringWithFormat: @"%i", batteryNum = batteryNum + 1];
            
            [arrayOfBattery removeObject:bat];
            
            
            [bat removeFromSuperview];
            
         
            break;
        }
    }
    

    
    
    
    
    
    if (coilNum >= 1 && batteryNum >= 1 && magnetOnButton.alpha != 1 && !magnetOn)
    {
        numberOfCoil.text = [NSString stringWithFormat:@"%i", coilNum = coilNum - 1];
        numberOfbattery.text = [NSString stringWithFormat:@"%i", batteryNum = batteryNum - 1];
        [magnetOnButton setAlpha:1];
        
    }
    
    if (batteryNum == 0)
    {
        numberOfbattery.alpha = 0.5;
        [batteryImage setAlpha:0.5];
    }
    
    if (coilNum == 0)
    {
        [numberOfCoil setAlpha:0.5];
        [coilImage setAlpha:0.5];
    }
    
}



-(void)getElectroShield
{
    
    //HITS COIL
    for (UIImageView *tesla in arrayOfTesla)
    {
       
        //Remove if hit and add score
       if ([self CheckifTeslaGet:tesla])
       {
            
           
            [numberOftesla setAlpha:1];
            [teslaImage setAlpha:1];
            numberOftesla.text = [NSString stringWithFormat:@"%i",teslaNum = teslaNum+1];
            
            [arrayOfTesla removeObject:tesla];
           
            
            [tesla removeFromSuperview];
            
            
            break;
       }
    }
    
    

    
    
    
    
    
    if (teslaNum >= 1 && batteryNum >= 1 && shieldOnButton.alpha != 1 && !shieldOn)
    {
        numberOftesla.text = [NSString stringWithFormat:@"%i", teslaNum = teslaNum - 1];
        numberOfbattery.text = [NSString stringWithFormat:@"%i", batteryNum = batteryNum - 1];
        [shieldOnButton setAlpha:1];
        
    }
    
    if (batteryNum == 0)
    {
        numberOfbattery.alpha = 0.5;
        [batteryImage setAlpha:0.5];
    }
    
    if (teslaNum == 0)
    {
        [numberOftesla setAlpha:0.5];
        [teslaImage setAlpha:0.5];
   }
    
}



-(void)createOil
{
    //add gas
    CGRect oilRect = CGRectMake(0, 0, 30, 30);
    
    UIImageView  *oilView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"crudeoil.png"]];
    
    [oilView setFrame:oilRect];
    
    oilView.center = CGPointMake(abs(arc4random()%300)+10 ,0);
    
    [arrayOfOil addObject:oilView];
    [self.view addSubview:oilView];
    
}

-(void)createRefinery
{
    //add refinery
    CGRect refRect = CGRectMake(0, 0, 35, 30);
    
    UIImageView  *refView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"refinery.png"]];
    
    [refView setFrame:refRect];
    
    refView.center = CGPointMake(abs(arc4random()%300)+10 ,0);
    
    [arrayOfRefinery addObject:refView];
    [self.view addSubview:refView];
    
}

-(void) createCoil
{
    

          //add coil
          CGRect coilRect = CGRectMake(0, 0, 30, 30);
    
           UIImageView  *coilView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"coil.png"]];
    
           [coilView setFrame:coilRect];
    
           coilView.center = CGPointMake(abs(arc4random()%300)+10 ,0);
    
           [arrayOfCoil addObject:coilView];
            [self.view addSubview:coilView];
}

-(void) createBattery
{

            //add battery
           CGRect batRect = CGRectMake(0, 0, 30, 30);

            UIImageView  *batteryView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"battery.png"]];
   
           [batteryView setFrame:batRect];
  
            batteryView.center = CGPointMake(abs(arc4random()%300)+10 ,0);
    
           [arrayOfBattery addObject:batteryView];
           [self.view addSubview:batteryView];
}


-(void)createTesla
{
    
    //add tesla
    CGRect teslaRect = CGRectMake(0, 0, 30, 30);
    
    UIImageView  *teslaView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tesla.png"]];
    
    [teslaView setFrame:teslaRect];
    
    teslaView.center = CGPointMake(abs(arc4random()%300)+10 ,0);
    
    [arrayOfTesla addObject:teslaView];
    [self.view addSubview:teslaView];
}


-(void)checkMagnetDuration
{
    if (magnetDuration <=0)
    {
 
        magnetOn= NO;
        [audioplayer3 stop];
      [magnetized setAlpha:0];
    }
    magnetDuration--;
    
}

-(void)magnetOnMode
{
    
    
    if (!magnetOn)
    {
        magnetOn = YES;
        magnetDuration=10;
        [audioplayer3 play];
        [magnetOnButton setAlpha:0];
        [magnetized setAlpha:1];
    }
    
    else
    {
        magnetOn = NO;
    
    }
}



-(void)checkShieldDuration
{
    if (shieldDuration <=0)
    {
        
        shieldOn= NO;
        [audioplayer2 stop];
        [electroShield setAlpha:0];
    }
    shieldDuration--;
    
}

-(void)shieldOnMode
{
    if (!shieldOn)
    {
        shieldOn = YES;
        shieldDuration=10;
        [audioplayer2 play];
        [shieldOnButton setAlpha:0];
        [electroShield setAlpha:1];
    }
    
    else
    {
        shieldOn = NO;
        
    }
}



-(void)movetoGameOverScene
{
    
    accelerometer.delegate = nil;
    [timerdelay invalidate];
    timerdelay = nil;
    
    [timerBounce invalidate];
    timerBounce =nil;
    
    [timerMovePlatform invalidate];
    timerMovePlatform = nil;
    
    [timerRocket invalidate];
    timerRocket = nil;
    
    [timerdelay invalidate];
    timerdelay = nil;
    
    [gameTimer invalidate];
    gameTimer = nil;
    
    [timerBGmusic invalidate];
    timerBGmusic = nil;
    
    [audioplayer stop];
    audioplayer = nil;
    
    [audioplayer2 stop];
    audioplayer2 = nil;
    
    
    [audioplayer3 stop];
    audioplayer3 = nil;
    
    [audioplayer4 stop];
    audioplayer4 = nil;
    
    GameOverViewController *gameOverScene = [[GameOverViewController alloc] init];
    [gameOverScene finishedScore:score];
    gameOverScene.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:gameOverScene animated:YES];
}








-(void)movetoGameFinishScene
{
    
    accelerometer.delegate = nil;
    [timerdelay invalidate];
    timerdelay = nil;
    
    [timerBounce invalidate];
    timerBounce =nil;
    
    [timerMovePlatform invalidate];
    timerMovePlatform = nil;
    
    [timerRocket invalidate];
    timerRocket = nil;
    
    [timerdelay invalidate];
    timerdelay = nil;
    
    [gameTimer invalidate];
    gameTimer = nil;
    
    [timerBGmusic invalidate];
    timerBGmusic = nil;
    
    [audioplayer stop];
    audioplayer = nil;
    
    [audioplayer2 stop];
    audioplayer2 = nil;
    
    [audioplayer3 stop];
    audioplayer3 = nil;
    
    [audioplayer4 stop];
    audioplayer4 = nil;
    
    GameFinishedViewController *gamefinish = [[GameFinishedViewController  alloc] init];

    [gamefinish finishedScore:score];
    gamefinish.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:gamefinish animated:YES];
}





-(void)pauseGame
{
    NSLog(@"Pause");
    
    if (!pauseOn) {
        pauseOn = YES;
        

        
        [timerBounce invalidate];
        timerBounce =nil;
        
        [timerMovePlatform invalidate];
        timerMovePlatform = nil;
        
        [timerRocket invalidate];
        timerRocket = nil;
        
        [gameTimer invalidate];
        gameTimer =nil;
        
        [timerBGmusic invalidate];
        timerBGmusic = nil;
        
        [audioplayer stop];
        audioplayer = nil;
        
        [audioplayer2 stop];
        audioplayer2 = nil;
        
        [audioplayer3 stop];
        audioplayer3 = nil;
        [audioplayer4 stop];
        audioplayer4 = nil;
        
        viewPause.alpha = 0.7;
    }


else
    {
        
        pauseOn = NO;
        
        viewPause.alpha = 0;
        
        timerBounce = [NSTimer scheduledTimerWithTimeInterval:.07 target:self selector:@selector(jump) userInfo:nil repeats:YES];
        
        
        timerMovePlatform = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(movePlatforms) userInfo:nil repeats:YES];
        
        gameTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(gameTimeMethod) userInfo:nil repeats:YES];
        
        timerBGmusic = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(bgmusicplay) userInfo:nil repeats:NO];
    
        if (rocketOn) {
                timerRocket = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkRocketDuration) userInfo:nil repeats:YES];
            
            
        }
    
    }
    
    
}



-(void)bgmusicplay
{
    

//[audioplayer4 play];
}




@end
