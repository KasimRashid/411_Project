import SwiftUI

struct FactsView: View {
    @State private var message = "Hello, here is the app!"
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            //Title
            VStack(spacing: 50){
                Text("Animal Facts")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .padding(.top, 50)
            
            //Facts
            FactCard(fact: "first fact")
                .frame(maxHeight: .infinity)
            FactCard(fact: "next fact")
                .frame(maxHeight: .infinity)
            FactCard(fact: "next fact")
                .frame(maxHeight: .infinity)
            FactCard(fact: "next fact")
                .frame(maxHeight: .infinity)
            
            //Get more button
            Button{
                //insert api functionality
            } label: {
                Label("Get More", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(16)
            }
            
            //Home button
            Button{
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
        .padding(.horizontal, 24)
        .padding(.bottom, 100)
    }
}
// Facts subview
struct FactCard: View{
    let fact: String
    
    var body: some View{
        VStack(alignment: .leading,spacing: 20){
            Text(fact)
                .font(.body)
                .lineSpacing(5)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .blue.opacity(0.5), radius:6,y:4)
    }
}

#Preview {
    NavigationStack{
        FactsView()
    }
}
