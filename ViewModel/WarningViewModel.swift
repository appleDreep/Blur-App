//
//  WarningViewModel.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

struct WarningConfig {
    let violation:Violation
    let violationType:ViolationType
}
enum WarningType {
    case violationsCount(violations:Int)
}

struct WarningViewModel {
    let violation:Violation
    let violationType:ViolationType
    
    var violationImageUrl:URL? {
        return URL(string: violation.url)
    }
    var titleImage:UIImage? {
        return UIImage(systemName: "photo")
    }
    var titleText:String {
        switch violationType {
        
        case .adult:
            return "Image removed for nudity or sexual activity."
        case .violence:
            return "Image removed for violence or dangerous organizations."
        }
    }
    var layoutConstraintConstant:CGFloat {
        return 13
    }
    init(warningConfig:WarningConfig) {
        self.violation = warningConfig.violation
        self.violationType = warningConfig.violationType
    }
}
struct WarningHeaderViewModel {
    let warningType:WarningType
    
    var titleText:String {
        return "Your Account May Be Deleted"
    }
    var descriptionText:String {
        
        switch warningType {
        
        case .violationsCount(violations: let violations):
            if violations == 1 {
                return "Your post didn't follow our Community Guidelines. if you upload something that goes against our guidelines again, you account may be deleted, including messages."
            }else {
                return "Some of your previous posts didn't follow our Community Guidelines. if you upload something that goes against our guidelines again, you account may be deleted, including messages."
            }
        }
    }
    init(warningType:WarningType) {
        self.warningType = warningType
    }
}
