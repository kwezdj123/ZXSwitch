//
//  ZXSwitchProtocol.swift
//  ZXAlert
//
//  Created by LionPig on 2019/1/10.
//  Copyright © 2019 LionPig. All rights reserved.
//

import UIKit

protocol ZXSwitchDelegate:AnyObject {
    ///改变之前调用，返回值控制是否改变此次状态
    /// - 当开关的isControlChanged = true 时，才可用
    func willChangeStatus(_ status:Bool,isAllowChange:ReturnBoolean)
    ///改变之后调用
    func didChangedStatus(_ status:Bool)
}

