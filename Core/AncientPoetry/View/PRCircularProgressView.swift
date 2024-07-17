import UIKit

class PRCircularProgressView: UIView {
    
    private var shapeLayer: CAShapeLayer!
    private var duration: TimeInterval = 0
    private var pausedTime: CFTimeInterval = 0
    
    var lineColor  = UIColor.init(hexString: "#75E4C3")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayer()
    }
    
    private func setupLayer() {
        self.isUserInteractionEnabled = true
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: bounds.width / 2, startAngle: -CGFloat.pi / 2, endAngle: 3 * CGFloat.pi / 2, clockwise: true)
        
        shapeLayer = CAShapeLayer()
        shapeLayer.path = circularPath.cgPath
    
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.strokeEnd = 0
        shapeLayer.opacity = 0.8
        shapeLayer.lineCap = .round
        layer.addSublayer(shapeLayer)
    }
    func isDrawing()-> Bool{
        if self.duration > 0{
            return true
        }else{
            return false
        }
    }
    func startAnimation(duration: TimeInterval) {
        self.duration = duration
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = duration
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.add(animation, forKey: "circularProgressAnimation")
    }
    
    func pauseAnimation() {
        pausedTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        shapeLayer.speed = 0.0
        shapeLayer.timeOffset = pausedTime
    }
    
    func resumeAnimation() {
        let pausedTime = shapeLayer.timeOffset
        shapeLayer.speed = 1.0
        shapeLayer.timeOffset = 0.0
        shapeLayer.beginTime = 0.0
        let timeSincePause = shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        shapeLayer.beginTime = timeSincePause
    }
    
    func resetAnimation() {
        shapeLayer.removeAllAnimations()
        shapeLayer.strokeEnd = 0
        duration = 0.0
    }
}

