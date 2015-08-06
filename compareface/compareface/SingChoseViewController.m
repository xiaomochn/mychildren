//
//  SingChoseViewController.m
//  compareface
//
//  Created by qiao on 15/6/5.
//  Copyright (c) 2015年 qiao. All rights reserved.
//

#import "SingChoseViewController.h"
#import "btRippleButtton.h"
#import "LTBounceSheet.h"
#import <ShareSDK/ShareSDK.h>
#import "APIKeyAndAPISecret.h"
#import "PulsingHaloLayer.h"
#import "UILabel+FlickerNumber.h"
#import "PECropViewController.h"
#import "MobClick.h"
#import <math.h>
@interface SingChoseViewController ()<PECropViewControllerDelegate>
@property(nonatomic,strong) LTBounceSheet *sheet;
@property(nonatomic,strong) NSMutableArray *scoredetil ;
@property int score;
@end
@implementation SingChoseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    imagePicker = [[UIImagePickerController alloc] init];
    
    // initialize
    NSString *API_KEY = @"d277502ffe983493f92754c4431726db";
    NSString *API_SECRET = @"pxyJuPZXukNG4JGPllXqooYaOOna4rIv";
    [FaceppAPI initWithApiKey:API_KEY andApiSecret:API_SECRET andRegion:APIServerRegionCN];
    
    //    BTRippleButtton *rippleButton = [[BTRippleButtton alloc]initWithImage:[UIImage imageNamed:@"maincolor.png"]
    //                                                                 andFrame:CGRectMake((kSCREEN_WIDTH)/2-50, (kSCREEN_HEIGHT)/2, 100, 100)
    //                                                                andTarget:@selector(toggle)
    //                                                                    andID:self];
    //
    //    [rippleButton setRippeEffectEnabled:YES];
    //    [rippleButton setRippleEffectWithColor:kMAIN_COLOOR];
    //
    //    [self.view addSubview:rippleButton];
    // turn on the debug mode
    [FaceppAPI setDebugMode:TRUE];
    
    self.sheet = [[LTBounceSheet alloc]initWithHeight:250 bgColor:mainColor];
    
    UIButton * option1 = [self produceButtonWithTitle:@"拍 照"];
    option1.frame=CGRectMake(15, 30, kSCREEN_WIDTH-30, 46);
    [option1 addTarget:self action:@selector(toggleClickCM) forControlEvents:UIControlEventTouchUpInside];
    [self.sheet addView:option1];
    
    UIButton * option2 = [self produceButtonWithTitle:@"从相册选择"];
    option2.frame=CGRectMake(15, 90, kSCREEN_WIDTH-30, 46);
    [option2 addTarget:self action:@selector(toggleClickPT) forControlEvents:UIControlEventTouchUpInside];
    [self.sheet addView:option2];
    
    UIButton * cancel = [self produceButtonWithTitle:@"取消"];
    cancel.frame=CGRectMake(15, 170, kSCREEN_WIDTH-30, 46);
    [cancel addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
    
    [self.sheet addView:cancel];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.sheet];
    PulsingHaloLayer *halo = [PulsingHaloLayer layer];
    
    halo.position = self.view.center;
    [self.view.layer addSublayer:halo];
    
    UIButton * rippleButton=[[UIButton alloc]initWithFrame:CGRectMake((kSCREEN_WIDTH)/2-100, (kSCREEN_HEIGHT)/2-100, 200, 200)];
    [rippleButton addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rippleButton];
    //    resultLable=[[UILabel alloc] initWithFrame:CGRectMake(10, (kSCREEN_HEIGHT)-100, kSCREEN_WIDTH-20, 100)];
    //    [self.view addSubview:resultLable];
    [self initalla];
    UIFont *font = [UIFont fontWithName:@"MGentleHKS" size:21];
    [resultLable setFont:font];
    font=[UIFont fontWithName:@"MGentleHKS" size:41];
    [resultLable addGestureRecognizer: [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickUILable)]];
    [scoreLable setFont:font];
    {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"scoreresult" ofType:@"plist"];
    _scoredetil = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    }
    
}
-(int)scoreToLeval:(int )score
{
    return  ( score-50)/7;
}
-(void)onClickUILable
{
    if (_score>50) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:[_scoredetil valueForKey:@"title"][[self scoreToLeval:_score]]
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"了解!"
                              otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
   
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"PageOne"];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"PageOne"];
}

