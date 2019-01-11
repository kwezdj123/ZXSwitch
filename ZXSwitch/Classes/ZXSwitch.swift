//
//  ZXDefaultSwitch.swift
//  ZXAlert
//
//  Created by LionPig on 2019/1/10.
//  Copyright © 2019 LionPig. All rights reserved.

import UIKit

private var kZXSwitchStatus = "ZXSwitchStatus"

class ZXSwitch: UIView {

    ///滑动方向
    private var isVertical:Bool{
        return bounds.size.width < bounds.size.height
    }
    
    ///是否手动控制开关状态改变
    /// - 默认必须手动控制
    var isControlChanged:Bool = true
    ///是否触发反馈ios10以上；default is true
    var isFeedBack = true
    ///动画时间
    lazy private var timerScale:Double = {
         return Double(0.15*(31/bounds.size.height)/(49/bounds.size.width))
    }()
    
    ///边距系数
    private var marginScale:CGFloat = 2
    ///边距
    private var margin:CGFloat{
        get{ return marginScale*(minWidth/31) }
    }
    
    ///动画添加宽度
    private var addWidth:CGFloat{
        return (minWidth-margin*2)/27*6
    }
    
    ///代理
    ///- 代理协议：ZXDefaultSwitchDelegate
    weak var delegate:ZXSwitchDelegate?
    private var usingSpringWithDamping:CGFloat = 0.58
    private var initialSpringVelocity:CGFloat = 0.88
    
    ///开关状态
    public var isOpen:Bool{
        return status
    }
    
    private lazy var backView:UIView = {
        let view = UIView()
        view.backgroundColor = closeColor
        return view
    }()
    
    private lazy var sliderView:ZXSwitchSlider = {
        let view = ZXSwitchSlider()
        view.backgroundColor = .white
        return view
    }()
    
