//
//  ContentView.swift
//  MacToolBox
//
//  Created by 朱校明 on 2023/6/2.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: CodeRecognizeView()) {
                    Text("识别二维码")
                }
                NavigationLink(destination: DetailView(text: "3")) {
                    Text("生成二维码")
                }
                NavigationLink(destination: ImageVisionView()) {
                    Text("识图生字")
                }
            }
            .listStyle(SidebarListStyle())
        }
    }
}

struct DetailView: View {
    var text: String
    var body: some View {
        Text(text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
