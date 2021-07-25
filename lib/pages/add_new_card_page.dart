import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:movie_booking_app/resources/strings.dart';
import 'package:movie_booking_app/widgets/add_new_card_title.dart';
import 'package:movie_booking_app/widgets/general_text_field_view.dart';
import 'package:movie_booking_app/widgets/label_title.dart';
import 'package:pattern_formatter/numeric_formatter.dart';

class AddNewCardPage extends StatelessWidget {
  final cardNumberController = TextEditingController();
  final cardHolderController = TextEditingController();
  final expirationDateController = TextEditingController();
  final cvcController = TextEditingController();

  final Function(String, String, String, String) addNewCardFunc;

  AddNewCardPage(this.addNewCardFunc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.chevron_left,
            color: Colors.black,
            size: ICON_MEDIUM_2,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(
            top: MARGIN_MEDIUM_2,
            left: MARGIN_MEDIUM_2,
            right: MARGIN_MEDIUM_2,
            bottom: MediaQuery.of(context).viewInsets.bottom + MARGIN_XLARGE,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabelTitle(CARD_NUMBER_TITLE),
              CreditCardNumberTextFieldView(cardNumberController: cardNumberController),
              SizedBox(
                height: MARGIN_MEDIUM_2,
              ),
              LabelTitle(CARD_HOLDER_TITLE),
              GeneralTextFieldView(cardHolderController),
              SizedBox(
                height: MARGIN_MEDIUM_2,
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 2.3 / 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelTitle(EXPIRATION_DATE_TITLE),
                        GeneralTextFieldView(expirationDateController,),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: MARGIN_MEDIUM_2),
                    width: MediaQuery.of(context).size.width * 2.3 / 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelTitle(CVC_TITLE),
                        GeneralTextFieldView(cvcController),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: MARGIN_XLARGE,
              ),
              TextButton(
                onPressed: () {
                  addNewCardFunc(
                    cardNumberController.text,
                    cardHolderController.text,
                    expirationDateController.text,
                    cvcController.text,
                  );
                  Navigator.pop(context);
                },
                child: AddNewCardTitle(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreditCardNumberTextFieldView extends StatelessWidget {
  const CreditCardNumberTextFieldView({
    Key key,
    @required this.cardNumberController,
  }) : super(key: key);

  final TextEditingController cardNumberController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorHeight: MARGIN_LARGE,
      controller: cardNumberController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(19),
        CreditCardFormatter(),
      ],
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: MARGIN_MEDIUM),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: SECONDARY_TEXT_COLOR),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: SECONDARY_TEXT_COLOR),
        ),
      ),
      cursorColor: PRIMARY_COLOR,
    );
  }
}
