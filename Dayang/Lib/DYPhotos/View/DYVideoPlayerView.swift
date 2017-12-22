//
//  DYVideoPlayerView.swift
//  Dayang
//
//  Created by 田向阳 on 2017/9/1.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit
import AVFoundation

class DYVideoPlayerView: UIImageView, DYVideoPlayerMenuViewDelegate{
    
    var currentPlayURL: String? //当前播放的url
    var timeObserver: Any?
    var isDisPlay: Bool = false {
        didSet{
            if isDisPlay {
                self.play()
            }else{
                self.pause()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        self.contentMode = .scaleAspectFit
        createUI()
        addNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        dy_Print("播放器释放")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Action
    // 配置item
    private func setURL(url: URL) {
        self.playerItem = AVPlayerItem.init(url: url)
        self.player.replaceCurrentItem(with: self.playerItem)
    }
    
    private func addTimeObserver() {
        if self.timeObserver != nil {
            return
        }
        self.timeObserver = self.player.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 30), queue: DispatchQueue.main, using: { [weak self] (cmTime) in
            if self?.player.status == .readyToPlay {
                let currentTime = CMTimeGetSeconds(cmTime)
                let totalTime = self?.totalDuration()
                self?.menuView.updatePlayTime(currentTime: currentTime, totalTime: totalTime!)
            }
        })
        
    }

    public func play() {
        player.play()
        self.menuView.playButton.isSelected = true
        addTimeObserver()
    }
    
    public func pause() {
        player.pause()
        if self.timeObserver != nil {
            player.removeTimeObserver(self.timeObserver!)
            self.timeObserver = nil
        }
        self.menuView.playButton.isSelected = false
    }
    
    //MARK: registNotification
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidPlayToEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    @objc private func playerItemDidPlayToEnd() {
        pause()
        seekToTime(time: 0)
        self.menuView.updatePlayTime(currentTime: 0, totalTime: totalDuration())
    }
    
    @objc private func appWillResignActive() {
        pause()
    }
    
    @objc private func appDidBecomeActive() {
        if isDisPlay {
            play()
        }
    }
    //MARK: DYVideoPlayerMenuViewDelegate
    func sliderDragBegin() {
        pause()
    }
    
    func sliderDraging(value: Double) {
        if  value < 0.95 {
            seekToTime(time: value * totalDuration())
        }
        menuView.updatePlayTime(currentTime: currentTime(), totalTime: totalDuration())
    }
    
    func sliderDragEnd() {
        play()
    }
    
    func playButtonAction(button: UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            play()
        }else{
            pause()
        }
    }
    
