import SwiftUI

struct Menu: View {
    @State private var selectedTab2: Tab2?
    @Environment (\.colorScheme) private var scheme
    @State private var tab2Progress: CGFloat = 1
    @State private var searchText = ""
    @State private var items: [String] = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
    @State private var models: [ResponseModel] = []
    @State private var models2: [Horariosmodel] = []
    @State private var showAlert: Bool = false
    @State private var alertuser = false
    @State private var goqdetahes = false
    @State private var goalterarsessao = false
    
    let URL_GET_TRACKS = "\(API)/gettracks.php"
    let URL_GET_HORARIO = "\(API)/gethorariotrack.php"
    let DELETE_TRACK = "\(API)/deletetrack.php"
    
    
    var filteredItems: [String] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    } 
    
    var body: some View {
        NavigationView(){
            VStack (spacing: 15) {
                
                HStack {
                    if(UserLoged == 0){
                        NavigationLink(destination: login()){
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                    }else{
                        NavigationLink(destination: perfil()){
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                    }

                    
                    Spacer()
                    NavigationLink(destination: sessao()){
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    
                }
                .font(.title2)
                .overlay {
                    Text("Menu")
                        .font(.title3.bold())
                }
                .foregroundStyle(.primary)
                .padding(15)
                
                //.frame(height: 80)
                
                CustomTabBar(searchText: $searchText, items: $items)
                
                GeometryReader{
                    let size = $0.size
                    
                    
                    LazyHStack(spacing: 0){
                        
                        
                        SampleView(.gray)
                            .id(Tab2.ficheiros)
                            .containerRelativeFrame(.horizontal)
                    }
                    .scrollTargetLayout()
                    .offsetX2 { value in
                        
                        let progress = -value / (size.width * CGFloat(Tab.allCases.count - 1))
                        
                        tab2Progress = max(min(progress, 1), 0)
                    }
                    
                    .scrollPosition(id: $selectedTab2)
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.paging)
                    .scrollClipDisabled()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(.gray.opacity(0.1))
        }
    }
    @ViewBuilder
    func CustomTabBar(searchText: Binding<String>, items: Binding<[String]>) -> some View {
        var filteredItems: [String] {
            if searchText.wrappedValue == "" {
                return items.wrappedValue
            } else {
                return items.wrappedValue.filter { $0.localizedCaseInsensitiveContains(searchText.wrappedValue) }
            }
        }
        
        HStack(spacing: 0) {
            TextField("Search", text: searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.vertical, 10)
        }
        .tab2Mask(tab2Progress)
        .background {
            GeometryReader {
                let size = $0.size
                let capusleWidth = size.width / CGFloat(Tab2.allCases.count)
                
                Capsule()
                    .fill(scheme == .dark ? .black : .white)
                    .frame(width: capusleWidth)
                    .offset(x: tab2Progress * (size.width - capusleWidth))
            }
        }
        .background(.gray.opacity(0.1), in: .capsule)
        .padding(.horizontal, 15)
    }
    @ViewBuilder
    func SampleView(_ color: Color) -> some View {
        ScrollView(.vertical){
            LazyVGrid(columns: Array(repeating: GridItem(),count: 1), content: {
                ForEach(Array(zip(models, models2)), id: \.0.id) { (model, model2) in
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .fill(color.gradient)
                            .frame(width: 250, height: 150)
                        
                        Text(model.nome ?? "")
                            .bold()
                            .font(.system(size: 25))
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                            .offset(y:-40)
                        
                        Text(model.texto ?? "")
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                            .offset(y:50)
                        
                        Text("Horario: \(model2.data ?? "") \(model2.hora ?? "")")
                            .foregroundColor(.black)
                            .bold()
                            .font(.system(size: 13))
                            .offset(y:-10)
                        
                        Text("Sala: \(model2.sala ?? "")")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                            .offset(y:20)
                        
                    }
                    .offset(x:-50)
                    .onTapGesture{
                        TrackPicked = Int(model.id!)!
                        goqdetahes = true
                    }
                    
                    VStack{
                        if(useradmin == "0"){

                        }
                        else{
                            Image(systemName: "gear")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .foregroundColor(.black)
                                .padding()
                                .onTapGesture{
                                    TrackPicked = Int(model.id!)!
                                    print(TrackPicked)
                                    goalterarsessao = true
                                }
                        
                            
                            Image(systemName: "trash")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .foregroundColor(.black)
                                .onTapGesture{
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
                                }
                                .alert(isPresented: $showAlert, content: {
                                    if(alertuser == true){
                                        Alert(title: Text("Sucesso!"), message: Text("A track foi apagada com sucesso."))
                                    }else{
                                        Alert(title: Text("Erro!"), message: Text("Nao foi possivel apagar a Track."))
                                    }
                                })
                        }
                            
                    }
                    .offset(x:140,y:-150)
                    
                }
                
            })
            .padding(15)
            
            NavigationLink(destination: Detalhes(), isActive: $goqdetahes) {
            }
            .hidden()
            
            NavigationLink(destination: alterarsessao(), isActive: $goalterarsessao) {
            }
            .hidden()
        }
        .onAppear(perform: {
            loadData()
            loadHorarios()
        })
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
        .mask {
            Rectangle()
                .padding(.bottom, -100)
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
    
    func loadHorarios() {
        guard let url: URL = URL(string: URL_GET_HORARIO) else {
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
                self.models2 = try JSONDecoder().decode([Horariosmodel].self, from: data)
            } catch {
                print(String(describing: error))
            }
        }.resume()
    }
}

struct ResponseModel: Codable, Identifiable {
    var id: String? = ""
    var nome: String? = ""
    var texto: String? = ""
}

struct Horariosmodel: Codable, Identifiable {
    var id: String? = ""
    var sala: String? = ""
    var data: String? = ""
    var hora: String? = ""
}

#Preview {
    Menu()
}
