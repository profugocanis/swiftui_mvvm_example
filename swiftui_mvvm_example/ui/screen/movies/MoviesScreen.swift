import SwiftUI

struct MoviesScreen: BaseScreen {
    
    @ObservedObject private var state: MoviesScreenState
    private var viewModel: MoviesViewModel
    
    private let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    init(_ vc: ScreenViewController) {
        self.viewModel = AppComponent.shared.injectViewModel(vc)
        self.state = viewModel.state
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color(.systemBackground), Color(.secondarySystemBackground)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                content
                
                // Loading overlay with blur effect
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .overlay(
                        VStack(spacing: 20) {
                            ProgressView()
                                .scaleEffect(1.5)
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            
                            Text("Loading movies...")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                            .padding(30)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.black.opacity(0.7))
                                    .blur(radius: 0.5)
                            )
                    )
                    .opacity(state.isLoading ? 1 : 0)
                    .animation(.default, value: state.isLoading)
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: open
    static func open(_ nv: UINavigationController?) {
        let vc = ScreenViewController { vc in
            MoviesScreen(vc)
        }
        vc.title = "Movies"
        nv?.pushViewController(vc, animated: true)
    }
    
}

extension MoviesScreen {
    
    private var content: some View {
        VStack(spacing: 0) {
            // Custom header
            headerView
            
            // Search section
            searchSection
            
            // Movies grid
            moviesGridView
            //                .animation(.default, value: state.isLoading)
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Discover")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Find your favorite movies")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Optional: Add profile or settings button here
            Button(action: {}) {
                Image(systemName: "person.circle.fill")
                    .font(.title2)
                    .foregroundColor(.accentColor)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchSection: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                    .font(.system(size: 16, weight: .medium))
                
                TextField("Search for movies...", text: $state.search)
                    .font(.system(size: 16))
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !state.search.isEmpty {
                    Button(action: {
                        state.search = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.system(size: 16))
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray4), lineWidth: 0.5)
                    )
            )
            .animation(.easeInOut(duration: 0.2), value: state.search.isEmpty)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var moviesGridView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(state.movies, id: \.imdbID) { movie in
                    MovieItemView(movie: movie)
                        .transition(.scale.combined(with: .opacity))
                }
                
                // Load more indicator
                if !state.movies.isEmpty {
                    HStack {
                        Spacer()
                        if state.isLoading {
                            ProgressView()
                                .scaleEffect(0.8)
                                .padding()
                        } else {
                            Text("Pull to load more")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding()
                        }
                        Spacer()
                    }
                    .gridCellColumns(2)
                    .onAppear {
                        if !state.isLoading {
                            viewModel.loadMore()
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .refreshable {
            await MainActor.run {
                viewModel.loadSearch()
            }
        }
    }
}

// MARK: lifecycle
extension MoviesScreen {
    
    func viewDidLoad() {
        state.$search
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink {
                if $0.count < 3 { return }
                viewModel.loadSearch()
            }
            .store(in: &viewModel.cancellables)
    }
}
