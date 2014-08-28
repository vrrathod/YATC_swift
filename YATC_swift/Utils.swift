//
//  Utils.swift
//  YATC_swift
//
//  Created by personal on 8/28/14.
//  Copyright (c) 2014 personal. All rights reserved.
//

import Foundation

class Utils {
    ////////////////////////////////////////////////////////////////////////////////////////////////
    // Constants
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
    let QUALITY_SETTINGS_NAME = "qualitySettings";
    let FOOD_QUALITY_NAME = "foodQuality";
    let SERVICE_QUALITY_NAME = "serviceQuality";
    let SPLIT_COUNT_NAME = "splitCount";
    let SPLIT_SETTINGS_NAME = "splitSettings";
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    // Methods
    ////////////////////////////////////////////////////////////////////////////////////////////////
    func initializeDefaultsIfRequired() {
        var defaults = NSUserDefaults.standardUserDefaults();
        // by default we want to store everything
        if (!defaults.objectForKey(QUALITY_SETTINGS_NAME) ) {
            defaults.setBool(true, forKey: QUALITY_SETTINGS_NAME);
            defaults.setInteger(1, forKey: FOOD_QUALITY_NAME);
            defaults.setInteger(1, forKey: SERVICE_QUALITY_NAME);
        }
        
        if (!defaults.boolForKey(SPLIT_SETTINGS_NAME) ) {
            defaults.setBool(true, forKey: SPLIT_SETTINGS_NAME);
            defaults.setDouble(1.0, forKey: SPLIT_COUNT_NAME);
        }
        
        defaults.synchronize();
    }
    
    
    //-------------------------------------------------------------------------------------------------
    // Quality settings
    func checkAndSaveQualitySettings(food:Int, service:Int) {
        var defaults = NSUserDefaults.standardUserDefaults();
        if defaults.boolForKey(QUALITY_SETTINGS_NAME) {
            defaults.setInteger(food, forKey: FOOD_QUALITY_NAME);
            defaults.setInteger(service, forKey: SERVICE_QUALITY_NAME);
            defaults.synchronize();
        }
    }
    
    func shouldSaveQualitySettings() -> Bool {
        var defaults = NSUserDefaults.standardUserDefaults();
        return defaults.boolForKey(QUALITY_SETTINGS_NAME);
    }
    
    func savedFoodQualityValue() -> Int {
        var foodQuality = 1;
        var defaults = NSUserDefaults.standardUserDefaults();
        if defaults.boolForKey(QUALITY_SETTINGS_NAME) {
            foodQuality = defaults.integerForKey(FOOD_QUALITY_NAME);
        }
        return foodQuality;
    }
    
    func savedServiceQualityValue() -> Int {
        var serviceQuality = 1;
        var defaults = NSUserDefaults.standardUserDefaults();
        if defaults.boolForKey(QUALITY_SETTINGS_NAME) {
            serviceQuality = defaults.integerForKey(SERVICE_QUALITY_NAME);
        }
        return serviceQuality;
    }
    
    func updateQualitySettings(val: Bool) {
        NSUserDefaults.standardUserDefaults().setBool(val, forKey: QUALITY_SETTINGS_NAME);
    }
    
    //-------------------------------------------------------------------------------------------------
    // split settings
    func shouldSaveSplitSettings() -> Bool {
        var defaults = NSUserDefaults.standardUserDefaults();
        return defaults.boolForKey(SPLIT_SETTINGS_NAME);
    }
    
    func checkAndSaveSplitSettings(splits:Double) {
        var defaults = NSUserDefaults.standardUserDefaults();
        if defaults.boolForKey(SPLIT_SETTINGS_NAME) {
            defaults.setDouble(splits, forKey: SPLIT_COUNT_NAME);
            defaults.synchronize();
        }
    }
    
    func savedSplitSettings() -> Double {
        var splitVal = 1.0;
        var defaults = NSUserDefaults.standardUserDefaults();
        if defaults.boolForKey(SPLIT_SETTINGS_NAME) {
            splitVal =  defaults.doubleForKey(SPLIT_COUNT_NAME) ;
        }
        return splitVal;
    }
    
    func updateSplitSettings(val: Bool) {
        NSUserDefaults.standardUserDefaults().setBool(val, forKey: SPLIT_SETTINGS_NAME);
    }
}
//-------------------------------------------------------------------------------------------------