import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _discriptionFocusNode = FocusNode();
  /* to have our own image controller */
  final _imageUrlController = TextEditingController();

  /* to avoid memory leak due to the focus nodes, we should always dispose focus after using them. */
  @override
  void dispose() {
    _priceFocusNode.dispose();
    _discriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Product',
        ),
      ),
      /* we are using Form instead of textediting controller, because using Form is lot more easy and efficient way. */
      body: Padding(
        padding: EdgeInsets.all(
          15,
        ),
        child: Form(
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                /**the below will determine what the button in the keyboard bottom right should be. */
                textInputAction: TextInputAction.next,
                /**the below will make sure the next focus will be as mentioned. */
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(
                    _priceFocusNode,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                /**the below will determine what the button in the keyboard bottom right should be. */
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                /**this will make get this field into focus, when the user clicks on the next button in the keyboard. */
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(
                    _discriptionFocusNode,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                /** below we are determining how long the input text should be. */
                maxLines: 3,
                /**the below will determine what the button in the keyboard bottom right should be. */
                keyboardType: TextInputType.multiline,
                /**the below will make sure the next focus will be as mentioned. */ focusNode:
                    _discriptionFocusNode,
              ),
              Row(
                children: <Widget>[
                  /** we will show the preview of the image, whose URL will be entered in the textformfield. */
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: Container(),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Image URL',
                    ),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    controller: _imageUrlController,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// onEditingComplete: () {
//       setState(() {});
//     },
