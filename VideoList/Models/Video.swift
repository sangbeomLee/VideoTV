//
//  Video.swift
//  VideoList
//
//  Created by 이상범 on 29/11/2019.
//  Copyright © 2019 이상범. All rights reserved.
//

import UIKit
// 동영상 파일을 가져오기 위해서 사용한다.
// 파일을 가지고 오기전에 사용자에게 명시적으로 알려주어야 하기때문에 info에 가서 privarcy photolibrary설정해주여야한다.
import AVKit
import Photos

class Video: NSObject {
    let url: URL
    let prevImage: UIImage?
    let title: String
    let subtitle: String?
    
    init(url: URL, prevImage: UIImage, title: String, subtitle: String?){
        self.url = url
        self.prevImage = prevImage
        self.title = title
        self.subtitle = subtitle ?? ""
        // 이 부분을 왜 하는지 알자.
        
        super.init()
    }
    
//    class func localVideos() -> [Video]{
//        var videos: [Video] = []
//        let names = ["newYorkFlip", "bulletTrain", "monkey", "shark"]
//        let titles = ["New York Flip", "Bullet Train Adventure", "Monkey Village", "Robot Battles"]
//        let subtitles = ["Can this guys really flip all of his bros? You'll never believe what happens!",
//                         "Enjoying the soothing view of passing towns in Japan",
//                         "Watch as a roving gang of monkeys terrorizes the top of this mountain!",
//                         "Have you ever seen a robot shark try to eat another robot?"]
//        // enumerated() 를 쓰면 인덱스와 값 두개를 동시에 가져올 수 있다.
//        for (index, name) in names.enumerated(){
//            let urlPath = Bundle.main.path(forResource: name, ofType: "mp4")!
//            let url = URL(fileURLWithPath: urlPath)
//            let thumbURLPath = Bundle.main.path(forResource: name, ofType: "png")!
//            let thumbURL = URL(fileURLWithPath: thumbURLPath)
//
//            let video = Video(url: url, thumbURL: thumbURL, title: titles[index], subtitle: subtitles[index])
//
//            videos.append(video)
//        }
//        return videos
//    }

    // 모든 비디오 파일 가져온다.
    class func fetchVideos() -> [Video]{
        var videos: [Video] = []
        var resultVideos: PHFetchResult<PHAsset>?
        
        resultVideos = PHAsset.fetchAssets(with: .video, options: nil)
        // allvideos 의 개수만큼 저장을 위해 사용한다.
        let videoCount = resultVideos?.count ?? 0
        for index in 0..<videoCount{
            guard let asset = resultVideos?.object(at: index) else{
                return videos
            }

            let avURL = getVideoUrlFromPHAsset(asset)
            //  캡쳐화면으로 바꿨다.
            let previewImage:UIImage = videoSnapshot(videoAsset: avURL)!
            let title = avURL.url.lastPathComponent
            let time = getTime(seconds: avURL.duration.seconds)
            let hasVideo = Video(url: avURL.url, prevImage: previewImage, title: title, subtitle: time)
            videos.append(hasVideo)
        }
        return videos
    }
    // PHAsset 을 AVURLAsset 으로 바꿔주는 함수 이부분 정말 제대로 잡고 넘어가야하겠다...
    class func getVideoUrlFromPHAsset(_ asset: PHAsset)->AVURLAsset{
        let semaphore = DispatchSemaphore(value: 0)
        var videoObj:AVURLAsset? = nil
        let options = PHVideoRequestOptions()
        // options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        PHImageManager().requestAVAsset(forVideo:asset, options: options, resultHandler: { (avurlAsset, audioMix, dict) in
            videoObj = avurlAsset as? AVURLAsset
            semaphore.signal()
        })
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)

        return videoObj!
    }
    
    // 비디오 스크린샷 해주는 함수
    class func videoSnapshot(videoAsset: AVURLAsset) -> UIImage? {
        //let vidURL = URL(filePathLocal)
        let generator = AVAssetImageGenerator(asset: videoAsset)
        generator.appliesPreferredTrackTransform = true

        let timestamp = CMTime(seconds: 3, preferredTimescale: 60)

        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: imageRef)
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
            return nil
        }
    }

}

func getTime(seconds: Double) -> String{
    let minute = String(format: "%d", Int(seconds / 60))
    let second = String(format: "%.0f" , seconds.truncatingRemainder(dividingBy: 60))
    
    let time = "\(minute) : \(second)"
    return time
}
