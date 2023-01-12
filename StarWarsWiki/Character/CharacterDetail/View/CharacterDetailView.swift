//
//  CharacterDetailView.swift
//  StarWarsWiki
//
//  Created by Victor Melcon Diez on 7/1/23.
//

import SwiftUI

struct CharacterDetailView: View {
    
    @ObservedObject var viewModel: CharacterDetailViewModel
    
    var body: some View {
        let state = viewModel.state
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            switch state {
            case .idle:
                Color.clear.onAppear(perform: viewModel.loadProfileData)
            case .loading:
                VStack(spacing: 10) {
                    ProgressView()
                    Text("Loading Data")
                }
            case .success:
                ScrollView {
                    VStack(spacing: 10) {
                        // Character image
                        Image(systemName: "person.2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .padding()
                        
                        // Character name
                        Text(viewModel.loadedViewModel.characterData.name)
                            .font(.title)
                            .padding(.bottom, 30)
                        
                        // Character data
                        VStack {
                            CharacterProperty(propertyName: "Height", propertyValue: viewModel.loadedViewModel.characterData.height)
                            CharacterProperty(propertyName: "Mass", propertyValue: viewModel.loadedViewModel.characterData.mass)
                            CharacterProperty(propertyName: "Hair Color", propertyValue: viewModel.loadedViewModel.characterData.hair_color)
                            CharacterProperty(propertyName: "Skin Color", propertyValue: viewModel.loadedViewModel.characterData.skin_color)
                            CharacterProperty(propertyName: "Eye Color", propertyValue: viewModel.loadedViewModel.characterData.eye_color)
                            CharacterProperty(propertyName: "Birth Year", propertyValue: viewModel.loadedViewModel.characterData.birth_year)
                            CharacterProperty(propertyName: "Gender", propertyValue: viewModel.loadedViewModel.characterData.gender)
                        }
                        .padding(.bottom, 30)
                        
                        // Other character data
                        VStack(spacing: 40) {
                            DetailNavigableCategoryItems(categoryName: "Homeworld", itemNames: [viewModel.loadedViewModel.homeWorld.name])
                            DetailNavigableCategoryItems(categoryName: "Films", itemNames: viewModel.loadedViewModel.filmList.map{ $0.title } )
                            if(viewModel.loadedViewModel.specieList.count > 0) {
                                DetailNavigableCategoryItems(categoryName: "Species", itemNames: viewModel.loadedViewModel.specieList.map{ $0.name })
                            }
                            if(viewModel.loadedViewModel.starshipList.count > 0) {
                                DetailNavigableCategoryItems(categoryName: "Starships", itemNames: viewModel.loadedViewModel.starshipList.map{ $0.name })
                            }
                            if(viewModel.loadedViewModel.vehicleList.count > 0) {
                                DetailNavigableCategoryItems(categoryName: "Vehicles", itemNames: viewModel.loadedViewModel.vehicleList.map{ $0.name })
                            }
                        }
                        
                        
                        
                    }
                    .navigationBarTitle(Text(viewModel.loadedViewModel.characterData.name), displayMode: .inline)
                    .background(.black)
                    .foregroundColor(.white)
                    .preferredColorScheme(.dark)
                    .padding([.leading, .trailing], 20)
                }
                
            case .failed(let errorViewModel):
                Color.clear.alert(isPresented: $viewModel.showErrorAlert) {
                    Alert(title: Text("Error"), message: Text(errorViewModel.message), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}

struct CharacterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterDetailView(viewModel: CharacterDetailViewModel(characterUrl: Character.SampleData.url))
    }
}

// Simple character property view
struct CharacterProperty: View {
    
    let propertyName: String
    let propertyValue: String
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(propertyName)
                    .font(.body)
                Spacer()
                Text(propertyValue)
                    .font(.body)
            }
            Rectangle()
                .frame(height: 1)
        }
    }
}

// View with category accesible items
struct DetailNavigableCategoryItems: View {
    
    let categoryName: String
    let itemNames: [String]
    let categoryImages = ["globe"]
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text(categoryName)
                    .font(.title)
                Spacer()
            }
            ScrollView(.horizontal) {
                
                HStack(spacing: 20) {
                    ForEach(itemNames, id: \.self) { itemName in
                        ClickableItem(destination: AnyView(EmptyView()), itemName: itemName, itemImage: categoryImages[0])
                            .frame(width: 200)
                    }
                }
            }
        }
    }
}