-(UIButton *) produceButtonWithTitle:(NSString*) title
{
    UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor= [UIColor whiteColor];
    button.layer.cornerRadius=23;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont fontWithName:@"MGentleHKS" size:16];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:mainColor forState:UIControlStateNormal];
    return button;
}



- (IBAction)toggleClickCM {
    [self.sheet toggle];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:imagePicker animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"failed to camera"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        
    }
}
- (IBAction)toggleClickPT {
    [self.sheet toggle];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:imagePicker animated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"failed to access photo library"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        
    }
}
- (IBAction)toggle {
    [self.sheet toggle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)pickFromCameraButtonPressed:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:imagePicker animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"failed to camera"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        
    }
}

-(IBAction)pickFromLibraryButtonPressed:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:imagePicker animated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"failed to access photo library"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        
    }
}

-(void)removeImageView
{
    [UIView animateWithDuration:(1) animations:^{
        if (imageView!=nil) {
            CGRect rect= imageView.frame;
            rect.origin.y=kSCREEN_HEIGHT;
            imageView.frame=rect;
        }
        if (imageViewSecond!=nil) {
            CGRect rect= imageViewSecond.frame;
            rect.origin.y=kSCREEN_HEIGHT;
            imageViewSecond.frame=rect;
        }
    } completion:^(BOOL finished) {
        if (imageView!=nil) {
            [imageView removeFromSuperview];
            imageView=nil;
        }
        if (imageViewSecond!=nil) {
            [imageViewSecond removeFromSuperview];
            imageViewSecond=nil;
        }
      
        
    }];
}
- (IBAction)initall:(id)sender {
    [self removeImageView];
    [self initalla];
}
#pragma  截屏
- (UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
 
    return  theImage;//[self getImageAreaFromImage:theImage atFrame:r];
}

- (IBAction)sharebtn:(id)sender {
 
//    UIImage *image=[self imageFromView:self.view atFrame:CGRectMake(0, 100, kSCREEN_WIDTH, kSCREEN_HEIGHT-100)];
    //构造分享内容
    UIView * theView = self.view  ;
    CGRect r=CGRectMake(0, 100, kSCREEN_WIDTH, kSCREEN_HEIGHT-100);

    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:context];
  UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"亲子鉴定，我们的基因相似率为％d",_score]
                                       defaultContent:@"亲子鉴定"
                                                image:[ShareSDK pngImageWithImage:firstImage]
                                                title:@"亲子鉴定"
                                                  url:@"https://itunes.apple.com/us/app/qin-zi-jian-ding/id1021182222?l=zh&ls=1&mt=8"
                                          description:[NSString stringWithFormat:@"我和孩子的基因相似率为%d％，敢试试你和你家孩子么",_score]
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }     }];
}
//
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

