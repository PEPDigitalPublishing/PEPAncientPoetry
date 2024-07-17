import UIKit

class PRWaveFormView: UIView {
    
    // MARK: - Properties
    
    private var leftVolumeBars: [UIView] = []
    private var rightVolumeBars: [UIView] = []
    private var leftVolumeValues: [Float] = Array(repeating: 0, count: 14)
    private var rightVolumeValues: [Float] = Array(repeating: 0, count: 14)
    private var barWidth: CGFloat = 3.0  // 小方块宽度
    private var barSpacing: CGFloat = 3.0  // 小方块间距
    private var maxHeight: CGFloat = 80.0  // 小方块最大高度
    private var minHeight: CGFloat = 4.0   // 小方块最小高度

    private var padding: CGFloat = 90.0
    private var waveCornerRadius: CGFloat = 1.5  // 小方块圆角半径
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        // 创建左侧小方块
        
        
        let numberOfBars = 14
        
        for index in 0..<numberOfBars {

            let bar = UIView()
            bar.backgroundColor = UIColor.theme
            bar.alpha = 0.8
            bar.layer.cornerRadius = waveCornerRadius
            self.addSubview(bar)
            leftVolumeBars.append(bar)
            let space = barWidth * CGFloat(index) + barSpacing * CGFloat(index)
            bar.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.equalTo(minHeight)
                make.width.equalTo(barWidth)
                make.left.equalToSuperview().offset(space)

            }
            
        }
        
        // 创建右侧小方块
    
        for index in 0..<numberOfBars {
            let bar = UIView()
            bar.backgroundColor = UIColor.theme
            bar.alpha = 0.8
            bar.layer.cornerRadius = waveCornerRadius
            self.addSubview(bar)
            rightVolumeBars.append(bar)
            let space = -(barWidth * CGFloat(index) + barSpacing * CGFloat(index))
            bar.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.equalTo(minHeight)
                make.width.equalTo(barWidth)
                make.right.equalToSuperview().offset(space)
            }
            
        }
        
        // 调整小方块的位置，使其从 PRWaveFormView 的 centerY 向上增长
        
    }
    
    private func updateBarsPosition(animated: Bool) {
     
        // 更新左侧小方块的位置和高度
        for (index, bar) in leftVolumeBars.enumerated() {
          let volume = max((leftVolumeValues[index] - 40), 4)
            let normalizedHeight = min(CGFloat(volume), CGFloat(70))  * 1.5 //放大1.5倍
           
            if animated {
                animateBar(bar: bar, to: normalizedHeight)
            }
            
        }
        
        // 更新右侧小方块的位置和高度
        for (index, bar) in rightVolumeBars.enumerated() {
            let volume = max((rightVolumeValues[index] - 40), 4)
            let normalizedHeight = min(CGFloat(volume), CGFloat(70))  * 1.5 //放大1.5倍
            
            if animated {
                animateBar(bar: bar, to: normalizedHeight)
            }
        }
    }

    
    private func animateBar(bar: UIView, to frame: CGFloat) {
        
        let duration = 0.1
        
        
        
        
        UIView.animate(withDuration: duration, animations: {
            bar.snp.updateConstraints({ make in
                
                make.height.equalTo(frame)
               
            })
            self.layoutIfNeeded()
        })
    }
    
    // MARK: - Public Methods
    
    func updateVolumeBars(newVolume: Float) {
        // 更新音量数据数组
        leftVolumeValues.removeFirst()
        leftVolumeValues.append(newVolume)
        
        rightVolumeValues.removeFirst()
        rightVolumeValues.append(newVolume)
        
        // 更新小方块高度并添加动画
        DispatchQueue.main.async {[weak self] in
            guard let self = self else{return}
            self.updateBarsPosition(animated: true)
        }
        
    }
    func resetVolumeBars(){
        leftVolumeValues = Array(repeating: 0, count: 14)
        rightVolumeValues = Array(repeating: 0, count: 14)
        
        DispatchQueue.main.async {[weak self] in
            guard let self = self else{return}
            self.updateBarsPosition(animated: true)
        }
    }
}

