//
//  GuidanceViewModel.swift
//  CachingPlayerSample
//
//  Created by MSP on 21.11.2022.
//

import Foundation
import Combine
import AVKit

final class GuidanceViewModel: ObservableObject {
  @Published var player: AVPlayer?
  @Published private var videoUrl: String?
  private var index: Int?
  private let range: Range<Int>?
  private let model: GuidanceModel
  private let videoPlayerManager: VideoPlayerManager
  private var cancellables = Set<AnyCancellable>()

  init(
    model: GuidanceModel,
    videoPlayerManager: VideoPlayerManager
  ) {
    self.index = nil
    self.range = model.videoUrls.isEmpty ? nil : (0..<model.videoUrls.count)
    self.model = model
    self.videoPlayerManager = videoPlayerManager

    $videoUrl.sink {
      videoPlayerManager.exerciseUrl = $0
    }.store(in: &cancellables)

    videoPlayerManager.$exerciseVideoConfig.sink { [weak self] config in
      DispatchQueue.main.async {
        self?.player = config?.player
      }
    }.store(in: &cancellables)
  }

  func next() {
    changeIndex(by: +1)
  }

  func prev() {
    changeIndex(by: -1)
  }

  private func changeIndex(by value: Int) {
    guard let range = range else { return }
    let newIndex = index.map { $0 + value } ?? 0

    guard range.contains(newIndex) else {
      index = nil
      videoUrl = nil
      return
    }

    index = newIndex
    videoUrl = model.videoUrls[newIndex]
  }
}
