
Pod::Spec.new do |s|

    s.name            = 'PEPAncientPoetry'

    s.version         = '1.0.0'

    s.summary         = '古诗词模块'

    s.license         = 'MIT'

    s.homepage        = 'https://github.com/PEPDigitalPublishing/PEPAncientPoetry'

    s.author          = { '崔冉' => 'cuir@pep.com.cn' }

    s.platform        = :ios, '12.0'

    s.source          = { :git => 'https://github.com/PEPDigitalPublishing/PEPAncientPoetry' }
    
    s.swift_version   = '5.0'
    
    s.source_files    = 'Core/AncientPoetry/*.{h,m,swift}',
                        'Core/AncientPoetry/倒计时/*.swift',
                        'Core/AncientPoetry/古诗词背诵/*.swift',
                        'Core/AncientPoetry/录音模块/*.{h,mm}',
                        'Core/AncientPoetry/下载模块/*.{h,m}',
                        'Core/AncientPoetry/Model/*.{h,m,swift}',
                        'Core/AncientPoetry/Model/PRPoetryInfo/*.swift',
                        'Core/AncientPoetry/Player/*.swift',
                        'Core/AncientPoetry/PRBaseUtil/*.{h,m}',
                        'Core/AncientPoetry/PRBaseUtil/OtherModuleUtil/*.{h,m}',
                        'Core/AncientPoetry/View/*.swift',
                        'Core/AncientPoetry/webSocket/*.swift',
                        'Core/AncientPoetryPlayerOnlineEngine/*.{h,m}',
                        'Core/Category/*.{h,m}',
                        'Core/Swift/Utils/*.swift',
                        'Core/YSTUtils/*.{h,m}',
                        'Core/BaseViewController/*.{h,m}',
                        'Core/AncientPoetry/录音模块/lib/*.{h,m}'
                        'Core/YSAudioUserManager/*.{h,m}',
                        
    s.resource_bundles= {
        'resource_module' => ['Core/resource_module/*.{xib,xcassets,storyboard}']
    }

    s.frameworks      = 'Foundation', 'UIKit', 'AVFoundation'

end
