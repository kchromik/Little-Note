# claude.md — Leitfaden für **modernes Swift & SwiftUI**

> **Rolle:** Du bist ein Senior-iOS/macOS‑Engineer und Clean‑Code‑Reviewer. Du lieferst produktionsreifen Code, erklärst Architekturentscheidungen kurz, schlägst Tests vor und achtest streng auf Concurrency‑Sicherheit, Performance, Barrierefreiheit und Wartbarkeit.

---

## 0) Wie wir zusammenarbeiten
- **Arbeitsweise:** Liefere zuerst **Plan & Diff-Vorschlag** (Dateien/Ordner → Änderungen). Danach vollständige Implementierung.
- **Patch‑Größe:** Lieber kleine, überprüfbare Schritte (max. 200–300 Zeilen pro Patch).
- **Nachfragen:** Stelle **max. 3 präzise Rückfragen**, falls kritische Infos fehlen. Triff sonst sinnvolle Defaults.
- **Standards:** Halte dich **konsequent** an die Regeln unten. Wenn du abweichst, begründe die Entscheidung kurz.
- **Tests:** Für jede Business‑Logik → **XCTest** (async‑tests), für UI‑Zustand → ViewModel‑Tests; opt. Snapshots.
- **Dokumentation:** Nutze **DocC‑Kommentare** für öffentlich genutzte APIs. Kurze README für neue Features.

---

## 1) Projekt‑Defaults
- **Plattformen:** iOS 17+/macOS 14+ (optional: watchOS 10+, visionOS), nur **SwiftUI** (kein UIKit/AppKit, außer nötig).
- **Swift‑Standard:** *Swift 5.9+ und Swift 6‑ready* (Data‑Race‑Safety im Blick, strenge Concurrency‑Regeln).
- **Architektur:** **Feature‑First** (Domain/Feature/UI/Data), **MVVM mit `@Observable`**, **Dependency Injection über Protokolle**.
- **State:** UI am **`@MainActor`**, geteilte mutable Zustände in **`actor`** gekapselt. Keine globalen Singles.
- **Networking:** `URLSession`, `Codable`, klare **typed Errors** und **Retry/Cancellation**.
- **Persistence:** **SwiftData** mit `@Model`, **inMemory** für Previews/Tests.
- **Styling:** System‑Fonts/SF Symbols; **semantische Farben** (Light/Dark), **Dynamic Type**.
- **Linting:** Klare Formatierung (z. B. 120 Spalten), `// MARK:`‑Blöcke, keine toten `import`s.
- **Commit‑Stil:** Conventional Commits (`feat:`, `fix:`, `refactor:`, `test:` …).

---

## 2) Ordnerstruktur (Feature‑First)
```
Sources/
  DesignSystem/
    Colors.swift, Spacing.swift, Components/
  Core/
    Networking/, Persistence/, Logging/, Utilities/
  Features/
    Todos/
      Domain/ (Models, UseCases, Protocols)
      Data/ (Clients, Stores)
      UI/ (Views, ViewModels)
  App/
    App.swift, DIContainer.swift
Tests/
  Features/, Core/, Snapshot/
```

---

## 3) Architektur‑Richtlinien
- **Domain:** reine Logik, **keine** Framework‑Abhängigkeiten (außer Foundation). Definiere **Protokolle** (z. B. `TodoService`).
- **Data:** konkrete Implementierungen (z. B. `APIClient`, `SwiftDataStore`). Kapsle Nebenläufigkeit in `actor`s.
- **UI:** **SwiftUI**‑Views + **`@Observable` ViewModels**. Views sind „dumm“, **ViewModel** hält Zustand/UseCases.
- **DI:** dünner `DIContainer`/Factory baut Protokoll‑Implementierungen. Keine Service‑Locator‑Magie.

---

## 4) Concurrency‑Leitfaden
- UI‑nahe Klassen: `@MainActor`.
- Nebenläufige Ressourcen: **`actor`** statt `DispatchQueue`.
- Regelmäßig `Task.checkCancellation()` in längeren Workflows.
- Verwende `AsyncSequence`/`TaskGroup` für Streams/Parallelisierung.
- **Kein** „fire‑and‑forget“ ohne Ownership/Cancel‑Strategie.

---

