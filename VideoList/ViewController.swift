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
    var filteredVideos: [Video] = []
    var allVideos: PHFetchResult<PHAsset>?
    // for search
    var isFiltered = false
    
    @IBOutlet weak var videoPreView: VideoPreView!
    @IBOutlet weak var videoTableView: UITableView!
    
    // 어떤게 나오나 보자
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        videoTableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        videos = Video.fetchVideos()
        videoPreView.isHidden = true
        
        let searchC = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchC
        searchC.searchBar.placeholder = "Search your video"
        searchC.searchResultsUpdater = self
        searchC.searchBar.delegate = self
        searchC.searchBar.returnKeyType = .search
        self.navigationItem.hidesSearchBarWhenScrolling = true
        
        
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
        if isFiltered{
            return filteredVideos.count
        }else{
            return videos.count
        }
        
    }
    
    // 이 부분을 줄일 필요가있다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 만든 VideoTableViewCell로 캐스팅 해준다.
        let videoCell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! VideoTableViewCell
        
        if(isFiltered){
            // 하나씩 모두 제스처를 달았다. 이부분을 간결하게 바꿔보자.
                   videoCell.titleLabel.text = filteredVideos[indexPath.row].title
                   videoCell.titleLabel.tag = indexPath.row
                   // 꼭 알도록하자 UI이미지를 패스로 가져오기
                   videoCell.previewImageView.image = filteredVideos[indexPath.row].prevImage
                   videoCell.previewImageView.tag = indexPath.row
                   let imgReconizer = UITapGestureRecognizer(target: self, action: #selector(tabUIImage2))
                   videoCell.previewImageView.addGestureRecognizer(imgReconizer)
                   videoCell.previewImageView.isUserInteractionEnabled = true
                   
                   videoCell.subtitleLabel.text = filteredVideos[indexPath.row].subtitle
                   videoCell.subtitleLabel.tag = indexPath.row
                   let titleLabel = UITapGestureRecognizer(target: self, action:  #selector (tabTitleLabel))
                   videoCell.subtitleLabel.isUserInteractionEnabled = true
                   videoCell.subtitleLabel.addGestureRecognizer(titleLabel)
                   
                   videoCell.preViewButton.tag = indexPath.row
                   let previewRecognizer = UITapGestureRecognizer(target: self, action: #selector(tabPreview2))
                   //videoCell.preViewButton.imageEdgeInsets = UIEdgeInsets(top: 7 ,left: 7,bottom: 7,right: 7)
                   videoCell.preViewButton.addGestureRecognizer(previewRecognizer)
                    
                   videoCell.selectionStyle = .none
        }else{
            // 하나씩 모두 제스처를 달았다. 이부분을 간결하게 바꿔보자.
                   videoCell.titleLabel.text = videos[indexPath.row].title
                   videoCell.titleLabel.tag = indexPath.row
                   // 꼭 알도록하자 UI이미지를 패스로 가져오기
                   videoCell.previewImageView.image = videos[indexPath.row].prevImage
                   videoCell.previewImageView.tag = indexPath.row
                   let imgReconizer = UITapGestureRecognizer(target: self, action: #selector(tabUIImage1))
                   videoCell.previewImageView.addGestureRecognizer(imgReconizer)
                   videoCell.previewImageView.isUserInteractionEnabled = true
                   
                   videoCell.subtitleLabel.text = videos[indexPath.row].subtitle
                   videoCell.subtitleLabel.tag = indexPath.row
                   let titleLabel = UITapGestureRecognizer(target: self, action:  #selector (tabTitleLabel))
                   videoCell.subtitleLabel.isUserInteractionEnabled = true
                   videoCell.subtitleLabel.addGestureRecognizer(titleLabel)
                   
                   videoCell.preViewButton.tag = indexPath.row
                   let previewRecognizer = UITapGestureRecognizer(target: self, action: #selector(tabPreview1))
                   //videoCell.preViewButton.imageEdgeInsets = UIEdgeInsets(top: 7 ,left: 7,bottom: 7,right: 7)
                   videoCell.preViewButton.addGestureRecognizer(previewRecognizer)
                    
                   videoCell.selectionStyle = .none
        }
        
        return videoCell
    }
    @objc func tabPreview1(sender: UITapGestureRecognizer){
        let hasButton = sender.view as! UIButton
        videoPreView.isHidden = false
        videoPreView.setVideoToPlayer(video: videos[hasButton.tag])
    }
    @objc func tabPreview2(sender: UITapGestureRecognizer){
        let hasButton = sender.view as! UIButton
        videoPreView.isHidden = false
        videoPreView.setVideoToPlayer(video: filteredVideos[hasButton.tag])
    }
    
    @objc func tabUIImage1(sender: UITapGestureRecognizer){
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
    @objc func tabUIImage2(sender: UITapGestureRecognizer){
        let getImage = sender.view as! UIImageView
        let video = filteredVideos[getImage.tag]
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

extension ViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        // 소문자로 변환
        if let hasText = searchController.searchBar.text?.lowercased(){
            if hasText.isEmpty {
                self.isFiltered = false
            }else{
                self.isFiltered = true
                filteredVideos = videos.filter({ (element) -> Bool in
                    return element.title.lowercased().contains(hasText)
                })
            }
            videoTableView.reloadData()
        }
    }
    
    
}

// push search
extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchButtonClicked")
        let video = filteredVideos[0]
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
}
