import SwiftUI
import AVKit

struct ImageView: View {
    let image:Image
    var body: some View {
        VStack(alignment: .center){
            image
                .resizable()
                .frame(width: 200,height: 210)
                .cornerRadius(20.0)
            Text("Nature").font(.title3).fontWeight(.bold)
        }
        .frame(width: 200,height: 210)
        .padding()
        .background(Color.white)
        .cornerRadius(20.0)
    }
}

struct VideoDesc: View {
    var body: some View {
        VStack(alignment: .leading){
            Text("Nature Video 1")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Description")
                .fontWeight(.medium)
                .padding(.vertical,4)
            Text("The Video is of the nature in the forest. the life of the animals and birds in the Wild life. The fishes are also the Part of Environment.")
                .lineSpacing(8.0)
                .opacity(0.6)
            ScrollView(.horizontal,showsIndicators: false){
                HStack{
                    ForEach(0 ..< 3) { index in
                        NavigationLink(destination: DetailScreen(), label: {
                            ImageView(image: Image("life_\(index + 1)"))
                        })
                        .navigationBarBackButtonHidden(true)
                    }
                }
            }
            
        }
        .padding()
        .padding(.top)
        .background(Color("Bg"))
        .cornerRadius(40.0)
        HStack(alignment: .center){
            Button(action: {
                openVideoInExternalPlayer()
            }) {
                Text("Play Video")
                    .frame(width: 280,height: 50)
                    .foregroundColor(.black)
                    
            }
            .background(Color.blue)
            .clipShape(Capsule())
        }
    }
    private func openVideoInExternalPlayer() {
            guard let videoURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/swiftuivideodownloader.appspot.com/o/173796%20(540p).mp4?alt=media&token=07273550-328d-464f-94fa-3335b8ddb8c3") else {
                return
            }

            let playerViewController = AVPlayerViewController()
            playerViewController.player = AVPlayer(url: videoURL)

            if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
                rootViewController.present(playerViewController, animated: true) {
                    playerViewController.player?.play()
                }
            }
        }
}

struct DownloadBtn: View {
    @State private var downloadStatus: String = ""
    
    var body: some View {
        Button(action: {
                    downloadVideo()
                }) {
                    Text("Download")
                        .frame(width: 250.0)
                        .foregroundColor(.black)
                }
                .alert(isPresented: $showAlert) {
                            Alert(title: Text("Download Status"), message: Text(downloadStatus), dismissButton: .default(Text("OK")))
                        }
    }
    
    private func downloadVideo() {
        guard let videoURL = URL(string: "https://firebasestorage.googleapis.com:443/v0/b/videod-4486d.appspot.com/o/videos%2F36C4A6B7-F25A-40E8-8983-7BD949DD848F?alt=media&token=66a2244a-8b75-47a1-b8df-713cd2b00443") else {
            downloadStatus = "Invalid video URL."
            showAlert = true
            return
        }
        
        let session = URLSession.shared
        let task = session.downloadTask(with: videoURL) { localURL, response, error in
            if let error = error {
                downloadStatus = "Failed to download video: \(error.localizedDescription)"
                showAlert = true
                return
            }
            
            guard let localURL = localURL else {
                downloadStatus = "Downloaded video URL is nil."
                showAlert = true
                return
            }
            
            let fileManager = FileManager.default
            let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let destinationURL = documentsDirectory.appendingPathComponent("downloaded_video4.mp4")
            
            do {
                try fileManager.moveItem(at: localURL, to: destinationURL)
                downloadStatus = "Video downloaded successfully."
                showAlert = true
            } catch {
                downloadStatus = "Failed to save the video: \(error.localizedDescription)"
                showAlert = true
            }
        }
        
        task.resume()
    }

    @State private var showAlert = false
}


struct DetailScreen: View {
    @Environment(\.presentationMode) var presentaionMode: Binding<PresentationMode>
    var body: some View {
        ZStack{
            Color("Bg")
                .edgesIgnoringSafeArea(.all)
                
            ScrollView{
                Image("life_3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    
                
                VideoDesc()
                    .offset(y:-40)
            }
            .edgesIgnoringSafeArea(.top)
            HStack{
                DownloadBtn()
            }
            .padding()
            .background(Color.green)
            .clipShape(Capsule())
            .padding()
            .frame(maxHeight: .infinity,alignment: .bottom)
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButtonView(action:{presentaionMode.wrappedValue.dismiss()})
        )
    }
}

struct DetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        DetailScreen()
    }
}

struct CustomBackButtonView: View{
    let action: ()->Void
    var body: some View{
        Button(action: action, label: {
            Image(systemName: "chevron.backward")
                .padding(.all, 12)
                .background(Color.white)
                .cornerRadius(8.0)
        })
        
    }
}
