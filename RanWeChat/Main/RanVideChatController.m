//
//  RanVideChatController.m
//  RanWeChat
//
//  Created by zouran on 2020/7/9.
//  Copyright © 2020 ran. All rights reserved.
//

#import "RanVideChatController.h"
#import <CoreGraphics/CoreGraphics.h>
#import <AVFoundation/AVFoundation.h>
@import SocketIO;

@interface RanVideChatController ()<RTCPeerConnectionDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,NSWindowDelegate>

// 本地的数据流
@property (weak) IBOutlet RTCMTLNSVideoView *localPreviewView;

@property(nonatomic, strong)RTCMediaStream *localStream;
// 姓名 rtcpeerconnect 对应的字典
@property(nonatomic, strong)NSMutableDictionary *userConnectDic;
// 连接工厂
@property(nonatomic, strong)RTCPeerConnectionFactory *factory;
// 远程视频界面
@property (weak, nonatomic) IBOutlet RTCMTLNSVideoView *remoteView;
// 远程视频流
@property(nonatomic, strong)RTCVideoTrack *remoteTrack;

// 后置摄像头
@property(nonatomic, strong) RTCVideoTrack *behind_videotrack;
// 前置摄像头
@property(nonatomic, strong) RTCVideoTrack *front_videotrack;
// 是否是前置
@property(nonatomic, assign, getter=isFront) BOOL Front;

// 是否关闭
@property(nonatomic, assign) BOOL close;

@property (nonatomic, strong)SocketManager* manager;
@property (nonatomic, strong)SocketIOClient* socket;


@property (nonatomic, strong)RTCPeerConnection *pc;

@property (nonatomic, strong)RTCAudioTrack *audioTrack;

@property (nonatomic, strong)AVCaptureSession *captureSession;
@property (nonatomic, strong)AVCaptureConnection* connectionVideo;
@property (nonatomic, strong)AVCaptureConnection* connectionAudio;
@property (weak, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong)RTCVideoSource *source;


@property (nonatomic,strong) NSAlert *alert;

@property(nonatomic, strong)RTCVideoCapturer *cap;

@property(nonatomic, strong)AVCaptureSession *screenCaptureSession;


@end

@implementation RanVideChatController

- (void)viewDidLayout {
    [super viewDidLayout];
    NSButton *closeButton = [self.view.window standardWindowButton:NSWindowCloseButton];
    [closeButton setTarget:self];
    [closeButton setAction:@selector(closeApplication)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 竖屏聊天
//    [self localImage];
    
    // 横屏聊天
    [self otherlocalImage];
    
    // 屏幕共享
//    [self screenShare];
    [self createConnection];
    
    NSURL* url = [[NSURL alloc] initWithString:@"http://192.168.137.243:9000/socket.io"];
    self.manager = [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @NO, @"compress": @NO}];
    self.socket = self.manager.defaultSocket;

    [self.socket on:@"connect" callback:^(NSArray*  _Nonnull data, SocketAckEmitter* _Nonnull ack) {
        NSDictionary *joinDic = @{@"userId": @"mac",
                @"roomName" : @"Room1"};
                // 加入房间
        [self.socket emit:@"join-room" with: @[[self dictionaryToJson:joinDic]]];
    }];

    [self.socket on:@"user-joined" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        NSLog(@"user-joined == %@",data);
        for (NSString *str in data) {
            if ([str isEqualToString:@"mac"]) {
//                [self localImage];
            }
        }
    }];

    [self.socket on:@"broadcast" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        [data enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull castDic, NSUInteger idx, BOOL * _Nonnull stop) {
            NSNumber *msgType = castDic[@"msgType"];
            NSString *userId = castDic[@"userId"];

            if ([msgType isEqual: @(0x01)]) {
                if ([userId isEqualToString:@"mac"]) {
                    return;
                }
                NSLog(@"offer");
                [self handleRemoteOffer:castDic];
            } else if ([msgType isEqual:@(0x02)]) {
                if ([userId isEqualToString:@"mac"]) {
                    return;
                }

                [self handleRemoteAnswer:castDic];
                NSLog(@"answer");

            } else if ([msgType isEqual:@(0x03)]) {
                if ([userId isEqualToString:@"mac"]) {
                    return;
                }
                [self handleRemoteCandidate:castDic];
                NSLog(@"ice");
            }
        }];
    }];
    [self.socket connect];


}


