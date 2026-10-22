import SwiftUI
import Playgrounds

struct ContentView: View {
    @State private var message = "Hello, here is the app!"

    var body: some View {
        VStack(spacing: 20) {
            Text(message)
                .font(.title)
                .padding()

            Button("animal facts!") {
                message = "1) animal facts!"
            }
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .cornerRadius(10)

            Button("Going to games") {
                message = "games!"
            }
            .padding()
            .background(.green)
            .foregroundStyle(.white)
            .cornerRadius(10)

            Button("other") {
                message = "random!"
            }
            .padding()
            .background(.orange)
            .foregroundStyle(.black)
            .cornerRadius(10)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

#Playground {
    _ = 1 + 2
}
