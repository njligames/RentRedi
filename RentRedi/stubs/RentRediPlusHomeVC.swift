//
//  RentRediPlusHomeVC.swift
//  RentRedi
//
//  Created by James Folk on 9/19/22.
//

import Foundation

class RentRediPlusHomeVC : ViewController {
    var tenantCardSubmission: TenantCardSubmission?
    var hasExistingInviteApplication: Bool = false
    enum ApplicationType {
        case applicationInvite
    }
    struct Dummy {
        var isHidden:Bool
    }
    
    var applicationPopup:Dummy = Dummy(isHidden: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func hideTenantToDoAlert() {
        
    }
    
    func applyPrequalifyVerb(noun: String) -> String {
        return ""
    }
    
    func setupTenantToDoAlert() {
        
    }
    
    func updateToDoAlert(title: String, description: String, type: ApplicationType) {
        
    }
}
