import SwiftUI

struct FactsResponse: Codable {
    let data: [CatFact]
    let last_page: Int
}
struct CatFact: Codable, Identifiable {
    let fact: String
    let length: Int
    var id: String { fact }

    enum CodingKeys: String, CodingKey {
        case fact, length
    }
}
struct FactsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var facts: [CatFact] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var currentPage = Int.random(in: 1...58)

    var body: some View {
        VStack(spacing: 16) {
            //Title
            VStack(spacing: 50) {
                Text("Animal Facts")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 16)
            }
            .padding(.top, 50)

            //Facts
            ScrollView {
                if isLoading && facts.isEmpty {
                    ProgressView("Loading...")
                        .padding(.top, 40)
                } else if let errorMessage, facts.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(facts) { item in FactCard(fact: item.fact) }
                    }
                }
            }
            //Get more button
            HStack(spacing: 16) {
                Button {
                    Task {
                        await fetchFacts()
                    }
                    //insert api functionality
                } label: {
                    Label("Get More", systemImage: "arrow.clockwise")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(16)
                }
                .disabled(isLoading)

                //Home button
                Button {
                    dismiss()
                } label: {
                    Label("Home", systemImage: "house.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(16)
                }
            }
            .padding(.bottom, 16)
        }
        .task {
            await fetchFacts()
        }
    }

    func fetchFacts() async {
        isLoading = true
        errorMessage = nil
        guard
            let url = URL(
                string:
                    "https://catfact.ninja/facts?max_length=120&limit=4&page=\(currentPage)"
            )
        else {
            isLoading = false
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(
                FactsResponse.self,
                from: data
            )
            print("Fetched page \(currentPage) of \(decoded.last_page)")
            var seen = Set(facts.map {
                $0.fact.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            })

            var uniqueNewFacts: [CatFact] = []
            for item in decoded.data {
                let cleaned = item.fact.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                if !cleaned.isEmpty && seen.insert(cleaned).inserted {
                    uniqueNewFacts.append(item)
                }
            }

            facts.append(contentsOf: uniqueNewFacts.shuffled())
            currentPage = currentPage < decoded.last_page ? currentPage + 1 : 1
            isLoading = false
        } catch {
            errorMessage = "Couldn't load facts, Try again"
            isLoading = false
        }
    }
    // Facts subview
    struct FactCard: View {
        let fact: String

        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                Text(fact)
                    .font(.body)
                    .foregroundColor(.black)
                    .lineSpacing(5)
            }
            .padding(24)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .blue.opacity(0.5), radius: 6, y: 4)
        }
    }
}

#Preview {
    NavigationStack {
        FactsView()
    }
}
