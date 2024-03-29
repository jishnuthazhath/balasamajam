import 'package:balasamajam/components/full_page_header.dart';
import 'package:balasamajam/components/template.dart';
import 'package:balasamajam/configs/local_theme_data.dart';
import 'package:balasamajam/configs/shared_state.dart';
import 'package:balasamajam/constants/api_constants.dart';
import 'package:balasamajam/general/models/request_base_model.dart';
import 'package:balasamajam/general/models/response_base_model.dart';
import 'package:balasamajam/network/api_enums.dart';
import 'package:balasamajam/network/api_helper.dart';
import 'package:balasamajam/network/api_service.dart';
import 'package:balasamajam/responsive.dart';
import 'package:balasamajam/screens/maranasamidhi/expense/add/models/add_expense_request_model.dart';
import 'package:balasamajam/screens/maranasamidhi/expense/add/models/add_expense_response_model.dart';
import 'package:balasamajam/screens/maranasamidhi/expense/expense_type.dart';
import 'package:balasamajam/utils/common_api_helper.dart';
import 'package:balasamajam/utils/models/member_response_model.dart';
import 'package:balasamajam/utils/on_screen_message_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  static const String routeName = "AddExpense";

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController dateController = TextEditingController();
  ExpenseType selectedExpenseType = ExpenseType.MARANAM;

  List<DropdownMenuItem<String>> membersDropList = [];

  String? snackBarMessage;

  String? description;
  String? memberId;
  double? amount;
  //String? dateOfDeath;
  String? notes;
  String? addedByAdminId;
  ExpenseType? expenseType;

  @override
  void initState() {
    DateTime now = DateTime.now();
    String formattedNow = DateFormat("dd/MM/yyyy").format(now);
    dateController.text = formattedNow;
    addedByAdminId = _getAdminIdFromState();
    _populateMembersDropList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FullPageHeader(showBackButton: true),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50))),
              padding: EdgeInsets.symmetric(
                  horizontal: Responsive.blockSizeHorizontal * 50,
                  vertical: Responsive.blockSizeVertical * 50),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Add Expense",
                            style: LocalThemeData.subTitle)),
                    const Divider(thickness: 2),
                    DropdownButtonFormField(
                      value: ExpenseType.MARANAM,
                      onSaved: (newValue) {
                        expenseType = newValue;
                      },
                      decoration: InputDecoration(
                          hintText: "Expense Type",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      items: _getExpenseTypes(),
                      onChanged: (value) {
                        setState(() {
                          selectedExpenseType = value!;
                        });
                      },
                    ),
                    SizedBox(height: Responsive.blockSizeVertical * 10),
                    TextFormField(
                      onSaved: (newValue) {
                        description = newValue!;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: selectedExpenseType == ExpenseType.MARANAM
                              ? "Name"
                              : "Description of the Expense"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Description cannot be empty";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: Responsive.blockSizeVertical * 10),
                    if (selectedExpenseType == ExpenseType.MARANAM)
                      DropdownButtonFormField(
                        onSaved: (newValue) {
                          memberId = newValue;
                        },
                        decoration: InputDecoration(
                            hintText: "Relative Of",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        items: membersDropList,
                        onChanged: (value) {},
                      ),
                    SizedBox(height: Responsive.blockSizeVertical * 10),
                    TextFormField(
                      onSaved: (newValue) {
                        amount = double.parse(newValue!);
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: "Amount"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Amount cannot be empty";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: Responsive.blockSizeVertical * 10),
                    GestureDetector(
                      onTap: () async {
                        String dateString = await _showDatePicker();
                        setState(() {
                          dateController.text = dateString;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.symmetric(
                            horizontal: Responsive.blockSizeHorizontal * 20,
                            vertical: Responsive.blockSizeVertical * 20),
                        height: Responsive.blockSizeHorizontal * 150,
                        width: Responsive.blockSizeHorizontal * 900,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_outlined,
                              semanticLabel: "Select Date of expense",
                            ),
                            SizedBox(width: Responsive.blockSizeHorizontal * 5),
                            Text(
                              dateController.text,
                              style: LocalThemeData.labelTextB,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: Responsive.blockSizeVertical * 10),
                    TextFormField(
                        minLines: 1,
                        maxLines: 5,
                        maxLength: 100,
                        onSaved: (newValue) {
                          notes = newValue;
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Add Notes")),
                    SizedBox(
                      height: Responsive.blockSizeVertical * 50,
                      width: Responsive.blockSizeHorizontal * 500,
                      child: OutlinedButton(
                          style: ButtonStyle(backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (states) {
                            if (states.contains(MaterialState.disabled)) {
                              return Colors.grey;
                            }
                            return LocalThemeData.primaryColor;
                          })),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              _addExpenseRequest();
                            }
                          },
                          child:
                              Text("Submit", style: LocalThemeData.labelTextW)),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }

  String? _getAdminIdFromState() {
    String? id = SharedState.getSharedStateWithoutWait(
        LocalAppState.ADMIN_ID.toString());
    return id;
  }

  void _addExpenseRequest() async {
    AddExpenseRequestModel addExpenseRequestModel = AddExpenseRequestModel(
        description!,
        memberId,
        amount!,
        dateController.text,
        notes!,
        addedByAdminId!,
        expenseType!);

    final token =
        await SharedState.getSharedState(LocalAppState.TOKEN.toString());

    final json = RequestBaseModel.toJson(
        RequestBaseModel(token, addExpenseRequestModel),
        (value) => addExpenseRequestModel.toJson());

    final response = await APIService.sendRequest(
        requestType: RequestType.POST,
        url: APIConstants.addExpense,
        body: json);

    ResponseBaseModel? responseBaseModel = APIHelper.filterResponse(
        apiCallback: _apiCallback,
        response: response,
        apiOnFailureCallBackWithMessage: _apiOnFailureCallBackWithMessage);

    if (responseBaseModel != null && responseBaseModel.status == "OK") {
      OnScreenMessageUtil.showSnackBarBottom(
          responseBaseModel.message, context, OnScreenMessageUtil.GREEN);
      _formKey.currentState!.reset();
    }
  }

  Future<String> _showDatePicker() async {
    DateTime? datePicker = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    String formattedDate = dateController.text;

    if (datePicker != null) {
      formattedDate = DateFormat("dd/MM/yyyy").format(datePicker);
    }

    return formattedDate;
  }

  _apiCallback(json) {
    if (json != null) {
      ResponseBaseModel response = ResponseBaseModel.fromJson(
          json, (json) => AddExpenseResponseModel.fromJson);
      return response;
    }
    return null;
  }

  _apiOnFailureCallBackWithMessage(APIResponseErrorType type, String message) {
    OnScreenMessageUtil.showSnackBarBottom(
        message, context, OnScreenMessageUtil.RED);
    return null;
  }

  List<DropdownMenuItem<ExpenseType>> _getExpenseTypes() {
    return const [
      DropdownMenuItem(
        value: ExpenseType.MARANAM,
        child: Text("Maranam"),
      ),
      DropdownMenuItem(
        value: ExpenseType.OTHERS,
        child: Text("Others"),
      )
    ];
  }

  _populateMembersDropList() async {
    List<MemberResponseModel> members = await CommonApiHelper.getAllMembers();
    setState(() {
      for (var element in members) {
        membersDropList.add(DropdownMenuItem(
            value: element.memberId, child: Text(element.memberFullName)));
      }
    });
  }
}
