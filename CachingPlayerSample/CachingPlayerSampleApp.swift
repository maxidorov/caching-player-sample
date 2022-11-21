//
//  CachingPlayerSampleApp.swift
//  CachingPlayerSample
//
//  Created by MSP on 21.11.2022.
//

import SwiftUI

@main
struct CachingPlayerSampleApp: App {
  var body: some Scene {
    WindowGroup {
      GuidanceView(viewModel: viewModel)
    }
  }
}

private let viewModel = GuidanceViewModel(
  model: GuidanceModel(),
  videoPlayerManager: VideoPlayerManager()
)
