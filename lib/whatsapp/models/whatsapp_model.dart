class WhatsappModel {
  String phoneNumber;
  String message;

  WhatsappModel({required this.phoneNumber,required this.message});

  Map<String,dynamic>toJson(){
    return{
      "messaging_product": "whatsapp",
      "recipient_type": "individual",
      "to":phoneNumber,
      "type": "template",
      "template": {
        "name": "attenda",
        "language": {
          "code": "en_Us"
        },
        "components": [
          {
            "type": "body",
            "parameters": [
              {
                "type": "text",
                "text": message,
              }
            ]
          }
        ]
      }
    };
  }
}