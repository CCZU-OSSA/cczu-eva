import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:cczu_eva/fields.dart';
import 'package:cczu_eva/type.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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

  Future<List<EvalutionEntry>> listTiles() async {
    var selector = BeautifulSoup(
        (await client.get("$baseUrl/web_jxpj/jxpj_xspj_kcxz.aspx")).data);

    return selector.findAll("tr", class_: "dg1-item").indexed.map((item) {
      var tds = item.$2.findAll("td");
      var entry = EvalutionEntry(
        name: tds[4].text,
        score: tds[9].text,
        teacher: tds[6].text,
        state: tds[7].text,
        order: item.$1,
        evaType: tds[8].text,
      );
      return entry;
    }).toList();
  }

  Future<String?> getEvalutionUrl(int order) async {
    var selector = BeautifulSoup(
        (await client.get("http://202.195.102.53/web_jxpj/jxpj_xspj_kcxz.aspx"))
            .data);

    var raw = (await client.post(
            "http://202.195.102.53/web_jxpj/jxpj_xspj_kcxz.aspx",
            data: FormData.fromMap(EvalutionUrlQuery(
                    order: order,
                    state: ASPSessionState.fromElement(
                        selector.find("form", id: "form1")!))
                .toMap())))
        .data
        .toString();
    var pattern = RegExp(r"(?<=top.winhtml\('..)\S+(?=\))");
    var matchs = pattern.stringMatch(raw);
    if (matchs != null) {
      return baseUrl + matchs.split(",")[0].replaceAll("'", "");
    }
    return null;
  }

  void evaluate(String evaUrl, OverallRating rating, String? comment,
      [Function(Response response)? callback]) async {
    debugPrint(evaUrl);
    var state = ASPSessionState.fromBeautifulSoup(
        BeautifulSoup((await client.get(evaUrl)).data));
    client
        .post(evaUrl,
            data: FormData.fromMap(EvalutionData(
              comment: comment ?? "",
              rating: rating,
              state: state,
            ).toMap()))
        .then(callback ?? (_) {});
  }
}
