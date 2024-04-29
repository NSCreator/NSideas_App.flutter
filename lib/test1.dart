

class AddressConvertor {
  final String street1;
  final String id;
  final String street2;
  final String city;
  final String state;
  final String zip;
  final String country;
  final String nearBy;
  final String phone;
  bool defaultVal; // Updated to not be final

  AddressConvertor({
    required this.street1,
    required this.id,
    this.street2 = '',
    required this.city,
    required this.state,
    required this.zip,
    required this.nearBy,
    required this.country,
    required this.phone,
    this.defaultVal = false, // Updated to not be final
  });

  Map<String, dynamic> toJson() {
    return {
      "street1": street1,
      "id": id,
      "street2": street2,
      "nearBy": nearBy,
      "city": city,
      "state": state,
      "zip": zip,
      "country": country,
      "phone": phone,
      "default": defaultVal,
    };
  }

  static AddressConvertor fromJson(Map<String, dynamic> json) {
    return AddressConvertor(
      id: json['id'] ?? "",
      street1: json['street1'] ?? "",
      nearBy: json['nearBy'] ?? "",
      street2: json['street2'] ?? '',
      city: json['city'] ?? "",
      state: json['state'] ?? "",
      zip: json['zip'] ?? "",
      country: json['country'] ?? "",
      phone: json['phone'] ?? "",
      defaultVal: json['default'] ?? false,
    );
  }

  static List<AddressConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }

  // // Encrypt data
  // String encryptData(String data,  key1) {
  //   final key = encrypt.Key.fromUtf8(key1);
  //
  //   final iv = IV.fromSecureRandom(16);
  //
  //   final encrypter = Encrypter(AES(key));
  //   final encrypted = encrypter.encrypt(data, iv: iv);
  //
  //   return encrypted.base64;
  // }
  //
  // // Decrypt data
  // String decryptData(String encryptedData,  key1) {
  //   final key = encrypt.Key.fromUtf8(key1);
  //
  //   final iv = IV.fromSecureRandom(16);
  //
  //   final encrypter = Encrypter(AES(key));
  //   final decrypted = encrypter.decrypt64(encryptedData, iv: iv);
  //
  //   return decrypted;
  // }
}

//
// void main1() {
//   final plainText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
//
//   final key = Key.fromUtf8(EncryptionData.encryptionKe);
//
//   final iv = IV.fromUtf8(EncryptionData.encryptionIV);
//   final encrypter = Encrypter(AES(key));
//
//   final encrypted = encrypter.encrypt(plainText, iv: iv);
//   String es = encrypted.base64;
//   final decrypted = encrypter.decrypt64(es, iv: iv);
//
//   print(decrypted);
//   print(encrypted.bytes);
//   print(encrypted.base16);
//   print(encrypted.base64);
// }
// class EncryptionData {
//   encryptionKey(){
//     String inputString = "YXmJkyGnqghzsgKrzOdootCK";
//     String outputString = "";
//
//     if (inputString.length >= 24) {
//       for (int i = 0; i < 24; i++) {
//         outputString += inputString[i];
//       }
//     } else {
//       int iterations = (24 / inputString.length).ceil();
//       for (int j = 0; j < iterations; j++) {
//         for (int i = 0; i < inputString.length && outputString.length < 24; i++) {
//           outputString += inputString[i];
//         }
//       }
//     }
//
//     print(outputString);
//   }
//   static const encryptionKe = "YXmJkyGnqghzsgKrzOdootCKlmkkkk";
//   static const encryptionIV = "Hkald6&ksl#usk9@";
// }
