//
//  PredictionModelView.swift
//  MC3-FitMotion
//
//  Created by Baghiz on 24/07/24.
//

import SwiftUI

class PredictionViewModel: ObservableObject {
    //for audio
    var audioManager = AudioManager.shared
    
    // Published Variables
    @Published var restTimeActive: Bool = false
    @Published var currentFrame: UIImage?
    @Published var predicted: String = ""
    @Published var confidence: String = ""
    @Published var benarCount: Int = 0
    @Published var salahCount: Int = 0
    @Published var pulseIndicator: Int = 0
    @Published var indicator: Bool = false
    var recognizedPoints: [CGPoint] = []

    
    // Properties to track "Output" frames
    private var benarFrameCount: Int = 0
    private var salahFrameCount: Int = 0
    private var idleFrameCount: Int = 0
    

    
    private let frameRate = 30.0 // 30 fps
    private let windowSize: Int
    
    private var isPaused: Bool = false
    
    /// Captures the frames from the camera and creates a frame publisher.
    var videoCapture: VideoCapture!

    /// Builds a chain of Combine publishers from a frame publisher.
    var videoProcessingChain: VideoProcessingChain!
    
    /// Maintains the aggregate time for each action the model predicts.
    var actionFrameCounts = [String: Int]()
    
    func disableVideoCaptureSession() {
        videoCapture?.isEnabled = false
    }
    func enableVideoCaptureSession() {
        videoCapture?.isEnabled = true
    }

    
    // Initialize the window size
    init() {
        let bicepCurl = BicepCurl()
        self.windowSize = bicepCurl.calculatePredictionWindowSize()
        
        // Set the view controller as the video-processing chain's delegate.
        videoProcessingChain = VideoProcessingChain()
        videoProcessingChain.delegate = self

        // Begin receiving frames from the video capture.
        videoCapture = VideoCapture()
        videoCapture.delegate = self
    }
    
    // Other properties...
    
    func updateUILabels(with prediction: ActionPrediction) {
        DispatchQueue.main.async {
            if self.isPaused {
                return
            }

            self.predicted = prediction.label
                        
            if self.indicator==true{
                if prediction.label == "Benar" {
                    self.benarFrameCount += 1
                    self.salahFrameCount = 0
                    print("---Benar count: \(self.benarFrameCount)")
                    
                    if self.benarFrameCount >= 4 {
                        self.audioManager.playSoundEffect(named: "Correct")
                        self.pausePrediction()
                        self.benarCount += 1
                        self.pulseIndicator = 1
                    }
                } else if prediction.label == "Salah" {
                    self.salahFrameCount += 1
                    self.benarFrameCount = 0
                    print("Salah count: \(self.salahFrameCount)---")
                    
                    if self.salahFrameCount >= 3 {
                        self.audioManager.playSoundEffect(named: "Wrong")
                        self.pausePrediction()
                        self.salahCount += 1
                        self.pulseIndicator = 2
                    }
                }
                else if prediction.label == "Idle"  {
                    self.idleFrameCount += 1
                    self.benarFrameCount = 0
                    self.salahFrameCount = 0
                    self.pulseIndicator = 0
                    print("--IDLE--")
                }
            }
            else{
                if prediction.label == "Idle"{
                self.idleFrameCount += 1
                    if self.idleFrameCount >= 8 {
                        self.pausePrediction2()
                        self.indicator = true
                    }
                }
            }
        }

        let confidenceString = prediction.confidenceString ?? "Observing..."
        DispatchQueue.main.async { self.confidence = confidenceString }
    }

    func pausePrediction(for duration: TimeInterval) {
        print("pausePrediction for \(duration) seconds called")
        self.isPaused = true
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.isPaused = false
            self.benarFrameCount = 0
            self.salahFrameCount = 0
            print("\(duration) Detik Break --")
        }
    }
    func pausePrediction() {
        pausePrediction(for: 2)
    }

    func pausePrediction2() {
        pausePrediction(for: 5)
    }

    func pausePrediction3() {
        self.audioManager.playSoundEffect(named: "countdown2")
        print("Disable Video for 30 second")
        // Disable the video capture session
        disableVideoCaptureSession()
        
        // Schedule re-enabling of the video capture session after 30 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            self.enableVideoCaptureSession()
        }
    }

    
    func updateRecognizedPoints(with points: [CGPoint]) {
        self.recognizedPoints = points
        // Notify observers that recognized points have changed
        self.objectWillChange.send()
    }
}

extension PredictionViewModel: VideoCaptureDelegate {
    
    func videoCapture(_ videoCapture: VideoCapture, didCreate framePublisher: FramePublisher) {
        
        updateUILabels(with: .startingPrediction)
        
        // Build a new video-processing chain by assigning the new frame publisher.
        videoProcessingChain.upstreamFramePublisher = framePublisher
    }
 
}

extension PredictionViewModel: VideoProcessingChainDelegate {
    
    func videoProcessingChain(_ chain: VideoProcessingChain,
                              didPredict actionPrediction: ActionPrediction,
                              for frames: Int) {
        
        if actionPrediction.isModelLabel {
            // Update the total number of frames for this action.
            addFrameCount(frames, to: actionPrediction.label)
        }

        // Present the prediction in the UI.
        DispatchQueue.main.async { self.updateUILabels(with: actionPrediction) }
        
    }
    
    func videoProcessingChain(_ chain: VideoProcessingChain,
                              didDetect poses: [Pose]?,
                              in frame: CGImage) {
        self.drawPoses(poses, onto: frame)
    }
        
}

private extension PredictionViewModel {
    func addFrameCount(_ frameCount: Int, to actionLabel: String) {
        let totalFrames = (actionFrameCounts[actionLabel] ?? 0) + frameCount
        actionFrameCounts[actionLabel] = totalFrames
    }

    func drawPoses(_ poses: [Pose]?, onto frame: CGImage) {
        let renderFormat = UIGraphicsImageRendererFormat()
        renderFormat.scale = 1.0

        let frameSize = CGSize(width: frame.width, height: frame.height)
        let poseRenderer = UIGraphicsImageRenderer(size: frameSize, format: renderFormat)

        let frameWithPosesRendering = poseRenderer.image { rendererContext in
            let cgContext = rendererContext.cgContext
            let inverse = cgContext.ctm.inverted()
            cgContext.concatenate(inverse)

            let imageRectangle = CGRect(origin: .zero, size: frameSize)
            cgContext.draw(frame, in: imageRectangle)

//            let pointTransform = CGAffineTransform(scaleX: frameSize.width, y: frameSize.height)
//
//            guard let poses = poses else { return }
//
//            for pose in poses {
//                pose.drawWireframeToContext(cgContext, applying: pointTransform)
//            }
        }

        DispatchQueue.main.async { self.currentFrame = frameWithPosesRendering }
    }
}
