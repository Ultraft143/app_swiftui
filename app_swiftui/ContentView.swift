//
//  ContentView.swift
//  app_swiftui
//
//  Created by Sysprobs on 1/9/24.
//
var IP = "192.168.28.132";
var API = "http://\(IP)/webservice/api"
var UserLoged = 0
var UserID = 0
var TrackPicked = 0
var PerguntaID = "3"
var useradmin = "1"

import SwiftUI

struct ContentView: View {
    var body: some View {
            Menu();
      
    }
}

#Preview {
    ContentView()
}
