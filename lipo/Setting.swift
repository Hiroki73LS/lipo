import UIKit
import SwiftUI
import RealmSwift

class Cellof: ObservableObject {
    
    var cellof0 : Int = 0
    var cellof1 : Int = 0
    var cellof2 : Int = 0
    var cellof3 : Int = 0
    var cellof4 : Int = 0
    var cellof5 : Int = 0
    var cellof6 : Int = 0
    
    init(){
//セルごとの登録数を取得↓-------------------
        let realm = try? Realm()
        cellof0 = realm?.objects(Model.self).count ?? 99
        cellof1 = realm?.objects(Model.self).filter("cells == 0").count ?? 99
        cellof2 = realm?.objects(Model.self).filter("cells == 1").count ?? 99
        cellof3 = realm?.objects(Model.self).filter("cells == 2").count ?? 99
        cellof4 = realm?.objects(Model.self).filter("cells == 3").count ?? 99
        cellof5 = realm?.objects(Model.self).filter("cells == 4").count ?? 99
        cellof6 = realm?.objects(Model.self).filter("cells == 5").count ?? 99
//セルごとの登録数を取得↑-------------------
    }
}

struct Setting: View {
    
    @ObservedObject var cellof = Cellof()
    @State var color1 = Color.white
    @State var color2 = Color.green
    @ObservedObject var profile = UserProfile()
    
    let backGroundColor = LinearGradient(gradient: Gradient(colors: [Color.white, Color.green]), startPoint: .top, endPoint: .bottom)
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        }

    var body: some View {
        NavigationView {
            ZStack{
                backGroundColor.edgesIgnoringSafeArea(.all)
                VStack{
                    VStack{
                        Text("ColorSetting & Info").font(.largeTitle)
                        ColorPicker(selection: $color1, label: {
                            Text("Select BackgroundColor(top)").bold()
                        })
                        ColorPicker(selection: $color2, label: {
                            Text("Select BackgroundColor(bottom)").bold()
                        })}
                        .padding()
                    Spacer()
                        .frame(width: 320, height: 100)
                    HStack{
                        VStack(alignment: .leading) {
                            Text("全バッテリー ： ").bold()
                            Text("　１セル ： ")
                            Text("　２セル ： ")
                            Text("　３セル ： ")
                            Text("　４セル ： ")
                            Text("　５セル ： ")
                            Text("　６セル ： ")
                        }.font(.title)
                        VStack(alignment: .center) {
                            Text("\(self.cellof.cellof0)").bold()
                            Text("\(self.cellof.cellof1)")
                            Text("\(self.cellof.cellof2)")
                            Text("\(self.cellof.cellof3)")
                            Text("\(self.cellof.cellof4)")
                            Text("\(self.cellof.cellof5)")
                            Text("\(self.cellof.cellof6)")
                        }.font(.title)
                        VStack(alignment: .leading) {
                            Text("個").bold()
                            Text("個")
                            Text("個")
                            Text("個")
                            Text("個")
                            Text("個")
                            Text("個")
                        }.font(.title)
                        Spacer()
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .padding()
                    Spacer()
                        .frame(width: 320, height: 200)
                    AdView()
                        .frame(width: 320, height: 50)
                }
            }}
    }
}


class UserProfile: ObservableObject {
    @Published var UD1: String {
        didSet {
            UserDefaults.standard.set(UD1, forKey: "UD1")
        }
    }
    @Published var UD2: String {
        didSet {
            UserDefaults.standard.set(UD2, forKey: "UD2")
        }
    }
    @Published var UD3: String {
        didSet {
            UserDefaults.standard.set(UD3, forKey: "UD3")
        }
    }

    init() {
        UD1 = UserDefaults.standard.string(forKey: "UD1") ?? ""
        UD2 = UserDefaults.standard.string(forKey: "UD2") ?? ""
        UD3 = UserDefaults.standard.string(forKey: "UD3") ?? ""
    }
}

//struct Setting_Previews: PreviewProvider {
//    static var previews: some View {
//        Setting()
//    }
//}
