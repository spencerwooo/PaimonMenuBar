//
//  ContentView.swift
//  PaimonMenuBar
//
//  Created by Spencer Woo on 2022/3/23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Image("FragileResin").padding()
            Text("Paimon in your MenuBar!").bold().font(.system(size: 16)).padding()
            Text("Created with love by @SpencerWoo").font(.system(size: 10)).padding()
        }.frame(width: 300, height: 200)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
