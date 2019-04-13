//
//  Language
//  ___PROJECTNAME___
//
//  Created ___FULLUSERNAME___ on ___DATE___.
//  Copyright © ___YEAR___ Ibtikar Technologies, Co. Ltd. All rights reserved.
//

import UIKit

enum Language: String {
    
    case english = "en"
    case arabic = "ar"
    
    var semantic: UISemanticContentAttribute {
        switch self {
        case .arabic:
            return .forceRightToLeft
        default:
             return .forceLeftToRight
        }
    }
    
    var languageCode:String {
        switch self {
        case .arabic: return "ar"
        case .english: return "en"
        }
    }
    
    var languageName: String {
        let locale : NSLocale = NSLocale(localeIdentifier: self.languageCode)
         let displayName = locale.displayName(forKey: NSLocale.Key.identifier,
                                              value: self.languageCode) ?? self.languageCode
        return displayName
    }
}
