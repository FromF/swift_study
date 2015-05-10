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
        var result : Bool = true
        
        if ((result) && (!camera.connected)) {
            result = camera.connect(OLYCameraConnectionTypeWiFi, error: nil)
        }
        if ((result) && (camera.connected)) {
            camera.liveViewDelegate = self
            result = camera.changeRunMode(OLYCameraRunModeRecording, error: nil)
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        var result : Bool = true
        if ((result) && (camera.connected)) {
            result = camera.disconnectWithPowerOff(false, error: nil)
        }
    }

    func camera(camera: OLYCamera!, didUpdateLiveView data: NSData!, metadata: [NSObject : AnyObject]!) {
        NSLog("count %d",liveviewCount)
        if (liveviewCount == 0) {
            var image : UIImage = OLYCameraConvertDataToImage(data,metadata)
            dispatch_async(dispatch_get_main_queue()) {
                self.liveViewImage.setImage(image)
                return
            }
        }
        liveviewCount++;
        if (liveviewCount > 60) {
            liveviewCount = 0;
        }
    }
}
