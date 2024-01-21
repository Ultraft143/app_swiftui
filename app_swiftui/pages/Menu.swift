import SwiftUI

struct Menu: View {
    @State private var searchText = ""
    @State private var models: [ResponseModel] = []
    @State private var showAlert: Bool = false
    @State private var alertuser = false
    
    let URL_GET_TRACKS = "\(API)/gettracks.php"
    let DELETE_TRACK = "\(API)/deletetrack.php"
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.lightGray).ignoresSafeArea()
                
                Circle()
                    .scale(1.9)
                    .foregroundColor(.white.opacity(0.15))
                    .zIndex(2)
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white)
                
                VStack{
                    ForEach(self.models) { (model) in
                        NavigationLink(destination: Detalhes()) {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 230, height: 120)
                                    .foregroundColor(Color.blue.opacity(0.0))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.black, lineWidth: 3)
                                    )
                                
                                Text(model.nome ?? "")
                                    .foregroundColor(.black)
                                    .offset(x: 0, y: -30)
                                
                                Text(model.texto ?? "")
                                    .foregroundColor(.black)
                                    .offset(x: 0, y: 0)
                                
                                VStack{
                                    NavigationLink(destination: alterarsessao()){
                                        Image(systemName: "gear")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.black)
                                            .padding()
                                    }

                                    
                                    Button(action: {
                                        //created NSURL
                                        let requestURL = URL(string: DELETE_TRACK)
                                        
                                        //creating NSMutableURLRequest
                                        let request = NSMutableURLRequest(url: requestURL! as URL)
                                        
                                        //setting the method to post
                                        request.httpMethod = "POST"
                                        
                                        //creating the post parameter by concatenating the keys and values from text field
                                        let postParameters = "nome=\(model.nome)&texto=\(model.texto)"
                                        
                                        //adding the parameters to request body
                                        request.httpBody = postParameters.data(using: String.Encoding.utf8)
                                        
                                        
                                        //creating a task to send the post request
                                        let task = URLSession.shared.dataTask(
                                            with: request as URLRequest,
                                            completionHandler: { data, response, error in
                                                DispatchQueue.main.async(execute:{
                                                    do {
                                                        if let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                                                            print("JSON response: \(jsonResponse)")
                                                            if(jsonResponse["error"] as! Int == 0){
                                                                alertuser = true
                                                            }
                                                            else{
                                                                alertuser = false
                                                            }
                                                            showAlert = true
                                                        } else {
                                                            print("Error: JSON parsing failed.")
                                                            alertuser = false
                                                            showAlert = true
                                                        }
                                                    } catch {
                                                        print("Error: JSON serialization failed.")
                                                        alertuser = false
                                                        showAlert = true
                                                    }
                                                    
                                                })
                                                
                                            })
                                        
                                        
                                        
                                        task.resume()
                                    }) {
                                        Image(systemName: "trash")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.black)
                                    }
                                    .padding()
                                }
                                .offset(x: 170, y: 0)
                            }
                        }
                    }
                }
                .alert(isPresented: $showAlert, content: {
                    if(alertuser == true){
                        Alert(title: Text("Sucesso!"), message: Text("A track foi apagada com sucesso."))
                    }else{
                        Alert(title: Text("Erro!"), message: Text("Nao foi possivel apagar a Track."))
                    }
                })
                .onAppear(perform: {
                    loadData()
                })
                
                
                
                VStack {
                    List(filteredCountries, id: \.self) { country in
                        Text(country.capitalized)
                    }
                    .offset(y:-60)
                    .searchable(text: $searchText)
                    .navigationTitle("Artigos")
                    .toolbar {     
                        if(UserLoged == 0){
                            NavigationLink(destination: perfil()) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.black)
                            }
                        }
                        else{
                            NavigationLink(destination: login()) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.black)
                            }
                        }

                        
                        NavigationLink(destination: sessao()) {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.black)
                            
                        }
                        
                    }
                    
                }
                .frame(height: 100)
                //.background(Color.red)
                .offset(y:-350)
                
                
                
                
            }
        }
    }
    
    func loadData() {
        guard let url: URL = URL(string: URL_GET_TRACKS) else {
            print("invalid URL")
            return
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else {
                print("invalid response")
                return
            }
            
            do {
                self.models = try JSONDecoder().decode([ResponseModel].self, from: data)
            } catch {
                print(String(describing: error))
            }
        }.resume()
    }
    
    var filteredCountries: [String] {
        let lcCountries = models.map { $0.nome?.lowercased() ?? "" }
        return searchText.isEmpty ? [] : lcCountries.filter {
            $0.contains(searchText.lowercased())
        }
    }
}

struct ResponseModel: Codable, Identifiable {
    var id: String? = ""
    var nome: String? = ""
    var texto: String? = ""
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