    private var openColor:UIColor = UIColor(red: 85/255, green: 211/255, blue: 115/255, alpha: 1)
    private var closeColor:UIColor = UIColor.lightGray.withAlphaComponent(0.5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var sliderOrigin = CGPoint()
    fileprivate func creatSwitchView(){
        
        if bounds.size.width < bounds.size.height{
            backView.bounds.size = CGSize(width: bounds.size.height, height: bounds.size.width)
            bounds.size = backView.bounds.size
        }else{
            backView.frame = bounds
        }
        
        backView.layer.cornerRadius = minWidth/2
        
        setUpSliderView()
        addSubview(backView)
        backView.addSubview(sliderView)
        
        addTapGesture(self)
    }
    
    private var minWidth:CGFloat{
        return min(frame.size.height, frame.size.width)
    }
    
    private func setUpSliderView(){
        
        sliderOrigin = CGPoint(x: margin, y: margin)
        sliderView.frame = CGRect(origin: sliderOrigin, size: CGSize(width: minWidth-margin*2, height: minWidth-margin*2))
        sliderView.layer.cornerRadius = sliderView.bounds.size.width/2
        
    }
    
    private func addTapGesture(_ view:UIView){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(BackViewTaped(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func addPanGesture(_ view:UIView){

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(SliderViewDidPan(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func SliderViewDidPan(_ pan:UIPanGestureRecognizer){
        var distence:CGFloat = 0
        
        switch pan.state {
        case .began:
            break
        case .changed:
            distence += pan.location(in: self).x
            ZXDebugSimplePrint(distence)
            sliderView.sliderMoved({
                [weak self] in
                guard let weakSelf = self else { return }
                if $0 && abs(distence) >= 10{
                    weakSelf.sliderAnimation()
                }
            })
            break
        default:
            break
        }
        
        pan.setTranslation(.zero, in: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        creatSwitchView()
    }
    
    @objc private func BackViewTaped(_ tap:UITapGestureRecognizer){
        status ? close() : open()
    }
    
    deinit {
        delegate = nil
        ZXDebugPrint("deinit:\(self.debugDescription)")
    }
    
    ///设置
    private func setSwitchVertical(isVertical:Bool) {
        self.transform = CGAffineTransform(rotationAngle: isVertical ? -CGFloat.pi/4 : 0)
    }
    
}

extension ZXSwitch{
    @objc private var status: Bool {
        get {
            if let aValue = objc_getAssociatedObject(self, &kZXSwitchStatus) as? Bool {
                return aValue
            } else {
                return false
            }
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kZXSwitchStatus, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

//MARK: - 设置方法
extension ZXSwitch{
    
    /// 设置开关状态的颜色
    ///
    /// - Parameters:
    ///   - openColor: open's color
    ///   - closeColor: close's color
    func setOpenColor(_ openColor:UIColor, AndCloseColor closeColor:UIColor){
        self.openColor = openColor
        self.closeColor = closeColor
    }
    
    /// 设置开关状态
    ///
    /// - Parameter isOpen: 是否打开
    func setSwitchStatus(_ isOpen:Bool){
        isOpen ? open() : close()
    }
    
    /// 设置滑块颜色
    ///
    /// - Parameter color: 滑块颜色
    func setSliderColor(_ color:UIColor){
        sliderView.backgroundColor = color
    }
    
    /// 设置动画弹簧效果
    ///
    /// - Parameters:
    ///   - usingSpringWithDamping: usingSpringWithDamping
    ///   - initialSpringVelocity: initialSpringVelocity
    func set(usingSpringWithDamping:CGFloat,AndInitialSpringVelocity initialSpringVelocity:CGFloat){
        self.usingSpringWithDamping = usingSpringWithDamping
        self.initialSpringVelocity = initialSpringVelocity
    }
    
    ///设置边距系数（影响边距宽度，滑块大小）
    func setMarginScale(_ scale:CGFloat){
        marginScale = scale
        setUpSliderView()
    }
    
}

extension ZXSwitch{
    private func open(){
        if !isControlChanged {
            sliderAnimation()
            return
        }
        
        guard let delegate = delegate else {
            sliderAnimation()
            return
        }
        
        delegate.willChangeStatus(status, isAllowChange: {
            [weak self] in
            guard let weakSelf = self else { return }
            if $0{
                weakSelf.sliderAnimation()
            }else{
                ZXDebugPrint("user not allow chang status")
            }
        })
    }
    
    private func close(){
        
        if !isControlChanged {
            sliderAnimation()
            return
        }
        
        guard let delegate = delegate else {
            sliderAnimation()
            return
        }
        
        delegate.willChangeStatus(status, isAllowChange: {
            [weak self] in
            guard let weakSelf = self else { return }
            if $0{
                weakSelf.sliderAnimation()
            }else{
                ZXDebugPrint("user not allow chang status")
            }
        })
        
    }
    
    ///添加动画
    private func sliderAnimation(){
        
        if isFeedBack{
            if #available(iOS 10.0, *) {
                let feedBack = UISelectionFeedbackGenerator()
                feedBack.selectionChanged()
                feedBack.prepare()
            }
        }
        
        UIView.animate(withDuration: timerScale, delay: timerScale, usingSpringWithDamping: 1, initialSpringVelocity: 1, options:[.curveEaseInOut,.allowUserInteraction], animations: {
            [weak self] in
            guard let weakSelf = self else { return }
            switch weakSelf.status {
            case true:
                weakSelf.sliderOrigin = CGPoint(x: weakSelf.margin+weakSelf.addWidth, y: weakSelf.sliderOrigin.y)
                
            case false:
                weakSelf.sliderOrigin = CGPoint(x: weakSelf.bounds.size.width-weakSelf.sliderView.bounds.size.width-weakSelf.margin-weakSelf.addWidth, y: weakSelf.sliderOrigin.y)
                
            }
            weakSelf.sliderView.frame = CGRect(origin: weakSelf.sliderOrigin, size: CGSize(width: weakSelf.sliderView.bounds.size.width + weakSelf.addWidth,
                                                                                           height: weakSelf.sliderView.bounds.size.height))
        }) { (finished) in
        }
        
        
        UIView.animate(withDuration: 4/3*timerScale, delay: timerScale, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options:[.curveEaseInOut,.allowUserInteraction], animations: {
            [weak self] in
            guard let weakSelf = self else { return }
            
            weakSelf.sliderView.bounds.size = CGSize(width: weakSelf.minWidth-weakSelf.margin*2,
                                                     height: weakSelf.minWidth-weakSelf.margin*2)
            
            switch weakSelf.status {
            case true:
                weakSelf.sliderOrigin = CGPoint(x: weakSelf.margin, y: weakSelf.sliderOrigin.y)
                
            case false:
                weakSelf.sliderOrigin = CGPoint(x: weakSelf.bounds.size.width-weakSelf.sliderView.bounds.size.width-weakSelf.margin,
                                                y: weakSelf.sliderOrigin.y)
                
            }
            
            weakSelf.sliderView.frame = CGRect(origin: weakSelf.sliderOrigin,
                                               size: weakSelf.sliderView.bounds.size)
            weakSelf.backView.backgroundColor = weakSelf.status ? weakSelf.closeColor : weakSelf.openColor
                    }) { [weak self] (finished) in
            guard let weakSelf = self else { return }
            weakSelf.delegate?.didChangedStatus(weakSelf.status)
        }
        
        status = !status
        
    }
}

