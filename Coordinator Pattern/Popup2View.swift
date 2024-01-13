//
//  Popup2View.swift
//  Coordinator Pattern
//
//  Created by Ady PC on 13/01/24.
//

import SwiftUI

struct Popup2View: View {
  @EnvironmentObject private var coordinator: Coordinator
  var body: some View {
    List {
      Button("Dismiss"){
        coordinator.dismissFullScreenCover()
      }
    }
    .navigationTitle("Popup 2 Title")
  }
}

struct Popup2View_Previews: PreviewProvider {
    static var previews: some View {
        Popup2View()
    }
}
