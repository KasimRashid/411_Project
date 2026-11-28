import SwiftUI
struct AxolotlView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentFact = 0
    @State private var currentImage = "axolotl"
    let axolotlImages = [
        "axolotl", "axolotl2", "axolotl3", "axolotl4", "axolotl5"
    ]
    let axolotlFacts = [
        "Axolotls are fully aquatic, neotenic salamanders native to lake Xochimiico!",
        "Axolotles can regenerate lost limbs, including parts of their heart and brain!",
        "Axolotls do not undergo metamorphosis to live on land, they instead keep their external gills and tadpole like tails.",
        "Their genome contains 32 billion DNA base pairs!",
        "They use suction to pull in small prey such as worms instead of chewing them!",
        "Axolotls grow up to around 8-12 inches long and can live up to 10 to 15 years!",
        "The name comes from Nahuatl language of the Aztecs combining words like water (atl) and god Xolotl!",
        "Wild axolotls are usually dark brown, black, or mottled shades for camoflage, but are pink or white from selective breeding!",
        "Axolotls are listed as critically endangered species with the population being in the hundreds to thousands in the Xochimilco canal system!"
    ]
    var body: some View{
        ZStack {
            Color(red: 1.0, green: 0.92, blue: 0.95)
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Axolotl Facts!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.pink)
                Text("Did you know?")
                    .font(.title2)
                    .fontWeight(.semibold)
                Image(currentImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 220)
                    .cornerRadius(20)
                Text(axolotlFacts[currentFact])
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(color: .pink.opacity(0.3), radius: 5)
                Button {
                    var newFact = currentFact
                    while newFact == currentFact {
                        newFact = Int.random(in: 0..<axolotlFacts.count)
                    }
                    currentFact = newFact
                    var newImage = currentImage
                    while newImage == currentImage {
                        newImage = axolotlImages.randomElement()!
                    }
                    currentImage = newImage
                } label: {
                    Label("Another Fact!", systemImage: "arrow.clockwise")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.pink)
                        .cornerRadius(15)
                }
                Button {
                    dismiss()
                } label: {
                    Label("Home", systemImage: "house.fill")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.purple)
                        .cornerRadius(15)
                }
                Spacer()
            }
            .padding()
        }
    }
}
#Preview{
    NavigationStack{
        AxolotlView()
    }
}
