//
//  ViewController.swift
//  DropBoxUploaderTest
//
//  Created by haruhito on 2015/05/09.
//  Copyright (c) 2015年 FromF. All rights reserved.
//

import UIKit

class ViewController: UIViewController,DBRestClientDelegate {
    var restClient :DBRestClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        restClient = DBRestClient(session: DBSession.sharedSession())
        restClient.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didPressLink(sender: AnyObject) {
        if (!DBSession.sharedSession().isLinked()) {
            DBSession.sharedSession().linkFromController(self)
        }
    }
    
    @IBAction func uploadTest(sender: AnyObject) {
        // Write a file to the local documents directory
        var text : String = "Hello world."
        var filename : String = "working-draft.txt"
        var localdir : String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var localpath : String = localdir + "/" + filename
        text.writeToFile(localpath, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        
        // Upload file to Dropbox
        var destDir : String = "/"
        restClient.uploadFile(filename, toPath: destDir, withParentRev: nil, fromPath: localpath)
    }

    func restClient(client: DBRestClient!, uploadedFile destPath: String!, fromUploadId uploadId: String!, metadata: DBMetadata!) {
        NSLog("Folder '%@' contains:", metadata.path)
    }

    func restClient(client: DBRestClient!, uploadFileFailedWithError error: NSError!) {
        NSLog("Error loading metadata: %@", error);
    }
}

