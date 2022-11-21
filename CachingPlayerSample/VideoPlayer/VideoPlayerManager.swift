//
//  VideoPlayerManager.swift
//  CachingPlayerSample
//
//  Created by MSP on 21.11.2022.
//

import Combine
import AVKit

struct VideoConfig {
  var player: AVPlayer
  var looper: AVPlayerLooper
  var size: CGSize?
}

final class VideoPlayerManager: ObservableObject {
  enum Destination: Equatable {
    case exercise(url: String?)
    case nextExercise(url: String?)
  }

  @Published var exerciseVideoConfig: VideoConfig?
  @Published var nextExerciseVideoConfig: VideoConfig?

  @Published var exerciseUrl: String?
  @Published var nextExerciseUrl: String?

  private var cancellables = Set<AnyCancellable>()

  init() {
    $exerciseUrl.sink { [weak self] url in
      guard let self = self else { return }

      Task {
        self.exerciseVideoConfig = await makeVideoConfig(urlString: url)
        await self.exerciseVideoConfig?.player.play()
      }
    }.store(in: &cancellables)

    $nextExerciseUrl.sink { [weak self] url in
      guard let self = self else { return }

      Task {
        self.nextExerciseVideoConfig = await makeVideoConfig(urlString: url)
        await self.nextExerciseVideoConfig?.player.play()
      }
    }.store(in: &cancellables)
  }

  func play(to destination: Destination?) {
    guard let destination = destination else {
      exerciseVideoConfig = nil
      nextExerciseVideoConfig = nil
      return
    }

    switch destination {
    case let .exercise(url):
      exerciseUrl = url
      nextExerciseUrl = nil

    case let .nextExercise(url):
      exerciseUrl = nil
      nextExerciseUrl = url
    }
  }
}

private func makeVideoConfig(urlString: String?) async -> VideoConfig? {
  guard let url = urlString.flatMap(URL.init) else {
    return nil
  }

  let player = AVQueuePlayer()
  let asset = AVAsset(url: url)

  let looper = AVPlayerLooper(
    player: player,
    templateItem: AVPlayerItem(asset: asset)
  )

  return VideoConfig(
    player: player,
    looper: looper,
    size: await asset.calculateVideoSize()
  )
}

extension AVAsset {
  func calculateVideoSize() async -> CGSize? {
    tracks(withMediaType: .video).first.map { track in
      track.naturalSize.applying(track.preferredTransform)
    }
  }
}

