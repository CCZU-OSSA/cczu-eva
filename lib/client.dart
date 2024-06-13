import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:cczu_eva/fields.dart';
import 'package:cczu_eva/type.dart';
import 'package:dio/dio.dart';

var urlpattern = RegExp(r"(?<=top.winhtml\('..)\S+(?=\))");

class EVAClient {
  final String username;
  final String password;
  final Dio client = Dio(BaseOptions(validateStatus: (status) {
    return status != null && status < 400;
  }));
  EVAClient({
    required this.username,
    required this.password,
  });

  Future<bool> login() async {
    client.options.headers["User-Agent"] =
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36 Edg/126.0.0.0";

    var selector = BeautifulSoup((await client.get(baseUrl)).data);
    var resp = await client.post(baseUrl,
        data: FormData.fromMap(ASPSessionState.fromBeautifulSoup(selector)
            .loginData(username, password)),
        options: Options(
          followRedirects: false,
        ));

    if (resp.statusCode == 302) {
      client.options.headers["cookie"] = resp.headers["set-cookie"];
    }
    return resp.statusCode == 302;
  }

  Future<List<EvaluationEntry>> listTiles() async {
    var selector = BeautifulSoup(
        (await client.get("$baseUrl/web_jxpj/jxpj_xspj_kcxz.aspx")).data);

    return selector.findAll("tr", class_: "dg1-item").indexed.map((item) {
      var tds = item.$2.findAll("td");
      var entry = EvaluationEntry(
        name: tds[4].text,
        score: tds[9].text,
        teacher: tds[6].text,
        state: tds[7].text,
        order: item.$1,
      );
      return entry;
    }).toList();
  }

  Future<String?> getEvaluationUrl(int order) async {
    var selector = BeautifulSoup(
        (await client.get("$baseUrl/web_jxpj/jxpj_xspj_kcxz.aspx")).data);

    var raw = (await client.post("$baseUrl/web_jxpj/jxpj_xspj_kcxz.aspx",
            data: FormData.fromMap(EvaluationUrlQuery(
                    order: order,
                    state: ASPSessionState.fromElement(
                        selector.find("form", id: "form1")!))
                .toMap())))
        .data
        .toString();
    var matchs = urlpattern.stringMatch(raw);
    if (matchs != null) {
      return baseUrl + matchs.split(",")[0].replaceAll("'", "");
    }
    return null;
  }

  Future<void> evaluate(
      String evaUrl, Rating rating, String? comment, PartRatings parts,
      [Function(Response response)? callback]) async {
    var state = ASPSessionState.fromBeautifulSoup(
        BeautifulSoup((await client.get(evaUrl)).data));
    client
        .post(evaUrl,
            data: FormData.fromMap(EvaluationData(
              comment: comment ?? "",
              rating: rating,
              parts: parts,
              state: state,
            ).toMap()))
        .then(callback ?? (_) {});
  }
}
