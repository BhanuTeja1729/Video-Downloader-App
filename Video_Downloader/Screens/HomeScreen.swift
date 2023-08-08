

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        NavigationView {
            ZStack{
                Color("Bg")
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading){
                    AppBarView()
                    Text("Video").font(.largeTitle).fontWeight(.bold)
                        .padding(.horizontal)
                    ScrollView(.vertical,showsIndicators: false){
                        VStack{
                            ForEach(0 ..< 3) { index in
                                NavigationLink(destination: DetailScreen(), label: {
                                    NatureView(image: Image("life_\(index + 1)"))
                                })
                                .navigationBarBackButtonHidden(true)
                            }
                        }.padding(.horizontal)
                    }
                }
                .padding()
            }
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}


struct AppBarView: View {
    var body: some View {
        HStack{
            Button(action: {}){
                Image("menu")
                    .padding()
                    .background(Color(.white))
                    .cornerRadius(10.0)
            }
            Spacer()
            
            
        }
        .padding(.horizontal)
    }
}

struct NatureView: View {
    let image:Image
    var body: some View {
        VStack(alignment: .center){
            image
                .resizable()
                .frame(width: 320,height: 320)
                .cornerRadius(20.0)
            Text("Nature").font(.title3).fontWeight(.bold)
        }
        .frame(width: 320)
        .padding()
        .background(Color.white)
        .cornerRadius(20.0)
    }
}
