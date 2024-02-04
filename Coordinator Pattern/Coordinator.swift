//
//  Coordinator.swift
//  Coordinator Pattern
//
//  Created by Ady PC on 13/01/24.
//

import Combine
import SwiftUI

enum Page: Hashable, Codable {
  case page1
  case page2(Page2Param)
  case page3
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
  private lazy var decoder = JSONDecoder()
  private lazy var encoder = JSONEncoder()
  
  var data: Data? {
    get {
      try? self.path.codable.map(self.encoder.encode)
    }
    set {
      guard let data = newValue,
            let path = try? decoder.decode(
              NavigationPath.CodableRepresentation.self, from: data
            )
      else {
        return
      }
      self.path = NavigationPath(path)
    }
  }
  
  var objectWillChangeSequence: AsyncPublisher<Publishers.Buffer<ObservableObjectPublisher>> {
    objectWillChange
      .buffer(size: 1, prefetch: .byRequest, whenFull: .dropOldest)
      .values
  }
  
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
    if !self.path.isEmpty {
      self.path.removeLast()
    }
  }
  
  func popToRoot() {
    if !self.path.isEmpty {
      self.path.removeLast(self.path.count)
    }
  }
  
  func dismissSheet() {
    self.sheet = nil
  }
  
  func dismissFullScreenCover() {
    self.fullscreenCover = nil
  }
  
  @ViewBuilder
  func build(page: Page = Page.page1) -> some View {
    switch page {
    case .page1:
      Page1View()
    case .page2(let param):
      Page2View(param: param)
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

// class Coordinator: ObservableObject {
//  @Published var path: [Page]
//  @Published var sheet: Sheet?
//  @Published var fullscreenCover: FullscreenCover?
//  private lazy var decoder = JSONDecoder()
//  private lazy var encoder = JSONEncoder()
//
//    init(path: [Page] = []) {
//      self.path = path
//    }
//
//    var data: Data? {
//      get {
//        try? JSONEncoder().encode(path)
//      }
//      set {
//        guard let data = newValue,
//              let path = try? JSONDecoder().decode([Page].self, from: data)
//        else {
//          return
//        }
//        self.path = path
//      }
//    }
//
//  func popToRoot() {
//    path = []
//  }
// }