- (void)handleRemoteOffer:(NSDictionary *)dic {
    RTCSessionDescription *ddd = [[RTCSessionDescription alloc] initWithType:RTCSdpTypeOffer sdp:dic[@"sdp"]];
    // 发送自己的sdp
    [self.pc setRemoteDescription:ddd completionHandler:^(NSError * _Nullable error) {
        if (error == nil) {

        } else {

        }
    }];
}

- (void)handleRemoteAnswer:(NSDictionary *)dic {
        RTCSessionDescription *sdp = [[RTCSessionDescription alloc] initWithType:RTCSdpTypeAnswer sdp:dic[@"sdp"]];
     [self.pc setRemoteDescription:sdp completionHandler:^(NSError * _Nullable error) {
           if (error == nil) {

           } else {

           }
       }];
}

- (void)handleRemoteCandidate:(NSDictionary *)dic {
    /*
     @{@"userId": [[UIDevice currentDevice] name],
        @"msgType" : @"3",
     @"id" : candidate.sdpMid,
     @"label":[NSString stringWithFormat:@"%d",candidate.sdpMLineIndex],
     @"candidate":candidate.sdp};
     
     */
//    RTCPeerConnection *con = [self createConnection];
    RTCIceCandidate *candidate = [[RTCIceCandidate alloc] initWithSdp:dic[@"candidate"] sdpMLineIndex:[dic[@"label"] intValue] sdpMid:dic[@"id"]];
    [self.pc addIceCandidate:candidate];
    
}

//json格式字符串转字典：

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) { return nil; }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}

//字典转json格式字符串：
- (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

// 设置本地摄像头
- (void)localImage {
     NSArray<AVCaptureDevice*>* devices = [RTCCameraVideoCapturer captureDevices];
        if (devices.count > 0) {
//            AVCaptureDevice* device = devices[0];
//            [RTCPeerConnectionFactory initialize];
            if (!self.factory) {
//                NSArray<RTCVideoCodecInfo *> *ddd = [RTCDefaultVideoEncoderFactory supportedCodecs];
//                            RTCDefaultVideoEncoderFactory *videoEncoderFactory = [[RTCDefaultVideoEncoderFactory alloc]init];
//                RTCVideoCodecInfo *info = ddd[2];
//                [videoEncoderFactory setPreferredCodec:info];
//                RTCDefaultVideoDecoderFactory *videoDecoderFactory = [[RTCDefaultVideoDecoderFactory alloc]init];
//                self.factory = [[RTCPeerConnectionFactory alloc] initWithEncoderFactory:videoEncoderFactory decoderFactory:videoDecoderFactory];
                //先初始化工厂
                RTCVideoCodecInfo *codecInfo = [[RTCVideoCodecInfo alloc]initWithName:@"VP8"];
                RTCDefaultVideoEncoderFactory *videoEncoderFactoryr = [[RTCDefaultVideoEncoderFactory alloc]init];
                id videoDecoderFactory = [[RTCDefaultVideoDecoderFactory alloc]init];
                // for ( RTCVideoCodecInfo *obj in videoDecoderFactory.supportedCodecs) {
                // NSLog(@“Decoderobj = %@”,obj.name);
                // }
                // for ( RTCVideoCodecInfo *obj in videoEncoderFactoryr.supportedCodecs) {
                // NSLog(@“Encoderobj = %@”,obj.name);
                // }
                videoEncoderFactoryr.preferredCodec = codecInfo;
                self.factory = [[RTCPeerConnectionFactory alloc] initWithEncoderFactory:videoEncoderFactoryr decoderFactory:videoDecoderFactory];
            }
            self.localStream = [self.factory mediaStreamWithStreamId:@"RTCmS"];
            self.source = [self.factory videoSource];
            self.cap = [[RTCVideoCapturer alloc] initWithDelegate:self.source];
            NSError *deviceError;
            AVCaptureDevice *cameraDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            
            AVCaptureDeviceInput *inputCameraDevice = [AVCaptureDeviceInput deviceInputWithDevice:cameraDevice error:&deviceError];
                // make output device
                
            AVCaptureVideoDataOutput *outputVideoDevice = [[AVCaptureVideoDataOutput alloc] init];
            NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
            NSNumber* val = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange];
            NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:val forKey:key];
            outputVideoDevice.videoSettings = videoSettings;
            [outputVideoDevice setSampleBufferDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)];
            AVCaptureAudioDataOutput *outputAudioDevice = [[AVCaptureAudioDataOutput alloc] init];
            NSDictionary *audioSettings = @{AVFormatIDKey : @(kAudioFormatMPEG4AAC), AVSampleRateKey : @44100, AVEncoderBitRateKey : @64000, AVNumberOfChannelsKey : @1};
            outputAudioDevice.audioSettings = audioSettings;
                // initialize capture session

            self.captureSession = [[AVCaptureSession alloc] init];
            [self.captureSession addInput:inputCameraDevice];
            [self.captureSession addOutput:outputVideoDevice];
            [self.captureSession addOutput:outputAudioDevice];
                
                // begin configuration for the AVCaptureSession
            [self.captureSession beginConfiguration];
                // picture resolution
            [self.captureSession setSessionPreset:[NSString stringWithString:AVCaptureSessionPreset1280x720]];
            self.connectionVideo = [outputVideoDevice connectionWithMediaType:AVMediaTypeVideo];
            self.connectionVideo.videoMirrored = NO;
            [self.captureSession commitConfiguration];
            // make preview layer and add so that camera's view is displayed on screen
            self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
            [self.previewLayer setVideoGravity:AVLayerVideoGravityResize];
            [self.view setWantsLayer:YES];
            self.previewLayer.frame = self.view.bounds;
            [self.view.layer addSublayer:self.previewLayer];
            [self.captureSession startRunning];
        }
}

