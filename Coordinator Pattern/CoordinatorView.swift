//
//  CoordinatorView.swift
//  Coordinator Pattern
//
//  Created by Ady PC on 13/01/24.
//

import SwiftUI

struct CoordinatorView: View {
  @StateObject private var coordinator = Coordinator()
  var body: some View {
    NavigationStack(path: $coordinator.path) {
      coordinator.build(page: .page1)
        .navigationDestination(for: Page.self) { page in
          coordinator.build(page: page)
        }
        .sheet(item: $coordinator.sheet) { sheet in
          coordinator.build(sheet: sheet)
        }
        .fullScreenCover(item: $coordinator.fullscreenCover) { fullScreenCover in
          coordinator.build(fullScreenCover: fullScreenCover)
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
