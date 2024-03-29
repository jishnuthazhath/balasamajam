import 'package:json_annotation/json_annotation.dart';

part 'fetch_payment_response_model.g.dart';

@JsonSerializable()
class FetchPaymentResponseModel {
  final String memberFullName;

  final String collectedByFullName;

  final double amount;

  final String paymentDate;

  FetchPaymentResponseModel(this.memberFullName, this.collectedByFullName,
      this.amount, this.paymentDate);

  factory FetchPaymentResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FetchPaymentResponseModelFromJson(json);
}
