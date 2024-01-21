import SwiftUI
import MessageUI

var emailMail = ""
var perguntaMail = ""

struct questao: View {
    @State private var nomesessao: String = "";
    @State private var email: String = "";
    @State private var questao: String = "";
    @State private var nr_artigo: String = String(TrackPicked);
    @State private var isChecked: Bool = false;
    @State private var showAlert: Bool = false;
    @State public var alertuser = false;
    @State private var showingMailView = false
    
    let URL_GETUSERBYID = "\(API)/getuserbyid.php"
    let URL_CREATE_PERGUNTA = "\(API)/createPergunta.php"
    
    
    
    var body: some View{
        
        ZStack{
            Color(.orange).ignoresSafeArea();
            
            Circle()
                .scale(1.7)
                .foregroundColor(.white.opacity(0.15))
            Circle()
                .scale(1.3)
                .foregroundColor(.white)
            
            VStack{
                
                
                
                Color("Default").ignoresSafeArea();
                
                Text ("Coloque a sua questão!")
                
                    .foregroundColor(.black)
                    .bold()
                    .font(.system(size: 33))
                    .offset(y: 100)
                
                VStack{
                    Text("Nome de Usuário:")
                        .bold()
                        .offset(CGSize(width: -70.0, height: 100.0))
                        .padding()
                    TextField ("", text: $nomesessao)
                        .padding()
                        .font(.callout)
                        .foregroundColor(.black)
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(5)
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                        .offset(y:90)
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    
                }
                
                .padding()
                
                VStack{
                    Text("Email:")
                        .bold()
                        .offset(CGSize(width: -120.0, height: 10.0))
                        .padding()
                    TextField ("", text: $email)
                        .padding()
                        .font(.callout)
                        .foregroundColor(.black)
                        .frame(width: 300, height: 50)
                        .cornerRadius(5)
                        .background(Color.black.opacity(0.05))
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                    
                }
                .offset(x:0,y:60)
                
                VStack{
                    Text("Track -->")
                        .bold()
                        .offset(x:-105.0 , y: 170.0)
                        .padding()
                    TextField ("", text: $nr_artigo)
                        .padding()
                        .disabled(true)
                        .font(.callout)
                        .foregroundColor(.black)
                        .frame(width: 60, height: 50)
                        .background(Color.black.opacity(0.05))
                        .border(Color.black)
                        .offset(x:-20,y:110)
                    
                    
                    
                }
                .offset(y:-100)
                
                .padding()
                VStack{
                    Text("Questão:")
                        .bold()
                        .offset(CGSize(width: -110.0, height: -50.0))
                        .padding()
                        .offset(x:0,y:120)
                    
                    ScrollView {
                        TextEditor(text: $questao)
                            .frame(width: 300, height: 1000)
                            .background(Color.black.opacity(0.05))
                        
                    }
                    .frame(height:200)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                    .offset(x:0,y:60)
                    
                }
                .offset(y:-100)
                
                .padding()
                
                CheckBox(isChecked: $isChecked)
                    .offset(CGSize(width: -140.0, height: -30.0))
                Text("Deseja receber uma cópia via email?")
                    .offset(CGSize(width: 12.0, height: -50.0))
                
                
            }
            
            .offset(y: -30)
            
            Button (action: {
                
                //created NSURL
                let requestURL = URL(string: URL_CREATE_PERGUNTA)
                
                //creating NSMutableURLRequest
                let request = NSMutableURLRequest(url: requestURL! as URL)
                
                //setting the method to post
                request.httpMethod = "POST"

                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                
                let postParameters = "nome=\($nomesessao.wrappedValue)&email=\($email.wrappedValue)&idTrack=\(TrackPicked)&pergunta=\($questao.wrappedValue)"
                
                //adding the parameters to request body
                request.httpBody = postParameters.data(using: String.Encoding.utf8)
                if($email.wrappedValue != ""){
                    //creating a task to send the post request
                    let task = URLSession.shared.dataTask(
                        with: request as URLRequest,
                        completionHandler: { data, response, error in
                            DispatchQueue.main.async(execute:{
                                do {
                                    if let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                                        print("JSON response: \(jsonResponse)")
                                        if(jsonResponse["error"] as! Int == 0){
                                            if(isChecked == true){
                                                emailMail = $email.wrappedValue
                                                perguntaMail = $questao.wrappedValue
                                                print(emailMail)
                                                print(perguntaMail)
                                                showingMailView = true
                                            }

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
                else{
                    alertuser = false
                    showAlert = true
                }
                
                
            }) {
                
                Text ("Submeter")
                
                    .font(.callout)
                
                    .foregroundColor(.white)
                
                    .frame(width: 200, height: 28)
                
                    .background (Color.black.opacity(0.80))
                
                    .cornerRadius(30)
            }
            .alert(isPresented: $showAlert, content: {
                if(alertuser == true){
                    Alert(title: Text("Sucesso!"), message: Text("Pergunta criada com sucesso."))
                }else{
                    Alert(title: Text("Erro!"), message: Text("Nao foi possivel criar a pergunta."))
                }
                
            })
            .offset(x:0 , y:370)
            
        }
        .onAppear(perform: {
            loadData()
        })
        
    }
    
    
    func loadData() {
        //created NSURL
        let requestURL = URL(string: URL_GETUSERBYID)
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        //creating the post parameter by concatenating the keys and values from text field
        let postParameters = "user_id=\(UserID)"
        
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
                            }else if(jsonResponse["user_name"] as! String != ""){
                                nomesessao = jsonResponse["user_name"] as! String
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


struct MailView: UIViewControllerRepresentable {
    @Binding var result: Bool

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var result: Bool

        init(result: Binding<Bool>) {
            _result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
            self.result = true
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = context.coordinator
        viewController.setToRecipients(["\(emailMail)"])
        viewController.setSubject("Pergunta")
        viewController.setMessageBody("\(perguntaMail)", isHTML: true)
        return viewController
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) {
        // Nothing to do here
    }
}

#Preview {
    questao()
}
