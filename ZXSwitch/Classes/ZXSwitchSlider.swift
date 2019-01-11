//
//  ZXSwitchSlider.swift
//  ZXAlert
//
//  Created by LionPig on 2019/1/10.
//  Copyright © 2019 LionPig. All rights reserved.
//

import UIKit

class ZXSwitchSlider: UIView {
    
    private var movedCallBack:ReturnBoolean?
    
    func sliderMoved(_ callBack:ReturnBoolean?){
        movedCallBack = callBack
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setShadow(UIColor.black.withAlphaComponent(0.36))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setShadow(_ color:UIColor) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: -0.2, height: 1)
        layer.shadowOpacity = 1
        layer.shadowRadius = 1
    }
    
  
}
