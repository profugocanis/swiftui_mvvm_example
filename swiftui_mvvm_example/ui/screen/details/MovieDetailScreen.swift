import SwiftUI

struct MovieDetailScreen: BaseScreen {
    
    let movie: Movie
    
    @ObservedObject private var state: MovieDetailState
    private var viewModel: MovieDetailViewModel
    
    init(movie: Movie, vc: ScreenViewController) {
        self.movie = movie
        self.viewModel = AppComponent.shared.injectViewModel(vc)
        self.state = viewModel.state
        self.viewModel.loadDetail(imdbID: movie.imdbID ?? "")
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            GeometryReader { geometry in
                if let poster = movie.poster,
                   let url = URL(string: poster),
                   poster != "N/A" {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: geometry.size.width, height: geometry.size.height)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.height + geometry.frame(in: .named("scroll")).minY)
                                .clipped()
                                .offset(y: -geometry.frame(in: .named("scroll")).minY)
                        default:
                            Color.gray
                                .frame(width: geometry.size.width, height: geometry.size.height)
                        }
                    }
                }
            }
            .frame(height: 300)

            VStack(alignment: .leading, spacing: 16) {
                Text(movie.title ?? "Unknown Title")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                HStack(spacing: 16) {
                    if let year = movie.year {
                        Label(year, systemImage: "calendar")
                    }
                    if let type = movie.type {
                        Label(type.capitalized, systemImage: type == "movie" ? "film" : "tv")
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal)

                if let plot = movie.plot, !plot.isEmpty {
                    Text(plot)
                        .font(.body)
                        .padding(.horizontal)
                }
            }
        }
        .coordinateSpace(name: "scroll")
        .navigationTitle(movie.title ?? "Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: open
    static func open(_ nv: UINavigationController?, movie: Movie) {
        let vc = ScreenViewController { vc in
            MovieDetailScreen(movie: movie, vc: vc)
        }
        vc.title = movie.title ?? "Movie Details"
        nv?.pushViewController(vc, animated: true)
    }
}

// Default implementation for viewDidLoad
extension MovieDetailScreen {
    func viewDidLoad() {}
}
