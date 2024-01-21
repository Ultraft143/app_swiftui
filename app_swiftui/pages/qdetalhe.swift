import SwiftUI

struct qdetalhe: View {
    @State private var usuarios: String = "";
    @State private var artigo: String = "";
    @State private var questao: String = "";
    
    let URL_GET_PERGUNTAID = "\(API)/getPerguntabyID.php"
    
    var body: some View{
        
        ZStack {
            
            VStack{
                Text("Nome de usuário:")
                    .bold()
                    .offset(x:-80,y:-170)
                    .padding()
                TextField ("Usuário", text: $usuarios)
                    .padding()
                    .disabled(true)
                    .font(.callout)
                    .foregroundColor(.black)
                    .frame(width: 200, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(5)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                    .offset(x:-50, y:-180)
                
            }
            .offset(y:-60)
            .padding()
            
            VStack{
                Text("Track:")
                    .bold()
                    .offset(x:-120,y:-20)
                    .padding()
                TextField ("Artigo:", text: $artigo)
                    .disabled(true)
                    .padding()
                    .font(.callout)
                    .foregroundColor(.black)
                    .frame(width: 200, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(5)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                    .offset(x:-50, y:-30)
            }
            .offset(y:-100)
            .padding()
            
            
            VStack{
                Text("Questão:")
                    .bold()
                    .offset(x:-110,y:170)
                    .padding()
                
                
                ScrollView {
                    TextEditor(text: $questao)
                        .frame(width: 300, height: 1000)
                        .background(Color.black.opacity(0.05))
                    
                }
                .frame(height:250)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                .offset(x:0,y:170)
            }
            .offset(y:-70)

            
        }
        .onAppear(perform: {
            loadData()
        })
    }
    
    func loadData() {
        //created NSURL
        let requestURL = URL(string: URL_GET_PERGUNTAID)
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        //creating the post parameter by concatenating the keys and values from text field
        let postParameters = "id=\(PerguntaID)"
        
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
                            if(PerguntaID == ""){
                                usuarios = "Erro!"
                            }else if(jsonResponse["nome"] as! String != ""){
                                usuarios = jsonResponse["nome"] as! String
                                artigo = jsonResponse["idTrack"] as! String
                                questao = jsonResponse["pergunta"] as! String
 
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
    qdetalhe()
}
