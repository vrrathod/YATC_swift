//
//  ViewController.swift
//  YATC_swift
//
//  Created by personal on 8/27/14.
//  Copyright (c) 2014 personal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /// UI Objects
    @IBOutlet weak var txtAmountWithoutTip: UITextField!
    @IBOutlet weak var segFoodQuality : UISegmentedControl!
    @IBOutlet weak var segServiceQuality : UISegmentedControl!
    @IBOutlet weak var txtTipAmount : UITextField!
    @IBOutlet weak var lblSplit : UILabel!
    @IBOutlet weak var lblYourShare : UILabel!
    @IBOutlet weak var lblFinalAmount : UILabel!
    @IBOutlet weak var stepTip: UIStepper!
    @IBOutlet weak var stepSplit: UIStepper!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        reset();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    // segment index to percentage
    func qualityToValue(segment : Int) -> Double {
        var value = 0.00;
        switch segment {
        case 0: value = 05.00; break;
        case 1: value = 07.50; break;
        case 2: value = 10.00; break;
        case 3: value = 12.50; break;
        default: value = 0;
        }
        return value;
    }
    // food quality to percentage
    func getFoodQuality() -> Double {
        return qualityToValue(segFoodQuality.selectedSegmentIndex);
    }
    // service quality to percentage
    func getServiceQuality() -> Double {
        return qualityToValue(segServiceQuality.selectedSegmentIndex);
    }
    
    //// Methods
    func reset() {
        // default the amount without tip
        txtAmountWithoutTip.text = "100.00";

        // read the quality from previous
        segFoodQuality.selectedSegmentIndex = savedFoodQualityValue();
        segServiceQuality.selectedSegmentIndex = savedServiceQualityValue();
        // read the split from previous
        stepSplit.value = savedSplitSettings();
        lblSplit.text = String( Int( stepSplit.value ) ) ;
        
        // if tip is saved, read it from previous
        computeAll();
    }
    
    // computes tip, updates ui and returns the tip value
    func computeTip() -> Double {
        // tip Percent
        var tipPercent = getFoodQuality() + getServiceQuality();
        var actualAmount = txtAmountWithoutTip.text.bridgeToObjectiveC().doubleValue;
        // tip Amount
        var tipAmount = actualAmount * tipPercent / 100;
        // Update Value
        txtTipAmount.text = String(format: "%.2f", tipAmount);
        stepTip.value = tipAmount;
        // serialize
        checkAndSaveTipAmount();
        return tipAmount;
    }
    
    func computeTotal(tipAmount:Double) -> Double {
        var actualAmount = txtAmountWithoutTip.text.bridgeToObjectiveC().doubleValue;
        // total amount
        var total = actualAmount + tipAmount;
        lblFinalAmount.text = String(format: "$%.2f", total);
        return total;
    }
    
    func computeSplit(total:Double) -> Double {
        // split
        var splitCount = lblSplit.text.bridgeToObjectiveC().doubleValue;
        var splitValue = total /  splitCount;
        lblYourShare.text = String(format: "$%.2f", splitValue);
        
        // serialize : for any change share will be affected
        checkAndSaveTipAmount();
        checkAndSaveQualitySettings();
        checkAndSaveSplitSettings();

        return splitValue;
    }
    
    func computeAll() {
        // compute tip
        var tipAmount = computeTip();
        var total = computeTotal(tipAmount);
        var split = computeSplit(total);
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    @IBAction func onSegmentChange(sender: AnyObject) {
        computeAll();
    }
    
    @IBAction func onSplitChange(sender: AnyObject) {
        lblSplit.text = String( Int( stepSplit.value ) );
        computeAll();
    }
    
    @IBAction func onAmountChanged(sender: AnyObject) {
        computeAll();
    }
    
    @IBAction func onTipEdited(sender: AnyObject) {
        stepTip.value = txtTipAmount.text.bridgeToObjectiveC().doubleValue;
        segFoodQuality.selectedSegmentIndex = -1;
        segServiceQuality.selectedSegmentIndex = -1;
        var total = computeTotal(stepTip.value);
        var split = computeSplit(total);
    }
    @IBAction func onTipStepped(sender: AnyObject) {
        // update tip amount with current value
        txtTipAmount.text = String( Int( stepTip.value ) );
        segFoodQuality.selectedSegmentIndex = -1;
        segServiceQuality.selectedSegmentIndex = -1;
        var total = computeTotal(stepTip.value);
        var split = computeSplit(total);
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true);
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    /// Saving Defaults
    func checkAndSaveTipAmount() {
        var defaults = NSUserDefaults.standardUserDefaults();
        if defaults.boolForKey("saveTipAmount") {
            defaults.setObject(txtTipAmount.text, forKey: "tipAmount");
            defaults.synchronize();
        }
    }
    
    func shouldSaveTipAmount() -> Bool {
        var defaults = NSUserDefaults.standardUserDefaults();
        return defaults.boolForKey("saveTipAmount");
    }
    
    func savedTipAmount() -> String {
        var tipAmount = "100";
        var defaults = NSUserDefaults.standardUserDefaults();
        if defaults.boolForKey("saveTipAmount") {
            tipAmount = defaults.stringForKey("tipAmount") ;
        }
        return tipAmount;
    }
    
    // Quality settings
    func checkAndSaveQualitySettings() {
        var defaults = NSUserDefaults.standardUserDefaults();
        if defaults.boolForKey("qualitySettings") {
            defaults.setInteger(segFoodQuality.selectedSegmentIndex, forKey: "foodQuality");
            defaults.setInteger(segServiceQuality.selectedSegmentIndex, forKey: "serviceQuality");
            defaults.synchronize();
        }
    }
    
    func shouldSaveQualitySettings() -> Bool {
        var defaults = NSUserDefaults.standardUserDefaults();
        return defaults.boolForKey("qualitySettings");
    }
    
    func savedFoodQualityValue() -> Int {
        var foodQuality = 1;
        var defaults = NSUserDefaults.standardUserDefaults();
        if defaults.boolForKey("qualitySettings") {
            foodQuality = defaults.integerForKey("foodQuality");
        }
        return foodQuality;
    }
    
    func savedServiceQualityValue() -> Int {
        var serviceQuality = 1;
        var defaults = NSUserDefaults.standardUserDefaults();
        if defaults.boolForKey("qualitySettings") {
            serviceQuality = defaults.integerForKey("serviceQuality");
        }
        return serviceQuality;
    }
    
    // split settings
    func shouldSaveSplitSettings() -> Bool {
        var defaults = NSUserDefaults.standardUserDefaults();
        return defaults.boolForKey("splitSettings");
    }
    
    func checkAndSaveSplitSettings() {
        var defaults = NSUserDefaults.standardUserDefaults();
        if defaults.boolForKey("splitSettings") {
            defaults.setDouble(stepSplit.value, forKey: "splitCount");
            defaults.synchronize();
        }
    }
    
    func savedSplitSettings() -> Double {
        var splitVal = 1.0;
        var defaults = NSUserDefaults.standardUserDefaults();
        if defaults.boolForKey("splitSettings") {
            splitVal =  defaults.doubleForKey("splitCount") ;
        }
        return splitVal;
    }
}