- (void)otherlocalImage {
    NSArray<AVCaptureDevice*>* devices = [RTCCameraVideoCapturer captureDevices];
        if (devices.count > 0) {
            AVCaptureDevice* device = devices[0];
            if (!self.factory) {
                 NSArray<RTCVideoCodecInfo *> *ddd = [RTCDefaultVideoEncoderFactory supportedCodecs];
                RTCDefaultVideoEncoderFactory *videoEncoderFactory = [[RTCDefaultVideoEncoderFactory alloc]init];
                RTCVideoCodecInfo *info = ddd[2];
                [videoEncoderFactory setPreferredCodec:info];
                RTCDefaultVideoDecoderFactory *videoDecoderFactory = [[RTCDefaultVideoDecoderFactory alloc]init];
                self.factory = [[RTCPeerConnectionFactory alloc] initWithEncoderFactory:videoEncoderFactory decoderFactory:videoDecoderFactory];
//                self.factory = [[RTCPeerConnectionFactory alloc] init];
            }
            self.localStream = [self.factory mediaStreamWithStreamId:@"RTCmS"];
            RTCVideoSource *videosorce = [self.factory videoSource];
            self.capture = [[RTCCameraVideoCapturer alloc] initWithDelegate:videosorce];
            AVCaptureDeviceFormat *format = [self selectFormatForDevice:device];
            NSInteger fps = [self selectFpsForFormat:format];
            RTCMTLNSVideoView *localView = [[RTCMTLNSVideoView alloc] initWithFrame:CGRectMake(0, 120, 200, 200)];
            localView.wantsLayer = YES;
            localView.layer.backgroundColor = [NSColor lightGrayColor].CGColor;
            localView.layer.borderWidth = 2;
            localView.layer.borderColor = [NSColor redColor].CGColor;
            [self.view addSubview:localView];
            [self.capture startCaptureWithDevice:device format:format fps:fps completionHandler:^(NSError * _Nonnull error) {
                self.front_videotrack = [self.factory videoTrackWithSource:videosorce trackId:@"RTCvS0"];
                [self.localStream addVideoTrack:self.front_videotrack];
                [self.front_videotrack addRenderer:localView];
            }];
            
        }
}

