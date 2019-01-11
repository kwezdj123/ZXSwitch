//
//  ViewController.swift
//  ZXSwitch
//
//  Created by LionPig on 2019/1/11.
//  Copyright © 2019 LionPig. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let mySwitch = ZXSwitch(frame: CGRect(origin: CGPoint(x: 100, y: 100), size: CGSize(width: 49, height: 31)))
        mySwitch.delegate = self
        view.addSubview(mySwitch)
    }

}
extension ViewController:ZXSwitchDelegate{
    
    func didChangedStatus(_ status: Bool) {
        
    }
    
    func willChangeStatus(_ status: Bool, isAllowChange: (Bool) -> Void) {
        
    }
    
}
