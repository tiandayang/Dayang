//
//  DYAVRecordManager.swift
//  Dayang
//
//  Created by 田向阳 on 2017/12/5.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit
import AVFoundation

let videoPixelWidth = 720
let videoPixelHeight = 1280

protocol DYAVRecordManagerDelegate: NSObjectProtocol {
    func dy_recordProgress(progress: Double)
}


extension DYAVRecordManager: AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
       var isVideo = true
        objc_sync_enter(self)
        if !isRecording || isPaused{
            return
        }
        if videoOutput != output {
            isVideo = false
        }
        if avEncoder == nil && !isVideo {
            if let des = CMSampleBufferGetFormatDescription(sampleBuffer) {
                setAudioFormat(format: des)
            }
            avEncoder = DYAVRecordEncode.init(path: tempVideoPath, width: videoPixelWidth, height: videoPixelHeight, audioChannels: channel, rate: samplerate)
        }
        //如果中断过
        if isBreak {
            if isVideo {
                return
            }
            isBreak = false
            var curTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
            let last = isVideo ? lastVideoTime : lastAudioTime
            if last.flags.contains(CMTimeFlags.valid) {
                if timeOffset.flags.contains(CMTimeFlags.valid) {
                    curTime = CMTimeSubtract(curTime, timeOffset) //  Returns the difference of two CMTimes
                }
                
                let offset = CMTimeSubtract(curTime, last)
                if timeOffset.value == 0 {
                    timeOffset = offset
                }else{
                    timeOffset = CMTimeAdd(timeOffset, offset) //Returns the sum of two CMTimes
                }
            }
            lastVideoTime.flags = CMTimeFlags.init(rawValue: 0)
            lastAudioTime.flags = CMTimeFlags.init(rawValue: 0)
        }
        
        if timeOffset.value > 0 {
//            sampleBuffer = ajustBufferTime(buffer: sampleBuffer, offset: timeOffset)
        }
        
        
        objc_sync_exit(self)
        
    }
    
    public func setAudioFormat(format: CMFormatDescription) {
       let des = CMAudioFormatDescriptionGetStreamBasicDescription(format)
        samplerate = des?.pointee.mSampleRate ?? 0
        channel = Int(des?.pointee.mChannelsPerFrame ?? 0)
    }
    
    public func ajustBufferTime(buffer: CMSampleBuffer, offset: CMTime) -> CMSampleBuffer {
        var count = CMItemCount(0)
        CMSampleBufferGetSampleTimingInfoArray(buffer, 0, nil, &count)
        let timingInfo = malloc(MemoryLayout<CMSampleTimingInfo>.size * count) //  UnsafeMutableRawPointer
//        UnsafeMutablePointer<CMSampleTimingInfo>
        let pointer = timingInfo?.bindMemory(to: CMSampleTimingInfo.self, capacity: count)
        CMSampleBufferGetSampleTimingInfoArray(buffer, count, pointer, &count)
        for  index in 0...count {
            pointer![index].decodeTimeStamp = CMTimeSubtract(pointer![index].decodeTimeStamp, offset)
            pointer![index].presentationTimeStamp = CMTimeSubtract(pointer![index].presentationTimeStamp, offset)
        }
        
        var sampleBuffer: CMSampleBuffer? = nil
        CMSampleBufferCreateCopyWithNewTiming(nil, buffer, count, pointer, &sampleBuffer)
        free(timingInfo)
        return sampleBuffer!
    }
}

extension DYAVRecordManager {
    
    /// 开始录制
   public func dy_beginRecord() {
        
    }
    
    /// 停止录制
   public func dy_stopRecord() {
        
    }
    /// 暂停录制
   public func dy_pauseRecord() {
        
    }
    /// 继续录制
   public func dy_resumeRecord() {
        
    }
    
    /// 调整闪光灯
    ///
    /// - Parameter isOpen: 是否开启
   public func ajustFlashLight(isOpen: Bool) {
        
    }
    
    /// 调整摄像头
    ///
    /// - Parameter isFront: 是否是前置
   public func ajustCamera(isFront: Bool) {
        
    }
    
}

public class DYAVRecordManager: NSObject {
    