// 为自己发offer
- (void)sendOffer {
//    RTCPeerConnection *con = [self createConnection];
    [self.pc offerForConstraints:[self offerOranswerConstraint] completionHandler:^(RTCSessionDescription * _Nullable sdp, NSError * _Nullable sdpError) {
           if (sdpError == nil) {
               [self.pc setLocalDescription:sdp completionHandler:^(NSError * _Nullable error) {
                   if (error == nil) {

                   } else {

                   }
               }];
           }
    }];
}


//#pragma mark -- RTC连接的代理
/** Called when the SignalingState changed. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection
didChangeSignalingState:(RTCSignalingState)stateChanged {
    NSLog(@"%s",__func__);
    // 发送自己的sdp
    if (stateChanged == RTCSignalingStateHaveLocalOffer) {
        [peerConnection offerForConstraints:[self offerOranswerConstraint] completionHandler:^(RTCSessionDescription * _Nullable sdp, NSError * _Nullable error) {
            NSDictionary *sdpDic = @{@"userId": @"mac",
                                    @"msgType" : @(0x01),
                                     @"sdp" : sdp.sdp};
//            [self.socket emit:@"broadcast" with:@[[self dictionaryToJson:sdpDic]]];
            [self.socket emit:@"broadcast" with:@[sdpDic]];
        }];
    }
    else if (stateChanged == RTCSignalingStateHaveRemoteOffer) {
        [peerConnection answerForConstraints:[self offerOranswerConstraint] completionHandler:^(RTCSessionDescription * _Nullable sdp, NSError * _Nullable error) {
            NSDictionary *sdpDic = @{@"userId": @"mac",
                                     @"msgType" : @(0x02),
                                     @"sdp" : sdp.sdp};
//            [self.socket emit:@"broadcast" with:@[[self dictionaryToJson:sdpDic]]];
            [self.socket emit:@"broadcast" with:@[sdpDic]];

            [self.pc setLocalDescription:sdp completionHandler:^(NSError * _Nullable error) {


            }];
        }];
    }
}


/** Called when media is received on a new stream from remote peer. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection didAddStream:(RTCMediaStream *)stream {
    RTCVideoTrack * track1 = [stream.videoTracks lastObject];
    self.remoteTrack = track1;
    [self.remoteTrack addRenderer:self.remoteView];
}

/** Called when a remote peer closes a stream.
 *  This is not called when RTCSdpSemanticsUnifiedPlan is specified.
 */
- (void)peerConnection:(RTCPeerConnection *)peerConnection didRemoveStream:(RTCMediaStream *)stream {
    NSLog(@"%s",__func__);
}

/** Called when negotiation is needed, for example ICE has restarted. */
- (void)peerConnectionShouldNegotiate:(RTCPeerConnection *)peerConnection {
    NSLog(@"%s",__func__);
}

/** Called any time the IceConnectionState changes. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection
    didChangeIceConnectionState:(RTCIceConnectionState)newState {
    NSLog(@"%s",__func__);
    NSLog(@"%s======%ld",__func__,newState);
    if (newState == RTCIceConnectionStateCompleted || newState == RTCIceConnectionStateConnected) {
//         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"聊天成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//                                [alertController addAction:actionOne];
//        [self presentViewController:alertController animated:YES completion:NULL];
    }
}

/** Called any time the IceGatheringState changes. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection
    didChangeIceGatheringState:(RTCIceGatheringState)newState {
    
}

/** New ice candidate has been found. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection
    didGenerateIceCandidate:(RTCIceCandidate *)candidate {
#pragma mark 上传ice

    NSDictionary *iceDic = @{@"userId":@"mac",
                                @"msgType" : @(0x03),
                             @"id" : candidate.sdpMid,
                             @"label":[NSString stringWithFormat:@"%d",candidate.sdpMLineIndex],
                             @"candidate":candidate.sdp};
//    [self.socket emit:@"broadcast" with:@[[self dictionaryToJson:iceDic]]];
    [self.socket emit:@"broadcast" with:@[iceDic]];

}

/** Called when a group of local Ice candidates have been removed. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection
    didRemoveIceCandidates:(NSArray<RTCIceCandidate *> *)candidates {
        NSLog(@"%s",__func__);
    }

/** New data channel has been opened. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection
    didOpenDataChannel:(RTCDataChannel *)dataChannel {
        NSLog(@"%s",__func__);
    }

/** Called when a receiver and its track are created. */
- (void)peerConnection:(RTCPeerConnection *)peerConnection
didAddReceiver:(RTCRtpReceiver *)rtpReceiver
               streams:(NSArray<RTCMediaStream *> *)mediaStreams  {


}

