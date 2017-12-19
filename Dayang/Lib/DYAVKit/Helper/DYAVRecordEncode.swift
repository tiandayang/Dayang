//
//  DYRecordEncode.swift
//  Dayang
//
//  Created by 田向阳 on 2017/12/5.
//  Copyright © 2017年 田向阳. All rights reserved.
//

import UIKit
import AVFoundation

public class DYAVRecordEncode: NSObject {

    var path: String!
    var avWriter: AVAssetWriter!
    var avAudioInput: AVAssetWriterInput?
    var avVideoInput: AVAssetWriterInput!

    convenience init (path: String, width: Int, height: Int, audioChannels:Int, rate: Float64) {
        self.init()
        self.path = path;
        WXXFileServer.removeFileAtPath(path: path) //先删除本地保存的残留
       let url = URL.init(fileURLWithPath: path)
        do {
            try avWriter = AVAssetWriter.init(url: url, fileType: AVFileTypeMPEG4)
        } catch _ {
            debugPrint("init AVWriter error")
            return
        }
        avWriter.shouldOptimizeForNetworkUse = true
        initVideoInput(width: width, height: height)
        if audioChannels != 0 && rate != 0 {
            self.initAudioInput(ch: audioChannels, rate: rate)
        }
 
    }
    
    /// 初始化视频的输入源
    ///
    /// - Parameters:
    ///   - width: 像素宽
    ///   - height: 像素高
    func initVideoInput(width: Int, height: Int) {
        let config : [String : Any] = [
            AVVideoCodecKey: AVVideoCodecH264,
            AVVideoWidthKey: width,
            AVVideoHeightKey: height,
                      ]
        avVideoInput = AVAssetWriterInput.init(mediaType: AVMediaTypeVideo, outputSettings: config)
        //实时数据源的数据
        avVideoInput.expectsMediaDataInRealTime = true
        avWriter.add(avVideoInput)
    }
    
    /// 初始化音频输入源
    ///
    /// - Parameters:
    ///   - ch: 声道
    ///   - rate: 比率
    func initAudioInput(ch: Int, rate: Float64) {
        let config : [String : Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVNumberOfChannelsKey: ch,
            AVSampleRateKey: rate,
            AVEncoderBitRateKey: 128000
            ]
        avAudioInput = AVAssetWriterInput.init(mediaType: AVMediaTypeAudio, outputSettings: config)
        avAudioInput!.expectsMediaDataInRealTime = true
        avWriter.add(avAudioInput!)
    }
    
    /// 开始写入数据
    ///
    /// - Parameters:
    ///   - buffer: 捕捉的数据
    ///   - isVideo: 是否是视频的buffer
    /// - Returns: 是否写入成功
    func encodeBuffer(buffer: CMSampleBuffer, isVideo: Bool) -> Bool{
        if CMSampleBufferDataIsReady(buffer) {
            //写入状态未知的话 先写入视频
            if avWriter.status == .unknown && isVideo {
                let startTime = CMSampleBufferGetPresentationTimeStamp(buffer)
                avWriter.startWriting()
                avWriter.startSession(atSourceTime: startTime)
            }
            //写入失败
            if avWriter.status == .failed {
                debugPrint(avWriter.error?.localizedDescription as Any)
               return false
            }
            //拼接buffer
            if isVideo {
                if avVideoInput.isReadyForMoreMediaData {
                    avVideoInput.append(buffer)
                    return true
                }
            }else{
                if avAudioInput?.isReadyForMoreMediaData ?? false {
                    avAudioInput?.append(buffer)
                    return true
                }
            }
        }
        return false
    }
    
}