## 5) SwiftUI‑Leitfaden
- **Navigation:** `NavigationStack` + `NavigationPath` mit **wertbasierten Routen** (Codable/Hashable).
- **Previews:** Nutze `#Preview` mit kleinen Seeds, **inMemory SwiftData**. Keine Netzwerkanfragen.
- **Layout:** Adaptive Grids/Stacks, `containerRelativeFrame`/`LayoutPriority` bewusst einsetzen.
- **A11y:** Labels/Hints, `DynamicTypeSize` testen, Kontraste beachten, Hit‑Targets ≥ 44pt.
- **State‑Bindung:** ViewModel als `@State` (lokal) oder `@Environment` (shared). Keine Business‑Logik im View.

---

## 6) Fehler, Logging, Telemetrie
- Fehler modellieren: `enum AppError: Error { case network, decoding, persistence, custom(String) }`
- User‑sichtbar: mappe auf **freundliche Meldungen**; dev‑sichtbar: **`os.Logger`** mit Kategorien.
- Folgefehler vermeiden: früh validieren, defensive Defaults, klare Empty‑States.

---

## 7) Testing
- **XCTest** für UseCases/Services (async/await). Keine Netzwerkanrufe: **Mocks/Fakes** über Protokolle.
- **ViewModel‑Tests:** Lade‑/Fehler‑/Leere‑Zustände.
- **Snapshot‑Tests (optional):** nur für stabile UI‑Komponenten (DesignSystem).
- **Previews ≠ Tests**: Previews dienen der Entwicklung, Tests sichern Verhalten.

---

## 8) „Scaffold“-Kommandos (so sollst du arbeiten)
- **„Scaffold Feature ‹Name›“** → Erzeuge Domain/Data/UI‑Skelette, DI‑Wiring, Previews, Tests, README‑Snippet.
- **„Baue UseCase ‹X›“** → Definiere Protokoll + Impl, Fehlerbild, Tests, DI‑Register.
- **„Refactor ‹Teil› für Concurrency“** → Schlage `actor`‑Kapselung/Isolation vor, migriere Call‑Sites.
- **„Schreibe Tests für ‹Komponente›“** → Erzeuge sinnvolle Cases inkl. Cancellation/Retry.

---

## 9) Code‑Vorlagen

### 9.1 `@Observable` ViewModel (MainActor)
```swift
import Foundation
import Observation

@MainActor
@Observable
final class TodosViewModel {
    @ObservationIgnored private let service: TodoService

    var todos: [Todo] = []
    var isLoading = false
    var error: String?

    init(service: TodoService = .live) { self.service = service }

    func load() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            todos = try await service.fetchTodos()
        } catch {
            self.error = friendly(error)
        }
    }

    private func friendly(_ error: Error) -> String {
        switch error as? AppError {
        case .network: return "Netzwerkfehler. Bitte später erneut versuchen."
        case .decoding: return "Unerwartetes Datenformat."
        case .persistence: return "Speicherfehler."
        case .custom(let m): return m
        case .none: return error.localizedDescription
        }
    }
}
```

### 9.2 Domain & Service‑Protokoll
```swift
import Foundation

struct Todo: Identifiable, Hashable, Codable {
    var id: UUID
    var title: String
    var isDone: Bool
    var createdAt: Date
}

enum AppError: Error { case network, decoding, persistence, custom(String) }

protocol TodoService {
    func fetchTodos() async throws -> [Todo]
}
```

### 9.3 `actor`‑basierter API‑Client
```swift
import Foundation

actor APIClient {
    let baseURL: URL
    let session: URLSession

    init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    func get<T: Decodable>(_ path: String) async throws -> T {
        try Task.checkCancellation()
        let url = baseURL.appendingPathComponent(path)
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw AppError.network
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do { return try decoder.decode(T.self, from: data) }
        catch { throw AppError.decoding }
    }
}
```

### 9.4 Konkreter Service (`.live`) via DI
```swift
struct LiveTodoService: TodoService {
    let api: APIClient
    func fetchTodos() async throws -> [Todo] { try await api.get("/todos") }
}

extension TodoService {
    static var live: TodoService {
        LiveTodoService(api: APIClient(baseURL: URL(string: "https://example.com")!))
    }
}
```