- (void)peerConnection:(RTCPeerConnection *)peerConnection
didStartReceivingOnTransceiver:(RTCRtpTransceiver *)transceiver {


}

- (RTCPeerConnection *)createConnection {
    NSDictionary *fieldTrials = @{};
    RTCInitFieldTrialDictionary(fieldTrials);
    RTCInitializeSSL();
    RTCSetupInternalTracer();
//    // Create peer connection.
    RTCConfiguration *config = [[RTCConfiguration alloc] init];
    self.pc = [self.factory
                         peerConnectionWithConfiguration:config
                                             constraints:[self defaultPeerConnectionConstraints]
                                                delegate:self];
    RTCMediaConstraints *constraints = [self defaultMediaAudioConstraints];
    RTCAudioSource *source = [self.factory audioSourceWithConstraints:constraints];
        //音频
    RTCAudioTrack *loclTrc = [self.factory audioTrackWithSource:source trackId:@"RTCaS0"];
    loclTrc.source.volume = 10;
    [self.localStream addAudioTrack:loclTrc];
    [self.pc addStream:self.localStream];
    return self.pc;
}


- (RTCMediaConstraints *)offerOranswerConstraint {
    NSMutableDictionary *dic = [@{kRTCMediaConstraintsOfferToReceiveAudio:kRTCMediaConstraintsValueTrue,kRTCMediaConstraintsOfferToReceiveVideo:kRTCMediaConstraintsValueTrue} mutableCopy];
    RTCMediaConstraints *constraints = [[RTCMediaConstraints alloc] initWithMandatoryConstraints:dic optionalConstraints:nil];
    return constraints;
}

- (RTCMediaConstraints *)defaultPeerConnectionConstraints {
  RTCMediaConstraints* constraints =
      [[RTCMediaConstraints alloc]
          initWithMandatoryConstraints:nil
                   optionalConstraints:@{ @"DtlsSrtpKeyAgreement":@"true"}];
  return constraints;
}


 - (RTCMediaConstraints *)defaultMediaAudioConstraints {
   NSDictionary *mandatoryConstraints = @{};
   RTCMediaConstraints *constraints =
       [[RTCMediaConstraints alloc] initWithMandatoryConstraints:mandatoryConstraints
                                             optionalConstraints:nil];
   return constraints;
}

- (void)startCaptureLocalVideo:(id<RTCVideoRenderer>)render {
}


- (AVCaptureDeviceFormat *)selectFormatForDevice:(AVCaptureDevice *)device {
  NSArray<AVCaptureDeviceFormat *> *formats =
      [RTCCameraVideoCapturer supportedFormatsForDevice:device];
  int targetWidth = 1280;
  int targetHeight = 720;
  AVCaptureDeviceFormat *selectedFormat = nil;
  int currentDiff = INT_MAX;

  for (AVCaptureDeviceFormat *format in formats) {
      
     
      
    CMVideoDimensions dimension = CMVideoFormatDescriptionGetDimensions(format.formatDescription);
      NSLog(@"%d---%d",dimension.width,dimension.height);
    FourCharCode pixelFormat = CMFormatDescriptionGetMediaSubType(format.formatDescription);
      
    int diff = abs(targetWidth - dimension.width) + abs(targetHeight - dimension.height);
    if (diff < currentDiff) {
      selectedFormat = format;
      currentDiff = diff;
    } else if (diff == currentDiff && pixelFormat == [self.capture preferredOutputPixelFormat]) {
      selectedFormat = format;
    }
  }

  return selectedFormat;
}

