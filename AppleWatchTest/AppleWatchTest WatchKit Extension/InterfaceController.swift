//
//  InterfaceController.swift
//  AppleWatchTest WatchKit Extension
//
//  Created by haruhito on 2015/05/02.
//  Copyright (c) 2015年 FromF. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController , OLYCameraLiveViewDelegate {

    let camera : OLYCamera = OLYCamera()
    var liveviewCount : NSInteger = 0
    @IBOutlet weak var liveViewImage: WKInterfaceImage!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        liveViewImage.setImage(nil)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            var result : Bool = true
            
            if ((result) && (!self.camera.connected)) {
                result = self.camera.connect(OLYCameraConnectionTypeWiFi, error: nil)
            }
            if ((result) && (self.camera.connected)) {
                self.camera.liveViewDelegate = self
                result = self.camera.changeRunMode(OLYCameraRunModeRecording, error: nil)
            }
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        var result : Bool = true
        if ((result) && (camera.connected)) {
            result = camera.disconnectWithPowerOff(false, error: nil)
            liveViewImage.setImage(nil)
        }
    }

    @IBAction func shutter() {
        if (camera.connected) {
            camera.takePicture(nil, progressHandler: nil, completionHandler: nil, errorHandler: nil)
        }
    }
    func camera(camera: OLYCamera!, didUpdateLiveView data: NSData!, metadata: [NSObject : AnyObject]!) {
        NSLog("count %d",liveviewCount)
        if (liveviewCount == 0) {
            var image : UIImage = OLYCameraConvertDataToImage(data,metadata)
            dispatch_async(dispatch_get_main_queue()) {
                //リサイズする
                var size = CGSizeMake((image.size.width * 0.2),(image.size.height * 0.2))
                UIGraphicsBeginImageContext(size)
                image.drawInRect(CGRectMake(0, 0, size.width, size.height))
                let image_reized : UIImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                //
                self.liveViewImage.setImage(image_reized)
                return
            }
        }
        liveviewCount++;
        if (liveviewCount > 15) {
            liveviewCount = 0;
        }
    }
}
