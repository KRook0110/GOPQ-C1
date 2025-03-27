//
//  Navbar.swift
//  GOPQ
//
//  Created by Yehezkiel Joseph Widianto on 27/03/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct NavigationBar: View {
    
    @Binding var showMapSheet:Bool
    @Binding var showImportSheet: Bool

    var body: some View {
        HStack {
            Image("gopq")
                .resizable()
                .frame(width:30,height:45)
                .padding(.leading,15)
                .padding(.trailing,30)
            
            Spacer()
            
            HStack(spacing: 16) {
                
                Button{
                    showImportSheet = true
                } label: {
                    Image(systemName: "square.and.arrow.down")
                                .resizable()
                                .foregroundColor(.blue)
                                .frame(width: 28, height: 35)
                }.fileImporter(isPresented: $showImportSheet, allowedContentTypes: [UTType.commaSeparatedText]) { result in switch result {
                    case .success(let url):
                        do {
                            let content = try String(contentsOf: url, encoding: .utf8)
                            print(content)
                        } catch {
                            print(error)
                        }
                    case .failure(let error): print("error loading file \(error)")
                    
                    }
                }
                
                Button{showMapSheet = true} label:{
                    Image(systemName: "map.fill")
                                .resizable()
                                .font(.system(size: 35))
                                .foregroundColor(.blue)
                                .frame(width: 30, height: 35)
                }
            }
        }
        .padding()
        .background(Color.black)
    }
    
}
#Preview {
    
    @Previewable @State var showMapSheet = false
    @Previewable @State var showImportSheet: Bool = false
    NavigationBar(showMapSheet:$showMapSheet, showImportSheet: $showImportSheet)
}
