//
//  CoordinatorView.swift
//  Coordinator Pattern
//
//  Created by Ady PC on 13/01/24.
//

import SwiftUI

struct CoordinatorView: View {
  @StateObject private var coordinator = Coordinator()
  @SceneStorage("navigationState") var navigationStateData: Data?
  var body: some View {
    NavigationStack(path: $coordinator.path) {
      coordinator.build()
        .navigationDestination(for: Page.self) { page in
          coordinator.build(page: page)
        }
        .sheet(item: $coordinator.sheet) { sheet in
          coordinator.build(sheet: sheet)
        }
        .fullScreenCover(item: $coordinator.fullscreenCover) { fullScreenCover in
          coordinator.build(fullScreenCover: fullScreenCover)
        }
        .onReceive(coordinator.objectWillChange.dropFirst()) { a in
          navigationStateData = coordinator.data
        }
        .onAppear {
          coordinator.data = navigationStateData
        }
    }
    .environmentObject(coordinator)
  }
}

struct CoordinatorView_Previews: PreviewProvider {
  static var previews: some View {
    CoordinatorView()
  }
}
