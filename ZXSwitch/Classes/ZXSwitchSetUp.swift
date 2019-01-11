//
//  ZXSwitchSetUp.swift
//  ZXAlert
//
//  Created by LionPig on 2019/1/11.
//  Copyright © 2019 LionPig. All rights reserved.
//

import UIKit

/// 交换两个变量的值
///
/// - Parameters:
///   - a: 变量a
///   - b: 变量b
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temporaryA = a
    a = b
    b = temporaryA
}

typealias ReturnBoolean = (_ isTrue:Bool)->Void

func ZXDebugPrint<T>(_ debugStr:T,
                     methodName:String = #function,
                     line:Int = #line,
                     file:String = #file)
{
    #if DEBUG
    print("----------------------------\nZXDebug:\(debugStr)\nfrom:\(methodName)\nLine:\(line.description)\nfile:\(file)\n----------------------------\n")
    #else
    #endif
}

func ZXDebugSimplePrint<T>(_ debugStr:T,
                           methodName:String = #function)
{
    #if DEBUG
    print("----------------------------\nZXDebug:\(debugStr)\nfrom:\(methodName)----------------------------\n")
    #else
    #endif
}
