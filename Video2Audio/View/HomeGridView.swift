//
//  HomeGridView.swift
//  Video2Audio
//
//  Created by xxy-mm on 2024/10/29.
//

import SwiftData
import SwiftUI

enum GridLink: String, Identifiable, CaseIterable {
    case favorites, playlists, audios, tasks

    var id: String {
        rawValue
    }
}

struct HomeGridView: View {
    @Query private var audioItems: [AudioItem]
    @Query private var playlists: [Playlist]
    @Query private var tasks: [ConvertionTask]

    @State private var selectedItem: GridLink? = .audios

    private var favorites: [AudioItem] {
        audioItems.filter { $0.isFavorite ?? false }
    }

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        NavigationSplitView {
            ZStack {
                AppBackground()
                VStack(alignment: .leading) {
                    LazyVGrid(columns: columns, spacing: 10) {
                        NavigationLink(value: GridLink.favorites) {
                            GridItemView(icon: "heart", title: "Favorites", subtitle: "\(favorites.count) audios")
                        }

                        NavigationLink(value: GridLink.playlists) {
                            GridItemView(icon: "music.note.list", title: "Playlists", subtitle: "\(playlists.count) playlists")
                        }

                        NavigationLink(value: GridLink.audios) {
                            GridItemView(icon: "arrow.down.circle", title: "All Audios", subtitle: "\(audioItems.count) audios")
                        }

                        NavigationLink(value: GridLink.tasks) {
                            GridItemView(icon: "plus.circle", title: "Tasks", subtitle: "\(tasks.count) tasks")
                        }
                    }
                    .padding()
                    .navigationDestination(for: GridLink.self) { link in
                        switch link {
                        case .favorites:
                            FavoriteAudioList()
                        case .playlists:
                            PlaylistsView()
                        case .audios:
                            AudioListView()
                        case .tasks:
                            TaskListView()
                        }
                    }
                    Spacer()
                }
                .navigationTitle("Home")
            }
        } detail: {
            
        }
    }
}

// A separate view for each grid item
struct GridItemView: View {
    var icon: String
    var title: String
    var subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 20))
            Text(title)
                .lineLimit(1)
                .truncationMode(.tail)
                .font(.headline)
            Text(subtitle)
                .lineLimit(1)
                .truncationMode(.tail)
                .font(.subheadline)
        }
        .foregroundStyle(.text)
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.bg)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    let container = ModelContainer.previewContainer
    HomeGridView()
        .modelContainer(container)
}
