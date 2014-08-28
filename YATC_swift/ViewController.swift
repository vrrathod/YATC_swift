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
    // utils class instance
    let utils = Utils();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // for the first time, we will need to create required settings, later 
        utils.initializeDefaultsIfRequired();
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
        segFoodQuality.selectedSegmentIndex = utils.savedFoodQualityValue();
        segServiceQuality.selectedSegmentIndex = utils.savedServiceQualityValue();
        // read the split from previous
        stepSplit.value = utils.savedSplitSettings();
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
        utils.checkAndSaveQualitySettings(segFoodQuality.selectedSegmentIndex, service: segServiceQuality.selectedSegmentIndex);
        utils.checkAndSaveSplitSettings(splitCount);
        
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
    
}

