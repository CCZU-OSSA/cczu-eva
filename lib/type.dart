import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/foundation.dart';

abstract interface class IntoMap {
  Map<String, dynamic> toMap();
}

@immutable
class EvalutionEntry {
  final int order;
  final String name;
  final String teacher;
  final String score;
  final String state;
  final String evaType;
  const EvalutionEntry({
    required this.name,
    required this.score,
    required this.teacher,
    required this.state,
    required this.order,
    required this.evaType,
  });

  @override
  String toString() {
    return "EvalutionEntry $name $teacher $score $state $order";
  }
}

@immutable
class ASPSessionState implements IntoMap {
  final String? viewstate;
  final String? viewstategenerator;
  const ASPSessionState({
    this.viewstate,
    this.viewstategenerator,
  });

  static ASPSessionState fromBeautifulSoup(BeautifulSoup selector) {
    return ASPSessionState(
        viewstate:
            selector.find("input", id: "__VIEWSTATE")?.getAttrValue("value"),
        viewstategenerator: selector
            .find("input", id: "__VIEWSTATEGENERATOR")
            ?.getAttrValue("value"));
  }

  static ASPSessionState fromElement(Bs4Element selector) {
    return ASPSessionState(
        viewstate:
            selector.find("input", id: "__VIEWSTATE")?.getAttrValue("value"),
        viewstategenerator: selector
            .find("input", id: "__VIEWSTATEGENERATOR")
            ?.getAttrValue("value"));
  }

  @override
  Map<String, String> toMap() {
    return {
      "__VIEWSTATE": viewstate.toString(),
      "__VIEWSTATEGENERATOR": viewstategenerator.toString()
    };
  }

  Map<String, String> loginData(String username, String password) {
    return {
      "username": username,
      "userpasd": password,
      "btLogin": "登录",
    }..addAll(toMap());
  }
}

@immutable
class EvalutionUrlQuery implements IntoMap {
  final ASPSessionState state;
  final int order;

  const EvalutionUrlQuery({required this.state, required this.order});

  @override
  Map<String, dynamic> toMap() {
    return {
      "__EVENTTARGET": "GVpjkc",
      "__EVENTARGUMENT": "Select\$$order",
      "__VIEWSTATEENCRYPTED": "",
      "__ASYNCPOST": true
    }..addAll(state.toMap());
  }
}

enum OverallRating { bad, normal, good, excellent }

@immutable
class EvalutionData implements IntoMap {
  final ASPSessionState state;
  final String comment;
  final OverallRating rating;

  const EvalutionData(
      {required this.state, required this.comment, required this.rating});

  @override
  Map<String, dynamic> toMap() {
    return {
      "Txtyjjy": comment.isEmpty ? " " : comment,
      "DDztpj": switch (rating) {
        OverallRating.bad => "较差",
        OverallRating.normal => "一般",
        OverallRating.good => "较好",
        OverallRating.excellent => "很好",
      },
      "GVpjzb\$ctl02\$RaBxz": 80,
      "GVpjzb\$ctl03\$RaBxz": 80,
      "GVpjzb\$ctl04\$RaBxz": 80,
      "GVpjzb\$ctl05\$RaBxz": 80,
      "GVpjzb\$ctl06\$RaBxz": 80,
      "GVpjzb\$ctl07\$RaBxz": 80,
      "__EVENTTARGET": "",
      "__EVENTARGUMENT": "",
      "__LASTFOCUS": "",
      "__VIEWSTATEENCRYPTED": "",
      "__ASYNCPOST": true,
      "Button2": "保存评价"
    }..addAll(state.toMap());
  }
}
