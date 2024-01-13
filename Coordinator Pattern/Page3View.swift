//
//  Page3View.swift
//  Coordinator Pattern
//
//  Created by Ady PC on 13/01/24.
//

import SwiftUI

struct Page3View: View {
  @EnvironmentObject private var coordinator: Coordinator
  var body: some View {
    List {
      Button("Kembali"){
        coordinator.pop()
      }
      Button("Kembali ke Paling Awal"){
        coordinator.popToRoot()
      }
    }
    .navigationTitle("Page 3 Title")
  }
}

struct Page3View_Previews: PreviewProvider {
    static var previews: some View {
        Page3View()
    }
}
