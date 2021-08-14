//
//  ViolationViewModel.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

struct ViolationConfig {
    let violationOption:ViolationOptions
    let violationType:ViolationType
    let violation:Violation
}
enum ViolationOptions:Int,CaseIterable {
    case violationDescription
    case violationGuidelines
}
enum ViolationType:String {
    case adult
    case violence
}

struct ViolationViewModel {
    let violation:Violation
    let violationType:ViolationType
    let violationOption:ViolationOptions
    
    var violationImageUrl:URL? {
        return URL(string: violation.url)
    }
    var titleImage:UIImage? {
        switch violationOption {
        
        case .violationDescription:
            return UIImage(systemName: "photo")
        case .violationGuidelines:
            return UIImage(systemName: "exclamationmark.triangle")
        }
    }
    var titleText:String {
        switch violationOption {
        
        case .violationDescription:
            switch violationType {
            
            case .adult:
                return "Image removed for nudity or sexual activity."
            case .violence:
                return "Image removed for violence or dangerous organizations."
            }
            
        case .violationGuidelines:
            switch violationType {
            
            case .adult:
                return "Nudity or sexual activity guidelines."
            case .violence:
                return "Violence guidelines."
            }
        }
    }
    var secondaryTitleText:String {
        switch violationOption {
        
        case .violationDescription:
            return ""
        case .violationGuidelines:
            switch violationType {
            
            case .adult:
                return
                    """
                    We remove:
                    
                    ・Photos, videos and some digitally-created content that show sexual intercourse, genitals, and close-ups of fully-nude buttocks.
                    
                    ・Some photos of female nipples, but photos of post-mastectomy scarring and women actively breastfeeding are allowed.
                    
                    ・Some images that show nude or partially-nude children.
                    
                    ・Threats to post intimate images of others.
                    """
            case .violence:
                return
                    """
                    We don't allow content that may lead to a genuine risk to physical harm or direct threat to public safety.
                    
                    This includes things like:
                    
                    ・Language that leads to serious violence.
                    
                    ・Threats that can lead to death, violent or serious injury.
                    
                    ・Instructions on how to make weapons, if the objective is to seriously injure or kill people.
                    """
            }
        }
    }
    var hiddenElements:Bool {
        switch violationOption {
        
        case .violationDescription:
            return false
        case .violationGuidelines:
            return true
        }
    }
    var titleImageAlignment:UIStackView.Alignment {
        switch violationOption {
        
        case .violationDescription:
            return .center
        case .violationGuidelines:
            return .top
        }
    }
    var layoutConstraintConstant:CGFloat {
        switch violationOption {
        
        case .violationDescription:
            return 13
        case .violationGuidelines:
            return 21
        }
    }
    init(violationConfig:ViolationConfig) {
        self.violationOption = violationConfig.violationOption
        self.violationType = violationConfig.violationType
        self.violation = violationConfig.violation
    }
}
struct ViolationHeaderViewModel {
    let violationType:ViolationType
    
    var titleText:String {
        return "Your Post Goes Against Our Community Guidelines"
    }
    var descriptionText:String {
        switch violationType {
        
        case .adult:
            return "We removed your post because it goes against our Community Guidelines on nudity or sexual activity. if you learn and follow our guidelines, you can prevent your account from being deleted."
        case .violence:
            return "We removed your post because it goes against our Community Guidelines on violence or dangerous organizations. if you learn and follow our guidelines, you can prevent your account from being deleted."
        }
    }
    init(violationType:ViolationType) {
        self.violationType = violationType
    }
}
