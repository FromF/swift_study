//
//  ViewController.swift
//  SwiftStudy01
//
//  Created by haruhito on 2015/04/07.
//  Copyright (c) 2015年 FromF. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var Label1: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //初期化する
        self.Label1.text = "初期化しました"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func Button1(sender: AnyObject) {
        self.Label1.text = "Button1が押されました"
    }
    @IBAction func Segment1(sender: AnyObject) {
        var segment: UISegmentedControl = sender as! UISegmentedControl
        self.Label1.text = "セグメントが\(segment.selectedSegmentIndex)に切り替わりました"
    }
}

