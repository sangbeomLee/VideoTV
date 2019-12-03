//
//  VideoClip.swift
//  VideoList
//
//  Created by 이상범 on 29/11/2019.
//  Copyright © 2019 이상범. All rights reserved.
//

import UIKit

class VideoClip: NSObject {
    let url: URL
    
    init(url: URL){
        self.url = url
        super.init()
    }
    
    class func allClips() -> [VideoClip]{
        var clips: [VideoClip] = []
        
        // Add HLS Stream to the beginning of clip show
        
        // 이름이 틀렸을 경우 대비해서 뭔가를 해야한다.
        let names = ["newYorkFlip-clip", "bulletTrain-clip", "monkey-clip", "shark-clip"]

        for name in names{
            let urlPath = Bundle.main.path(forResource: name, ofType: "mp4")!
            let url = URL(fileURLWithPath: urlPath)
            
            let clip = VideoClip(url: url)
            clips.append(clip)
        }
        
        return clips
    }
}
