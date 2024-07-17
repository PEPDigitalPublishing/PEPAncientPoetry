//
//  Toast.swift
//  PEPRead
//
//  Created by 李沛倬 on 2020/1/10.
//  Copyright © 2020 PEP. All rights reserved.
//

import UIKit

class Toast {
    static let shared = Toast()
    
    fileprivate let animateDuration = 0.3
    
    let toastView = ToastView(frame: CGRect.zero)
        
    var timerGroup: [DispatchSourceTimer] = []
    
    init() {}
    
    class func show(with string: String, inView: UIView = UIApplication.shared.keyWindow!, delayHidden: TimeInterval = -1) {
        Toast.shared.show(with: string, inView: inView, delayHidden: delayHidden)
    }
    
    func show(with string: String, inView: UIView = UIApplication.shared.keyWindow!, delayHidden: TimeInterval = -1) {
        guard string.isEmpty == false else { return }
        
        DispatchQueue.main.async {
            self._show(string: string, inView: inView, delayHidden: delayHidden)
        }
    }
    
    private func _show(string: String, inView: UIView = UIApplication.shared.keyWindow!, delayHidden: TimeInterval = -1) {
        let constraints = toastView.constraints
                
        if toastView.superview != inView {
            toastView.removeConstraints(constraints)
            toastView.removeFromSuperview()
            
            inView.addSubview(toastView)
            
            let percent: CGFloat = 0.618
            toastView.translatesAutoresizingMaskIntoConstraints = false
            toastView.centerXAnchor.constraint(equalTo: inView.centerXAnchor).isActive = true
            toastView.centerYAnchor.constraint(equalTo: inView.centerYAnchor, constant: 20).isActive = true
            toastView.widthAnchor.constraint(lessThanOrEqualTo: inView.widthAnchor, multiplier: percent).isActive = true
            toastView.heightAnchor.constraint(lessThanOrEqualTo: inView.heightAnchor, multiplier: percent).isActive = true
        } else {
            toastView.superview?.bringSubviewToFront(toastView)
        }

        toastView.titleLabel.text = string
        
        for timer in timerGroup { timer.cancel() }
        
        toastView.setNeedsLayout()
        UIView.animate(withDuration: animateDuration, animations: {
            self.toastView.alpha = 1
            self.toastView.layoutIfNeeded()
        }) { (_) in
            let timer: DispatchSourceTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())

            let duration: TimeInterval = delayHidden > 0 ? delayHidden : min(8, 1 + TimeInterval(string.count)*0.04)
            
            timer.schedule(wallDeadline: .now()+duration, repeating: 0, leeway: .milliseconds(100))
            timer.resume()

            var deadline = duration
            
            timer.setEventHandler {
                if deadline >= 0 {
                    deadline -= 0.1
                    return
                }
                
                timer.cancel()
                
                DispatchQueue.main.async {
                    UIView.animate(withDuration: self.animateDuration, animations: {
                        self.toastView.alpha = 0
                    }) { (_) in
                        
                    }
                }
            }
            
            self.timerGroup.append(timer)
        }
        
    }
    
}

class ToastView: UIView {
    
    lazy var effectView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        view.alpha = 0.9
        
        return view
    }()
    
    lazy var titleLabel: UILabel = LabelFactory.makeToastTitleLabel()
    
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func show(with title: String) {
        
    }
    
    
    
    // MARK: - UI
    
    func setupSubviews() {
        isUserInteractionEnabled = false
        layer.masksToBounds = true
        layer.cornerRadius = 8
//        backgroundColor = UIColor.black
        
        addSubview(effectView)
        addSubview(titleLabel)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if titleLabel.constraints.count > 0 { return }
        
        
        let offset: CGFloat = 8
        effectView.translatesAutoresizingMaskIntoConstraints = false
        effectView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        effectView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        effectView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        effectView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: offset).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: offset).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -offset).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -offset).isActive = true

    }

    

}
