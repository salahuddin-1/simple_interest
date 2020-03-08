import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Simple Interest Calculator App',
    home: SIForm(),
    theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.deepOrangeAccent,
        accentColor: Colors.deepOrangeAccent),
  ));
}

class SIForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SIFormState();
  }
}

class _SIFormState extends State<SIForm> {

  var _formkey = GlobalKey<FormState>();

  var _currencies = ['Rupees', 'Dollars', 'Pounds'];
  final _minimumPadding = 5.0;
  var _currentItemSelected = 'Rupees';
  var displayResult = '';

  TextEditingController principalController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController termController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.caption;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Simple Interest Calculator'),
      ),
      body: Form(
        key: _formkey,
        child: Padding(
            padding: EdgeInsets.all(_minimumPadding * 2),
            child: ListView(children: <Widget>[
              getImageAsset(),
              Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    style: textStyle,
                    controller: principalController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter principal amount';
                      }
                       else if(double.tryParse(value)==null) {
                        return 'Please enter a valid principal amount';

                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Principal',
                        hintText: 'Enter Principal e.g. 12000',
                        labelStyle: textStyle,
                        errorStyle: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 15.0,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: roiController,
                    style: textStyle,
                      validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter rate of interest';
                      }
                      else if(double.tryParse(value)==null) {
                        return 'Please enter a valid rate of interest';

                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Rate of Interest',
                        hintText: 'In percent',
                        labelStyle: textStyle,
                        errorStyle: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 15.0,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: TextFormField(
                        keyboardType: TextInputType.number,
                        style: textStyle,
                        controller: termController,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter a valid term';                            
                            }
                          else if(double.tryParse(value)==null) {
                            return 'Please enter a valid term';
                          
                        }  
                      },
                        
                        decoration: InputDecoration(
                            labelText: 'Term',
                            hintText: 'Time in years',
                            labelStyle: textStyle,
                            errorStyle: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 15.0,
                        ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )),
                      Container(width: _minimumPadding * 5),
                      Expanded(
                          child: DropdownButton<String>(
                        items: _currencies.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              textScaleFactor: 0.8,
                              ),
                            

                          );
                        }).toList(),
                        value: _currentItemSelected,
                        
                        onChanged: (String newValueSelected) {
                          _onDropDownItemSelected(newValueSelected);
                        },
                      )),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(
                    bottom: _minimumPadding, top: _minimumPadding),
                child: Row(children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      //color: Theme.of(context).textTheme,
                      //textColor: Theme.of(context).primaryColorDark,
                      child: Text(
                        'Calculate',
                        //textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_formkey.currentState.validate())
                          this.displayResult = _calculateTotalReturns();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RaisedButton(
                      //color: Theme.of(context).primaryColorDark,
                      //textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Reset',
                        //textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          _reset();
                        });
                      },
                    ),
                  ),
                ]),
              ),
              Center(
                  child: Padding(
                padding: EdgeInsets.all(_minimumPadding),
                child: Text(
                  this.displayResult,
                  style: textStyle,
                ),
              )),
            ])),
      ),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/lrb.png');
    Image image = Image(
      image: assetImage,
      width: 125.0,
      height: 125.0,
    );

    return Container(
      child: image,
      margin: EdgeInsets.all(_minimumPadding * 10.0),
    );
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }

  String _calculateTotalReturns() {
    double principal = double.parse(principalController.text);
    double roi = double.parse(roiController.text);
    double term = double.parse(termController.text);

    double totalAmountPayable = principal + (principal * roi * term) / 100;

    String result =
        'After $term years, your investment will be worth $totalAmountPayable  $_currentItemSelected';
    return result;
  }

  void _reset() {
    principalController.text = '';
    roiController.text = '';
    termController.text = '';
    displayResult = '';
    _currentItemSelected = _currencies[0];
  }
  
}
