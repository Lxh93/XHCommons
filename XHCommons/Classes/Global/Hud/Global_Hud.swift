//
//  Global_Hud.swift
//  CMICPro
//
//  Created by 李小华 on 2022/11/21.
//

import PKHUD

class HUD {
    
    public typealias TimerAction = (Bool) -> Void
    
    let hud : PKHUD = {
        let hud = PKHUD()
        //        hud.contentView = PKHUDProgressView()
        hud.contentView = CMHUDProgressView(image: nil, title: nil, subtitle: nil)
        hud.dimsBackground = false
        return hud
    }()
    

    public init () {
        
    }
    
//    public convenience init(viewToPresentOn view: UIView) {
//        self.init()
//    }

    
    open func show(onView view: UIView? = nil) {
        hud.show(onView: view ?? UIViewController.jk.topViewController()?.view)
    }
    
    open func hide(afterDelay delay: TimeInterval, completion: TimerAction? = nil) {
        hud.hide(afterDelay: delay, completion: completion)
    }
    
    open func hide(animated anim: Bool = true, completion: TimerAction? = nil) {
        hud.hide(animated: anim, completion: completion)
    }
}