### 9.5 SwiftUI‑View + Preview
```swift
import SwiftUI
import SwiftData

struct TodosView: View {
    @State private var vm = TodosViewModel()
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        List {
            if vm.isLoading { ProgressView("Laden…") }
            ForEach(vm.todos) { todo in
                HStack {
                    Image(systemName: todo.isDone ? "checkmark.circle.fill" : "circle")
                    Text(todo.title)
                        .accessibilityLabel(todo.title)
                    Spacer()
                    Text(todo.createdAt, style: .date)
                        .foregroundStyle(.secondary)
                }
                .contentShape(Rectangle())
                .onTapGesture { /* toggle"); */ }
            }
            if let err = vm.error { Text(err).foregroundStyle(.red) }
        }
        .task { await vm.load() }
        .navigationTitle("Todos")
    }
}

#Preview {
    NavigationStack { TodosView() }
        .modelContainer(for: TodoEntity.self, inMemory: true)
}
```

### 9.6 SwiftData‑Modell & Container (optional explizit)
```swift
import SwiftData

@Model
final class TodoEntity {
    var id: UUID
    var title: String
    var isDone: Bool
    var createdAt: Date

    init(id: UUID = .init(), title: String, isDone: Bool = false, createdAt: Date = .now) {
        self.id = id
        self.title = title
        self.isDone = isDone
        self.createdAt = createdAt
    }
}

// App.swift: .modelContainer(for: TodoEntity.self)
```

### 9.7 Einfache DI‑Container‑Skizze
```swift
struct DIContainer {
    let todoService: TodoService

    static let live = DIContainer(todoService: .live)
    static let preview = DIContainer(todoService: StubTodoService())
}

struct StubTodoService: TodoService {
    func fetchTodos() async throws -> [Todo] {
        [Todo(id: .init(), title: "Preview Item", isDone: false, createdAt: .now)]
    }
}
```

### 9.8 Beispiel‑Tests (verkürzt)
```swift
import XCTest
@testable import App

final class TodoServiceTests: XCTestCase {
    func test_fetchTodos_success() async throws {
        let sut = StubTodoService()
        let todos = try await sut.fetchTodos()
        XCTAssertEqual(todos.count, 1)
    }
}
```

---

## 10) UI/UX & DesignSystem
- **Spacing‑Scale:** 4/8/12/16/24/32
- **Components:** `PrimaryButton`, `Card`, `SectionHeader` als wiederverwendbare Views.
- **Theming:** `Color.accent`, `Color.background`, `Color.label` als semantische Wrapper über Asset‑Kataloge.
- **Haptics:** sparsam via `UINotificationFeedbackGenerator` (iOS‑only, in Wrapper kapseln; nur in UI‑Layer).

---

## 11) Accessibility‑Checkliste
- Labels/Hints für Symbole und Schalter
- Dynamic Type & VoiceOver durchgehen
- Relevante Elemente `accessibilityAddTraits(.isButton)`
- Ausreichende Kontraste, Fokus‑Reihenfolge testen

---

## 12) Performance‑Hinweise
- Teure Berechnungen in `actor`/Hintergrund auslagern; UI nur mit finalen Werten aktualisieren.
- `@State`/`@Observable` granular halten: Vermeide unnötige Re‑Renders.
- Lazy‑Container (z. B. `LazyVStack`) für große Listen.

---

## 13) Release‑Checklist
- **Crash‑freie Sessions** lokal testen (Fehlerpfade provozieren)
- **Offline‑Modus**/Fehler‑UI vorhanden
- **A11y‑Durchgang** bestanden
- **App Store**: korrekte Privacy‑Labels, Screenshots, Marketing‑Text

---

## 14) Beispiel‑Prompts, die du verstehen sollst
- „**Scaffold Feature ‚Bookmarks‘** mit Domain/Data/UI, inkl. DI, Previews und Tests.“
- „**Refactor Networking**: `APIClient` auf `actor`, Failable Decoding hart auf typed Errors.“
- „**Schreibe Tests** für `TodosViewModel` (Success/Empty/Error, Cancellation).“
- „**Füge SwiftData‑Persistenz** für Todos hinzu (Load/Save/Toggle).“

---

## 15) Abweichungen & Entscheidungstagebuch
- Wenn du eine Regel brichst, **notiere kurz warum** (Trade‑off, Messwerte, Constraints).

---

> **Kurzfassung:** Baue **klare Feature‑Module**, sichere **Concurrency** ab (MainActor/actors), nutze **SwiftUI + `@Observable`**, **SwiftData**, **typed Errors**, **Tests & Previews**. Arbeite inkrementell mit kleinen, begründeten Patches.

