import SwiftUI

struct alterarsessao: View {
    @State private var nomesessao: String = "";
    @State private var sala: String = "";
    @State private var data = Date()
    @State private var hora: String = "";
    @State private var autores: String = "";
    @State private var descrição: String = "";
    @State var articles: [String] = Array(repeating: "", count: 10)
    @State private var showAlert: Bool = false;
    @State public var alertuser = false;
    
    let URL_GET_TRACKBYID = "\(API)/getTrackbyid.php"
    let URL_UPDATE_TRACK = "\(API)/updateTrack.php"

    
    var body: some View{
        
        
        
        
        ZStack{
            Color(.lightGray).ignoresSafeArea()
            
            Circle()
                .scale(1.7)
                .foregroundColor(.white.opacity(0.15))
            Circle()
                .scale(1.3)
                .foregroundColor(.white)
            
            VStack{
                
                
                
                Color("Default").ignoresSafeArea();
                
                Text ("Modificar sessão")
                
                    .foregroundColor(.black)
                    .bold()
                    .font(.system(size: 45))
                    .offset(y: -50)
                
                
                
                TextField ("Nome da Sessão", text: $nomesessao)
                    .padding()
                    .font(.callout)
                    .foregroundColor(.black)
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(5)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                    .offset(x:0,y:-40)
                
                TextField ("Sala:", text: $sala)
                    .padding()
                    .font(.callout)
                    .foregroundColor(.black)
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(5)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                    .offset(x:0,y:-35)
                
                HStack{
                    @State var selectedDate: Date = Date()
                    Text("Data e hora:")
                    DatePicker("Data", selection: $selectedDate)
                        .labelsHidden()
                    
                }
                .offset(x:0,y:30)
                
                .padding()
                
                
                TextField("Autores", text: $autores)
                    .padding()
                    .font(.callout)
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(5)
                    .foregroundColor(.black)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                    .offset(x:0,y:-120)
                    .padding()
                
                ScrollView {
                    LazyVStack {
                        ForEach(0..<articles.count, id: \.self) { index in
                            TextField("Artigo \(index + 1):", text: $articles[index])
                                .padding()
                                .frame(width: 350, height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                        }
                    }
                    
                }
                
                .offset(x:0,y:-60)
                VStack{
                    Text("Descrição:")
                        .bold()
                        .offset(x:-100,y:70)
                        .padding()
                    
                    
                    ScrollView {
                        TextEditor(text: $descrição)
                            .frame(width: 300, height: 1000)
                            .background(Color.black.opacity(0.05))
                        
                    }
                    .frame(height:150)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                    .offset(x:0,y:60)
                    Button(action: {
                        
                        //created NSURL
                        let requestURL = URL(string: URL_UPDATE_TRACK)
                        
                        //creating NSMutableURLRequest
                        let request = NSMutableURLRequest(url: requestURL! as URL)
                        
                        //setting the method to post
                        request.httpMethod = "POST"
                        
                        let dateFormatter = DateFormatter()
                        let horaFormatter = DateFormatter()
                        
                        dateFormatter.dateFormat = "dd/MM/YY"
                        horaFormatter.dateFormat = "HH:mm:ss"
                        
                        //creating the post parameter by concatenating the keys and values from text field
                        let postParameters = "id=\(TrackPicked)&nome=\($nomesessao.wrappedValue)&texto=\($descrição.wrappedValue)&titulo=\($articles.wrappedValue)&autores=\($autores.wrappedValue)&descricao=\($descrição.wrappedValue)&sala=\($sala.wrappedValue)&data=\(dateFormatter.string(from: data))"
                        
                        //adding the parameters to request body
                        request.httpBody = postParameters.data(using: String.Encoding.utf8)
                        
                        
                        if($nomesessao.wrappedValue == ""){
                            //creating a task to send the post request
                            let task = URLSession.shared.dataTask(
                                with: request as URLRequest,
                                completionHandler: { data, response, error in
                                    DispatchQueue.main.async(execute:{
                                        alertuser = true
                                        showAlert = true
                                    })
                                    
                                })
                            
                            
                            task.resume()
                        }
                        else{
                            alertuser = false
                            showAlert = true
                        }
                    
                    }){
                        Text("Confirmar Alterações")
                            .font(.callout)
                            .foregroundColor(.white)
                            .frame(width: 250, height: 50)
                            .bold()
                            .background(Color.orange)
                            .cornerRadius(30)
                            
                    }
                    .alert(isPresented: $showAlert, content: {
                        if(alertuser == true){
                            Alert(title: Text("Sucesso!"), message: Text("Track alterada com sucesso."))
                        }else{
                            Alert(title: Text("Erro!"), message: Text("Nao foi possivel alterar a Track."))
                        }
                        
                    })
                    .offset(y: 100)
                }
                .offset(y: -100)
               
            }.onAppear(perform: {
                loadData()
            })
            
        }
        
        
    }
    
    
    func loadData() {
        //created NSURL
        let requestURL = URL(string: URL_GET_TRACKBYID)
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        //creating the post parameter by concatenating the keys and values from text field
        let postParameters = "id=\(TrackPicked)"
        
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
                            //print(UserID)
                            if(TrackPicked == 0){
                                nomesessao = "Erro!"
                            }else if(jsonResponse["nome"] as! String != ""){
                                nomesessao = jsonResponse["nome"] as! String
                                sala = jsonResponse["sala"] as! String
                                autores = jsonResponse["autores"] as! String
                                
                                let dataformat = "dd/MM/YY"
                                let horaformat = "HH:mm:ss"

                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = dataformat

                                let horaFormatter = DateFormatter()
                                horaFormatter.dateFormat = horaformat

                                let datapass = jsonResponse["data"] as! String
                                let horapass = jsonResponse["hora"] as! String

                                if let dataDate = dateFormatter.date(from: datapass + horapass){
                                    self.data = dataDate
                                } else {
                                    print("Error: Unable to convert datapass to date.")
                                }

                                
                                if let titles = jsonResponse["titulo"] as? String {
                                    articles = titles.components(separatedBy: ",")
                                } else {
                                    print("Error: Unable to retrieve titles from JSON response.")
                                }
                                descrição = jsonResponse["texto"] as! String
                                
                            }
                            
                        } else {
                            print("Error: JSON parsing failed.")
                        }
                    } catch {
                        print("Error: JSON serialization failed.")
                    }
                    
                })
                
            })
        
        
        
        task.resume()
    }
}

#Preview {
    
    alterarsessao()
    
}
