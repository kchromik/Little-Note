//
//  ContentView.swift
//  Little Note iOS
//
//  Created by Kevin Chromik on 08.08.24.
//

import LittleBase
import SwiftData
import SwiftUI

struct NotesScreen: View {

    @State private var viewModel: ContentViewModel

    init(modelContext: ModelContext) {
        let viewModel = ContentViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(Filter.allCases, id: \.self) { filter in
                                FilterView(
                                    filter: filter,
                                    isActive: viewModel.currentFilter == filter
                                )
                                .onTapGesture {
                                    withAnimation {
                                        viewModel.currentFilter = filter
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    Spacer()

                    Button {
                        viewModel.showingSettings.toggle()
                    } label: {
                        Image(systemName: "gear")
                            .tint(.white)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .fill(Color.black)
                            )
                    }
                    .padding(.trailing, 20)
                }

                Spacer()

                if viewModel.filteredNotes.isEmpty {
                    EmptyListView(activeFilter: viewModel.currentFilter)
                } else {
                    List {
                        ForEach(viewModel.filteredNotes) { note in
                            Button {
                                viewModel.isEditing = true
                                viewModel.currentNote = note
                                withAnimation {
                                    viewModel.showingDetails.toggle()
                                }
                            } label: {
                                Cell(note: note)
                            }
                            .buttonStyle(ScalableButtonStyle())
                            .listRowSeparator(.hidden)
                            .listRowInsets(.init(top: 8, leading: 8, bottom: 12, trailing: 8))
                        }
                        .onDelete(perform: viewModel.deleteNote)

                    }
                    .listStyle(.plain)
                    .listRowSpacing(0)
                    .animation(.default, value: viewModel.filteredNotes)
                }
            }

            VStack {
                Spacer()
                FloatingButtons(showingDetails: $viewModel.showingDetails)
            }
            .padding(.bottom, 12)
        }
        .sheet(isPresented: $viewModel.showingDetails, onDismiss: viewModel.saveCurrentNoteIfNotEmpty) {
            if let note = viewModel.currentNote {
                DetailView(note: note)
                    .presentationDetents([.medium, .large])
                    .presentationCornerRadius(32)
                    .presentationDragIndicator(.visible)
            }
        }
        .fullScreenCover(isPresented: $viewModel.showingSettings) {
            SettingsView()
        }
        .onChange(of: viewModel.showingDetails) { oldValue, newValue in
            if newValue && !viewModel.isEditing {
                viewModel.currentNote = Note()
            }
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return NotesScreen(modelContext: previewer.container.mainContext)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

extension [Note] {

    func filteredNotes(for filter: Filter) -> [Note] {
        switch filter {
        case .all:
            return self
        case .favorite:
            return self.filter { $0.isFavourite }
        @unknown default:
            fatalError()
        }
    }
}
