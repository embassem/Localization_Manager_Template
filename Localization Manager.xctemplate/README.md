#  How to Use

## Step one
``` Swift
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

func application(_ application: UIApplication,
didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
LocalizationManager.syncLanguage()
LocalizationManager.swizzleLanguage()

return true
}
}
```

## step two

change Default language in LocalizationManager.defaultLanguage
```
class LocalizationManager {

    static var defaultLanguage = Language.arabic
}
```

##  step three

when change Language
pass root view controller to the function , check default values
```
LocalizationManager
.changeLanguage(language: Language.arabic) { () -> UIViewController in
return  UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()!
} 
```
```Swift
import UIKit

class LanguageViewController: UIViewController {

@IBOutlet weak var englishButton: UIButton!

@IBOutlet weak var arabicButton: UIButton!

override func viewDidLoad() {
super.viewDidLoad()
englishButton.setTitle(Language.english.languageName, for: .normal)
arabicButton.setTitle(Language.arabic.languageName, for: .normal)
}

@IBAction func changeToArabic(_ sender: Any) {
LocalizationManager
.changeLanguage(language: Language.arabic) { () -> UIViewController in
return  UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()!
}
}

@IBAction func changeToEnglish(_ sender: Any) {

LocalizationManager
.changeLanguage(language: Language.english) { () -> UIViewController in
return  UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()!
}

}
}

```


## Note :
System Buttons title must be included in Localizable.strings file  ex Done , Edit , etc buttons 
in appDelegate call syncLanguage and SwizzleLanguage in the begining of didFinishLaunch
