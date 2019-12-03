//
//  ViewController.swift
//  VideoList
//
//  Created by 이상범 on 29/11/2019.
//  Copyright © 2019 이상범. All rights reserved.
//

import UIKit
import AVKit
import Photos

class ViewController: UIViewController {
    // 비디오 배열 객체를 만들어준다.
    var videos: [Video] = []
    var allVideos: PHFetchResult<PHAsset>?
    
    @IBOutlet weak var videoTableView: UITableView!
    
    let videoPreviewLooper = VideoLooperView(clips: VideoClip.allClips())
    
    // 어떤게 나오나 보자
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.videoPreviewLooper.LooperViewStart()
        print("viewWillAppear")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        //videos = Video.allVideos()
        videos = Video.fetchVideos()
        //loadLoopView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.videoPreviewLooper.LooperViewPause()
        print("viewWillDisappear")
    }
    
    // 루프 뷰 위치와 크기 정해준다. 따로 빼내어야 할 듯 하다.
    func loadLoopView(){
        videoPreviewLooper.frame = CGRect(x: view.bounds.width - 150 - 16, y: view.bounds.height - 100 - 16, width: 150, height: 100)
        videoPreviewLooper.backgroundColor = .black
        view.addSubview(videoPreviewLooper)
    }
}


extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330
        
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 만든 VideoTableViewCell로 캐스팅 해준다.
        let videoCell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! VideoTableViewCell
        
        videoCell.titleLabel.text = videos[indexPath.row].title
        // 꼭 알도록하자 UI이미지를 패스로 가져오기
        videoCell.previewImageView.image = videos[indexPath.row].prevImage
        videoCell.subtitleLabel.text = videos[indexPath.row].subtitle
        
        return videoCell
    }
    
    // row가 셀렉트 되었을 때
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = videos[indexPath.row]
        let videoURL = video.url
        let player = AVPlayer(url: videoURL)
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        present(playerViewController, animated: true, completion: {
            playerViewController.player?.play()
        })
    }
    
    
}

// 이 부분이 있기때문에 비디디오가 올라가는것 같다 뷰에
extension VideoLooperView {
  override func layoutSubviews() {
    super.layoutSubviews()
    
    videoPlayerView.frame = bounds
    addSubview(videoPlayerView)
  }
}