// Use facepp SDK to detect faces
-(void) detectWithImage: (UIImage*) image {
    //    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    FaceppResult *result = [[FaceppAPI detection] detectWithURL:nil orImageData:UIImageJPEGRepresentation(image, 0.5) mode:FaceppDetectionModeNormal attribute:FaceppDetectionAttributeAll];
    if (result.success) {
        switch ([[result content][@"face"] count]) {
            case 0:
                [resultLable setText:@"照片中没找到人，重新传一张试试"];
                break;
                
            case 1:
                [resultLable setText:@"就一个人怎么测"];
                break;
                
            default:
                face1=[result content][@"face"][0];
                face2=[result content][@"face"][1];
                [resultLable setText:[NSString stringWithFormat:@"相片上总共找到%d个人,只计算前两个哦",[[result content][@"face"] count]]];
                if (face1!=nil&&face2!=nil) {
                    FaceppResult *resultcoompare=[[[FaceppRecognition alloc ] init] compareWithFaceId1:[result content][@"face"][0][@"face_id"]  andId2:[result content][@"face"][1][@"face_id"]  async:NO];
                    NSString *componentstr=@"";
                    
                    double maxscore=[[[resultcoompare content][@"component_similarity"] objectForKey:@"eye"] doubleValue];
                    NSString *maxkey=@"眼睛";
                    if (maxscore<[[[resultcoompare content][@"component_similarity"] objectForKey:@"nose"] doubleValue]) {
                        maxscore=[[[resultcoompare content][@"component_similarity"] objectForKey:@"nose"] doubleValue];
                        maxkey=@"鼻子";
                    }
                    if (maxscore<[[[resultcoompare content][@"component_similarity"] objectForKey:@"mouth"] doubleValue]) {
                        maxscore=[[[resultcoompare content][@"component_similarity"] objectForKey:@"mouth"] doubleValue];
                        maxkey=@"嘴";
                    }
                    if (maxscore<[[[resultcoompare content][@"component_similarity"] objectForKey:@"eyebrow"] doubleValue]) {
                        maxscore=[[[resultcoompare content][@"component_similarity"] objectForKey:@"eyebrow"] doubleValue];
                        maxkey=@"眼睫毛";
                    }
                     _score=[self getScoreWithTrueScore:(int)([[resultcoompare content][@"similarity"] doubleValue])];
                       componentstr=[NSString stringWithFormat:@"你们看起来最像的地方是%@，你们相差%d岁",maxkey,abs([ face1[@"attribute"][@"age"][@"value"] integerValue]-[ face2[@"attribute"][@"age"][@"value"] integerValue])];
                  
                
                    [resultLable setText:componentstr];
                    //                    [scoreLable dd_setNumber:@(30)];
                    
                    
                    if ((int)([[resultcoompare content][@"similarity"] doubleValue])>95) {
                        [resultLable setText:@"不要说你们是双胞胎哦..."];
                    }
                    
                     [scoreLable setText:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:_score]]];
                     [scoreLable setHidden:NO];
                  
                }

        }
        
        
        //        FaceppResult *resulu= [[[FaceppRecognition alloc] init] searchWithKeyFaceId:[result content][@"face"][0][@"face_id"] andFacesetId:nil orFacesetName:@"starlib3" andCount:nil async:NO];
        
    } else {
        // some errors occurred
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"服务器出了会小差，重新试试呗"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"抽你丫的"
                              otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    
   
    [load stopAnimating];

    //    [MBProgressHUD hideHUDForView:self.view animated:YES];
  
}
-(int ) getScoreWithTrueScore:(int )score
{
    return score*0.5+50;;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
      [picker dismissModalViewControllerAnimated:YES];
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = info[UIImagePickerControllerOriginalImage];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:YES completion:NULL];
  
    if (YES) {
        return;
    }
   
    [load startAnimating];
    [scoreLable setHidden:YES];
    UIImage *sourceImage = info[UIImagePickerControllerOriginalImage];
    
    UIImage *imageToDisplay = [self fixOrientation:sourceImage];
    float scale = 1.0f;
    scale = MIN(scale, (kSCREEN_WIDTH-40)/imageToDisplay.size.width);
    scale = MIN(scale, (kSCREEN_HEIGHT/3*2)/imageToDisplay.size.height);
    
    //    [imageView setImage:sourceImage];
    // perform detection in background thread
    
    if (imageView==nil) {
        imageView=[[UIImageView alloc] initWithImage:imageToDisplay];
        [imageView setFrame:CGRectMake(kSCREEN_WIDTH/2-imageToDisplay.size.width * scale/2,
                                       kSCREEN_HEIGHT/2-imageToDisplay.size.height * scale/2,
                                       imageToDisplay.size.width * scale,
                                       imageToDisplay.size.height * scale)];
        imageView.userInteractionEnabled=true;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggle)]];
        [self.view addSubview:imageView];
    }else if(imageViewSecond==nil)
    {
        float scale = 1.0f;
        scale = MIN(scale, (kSCREEN_WIDTH-40)/imageToDisplay.size.width);
        scale = MIN(scale, (kSCREEN_HEIGHT/3*2)/imageToDisplay.size.height);
        scale=scale/2;
        
        imageViewSecond=[[UIImageView alloc] initWithImage:imageToDisplay];
        [imageViewSecond setFrame:CGRectMake(kSCREEN_WIDTH,
                                             kSCREEN_HEIGHT/2-imageToDisplay.size.height * scale/2,
                                             imageToDisplay.size.width * scale,
                                             imageToDisplay.size.height * scale)];
        imageViewSecond.userInteractionEnabled=true;
        [imageViewSecond addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggle)]];
        [self.view addSubview:imageViewSecond];
        [self performSelector:@selector(addphoto) withObject:nil afterDelay:0.1f];
    }else
    {
        float scale = 1.0f;
        scale = MIN(scale, (kSCREEN_WIDTH-40)/imageToDisplay.size.width);
        scale = MIN(scale, (kSCREEN_HEIGHT/3*2)/imageToDisplay.size.height);
        scale=scale/2;
        
        imageViewhTemp=[[UIImageView alloc] initWithImage:imageToDisplay];
        [imageViewhTemp setFrame:CGRectMake(kSCREEN_WIDTH,
                                            kSCREEN_HEIGHT/2-imageToDisplay.size.height * scale/2,
                                            imageToDisplay.size.width * scale,
                                            imageToDisplay.size.height * scale)];
        imageViewhTemp.userInteractionEnabled=true;
        [imageViewhTemp addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggle)]];
        [self.view addSubview:imageViewhTemp];
        [self performSelector:@selector(addmorephoto) withObject:nil afterDelay:0.1f];
    }
    [resultLable setText:@"客官您稍等"];
    UIImage *imageToDetect=imageToDisplay;
    if (firstImage!=nil) {
        imageToDetect=[self addImage:imageToDisplay toImage:firstImage];
        
    }
    firstImage=imageToDisplay;
    [self performSelectorInBackground:@selector(detectWithImage:) withObject:imageToDetect ];
    
}

