//
//  VideoPlayerView.swift
//  CachingPlayerSample
//
//  Created by MSP on 21.11.2022.
//

import SwiftUI
import UIKit
import AVKit

struct VideoPlayerView: UIViewRepresentable {
  class PlayerView: UIView {
    override static var layerClass: AnyClass {
      AVPlayerLayer.self
    }

    var player: AVPlayer? {
      get { playerLayer.player }
      set { playerLayer.player = newValue }
    }

    private var playerLayer: AVPlayerLayer {
      let layer = self.layer as! AVPlayerLayer
      layer.videoGravity = .resizeAspectFill
      return layer
    }
  }

  let player: AVPlayer?

  func makeUIView(context: Context) -> PlayerView {
    let view = PlayerView()
    view.player = player
    return view
  }

  func updateUIView(_ uiView: PlayerView, context: Context) {
    uiView.player = player
  }
}