- (NSInteger)selectFpsForFormat:(AVCaptureDeviceFormat *)format {
  Float64 maxSupportedFramerate = 0;
  for (AVFrameRateRange *fpsRange in format.videoSupportedFrameRateRanges) {
    maxSupportedFramerate = fmax(maxSupportedFramerate, fpsRange.maxFrameRate);
  }
  return fmin(maxSupportedFramerate, 15);
}

- (IBAction)callClick:(NSButton *)sender {
    [self.pc offerForConstraints:[self offerOranswerConstraint] completionHandler:^(RTCSessionDescription * _Nullable sdp, NSError * _Nullable sdpError) {
           if (sdpError == nil) {
               [self.pc setLocalDescription:sdp completionHandler:^(NSError * _Nullable error) {
                   

               }];
           } else {
               NSLog(@"--->error %@",sdpError);
           }
    }];
}

- (IBAction)endCallClick:(NSButton *)sender {
    [self.screenCaptureSession stopRunning];
    [self.captureSession stopRunning];
    [self.capture stopCapture];
    self.factory = nil;
    self.pc = nil;
    [self.socket disconnect];
    RTCStopInternalCapture();
    RTCShutdownInternalTracer();
    [self.view.window orderOut:nil];
    [self.view.window close];
}

- (void)closeApplication {
    [self.screenCaptureSession stopRunning];
    [self.captureSession stopRunning];
    self.alert.informativeText = @"关闭窗口将关闭视频聊天";
    [self.capture stopCapture];
    RTCStopInternalCapture();
    RTCShutdownInternalTracer();
    self.factory = nil;
    self.pc = nil;
    [self.alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        [self.captureSession stopRunning];
        [self.socket disconnect];
        [self.view.window orderOut:nil];
        [self.view.window close];
    }];
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if (connection == self.connectionVideo) {
                // Handle video sample buffer
            if (CMSampleBufferGetNumSamples(sampleBuffer) != 1 || !CMSampleBufferIsValid(sampleBuffer) ||
                !CMSampleBufferDataIsReady(sampleBuffer)) {
              return;
            }

            CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
            if (pixelBuffer == nil) {
              return;
            }

            RTCCVPixelBuffer *rtcPixelBuffer = [[RTCCVPixelBuffer alloc] initWithPixelBuffer:pixelBuffer];
            int64_t timeStampNs =
                CMTimeGetSeconds(CMSampleBufferGetPresentationTimeStamp(sampleBuffer)) * NSEC_PER_SEC;
            RTCVideoFrame *videoFrame = [[RTCVideoFrame alloc] initWithBuffer:rtcPixelBuffer
                                                                     rotation:RTCVideoRotation_0
                                                                  timeStampNs:timeStampNs];
            
            
            // connect the video frames to the WebRTC
            [self.source capturer:self.cap didCaptureVideoFrame:videoFrame];
            
            RTCVideoTrack *videoTrack = [self.factory videoTrackWithSource:self.source trackId:@"RTCvS0"];
            [self.localStream addVideoTrack:videoTrack];
    } else {
        if (CMSampleBufferGetNumSamples(sampleBuffer) != 1 || !CMSampleBufferIsValid(sampleBuffer) ||
            !CMSampleBufferDataIsReady(sampleBuffer)) {
          return;
        }

        CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        if (pixelBuffer == nil) {
          return;
        }

        RTCCVPixelBuffer *rtcPixelBuffer = [[RTCCVPixelBuffer alloc] initWithPixelBuffer:pixelBuffer];
        int64_t timeStampNs =
            CMTimeGetSeconds(CMSampleBufferGetPresentationTimeStamp(sampleBuffer)) * NSEC_PER_SEC;
        RTCVideoFrame *videoFrame = [[RTCVideoFrame alloc] initWithBuffer:rtcPixelBuffer
                                                                 rotation:RTCVideoRotation_0
                                                              timeStampNs:timeStampNs];
        
        
        // connect the video frames to the WebRTC
        [self.source capturer:self.cap didCaptureVideoFrame:videoFrame];
        
        RTCVideoTrack *videoTrack = [self.factory videoTrackWithSource:self.source trackId:@"RTCvS0"];
        [self.localStream addVideoTrack:videoTrack];
    }
    
}

