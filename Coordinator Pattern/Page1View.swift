//
//  Page1View.swift
//  Coordinator Pattern
//
//  Created by Ady PC on 13/01/24.
//

import SwiftUI

struct Page1View: View {
  @EnvironmentObject private var coordinator: Coordinator

  var body: some View {
    List {
      Button("Pindah ke Halaman 2") {
        coordinator.push(.page2(Page2Param(menuTitle: "From Page 1")))
      }
      Button("Tampilkan Popup 1") {
        coordinator.present(sheet: .popup1)
      }
      Button("Tampilkan Popup 2") {
        coordinator.present(fullScreenCover: .popup2)
      }
    }
    .navigationTitle("Page 1 Title")
  }
}

struct Page1View_Previews: PreviewProvider {
  static var previews: some View {
    Page1View()
  }
}
