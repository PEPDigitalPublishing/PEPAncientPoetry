//
//  PRPoetryStackView.swift
//  PEPRead
//
//  Created by sunShine on 2023/9/20.
//  Copyright © 2023 PEP. All rights reserved.
//

import Foundation
class PRPoetryHStackView: UIStackView {
    init(styleData: PRPoetrySingleTextData){
        super.init(frame: .zero)
        self.axis = .horizontal
        self.distribution = .fill
        self.alignment = .fill
        self.spacing = styleData.spacing
        switch styleData.style{
        case .title:
            
            self.backgroundColor = .clear
            
        case .poet:

            
            self.backgroundColor = .clear
            
        case .order:
            
            
            self.backgroundColor = .clear
            
        case .content:
            
            
            self.backgroundColor = .clear
        }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class PRPoetryVStackView: UIStackView {
    init(style: PRPoetrySingleTextData){
        super.init(frame: .zero)
        self.axis = .vertical
        self.distribution = .fill
        
        switch style.style{
        case .title:
            self.spacing = 0
            self.backgroundColor = .clear
            self.alignment = .center
        case .poet:

            self.spacing = 0
            self.backgroundColor = .clear
            self.alignment = .center
        case .order:
            
            self.spacing = 5
            self.backgroundColor = .clear
            self.alignment = .leading
        case .content:
            if style.poetryStyle == .SongCi{
                self.alignment = .leading
            }else if  style.poetryStyle == .Tangpoetry{
                self.alignment = .center
            }else if style.poetryStyle == .YuanQu {
                self.alignment = .leading
            }else if style.poetryStyle == .Wen {
                self.alignment = .leading
            }else if style.poetryStyle == .Tangpoetry_needConfig {
                self.alignment = .center
            }else if style.poetryStyle == .Tangpoetry_dontNeedConfig {
                self.alignment = .center
            }else if style.poetryStyle == .QinYuanChunXue {
                self.alignment = .center
            }else if style.poetryStyle == .JianJia {
                self.alignment = .center
            }
            
            self.spacing = 12
            self.backgroundColor = .clear
        }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
