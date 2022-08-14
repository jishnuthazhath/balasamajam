import 'package:balasamajam/components/template.dart';
import 'package:balasamajam/configs/local_theme_data.dart';
import 'package:balasamajam/responsive.dart';
import 'package:balasamajam/screens/enquiry/maranasamidhi_personal_enquiry.dart';
import 'package:balasamajam/screens/pirivu/pirivu_details.dart';
import 'package:flutter/material.dart';

class MaranasamidhiHome extends StatelessWidget {
  const MaranasamidhiHome({super.key});

  static const String routeName = "MaranasamidhiHome";

  @override
  Widget build(BuildContext context) {
    return Template(
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: Responsive.blockSizeHorizontal * 800,
            height: Responsive.blockSizeVertical * 100,
            child: ElevatedButton(
                onPressed: () => _pirivu_details(context),
                style: LocalThemeData.buttonPrimartColor,
                child: Text("Pirivu Vivarangal",
                    style: LocalThemeData.buttonText)),
          ),
          SizedBox(height: Responsive.blockSizeVertical * 30),
          SizedBox(
            width: Responsive.blockSizeHorizontal * 800,
            height: Responsive.blockSizeVertical * 100,
            child: ElevatedButton(
                onPressed: () => _personal_enquiry(context),
                style: LocalThemeData.buttonPrimartColor,
                child:
                    Text("Personal Enquiry", style: LocalThemeData.buttonText)),
          ),
          SizedBox(height: Responsive.blockSizeVertical * 30),
          SizedBox(
            width: Responsive.blockSizeHorizontal * 800,
            height: Responsive.blockSizeVertical * 100,
            child: ElevatedButton(
                onPressed: () => _chilav_details(context),
                style: LocalThemeData.buttonPrimartColor,
                child: Text("Chilav Vivarangal",
                    style: LocalThemeData.buttonText)),
          ),
        ],
      )),
    );
  }

  _pirivu_details(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PirivuDetails(title: 'Maranasamidhi')));
  }

  _personal_enquiry(BuildContext context) {
    Navigator.pushNamed(context, MaranasamidhiPersonalEnquiry.routeName);
  }

  _chilav_details(BuildContext context) {}
}