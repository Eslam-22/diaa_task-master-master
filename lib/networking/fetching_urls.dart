import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RequestModel {
  int native;
  List<String> allow;

  RequestModel({this.native, this.allow});

  RequestModel.fromJson(Map<String, dynamic> json) {
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


