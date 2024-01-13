//
//  PopUp1View.swift
//  Coordinator Pattern
//
//  Created by Ady PC on 13/01/24.
//

import SwiftUI

struct Popup1View: View {
  @EnvironmentObject private var coordinator: Coordinator
    var body: some View {
      List {
        Button("Dismiss"){
          coordinator.dismissSheet()
        }
      }
      .navigationTitle("Popup 1 Title")
    }
}

struct Popup1View_Previews: PreviewProvider {
    static var previews: some View {
        Popup1View()
    }
}
