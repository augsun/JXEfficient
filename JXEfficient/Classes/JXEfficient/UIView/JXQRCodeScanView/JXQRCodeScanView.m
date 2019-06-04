//
//  JXQRCodeScannerView.m
//  JXEfficient
//
//  Created by augsun on 12/2/16.
//  Copyright © 2016 CoderSun. All rights reserved.
//

#import "JXQRCodeScanView.h"
#import "JXMacro.h"

@interface JXQRCodeScanView () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureDevice               *device;
@property (nonatomic, strong) AVCaptureDeviceInput          *input;
@property (nonatomic, strong) AVCaptureMetadataOutput       *output;
@property (nonatomic, strong) AVCaptureSession              *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer    *previewLayer;

@end

@implementation JXQRCodeScanView

- (AVAuthorizationStatus)status {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    return status;
}

- (void)startRunning {
    [self.session startRunning];
}

- (BOOL)running {
    return self.session.running;
}

- (void)stopRunning {
    [self.session stopRunning];
}

- (BOOL)configScannerWithMetadataObjectTypes:(NSArray *)metadataObjectTypes {
    if (self.status == AVAuthorizationStatusRestricted ||
        self.status == AVAuthorizationStatusDenied ||
        metadataObjectTypes.count == 0) {
        return NO;
    }

    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc] init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    }
    else {
        [self.session setSessionPreset:AVCaptureSessionPresetMedium];
    }
    
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    else {
        return NO;
    }
    
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
        NSMutableArray *typesTemp = [[NSMutableArray alloc] init];
        for (id obj in metadataObjectTypes) {
            if ([self.output.availableMetadataObjectTypes containsObject:obj]) {
                [typesTemp addObject:obj];
            }
        }
        if (typesTemp.count == 0) {
            return NO;
        }
        self.output.metadataObjectTypes = [typesTemp copy];
    }
    else {
        return NO;
    }
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = [UIScreen mainScreen].bounds;
    [self.layer insertSublayer:self.previewLayer atIndex:0];
    return YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.previewLayer.frame = self.bounds;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    //
    NSString *outputStringValue = nil;
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        outputStringValue = metadataObject.stringValue;
    }
    
    //
    JX_BLOCK_EXEC(self.didOutputStringValue, outputStringValue);
}

@end




















