import SwiftUI

struct LaunchScreen: View {
    @State private var isLoading = true

    var body: some View {
        if isLoading {
            ZStack {
                VStack{
                Text("Drone Battery Info").font(.largeTitle)
                    HStack{
                        Image("1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40.0, height: 50.0, alignment: .leading)
                        Spacer().frame(width: 20)
                        Image("2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40.0, height: 50.0, alignment: .leading)
                        Spacer().frame(width: 20)
                        Image("3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40.0, height: 50.0, alignment: .leading)
                    }
                    Image("drone")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                    HStack{
                        Image("4")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40.0, height: 50.0, alignment: .leading)
                        Spacer().frame(width: 20)
                        Image("5")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40.0, height: 50.0, alignment: .leading)
                        Spacer().frame(width: 20)
                        Image("6")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40.0, height: 50.0, alignment: .leading)
                    }}}
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
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
