import "package:http/http.dart" as http;

String baseURL = "https://apihomechef.antopolis.xyz/";

class CustomHttp {
  static const Map<String, String> defaultHeader = {
    "Accept": "application/json",
  };

  Future<String> loginUser(String email, String password) async {
    var link = "${baseURL}api/admin/sign-in";

    var map = Map<String, dynamic>();
    map = {"email": email, "password": password};

    var response =
        await http.post(Uri.parse(link), body: map, headers: defaultHeader);

    print(" ${response.body}");

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "Failed";
    }
  }
}
