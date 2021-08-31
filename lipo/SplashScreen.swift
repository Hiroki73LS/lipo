import SwiftUI

struct LaunchScreen: View {
    @State private var isLoading = true

    var body: some View {
        if isLoading {
            ZStack {
                VStack{
                Text("Drone Battery Info").font(.title)
                Image("drone")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    HStack{
                        Image(systemName: "battery.100")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50.0, height: 50.0, alignment: .leading)
                        Image(systemName: "battery.100")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50.0, height: 50.0, alignment: .leading)
                        Image(systemName: "battery.100")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50.0, height: 50.0, alignment: .leading)
                    }}}
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation {
                        isLoading = false
                    }
                }
            }
        } else {
            ContentView()
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
