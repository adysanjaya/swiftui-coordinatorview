//
//  Coordinator.swift
//  Coordinator Pattern
//
//  Created by Ady PC on 13/01/24.
//

import SwiftUI

enum Page: String, Identifiable {
  case page1, page2, page3
  
  var id: String {
    self.rawValue
  }
}

enum Sheet: String, Identifiable {
  case popup1
  
  var id: String {
    self.rawValue
  }
}

enum FullscreenCover: String, Identifiable {
  case popup2
  
  var id: String {
    self.rawValue
  }
}

class Coordinator: ObservableObject {
  @Published var path = NavigationPath()
  @Published var sheet: Sheet?
  @Published var fullscreenCover: FullscreenCover?
  
  func push(_ page: Page) {
    self.path.append(page)
  }
  
  func present(sheet: Sheet) {
    self.sheet = sheet
  }
  
  func present(fullScreenCover: FullscreenCover) {
    self.fullscreenCover = fullScreenCover
  }
  
  func pop() {
    self.path.removeLast()
  }
  
  func popToRoot() {
    self.path.removeLast(self.path.count)
  }
  
  func dismissSheet() {
    self.sheet = nil
  }
  
  func dismissFullScreenCover() {
    self.fullscreenCover = nil
  }
  
  @ViewBuilder
  func build(page: Page) -> some View {
    switch page {
    case .page1:
      Page1View()
    case .page2:
      Page2View()
    case .page3:
      Page3View()
    }
  }
  
  @ViewBuilder
  func build(sheet: Sheet) -> some View {
    switch sheet {
    case .popup1:
      NavigationStack {
        Popup1View()
      }
    }
  }
    
  @ViewBuilder
  func build(fullScreenCover: FullscreenCover) -> some View {
    switch fullScreenCover {
    case .popup2:
      NavigationStack {
        Popup2View()
      }
    }
  }
}