- (UIImage *)addImage:(UIImage *)image2 toImage:(UIImage *)image1 {
    
    UIGraphicsBeginImageContext(CGSizeMake(image1.size.width+image2.size.width, MAX(image1.size.height, image2.size.height)));
    
    // Draw image1
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    // Draw image2
    [image2 drawInRect:CGRectMake(image1.size.width, 0, image2.size.width, image2.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

-(void)initalla
{
    _score=0;
    [load stopAnimating];
    [scoreLable setHidden:YES];
    firstImage=nil;
    [UIView animateWithDuration:1 animations:^{
        [resultLable setText:@"赶紧选一张照片试试吧"];
    }];
    
    
}
-(void)addphoto
{
    [UIView animateWithDuration:1 animations:^{
        CGRect rect=imageView.frame;
        rect.size.height=rect.size.height/2;
        rect.size.width=rect.size.width/2;
        rect.origin.y=kSCREEN_HEIGHT/2-rect.size.height/2;
        imageView.frame=rect;
        CGRect rectsecond=imageViewSecond.frame;
        rectsecond.origin.x=kSCREEN_WIDTH/2;
        imageViewSecond.frame=rectsecond;
        //            [self.view addSubview:imageViewSecond];
    }];
    
}
-(void)addmorephoto
{
    
    [UIView animateWithDuration:1 animations:^{
        UIImageView *temp=imageView;
        
        CGRect rect=imageView.frame;
        rect.origin.x=-rect.size.width;
        imageView.frame=rect;
        imageView=imageViewSecond;
        rect=imageView.frame;
        rect.origin.x=kSCREEN_WIDTH/2-rect.size.width;
        imageView.frame=rect;
        imageViewSecond=imageViewhTemp;
        CGRect rectsecond=imageViewSecond.frame;
        rectsecond.origin.x=kSCREEN_WIDTH/2;
        imageViewSecond.frame=rectsecond;
        imageViewhTemp=temp;
    } completion:^(BOOL finished) {
        [imageViewhTemp removeFromSuperview];
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
}

// callback when cropping finished
- (void)cropViewControllerDidCancel:(PECropViewController *)controller{
     [controller dismissModalViewControllerAnimated:YES];
}
- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [controller dismissViewControllerAnimated:YES completion:^{
        
    }];
    [load startAnimating];
    [scoreLable setHidden:YES];
    UIImage *sourceImage = croppedImage;
    
    
    UIImage *imageToDisplay = [self fixOrientation:sourceImage];
    float scale = 1.0f;
    scale = MIN(scale, (kSCREEN_WIDTH-40)/imageToDisplay.size.width);
    scale = MIN(scale, (kSCREEN_HEIGHT/3*2)/imageToDisplay.size.height);
    
    //    [imageView setImage:sourceImage];
    // perform detection in background thread
    
    if (imageView==nil) {
        imageView=[[UIImageView alloc] initWithImage:imageToDisplay];
        [imageView setFrame:CGRectMake(kSCREEN_WIDTH/2-imageToDisplay.size.width * scale/2,
                                       kSCREEN_HEIGHT/2-imageToDisplay.size.height * scale/2,
                                       imageToDisplay.size.width * scale,
                                       imageToDisplay.size.height * scale)];
        imageView.userInteractionEnabled=true;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggle)]];
        [self.view addSubview:imageView];
    }else if(imageViewSecond==nil)
    {
        float scale = 1.0f;
        scale = MIN(scale, (kSCREEN_WIDTH-40)/imageToDisplay.size.width);
        scale = MIN(scale, (kSCREEN_HEIGHT/3*2)/imageToDisplay.size.height);
        scale=scale/2;
        
        imageViewSecond=[[UIImageView alloc] initWithImage:imageToDisplay];
        [imageViewSecond setFrame:CGRectMake(kSCREEN_WIDTH,
                                             kSCREEN_HEIGHT/2-imageToDisplay.size.height * scale/2,
                                             imageToDisplay.size.width * scale,
                                             imageToDisplay.size.height * scale)];
        imageViewSecond.userInteractionEnabled=true;
        [imageViewSecond addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggle)]];
        [self.view addSubview:imageViewSecond];
        [self performSelector:@selector(addphoto) withObject:nil afterDelay:0.1f];
    }else
    {
        float scale = 1.0f;
        scale = MIN(scale, (kSCREEN_WIDTH-40)/imageToDisplay.size.width);
        scale = MIN(scale, (kSCREEN_HEIGHT/3*2)/imageToDisplay.size.height);
        scale=scale/2;
        
        imageViewhTemp=[[UIImageView alloc] initWithImage:imageToDisplay];
        [imageViewhTemp setFrame:CGRectMake(kSCREEN_WIDTH,
                                            kSCREEN_HEIGHT/2-imageToDisplay.size.height * scale/2,
                                            imageToDisplay.size.width * scale,
                                            imageToDisplay.size.height * scale)];
        imageViewhTemp.userInteractionEnabled=true;
        [imageViewhTemp addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggle)]];
        [self.view addSubview:imageViewhTemp];
        [self performSelector:@selector(addmorephoto) withObject:nil afterDelay:0.1f];
    }
    [resultLable setText:@"客官您稍等"];
    UIImage *imageToDetect=imageToDisplay;
    if (firstImage!=nil) {
        imageToDetect=[self addImage:imageToDisplay toImage:firstImage];
        
    }
    firstImage=imageToDisplay;
    [self performSelectorInBackground:@selector(detectWithImage:) withObject:imageToDetect ];

}



@end
