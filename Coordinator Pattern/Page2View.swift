//
//  Page2View.swift
//  Coordinator Pattern
//
//  Created by Ady PC on 13/01/24.
//

import SwiftUI

struct Page2View: View {
  @EnvironmentObject private var coordinator: Coordinator
  @Environment(\.presentationMode) var presentationMode
  var param: Page2Param
  
  var body: some View {
    List {
      Button("Pindah ke Halaman 3"){
        coordinator.push(.page3)
      }
      Button("Kembali"){
        presentationMode.wrappedValue.dismiss()
      }
    }
    .navigationTitle(param.menuTitle)
  }
}

struct Page2View_Previews: PreviewProvider {
    static var previews: some View {
      Page2View(param: Page2Param(menuTitle: "Page2View"))
    }
}
