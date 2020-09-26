//
//  ContentView.swift
//  PhotosUIPHPicker
//
//  Created by Alexander Römer on 26.09.20.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @State private var images: [UIImage] = []
    @State private var picker = false
    
    var body: some View {
        ZStack {
            Color(UIColor.darkGray)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if !images.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false, content: {
                        HStack(spacing: 15) {
                            ForEach(images, id: \.self) { img in
                                Image(uiImage: img)
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width - 24, height: 250)
                                    .cornerRadius(20)
                            }
                        }
                    })
                } else {
                    Button(action: {
                        picker.toggle()
                    }, label: {
                        Text("Pick Images")
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 35)
                            .background(Color.blue)
                            .clipShape(Capsule())
                    })
                }
            }
            .sheet(isPresented: self.$picker) {
                ImagePicker(images: self.$images, picker: self.$picker)
        }
        }
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    
    
    @Binding var images: [UIImage]
    @Binding var picker: Bool

    
    func makeCoordinator() -> Coordinator {
        return ImagePicker.Coordinator(parentImagePicker: self)
    }
    
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 0
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parentImage: ImagePicker
        
        init(parentImagePicker: ImagePicker) {
            parentImage = parentImagePicker
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parentImage.picker.toggle()
            for image in results {
                if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    image.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        guard let image1 = image else { print("Error"); return }
                        self.parentImage.images.append(image1 as! UIImage)
                    }
                } else {
                    print("Cannot be loaded")
                }
            }
        }
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
