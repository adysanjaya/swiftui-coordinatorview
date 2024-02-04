# Swiftui Coordinator View
Cara terbaik untuk manajemen halaman / navigasi di SwiftUI

Project terdiri dari 3 Halaman & 2 jenis tampilan popup

Page1View.swift
```swiftui
import SwiftUI

struct Page1View: View {
  @EnvironmentObject private var coordinator: Coordinator
    var body: some View {
      List {
        Button("Pindah ke Halaman 2"){
          coordinator.push(.page2)
        }
        Button("Tampilkan Popup 1"){
          coordinator.present(sheet: .popup1)
        }
        Button("Tampilkan Popup 2"){
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
```

Page2Param.swift
```swiftui
import SwiftUI

struct Page2Param: Hashable, Codable {
  var menuTitle: String
}
```

Page2View.swift
```swiftui
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
```

Page3View.swift
```swiftui
import SwiftUI

struct Page3View: View {
  @EnvironmentObject private var coordinator: Coordinator
  @Environment(\.presentationMode) var presentationMode
  var body: some View {
    List {
      Button("Kembali"){
        presentationMode.wrappedValue.dismiss()
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
```

Popup1View.swift
```swiftui
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
```

Popup2View.swift
```swiftui
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

```

Coordinator.swift
```swiftui
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
```

CoordinatorView.swift
```swiftui
import SwiftUI

struct CoordinatorView: View {
  @StateObject private var coordinator = Coordinator()
  @SceneStorage("navigationState") var navigationStateData: Data?
  var body: some View {
    NavigationStack(path: $coordinator.path) {
      coordinator.build()
        .navigationDestination(for: Page.self) { page in
          coordinator.build(page: page)
        }
        .sheet(item: $coordinator.sheet) { sheet in
          coordinator.build(sheet: sheet)
        }
        .fullScreenCover(item: $coordinator.fullscreenCover) { fullScreenCover in
          coordinator.build(fullScreenCover: fullScreenCover)
        }
        .onReceive(coordinator.objectWillChange.dropFirst()) { a in
          navigationStateData = coordinator.data
        }
        .onAppear {
          coordinator.data = navigationStateData
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
```

Coordinator_PatternApp.swift
```swiftui
import SwiftUI

@main
struct Coordinator_PatternApp: App {
    var body: some Scene {
        WindowGroup {
            CoordinatorView()
        }
    }
}
```
## Demo
![](https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExd21nbTZreDl0ajN1ZnVoY2dmeWs5dHJjMWM5NDF5MWE5ZDc0c2M4aCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/M1HGHYBszajas3panE/giphy.gif)

<h1 align="center">I'm Ady Sanjaya</h1>
<h3 align="center">Hello Everyone / 大家好 👋</h3>
- 🌱 I’m currently learning **Swift UI, KMP & Flutter**

<h3 align="left">Connect with me:</h3>
<p align="left">
<a href="https://linkedin.com/in/adysanjaya" target="blank"><img align="center" src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/linked-in-alt.svg" alt="adysanjaya" height="30" width="40" /></a>
<a href="https://medium.com/@adysanjaya" target="blank"><img align="center" src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/medium.svg" alt="@adysanjaya" height="30" width="40" /></a>
<a href="https://www.hackerrank.com/adysanjaya013" target="blank"><img align="center" src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/hackerrank.svg" alt="adysanjaya013" height="30" width="40" /></a>
</p>

<h3 align="left">Languages and Tools:</h3>
<p align="left"> <a href="https://flutter.dev" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/flutterio/flutterio-icon.svg" alt="flutter" width="40" height="40"/> </a> <a href="https://kafka.apache.org/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/apache_kafka/apache_kafka-icon.svg" alt="kafka" width="40" height="40"/> </a> <a href="https://kotlinlang.org" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/kotlinlang/kotlinlang-icon.svg" alt="kotlin" width="40" height="40"/> </a> <a href="https://laravel.com/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/laravel/laravel-plain-wordmark.svg" alt="laravel" width="40" height="40"/> </a> <a href="https://www.mongodb.com/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/mongodb/mongodb-original-wordmark.svg" alt="mongodb" width="40" height="40"/> </a> <a href="https://www.mysql.com/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/mysql/mysql-original-wordmark.svg" alt="mysql" width="40" height="40"/> </a> <a href="https://nestjs.com/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/nestjs/nestjs-plain.svg" alt="nestjs" width="40" height="40"/> </a> <a href="https://www.nginx.com" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/nginx/nginx-original.svg" alt="nginx" width="40" height="40"/> </a> <a href="https://reactjs.org/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/react/react-original-wordmark.svg" alt="react" width="40" height="40"/> </a> <a href="https://realm.io/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/bestofjs/bestofjs-webui/8665e8c267a0215f3159df28b33c365198101df5/public/logos/realm.svg" alt="realm" width="40" height="40"/> </a> <a href="https://redis.io" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/redis/redis-original-wordmark.svg" alt="redis" width="40" height="40"/> </a> <a href="https://spring.io/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/springio/springio-icon.svg" alt="spring" width="40" height="40"/> </a> <a href="https://www.sqlite.org/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/sqlite/sqlite-icon.svg" alt="sqlite" width="40" height="40"/> </a> <a href="https://developer.apple.com/swift/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/swift/swift-original.svg" alt="swift" width="40" height="40"/> </a> <a href="https://vuejs.org/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/vuejs/vuejs-original-wordmark.svg" alt="vuejs" width="40" height="40"/> </a> </p>

<h3 align="left">Support:</h3>
<p><a href="https://www.buymeacoffee.com/adysanjaya013"> <img align="left" src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" height="50" width="210" alt="adysanjaya013" /></a><a href="https://ko-fi.com/adysanjaya"> <img align="left" src="https://cdn.ko-fi.com/cdn/kofi3.png?v=3" height="50" width="210" alt="adysanjaya" /></a></p><br><br>

<p><img align="center" src="https://github-readme-stats.vercel.app/api/top-langs?username=adysanjaya&show_icons=true&locale=en&layout=compact" alt="adysanjaya" /></p>
