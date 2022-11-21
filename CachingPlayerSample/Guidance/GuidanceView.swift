//
//  GuidanceView.swift
//  CachingPlayerSample
//
//  Created by MSP on 21.11.2022.
//

import SwiftUI

struct GuidanceView: View {
  @ObservedObject
  var viewModel: GuidanceViewModel

  var body: some View {
    VStack {
      Spacer()

      VideoPlayerView(player: viewModel.player)
        .frame(width: 300, height: 300)

      Spacer()

      HStack {
        Button("prev", action: viewModel.prev)
        Button("next", action: viewModel.next)
      }

      Spacer()
    }
  }
}
