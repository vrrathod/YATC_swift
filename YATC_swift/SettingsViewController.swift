//
//  SettingsViewController.swift
//  YATC_swift
//
//  Created by personal on 8/28/14.
//  Copyright (c) 2014 personal. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onSaveTipAmountChanged(sender: UISwitch) {
        var defaults = NSUserDefaults.standardUserDefaults();
        defaults.setBool(sender.on, forKey: "saveTipAmount");
        defaults.synchronize();
    }
    
    @IBAction func onQualitySettingsChanged(sender: UISwitch) {
        var defaults = NSUserDefaults.standardUserDefaults();
        defaults.setBool(sender.on, forKey: "qualitySettings");
        defaults.synchronize();
    }

    @IBAction func onSaveSplitSettings(sender: UISwitch) {
        var defaults = NSUserDefaults.standardUserDefaults();
        defaults.setBool(sender.on, forKey: "splitSettings");
        defaults.synchronize();
    }
}