-(NSAlert *)alert {
    if (!_alert) {
        _alert = [[NSAlert alloc]init];
        _alert.messageText = @"温馨提示";
        _alert.informativeText = @"这是一个警告⚠️";
//        _alert.icon = [NSImage imageNamed:@"1"];
        [_alert addButtonWithTitle:@"确定"];
//        _alert.showsHelp = YES;
        _alert.delegate = self;
        _alert.alertStyle = NSAlertStyleWarning;
        _alert.helpAnchor = @"哈哈哈";
//        _alert.suppressionButton.target = self;
//        _alert.suppressionButton.action = @selector(handleSuppressionButton:);
//        [_alert.suppressionButton setTitle:@"2341224"];
//        _alert.showsSuppressionButton = YES;
        NSImageView *imageView = [[NSImageView alloc]initWithFrame:NSMakeRect(0, 0, 200, 50)];
//        imageView.image = [NSImage imageNamed:@"2"];
        _alert.accessoryView = imageView;
//        [_alert layout];
    }
    return _alert;
}

// 屏幕共享
- (void)screenShare {
    self.screenCaptureSession = [[AVCaptureSession alloc] init];
    
    AVCaptureVideoDataOutput* captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* val = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:val forKey:key];
    
    captureOutput.videoSettings = videoSettings;
    
    if ([self.screenCaptureSession canAddOutput:captureOutput]) {
        [self.screenCaptureSession addOutput:captureOutput];
    }
    
    [captureOutput setSampleBufferDelegate:self
                                     queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    NSArray* currentInputs = [self.screenCaptureSession inputs];
    // remove current input
    if ([currentInputs count] > 0) {
        AVCaptureInput* currentInput = (AVCaptureInput*)[currentInputs objectAtIndex:0];
        [self.screenCaptureSession removeInput:currentInput];
    }
    
    // now create capture session input out of AVCaptureDevice
    uint32_t count = 0;
    CGDirectDisplayID displayIDs[3] = {0};
    CGGetOnlineDisplayList(3, displayIDs, &count);
    AVCaptureScreenInput* newCaptureInput = [[AVCaptureScreenInput alloc] initWithDisplayID:displayIDs[0]];
    
    newCaptureInput.minFrameDuration = CMTimeMake(1, 120);
    
    // ---  设置分辨率  ---
    self.screenCaptureSession.sessionPreset = AVCaptureSessionPreset320x240;
        
    // try to add our new capture device to the capture session
    [self.screenCaptureSession beginConfiguration];
    
    BOOL addedCaptureInput = NO;
    if ([self.screenCaptureSession canAddInput:newCaptureInput]) {
        [self.screenCaptureSession addInput:newCaptureInput];
        addedCaptureInput = YES;
    } else {
        addedCaptureInput = NO;
    }
    
    [self.screenCaptureSession commitConfiguration];
    [self.screenCaptureSession startRunning];
    
    if (!self.factory) {
        NSArray<RTCVideoCodecInfo *> *ddd = [RTCDefaultVideoEncoderFactory supportedCodecs];
        RTCDefaultVideoEncoderFactory *videoEncoderFactory = [[RTCDefaultVideoEncoderFactory alloc]init];
        RTCVideoCodecInfo *info = ddd[2];
        [videoEncoderFactory setPreferredCodec:info];
        RTCDefaultVideoDecoderFactory *videoDecoderFactory = [[RTCDefaultVideoDecoderFactory alloc]init];
        self.factory = [[RTCPeerConnectionFactory alloc] initWithEncoderFactory:videoEncoderFactory decoderFactory:videoDecoderFactory];
        self.source = [self.factory videoSource];
        self.cap = [[RTCVideoCapturer alloc] initWithDelegate:self.source];
    }

    self.localStream = [self.factory mediaStreamWithStreamId:@"RTCmS"];
}


@end
