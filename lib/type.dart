import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/foundation.dart';

abstract interface class IntoMap {
  Map<String, dynamic> toMap();
}

@immutable
class EvaluationEntry {
  final int order;
  final String name;
  final String teacher;
  final String score;
  final String state;
  const EvaluationEntry({
    required this.name,
    required this.score,
    required this.teacher,
    required this.state,
    required this.order,
  });

  @override
  String toString() {
    return "EvaluationEntry $name $teacher $score $state $order";
  }
}

@immutable
class ASPSessionState implements IntoMap {
  final String? viewstate;
  final String? viewstategenerator;
  final String? viewstateencrypted;
  const ASPSessionState({
    this.viewstate,
    this.viewstategenerator,
    this.viewstateencrypted,
  });

  static ASPSessionState fromBeautifulSoup(BeautifulSoup selector) {
    return ASPSessionState(
      viewstate:
          selector.find("input", id: "__VIEWSTATE")?.getAttrValue("value"),
      viewstategenerator: selector
          .find("input", id: "__VIEWSTATEGENERATOR")
          ?.getAttrValue("value"),
      viewstateencrypted: "",
    );
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
      "__VIEWSTATEGENERATOR": viewstategenerator.toString(),
      "__VIEWSTATEENCRYPTED": "",
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
class EvaluationUrlQuery implements IntoMap {
  final ASPSessionState state;
  final int order;

  const EvaluationUrlQuery({required this.state, required this.order});

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

enum Rating { bad, normal, good, excellent }

typedef PartRatings = (
  Rating,
  Rating,
  Rating,
  Rating,
  Rating,
  Rating,
);

extension on Rating {
  String toEvaString() {
    return switch (this) {
      Rating.bad => "较差",
      Rating.normal => "一般",
      Rating.good => "较好",
      Rating.excellent => "很好",
    };
  }

  int toEvaPoint() {
    return switch (this) {
      Rating.bad => 40,
      Rating.normal => 60,
      Rating.good => 80,
      Rating.excellent => 100,
    };
  }
}

extension on PartRatings {
  (int, int, int, int, int, int) toPoints() {
    return (
      this.$1.toEvaPoint(),
      this.$2.toEvaPoint(),
      this.$3.toEvaPoint(),
      this.$4.toEvaPoint(),
      this.$5.toEvaPoint(),
      this.$6.toEvaPoint()
    );
  }
}

@immutable
class EvaluationData implements IntoMap {
  final ASPSessionState state;
  final String comment;
  final Rating rating;
  final PartRatings parts;

  const EvaluationData({
    required this.state,
    required this.comment,
    required this.rating,
    required this.parts,
  });

  @override
  Map<String, dynamic> toMap() {
    var points = parts.toPoints();
    return {
      "Txtyjjy": comment.isEmpty ? " " : comment,
      "DDztpj": rating.toEvaString(),
      "GVpjzb\$ctl02\$RaBxz": points.$1,
      "GVpjzb\$ctl03\$RaBxz": points.$2,
      "GVpjzb\$ctl04\$RaBxz": points.$3,
      "GVpjzb\$ctl05\$RaBxz": points.$4,
      "GVpjzb\$ctl06\$RaBxz": points.$5,
      "GVpjzb\$ctl07\$RaBxz": points.$6,
      "__EVENTTARGET": "",
      "__EVENTARGUMENT": "",
      "__LASTFOCUS": "",
      "__VIEWSTATEENCRYPTED": "",
      "__ASYNCPOST": true,
      "Button2": "保存评价"
    }..addAll(state.toMap());
  }
}
