import SwiftUI

enum PickerType: Identifiable {
    case photo,file
    
    var id: Int {
        hashValue
    }
}


struct sessao: View {
    @State private var nomesessao: String = "";
    @State private var sala: String = "";
    @State private var data = Date();
    @State private var hora: String = "";
    @State private var autores: String = "";
    @State private var descrição: String = "";
    @State var articles: [String] = Array(repeating: "", count: 10)
    @State private var actionSheetVisible = false
    @State private var pickerType: PickerType?
    @State private var selectedType: PickerType?
    @State private var selectedImage: UIImage?
    @State private var selectedDocument: Data?
    @State private var selectedDocumentName: String?
    @State private var selectedFilePath: URL?
    @State private var showAlert: Bool = false;
    @State public var alertuser = false;
    
    let URL_CREATE_TRACK = "\(API)/createTrack.php"
    
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
                
                Text ("Criar sessão")
                
                    .foregroundColor(.black)
                    .bold()
                    .font(.system(size: 56))
                    .offset(y: -20)
                
                
                
                TextField ("Nome da Sessão", text: $nomesessao)
                    .padding()
                    .font(.callout)
                    .foregroundColor(.black)
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(5)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                    .offset(x:0,y:-40)
                
                TextField ("Nome da Sala:", text: $sala)
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
                .frame(height:40)
                .offset(x:0,y:-60)
                VStack{
                    Text("Descrição:")
                        .bold()
                        .offset(x:-100,y:20)
                        .padding()
                    
                    
                    ScrollView {
                        TextEditor(text: $descrição)
                            .frame(width: 300, height: 1000)
                            .background(Color.black.opacity(0.05))
                        
                    }
                    .frame(height:150)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                    .offset(x:0,y:20)
                    
                    Button(action: {
                        
                        //created NSURL
                        let requestURL = URL(string: URL_CREATE_TRACK)
                        
                        //creating NSMutableURLRequest
                        let request = NSMutableURLRequest(url: requestURL! as URL)
                        
                        //setting the method to post
                        request.httpMethod = "POST"
                        //creating the post parameter by concatenating the keys and values from text field

                        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                        
                        let dateFormatter = DateFormatter()
                        let horaFormatter = DateFormatter()
                        
                        dateFormatter.dateFormat = "dd/MM/YY"
                        horaFormatter.dateFormat = "HH:mm:ss"
                        
                        let postParameters = "nome=\($nomesessao.wrappedValue)&texto=\($descrição.wrappedValue)&titulo=\($articles.wrappedValue)&autores=\($autores.wrappedValue)&descricao=\($descrição.wrappedValue)&sala=\($sala.wrappedValue)&data=\(dateFormatter.string(from: data))&hora=\(horaFormatter.string(from: data))&ficherio=\($selectedDocument)&foto=\($selectedImage)"
                        
                        //adding the parameters to request body
                        request.httpBody = postParameters.data(using: String.Encoding.utf8)
                        if($nomesessao.wrappedValue != ""){
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
                        Text("Criar")
                            .font(.callout)
                            .foregroundColor(.white)
                            .frame(width: 150, height: 50)
                            .bold()
                            .background(Color.orange)
                            .cornerRadius(30)
                            
                    }
                    .alert(isPresented: $showAlert, content: {
                        if(alertuser == true){
                            Alert(title: Text("Sucesso!"), message: Text("Track adicionada com sucesso."))
                        }else{
                            Alert(title: Text("Erro!"), message: Text("Nao foi possivel adicionar a Track."))
                        }
                        
                    })
                    .offset(y: 100)
                }
                .offset(y: -70)
                Text("Adicionar ficheiros ->")
                    .offset(x:-50,y:-80)
                VStack {
                    if (self.selectedType == .photo && self.selectedImage != nil) {
                        Text("selected image: ")
                        Image(uiImage: self.selectedImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:200, height: 200)
                    }
                    else if (self.selectedType == .file && self.selectedDocument != nil) {
                        Text("Document selected: " + self.selectedDocumentName!)
                    }
                }
                Button(action: {
                    self.actionSheetVisible = true
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.black)
                }
                .offset(x:70,y:-109)
                .confirmationDialog("Selecione o tipo", isPresented: self.$actionSheetVisible){
                    Button("Fotografia"){
                        self.pickerType = .photo
                        self.selectedType = .photo
                    }
                    Button("Ficheiro"){
                        self.pickerType = .file
                        self.selectedType = .file
                    }
                }
            }
            .sheet(item: self.$pickerType, onDismiss: { print("dismiss") }) { item in
                switch item {
                case .photo:
                    NavigationView {
                        ImagePicker(image: self.$selectedImage)
                    }
                case .file:
                    NavigationView {
                        DocumentPicker(filePath: $selectedFilePath, file: self.$selectedDocument, fileName: self.$selectedDocumentName)
                    }
                }
            }
            }
            
            
        }
        
        
    }



#Preview {
    sessao()
}