    //MARK: CreateUI
    override func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer.frame = self.bounds;
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    
    private func createUI() {
        self.layer.addSublayer(self.playerLayer)
        self.addSubview(menuView)
        menuView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    var videoURL: String? {
        didSet {
            if currentPlayURL != nil && videoURL == currentPlayURL{
                return;
            }
            currentPlayURL = videoURL
            setURL(url:DYPhotosHelper.getURL(url: currentPlayURL!))
        }
    }
    
    //MARK:LAZY
    lazy var player: AVPlayer = {
        let player = AVPlayer.init(playerItem: self.playerItem)
        return player
    }()
    
    lazy var playerItem: AVPlayerItem? = {
        var url = URL(string: "")
        if self.videoURL != nil {
            url = DYPhotosHelper.getURL(url: self.videoURL!)
        }
        if url == nil {
            return nil
        }
        let item = AVPlayerItem.init(url: url!)
        return item
    }()
    
    lazy var playerLayer: AVPlayerLayer = {
        let layer = AVPlayerLayer.init(player: self.player)
        return layer
    }()
    
    lazy var menuView: DYVideoPlayerMenuView = {
        let menuView = DYVideoPlayerMenuView.init(frame: CGRect.zero)
        menuView.delegate = self
        return menuView
    }()
    
    //MARK: Helper
    private func seekToTime(time: Double) {
        var cmTime = CMTimeMake(1, 30)
        if time < 4 {
            cmTime = CMTimeMakeWithSeconds(Float64(time), 1);
        }else{
            cmTime = CMTimeMakeWithSeconds(Float64(time), 30);
        }
        if (CMTIME_IS_INVALID(cmTime) || self.player.currentItem?.status != .readyToPlay){
            return;
        }
        DispatchQueue.global().async {
            self.player.seek(to: cmTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        }
    }
    
    private func totalDuration() -> Float64 {
        
        var duration = Float64(0)
        if self.playerItem != nil {
            if !CMTIME_IS_INVALID((self.player.currentItem?.duration)!) {
                duration = CMTimeGetSeconds((self.player.currentItem?.duration)!);
            }
        }
        return duration
    }
    
    private func currentTime() -> Float64 {
        var  currentTime = Float64(0)
        if self.player.currentItem != nil{
            if !CMTIME_IS_INVALID(self.player.currentTime()){
                currentTime = CMTimeGetSeconds(self.player.currentTime());
            }
        }
        return Float64(currentTime)
    }
}





protocol DYVideoPlayerMenuViewDelegate: NSObjectProtocol {
    
    func playButtonAction(button: UIButton)// 点击播放按钮
    func sliderDragBegin() //滑块拖动开始
    func sliderDragEnd()//滑块拖动结束
    func sliderDraging(value: Double)
}


class DYVideoPlayerMenuView: UIView {
   weak var delegate: DYVideoPlayerMenuViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Action
    @objc private func playButtonAction() {
        if delegate != nil {
            delegate?.playButtonAction(button: playButton)
        }
    }
    
    @objc private func sliderPan(pan: UIPanGestureRecognizer) {
        
        switch pan.state {
        case .began:
            if delegate != nil {
                self.delegate?.sliderDragBegin()
            }
            break
        case .changed:
            let point = pan.location(in: self)
            let x = slider.mj_x;
            let maxX = slider.mj_w + slider.mj_x;
            if point.x > x && point.x <= maxX {
                let currentX = point.x - x;
                var value = currentX / self.slider.mj_w;
                value = (value > 1) ? 1 : value
                slider.setValue(Float(value), animated: true)
                if delegate != nil {
                    delegate?.sliderDraging(value: Double(value))
                }
            }
            break
        case.ended:
            if delegate != nil {
                self.delegate?.sliderDragEnd()
            }
            break;
        default: break
            
        }
        
    }
    
    public func updatePlayTime(currentTime: Float64, totalTime: Float64) {
        if totalTime.isNaN {
            return
        }
        currentTimeLaebl.text = timeFormat(time: Int(currentTime))
        totalTimeLabel.text = timeFormat(time: Int(totalTime))
        slider.setValue(Float(currentTime / totalTime), animated: true)
    }
    
    //MARK: CreateUI
   private func createUI() {
        addSubview(playButton)
        addSubview(totalTimeLabel)
        addSubview(currentTimeLaebl)
        addSubview(slider)
    
    let pan = UIPanGestureRecognizer(target: self, action: #selector(sliderPan))
    self.addGestureRecognizer(pan)
    
        playButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(SCALE_WIDTH(width: 50))
            make.height.equalTo(SCALE_WIDTH(width: 30))
        }
        
        currentTimeLaebl.snp.makeConstraints { (make) in
            make.left.equalTo(playButton.snp.right)
            make.centerY.equalToSuperview()
            make.width.equalTo(SCALE_WIDTH(width: 60))
            make.height.equalToSuperview()
        }
        
        totalTimeLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(SCALE_WIDTH(width: 60))
            make.height.equalToSuperview()
        }
    
        slider.snp.makeConstraints { (make) in
            make.left.equalTo(currentTimeLaebl.snp.right)
            make.right.equalTo(totalTimeLabel.snp.left)
            make.height.centerY.equalToSuperview()
    }
    }
    //MARK: lazy
    
    lazy var playButton: UIButton = {
        let button = UIButton.dyButton()
        button.setImage(#imageLiteral(resourceName: "photo_videopause"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "photo_videoplay"), for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var currentTimeLaebl: UILabel = {
        let label = UILabel()
        label.font = UIFont.dy_systemFontWithSize(size: 11)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    lazy var totalTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.dy_systemFontWithSize(size: 11)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.setThumbImage(#imageLiteral(resourceName: "photo_videothumb"), for: .normal)
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = .lightGray
        slider.minimumValue = 0;
        slider.maximumValue = 1;
        slider.value = 0;
        slider.isContinuous = false
        slider.isUserInteractionEnabled = false
        return slider
    }()
    
    //MARK: Helper
    
    private func timeFormat(time: Int) -> String {
        return transformTimeStr(time:time / 3600) + ":" + transformTimeStr(time: (time % 3600) / 60) + ":" + transformTimeStr(time:(time) % 60)
    }
    
    private func transformTimeStr(time: Int) -> String{
        if time > 9 {
            return String(time)
        }else{
            return "0" + String(time)
        }
    }
}
