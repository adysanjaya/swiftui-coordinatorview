//
//  Page2View.swift
//  Coordinator Pattern
//
//  Created by Ady PC on 13/01/24.
//

import SwiftUI

struct Page2View: View {
  @EnvironmentObject private var coordinator: Coordinator
  @State var title: String
  
  init(title: String) {
    self.title = title
  }
  
  var body: some View {
    List {
      Button("Pindah ke Halaman 3"){
        coordinator.push(.page3)
      }
      Button("Kembali"){
        coordinator.pop()
      }
    }
    .navigationTitle(title)
    .navigationBarBackButtonHidden(true)
  }
}

struct Page2View_Previews: PreviewProvider {
    static var previews: some View {
      Page2View(title: "Page2View")
    }
}
