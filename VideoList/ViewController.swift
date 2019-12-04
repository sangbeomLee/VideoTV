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
    
    @IBOutlet weak var videoPreView: VideoPreView!
    @IBOutlet weak var videoTableView: UITableView!
    
    // 어떤게 나오나 보자
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        videos = Video.fetchVideos()
        videoPreView.isHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear")
    }
}


extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
        
    }
}



extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }    // 이 부분을 줄일 필요가있다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 만든 VideoTableViewCell로 캐스팅 해준다.
        let videoCell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! VideoTableViewCell
        
        // 하나씩 모두 제스처를 달았다. 이부분을 간결하게 바꿔보자.
        videoCell.titleLabel.text = videos[indexPath.row].title
        videoCell.titleLabel.tag = indexPath.row
                // 꼭 알도록하자 UI이미지를 패스로 가져오기
        videoCell.previewImageView.image = videos[indexPath.row].prevImage
        videoCell.previewImageView.tag = indexPath.row
        let imgReconizer = UITapGestureRecognizer(target: self, action: #selector(tabUIImage))
        videoCell.previewImageView.addGestureRecognizer(imgReconizer)
        videoCell.previewImageView.isUserInteractionEnabled = true
        
        videoCell.subtitleLabel.text = videos[indexPath.row].subtitle
        videoCell.subtitleLabel.tag = indexPath.row
        let titleLabel = UITapGestureRecognizer(target: self, action:  #selector (tabTitleLabel))
        videoCell.subtitleLabel.isUserInteractionEnabled = true
        videoCell.subtitleLabel.addGestureRecognizer(titleLabel)
        
        videoCell.preViewButton.tag = indexPath.row
        let previewRecognizer = UITapGestureRecognizer(target: self, action: #selector(tabPreview))
        //videoCell.preViewButton.imageEdgeInsets = UIEdgeInsets(top: 7 ,left: 7,bottom: 7,right: 7)
        videoCell.preViewButton.addGestureRecognizer(previewRecognizer)

        videoCell.selectionStyle = .none
        
    
        
        
        return videoCell
    }
    @objc func tabPreview(sender: UITapGestureRecognizer){
        let hasButton = sender.view as! UIButton
        videoPreView.isHidden = false
        videoPreView.setVideoToPlayer(video: videos[hasButton.tag])
    }
    
    @objc func tabUIImage(sender: UITapGestureRecognizer){
        let getImage = sender.view as! UIImageView
        let video = videos[getImage.tag]
        let videoURL = video.url
        let player = AVPlayer(url: videoURL)
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        // 틀기전에 멈춘다. preView는
        if videoPreView.isHidden == false{
            videoPreView.videoPlayerView.player!.pause()
        }
        videoPreView.isHidden = true
        present(playerViewController, animated: true, completion: {
            playerViewController.player?.play()
        })
    }
    
    @objc func tabTitleLabel(sender: UITapGestureRecognizer){
        print("touch subTitle")
    }

    
}
