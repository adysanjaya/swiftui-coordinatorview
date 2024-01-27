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
  private var parameters: [Page:Any] = [:]
  
  func push<T>(_ page: Page, params: T) {
    self.parameters[page] = params
    self.path.append(page)
  }
  
  func push(_ page: Page) {
    self.parameters[page] = nil
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
      if let page2Param = self.parameters[page] as? Page2Param {
        Page2View(title: page2Param.menuTitle)
      }
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