    var isRecording: Bool = false //是否在录制
    var isPaused: Bool = false // 是否暂停
    var isBreak: Bool = false // 是否中间中断过
    var maxRecordTime: TimeInterval = 10.0 //最长录制时间
    var startTime: CMTime = CMTimeMake(0, 0) //录制开始时间
    var currentTime: Double = 0.0;// 当前录制了多久
    var lastVideoTime: CMTime = CMTimeMake(0, 0) //暂停录制时的视频时间
    var lastAudioTime: CMTime = CMTimeMake(0, 0) //暂停录制时的音频时间  用来拼接视频
    var timeOffset: CMTime = CMTimeMake(0, 0) //录制的偏移时间
    var channel: Int = 0 //音频通道
    var samplerate: Float64 = 0 //采样率
    var avEncoder: DYAVRecordEncode? //编码器

   weak var delegate: DYAVRecordManagerDelegate?
    fileprivate var dyRecordEncode: DYAVRecordEncode!

    lazy var videoPath: String = {
        return self.getVideoPath()
    }() //视频最后存储路径
    
    lazy var tempVideoPath: String = {
        return self.getVideoPath()
    }() //视频录制时的存储路径
    
    fileprivate lazy var videoSessoin: AVCaptureSession  = {
        let session = AVCaptureSession()
        if self.backCameraInput != nil && session.canAddInput(self.backCameraInput!) {
            session.addInput(self.backCameraInput!)
        }
        if self.audioInput != nil && session.canAddInput(self.audioInput) {
        session.addInput(self.audioInput)
        }
        if session.canAddOutput(self.videoOutput) {
            session.addOutput(self.videoOutput)
        }
        
        if session.canAddOutput(self.audioOutput) {
            session.addOutput(self.audioOutput)
        }
        return session
    }()

    //MARK:音视频连接
    fileprivate var videoConnection: AVCaptureConnection? {
        let connection = self.videoOutput.connection(withMediaType: AVMediaTypeVideo)
        return connection
    }
    
    fileprivate var audioConnection: AVCaptureConnection? {
        let connection = self.audioOutput.connection(withMediaType: AVMediaTypeAudio)
        return connection
    }
    
    //MARK: 输出
   fileprivate lazy var recordQueue: DispatchQueue = {
        let queue = DispatchQueue.init(label: "com.dayang.DYAVRecordManagerQueue")
        return queue
    }()
    //视频输出
    lazy var videoOutput: AVCaptureVideoDataOutput = {
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: self.recordQueue)
        let config = [kCVPixelBufferPixelFormatTypeKey : kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange]
        output.videoSettings = config
        return output
    }()
    
    lazy var audioOutput: AVCaptureAudioDataOutput = {
        let output = AVCaptureAudioDataOutput()
        output.setSampleBufferDelegate(self, queue: self.recordQueue)
        return output
    }()
    
    //MARK: 输入
    // 音频输入
  fileprivate lazy var audioInput: AVCaptureDeviceInput? = {
    if let micDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio) {
        do {
            let input = try AVCaptureDeviceInput.init(device: micDevice)
            return input
        }catch {
            dy_Print("获取麦克风出错")
            return nil
        }
    }
    dy_Print("获取麦克风出错")
    return nil
    }()
    // 后置摄像头输入
  fileprivate lazy var backCameraInput: AVCaptureDeviceInput? = {
        if let device = self.getCameraDevice(isFront: false) {
            do {
                let input = try AVCaptureDeviceInput.init(device: device)
                return input
            } catch _{
                return nil
            }
        }
       return nil
    }()
    // 前置摄像头输入
  fileprivate lazy var frontCameraInput: AVCaptureDeviceInput? = {
        if let device = self.getCameraDevice(isFront: true) {
            do {
                let input = try AVCaptureDeviceInput.init(device: device)
                return input
            } catch _{
                return nil
            }
        }
        return nil
    }()
    //MARK: helper
   fileprivate func getCameraDevice(isFront: Bool) -> AVCaptureDevice? {
        let position = isFront ? AVCaptureDevicePosition.front : AVCaptureDevicePosition.back
        if let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) {
            for device in devices {
                let captureDevice = device as! AVCaptureDevice
                if captureDevice.position == position {
                    return captureDevice
                }
            }
        }
        return nil
    }
    
    fileprivate func getVideoPath() ->String {
        return  DYLocalFilePathServer.videoPath() + String(Date().timeIntervalSince1970).appending(".mp4")
    }
}
