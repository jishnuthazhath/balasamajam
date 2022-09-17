import 'package:balasamajam/components/long_card.dart';
import 'package:balasamajam/components/table_component.dart';
import 'package:balasamajam/components/template.dart';
import 'package:balasamajam/configs/local_theme_data.dart';
import 'package:balasamajam/configs/shared_state.dart';
import 'package:balasamajam/constants/api_constants.dart';
import 'package:balasamajam/network/api_enums.dart';
import 'package:balasamajam/network/api_service.dart';
import 'package:balasamajam/responsive.dart';
import 'package:balasamajam/screens/expense/expense_entry.dart';
import 'package:balasamajam/screens/payment/payment_history.dart';
import 'package:flutter/material.dart';

class MaranasamidhiPersonalEnquiry extends StatefulWidget {
  const MaranasamidhiPersonalEnquiry({super.key});

  static const String routeName = "MaranasamidhiPersonalEnquiry";

  @override
  State<MaranasamidhiPersonalEnquiry> createState() =>
      _MaranasamidhiPersonalEnquiryState();
}

class _MaranasamidhiPersonalEnquiryState
    extends State<MaranasamidhiPersonalEnquiry> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Template(
        child: Center(
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          GestureDetector(
            onTap: _addPayment,
            child: Container(
              decoration: BoxDecoration(
                  border:
                      Border.all(color: LocalThemeData.primaryColor, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              padding: EdgeInsets.symmetric(
                  horizontal: Responsive.blockSizeHorizontal * 20,
                  vertical: Responsive.blockSizeVertical * 10),
              child: Text("Add Payment", style: LocalThemeData.subTitle),
            ),
          )
        ]),
        SizedBox(height: Responsive.blockSizeVertical * 100),
        Text("Maranasamidhi - Personal Enquiry",
            style: LocalThemeData.subTitle),
        SizedBox(height: Responsive.blockSizeVertical * 30),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            width: Responsive.blockSizeHorizontal * 500,
            height: Responsive.blockSizeVertical * 45,
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Name',
                contentPadding: EdgeInsets.all(10),
              ),
            ),
          ),
          SizedBox(width: Responsive.blockSizeHorizontal * 10),
          ElevatedButton(
              onPressed: () => _fetchMemberDetails,
              style: LocalThemeData.buttonPrimartColor,
              child: Text("Go", style: LocalThemeData.buttonText)),
        ]),
        SizedBox(height: Responsive.blockSizeVertical * 100),
        Align(
            alignment: Alignment.centerLeft,
            child: Text("Mudakkamulla Thuga", style: LocalThemeData.subTitle)),
        TableComponent(
            headers: _getHeaders(),
            data: _getData(),
            rowClickCallback: rowOnClick),
        SizedBox(height: Responsive.blockSizeVertical * 50),
        LongCard(
          mainText: "View Payment History",
          callBack: () => _paymentHistory(),
        )
      ]),
    ));
  }

  List<String> _getHeaders() {
    return ["Maranavari", "Masavari", "Total"];
  }

  List<List<String>> _getData() {
    return [
      ["100 INR", "10 INR", "110"]
    ];
  }

  _paymentHistory() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentHistory(name: "Edward Cullen")));
  }

  void _addPayment() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ExpenseEntry(category: "Maranasamidhi")));
  }

  rowOnClick(row) {}

  _fetchMemberDetails() async {
    String searchText = searchController.text;
    Map<String, String> queryParams = {
      "token": await SharedState.getSharedState(LocalAppState.TOKEN.toString()),
      "key": searchText
    };
    final response = await APIService.sendRequest(
        requestType: RequestType.GET,
        url: APIConstants.searchMember,
        queryParams: queryParams);
  }
}
