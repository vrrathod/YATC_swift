//
//  SettingsViewController.swift
//  YATC_swift
//
//  Created by personal on 8/28/14.
//  Copyright (c) 2014 personal. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var switchTipAmount: UISwitch!
    @IBOutlet weak var switchQualitySettings: UISwitch!
    @IBOutlet weak var switchSplitSettings: UISwitch!
    let utils = Utils();
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        switchQualitySettings.on = utils.shouldSaveQualitySettings();
        switchSplitSettings.on = utils.shouldSaveSplitSettings();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onQualitySettingsChanged(sender: UISwitch) {
        utils.updateQualitySettings(sender.on);
    }

    @IBAction func onSaveSplitSettings(sender: UISwitch) {
        utils.updateSplitSettings(sender.on);
    }
}
