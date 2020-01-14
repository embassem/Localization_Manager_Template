//
//  Localization+Extension.swift
//  ___PROJECTNAME___
//
//  Created ___FULLUSERNAME___ on ___DATE___.
//  Copyright © ___YEAR___ Ibtikar Technologies, Co. Ltd. All rights reserved.
//


import UIKit

extension Bundle {
    
    @objc
    func appLocalizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        // check if its the main bundle then if the bundle of the current language is available
        // then try without locale
        // if not go back to base
        let translate =  { (tableName: String?) -> String in
            let currentLanguage = LocalizationManager.currentLanguage().languageCode // with locale
            let languageWithoutLocale = LocalizationManager.currentLanguage().languageCode// without locale
            var bundle = Bundle();
            // normal case where the lang with locale working
            if let _path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
                bundle = Bundle(path: _path)!
            } // en case when its working wihout locale
            else if let _path = Bundle.main.path(forResource: languageWithoutLocale, ofType: "lproj") {
                bundle = Bundle(path: _path)!
            } // current locale not exist , so we fallback
            else if let _path = Bundle.main.path(forResource: "Base", ofType: "lproj") {
                bundle = Bundle(path: _path)!
            }
            return (bundle.appLocalizedString(forKey: key, value: value, table: tableName))
        }
        // normal case
        if self == Bundle.main {
            return translate(tableName)
        } // let the bundle handle the locale
        else {
            return (self.appLocalizedString(forKey: key, value: value, table: tableName))
        }
    }
}

extension UIApplication {
    
    @objc var appUserInterfaceLayoutDirection: UIUserInterfaceLayoutDirection {
        var direction:UIUserInterfaceLayoutDirection = .leftToRight
        if LocalizationManager.currentLanguage() == .arabic {
            direction = .rightToLeft
        }
        return   direction
    }
}

extension UICollectionViewFlowLayout {
    open override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        if LocalizationManager.currentLanguage() == .arabic {
            return true
        }
        return false
    }
}



