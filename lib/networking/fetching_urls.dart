import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Statuse {
  int native;
  List<String> allow;

  Statuse({this.native, this.allow});

  Statuse.fromJson(Map<String, dynamic> json) {
    native = json['Native'];
    allow = json['Allow'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Native'] = this.native;
    data['Allow'] = this.allow;
    return data;
  }
}


