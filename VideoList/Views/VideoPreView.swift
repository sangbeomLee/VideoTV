/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
import UIKit
import AVFoundation

class VideoPreView: UIView {
    @objc var player: AVPlayer?
    let videoPlayerView = VideoPlayerView()
    private var isPlaying = false
    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        // gestrue추가
        addPreViewTapGestureRecognizers()
        print("initializePlayer: override init")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addPreViewTapGestureRecognizers()
        //이 부분을 해야 올라간다.
        // 뷰를 올리는 부분
        addSubview(videoPlayerView)
        // 이부분이 뭔지 알아야 겠다.
        
        videoPlayerView.frame = bounds
        print("initializePlayer: required init")
    }
    
    func setVideoToPlayer(video: Video) {
        let asset = AVURLAsset(url: video.url)
        let item = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: item)
        player!.volume = 0.0
        videoPlayerView.player = player
        videoPlayerView.isHidden = false
        print("setVideoToPlayer : \(video.url)")
        player!.play()
    }
    // MARK - Unnecessary but necessary Code

    func addPreViewTapGestureRecognizers(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(VideoPreView.wasTapped))
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(VideoPreView.wasDoubleTapped))
        //doubleTap.numberOfTouches = 2
        doubleTap.numberOfTapsRequired = 2
        
        // doubleTap을 허용하였기 때문에 tap에는 doubleTap을 꺼 놓는다.
        tap.require(toFail: doubleTap)
        
        // 넣어준다.
        addGestureRecognizer(tap)
        addGestureRecognizer(doubleTap)
    }
    
    // 나오고 들어가고 정해야겠다.
    @objc func wasTapped(){
        if isPlaying{
            player!.pause()
        }else{
            player!.play()
        }
        isPlaying = !isPlaying
        //player.volume = player.volume == 1.0 ? 0.0 : 1.0
    }
    
    @objc func wasDoubleTapped(){
        player!.rate = player!.rate == 1.0 ? 2.0 : 1.0
    }
}


