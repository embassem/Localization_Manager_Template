//
//  LocalizationManager.swift
//  ___PROJECTNAME___
//
//  Created ___FULLUSERNAME___ on ___DATE___.
//  Copyright © ___YEAR___ Ibtikar Technologies, Co. Ltd. All rights reserved.
//

import Foundation
import UIKit

class LocalizationManager {
    
    static var defaultLanguage = Language.arabic
    
    struct UserDefaultKey {
        private init () {}
        static let savedLanguage = "AppLanguages"
        static let appleLanguage = "AppleLanguages"
    }
    
    public private(set) static var appLocale: Locale = {
        return Locale(identifier: LocalizationManager.currentLanguage().languageCode)
    }()
    
    private init() {  }

    /// This function will sync apple language with default language ,
    /// should called if firstLaunch also it will not effect if called after that.
    open class func syncLanguage() {
        let def = UserDefaults.standard
        let appleLanguages = def.stringArray(forKey: UserDefaultKey.appleLanguage)
        let savedLanguage = def.string(forKey: UserDefaultKey.savedLanguage)
        print("LocalizationManager :: default Apple Languages : \(String(describing: appleLanguages))")
        print("LocalizationManager :: first prefared Languages : \(String(describing: prefaredLanguage()))")
        if let firstLang = appleLanguages?.first?.split(separator: "-").first {
            let lang = String(firstLang).lowercased()
            if savedLanguage == nil {
                //&& lang != defaultLanguage.languageCode
                setAppLangouge(language: LocalizationManager.defaultLanguage)
            }
        }
        print("LocalizationManager :: current Apple Languages : \(String(describing: def.array(forKey: UserDefaultKey.appleLanguage)))")
    }
    
    open class func swizzleLanguage() {
    swizzleMethodsForClass(className: Bundle.self,
                           originalSelector: #selector(Bundle.localizedString(forKey:value:table:)),
                           overrideSelector: #selector(Bundle.appLocalizedString(forKey:value:table:)))
        
        swizzleMethodsForClass(className: UIApplication.self,
                               originalSelector: #selector(getter: UIApplication.userInterfaceLayoutDirection),
                               overrideSelector: #selector(getter: UIApplication.appUserInterfaceLayoutDirection))
    }
    open class func availableLanguages() -> [String] {
        var availableLanguages = Bundle.main.localizations
        // If excludeBase = true, don't include "Base" in available languages
        if let indexOfBase = availableLanguages.index(of: "Base") {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }
    
    open class func prefaredLanguage () -> String {
        let preferredLocalizations = Bundle.main.preferredLocalizations
        return preferredLocalizations.first ?? defaultLanguage.languageCode
    }
    
    class func currentLanguage() -> Language {
        
        let def = UserDefaults.standard
        guard let savedlanguage = def.string(forKey: UserDefaultKey.savedLanguage) else {return defaultLanguage }
        let language =  Language(rawValue: savedlanguage) ?? defaultLanguage
        return language
    }
    
    open class func displayNameForLanguage(_ language: Language) -> String {
        let locale : NSLocale = NSLocale(localeIdentifier: currentLanguage().languageCode)
        if let displayName = locale.displayName(forKey: NSLocale.Key.identifier, value: language) {
            return displayName
        }
        return String()
    }
    private static let launchScreen:UIViewController?
        = UIStoryboard(name: "LaunchScreen", bundle: Bundle.main)
            .instantiateInitialViewController()
    
    public class func changeLanguage(language: Language ,
                                     splash: UIViewController? = launchScreen,
                                     splashDuration: TimeInterval = 1.5,
                                     options: UIView.AnimationOptions = [UIView.AnimationOptions.transitionCrossDissolve],
                                     animationDuration: TimeInterval = 0.5,
                                     resetBlock:@escaping (()-> UIViewController)) {
        
        let appWindow = (UIApplication.shared.delegate as! AppDelegate).window!
        
     
        if let splashScene = splash {
           appWindow.rootViewController = splashScene
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + splashDuration) {
          
            self.setAppLangouge(language: language)

            let rootView =  resetBlock()
            rootView.view.layoutIfNeeded()
            UIView.transition(with: appWindow,
                              duration: animationDuration,
                              options: options,
                              animations: {
                 appWindow.rootViewController = rootView
            }, completion: { completed in
                // maybe do something here
            })
        }
       
    }
    
    private class func setAppLangouge(language: Language){
        let def = UserDefaults.standard
        def.set([language.languageCode], forKey: UserDefaultKey.appleLanguage)
        def.set(language.languageCode, forKey: UserDefaultKey.savedLanguage)
        def.synchronize()
        
        LocalizationManager.appLocale = Locale(identifier: language.languageCode)
        
        UIView.appearance().semanticContentAttribute =  language.semantic
        UITextField.appearance().textAlignment
            = (language.semantic == UISemanticContentAttribute.forceLeftToRight)
            ? NSTextAlignment.left : NSTextAlignment.right
        }
    
    private class func swizzleMethodsForClass(className: AnyClass,
                                              originalSelector: Selector,
                                              overrideSelector: Selector) {
        
        //swiftlint:disable force_unwrapping
        let originalMethod: Method = class_getInstanceMethod(className, originalSelector)!
        let overrideMethod: Method = class_getInstanceMethod(className, overrideSelector)!
        
        if class_addMethod(className,
                           originalSelector,
                           method_getImplementation(overrideMethod),
                           method_getTypeEncoding(overrideMethod)) {
            
            class_replaceMethod(className,
                                overrideSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod))
        } else {
            // if method exist replace implementation
            method_exchangeImplementations(originalMethod, overrideMethod)
        }
    }
}
