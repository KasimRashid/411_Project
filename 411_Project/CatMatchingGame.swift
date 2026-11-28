import SwiftUI

//gives cards their unique ID, web link to the image, and bool on whether it's flipped and whether it's matched
struct CatCard: Identifiable {
    let id = UUID()
    let url: URL
    var isFaceUp = false
    var isMatched = false
}

//gets URL field from API (from thecatapi)
struct CatPhoto: Decodable {
    let url: URL
}

//game screen
struct CatMatchingGame: View {
    @State private var cards: [CatCard] = []
    @State private var firstIndex: Int?
    //might plan on changing this code later on
    @State private var pairCount = 6

    var body: some View {
        VStack(spacing: 12) {
            //player selection difficult, might change later on
            Picker("Pairs", selection: $pairCount) {
                Text("4 Pairs").tag(4)
                Text("6 Pairs").tag(6)
                Text("8 Pairs").tag(8)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            //changes game when player chooses number of pairs wanted to play with
            .onChange(of: pairCount) {
                Task { await loadCats() }
            }

            //win condition
            if cards.allSatisfy(\.isMatched) && !cards.isEmpty {
                Text("You won!").font(.title2.bold())
            }

            //how the game looks and the ui design after certain actions
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 75))], spacing: 10) {
                    ForEach(cards.indices, id: \.self) { i in
                        let card = cards[i]
                        RoundedRectangle(cornerRadius: 12)
                            .fill(card.isFaceUp || card.isMatched ? .white : .orange)
                            .aspectRatio(3/4, contentMode: .fit)
                            .overlay {
                                if card.isFaceUp || card.isMatched {
                                    AsyncImage(url: card.url) { $0.image?.resizable().scaledToFill() }
                                }
                            }
                        // made it so cat images actually fit and are same size so not overlap occurs
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .contentShape(Rectangle())
                            .opacity(card.isMatched ? 0.4 : 1)
                            .onTapGesture { tapCard(at: i) }
                    }
                }
                .padding(.horizontal)
            }

            //new game button
            Button("New Game") { Task { await loadCats() } }
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 8)
        }
        .task { await loadCats() }
    }

    //game logic when card is tapped
    func tapCard(at i: Int) {
        guard !cards[i].isFaceUp && !cards[i].isMatched else { return }

        if let first = firstIndex {
            cards[i].isFaceUp = true
            //checks if both are the same image
            if cards[i].url == cards[first].url {
                cards[i].isMatched = true
                cards[first].isMatched = true
            }
            firstIndex = nil
        } else {
            for idx in cards.indices where !cards[idx].isMatched {
                cards[idx].isFaceUp = false
            }
            //flips card
            cards[i].isFaceUp = true
            firstIndex = i
        }
    }

    //gets cat urls from api and shuffles them
    func loadCats() async {
        firstIndex = nil
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search?limit=\(pairCount)&mime_types=jpg,png"),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let cats = try? JSONDecoder().decode([CatPhoto].self, from: data) else { return }

        //duplicate to form pairs to allow matching pairs
        let urls = cats.prefix(pairCount).map(\.url)
        cards = (urls + urls).map { CatCard(url: $0) }.shuffled()
    }
}
