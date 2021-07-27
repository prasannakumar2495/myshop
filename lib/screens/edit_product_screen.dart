import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myshop/providers/product.dart';
import 'package:myshop/providers/products.dart';
import 'package:provider/provider.dart';

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
  final _imageUrlFocusNode = FocusNode();

  /// we mentioned the input data type as formstate, bcz we are trying to submit the data that has been entered in the form fields.
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(
      _upadteImageURl,
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          /** we cannot use the below as initial value, because we are already using controller to access imageUrl. */
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  /* to avoid memory leak due to the focus nodes, we should always dispose focus after using them. */
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(
      _upadteImageURl,
    );
    _priceFocusNode.dispose();
    _discriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  void _upadteImageURl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    /** the save method is provided by default, to save the form widget. */
    _form.currentState.save();
    if (_editedProduct.id != null) {
      /**
       * this will only update the current product.
       */
      Provider.of<Products>(
        context,
        listen: false,
      ).updateProduct(
        _editedProduct.id,
        _editedProduct,
      );
    } else {
      /**
       * this logic will come into play only when a new product is to be created.
       */
      Provider.of<Products>(
        context,
        listen: false,
      ).addProduct(
        _editedProduct,
      );
    }
    /** 
    * print(_editedProduct.title);
    * print(_editedProduct.price);
    * print(_editedProduct.description);
    * print(_editedProduct.imageUrl); 
    */

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Product',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.save,
            ),
            onPressed: _saveForm,
          ),
        ],
      ),
      /* we are using Form instead of textediting controller, because using Form is lot more easy and efficient way. */
      body: Padding(
        padding: EdgeInsets.all(
          15,
        ),
        child: Form(
          /** we can access the data that has been entered in the form widget with the help of GlobalKey. */
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['title'],
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
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    isFavorite: _editedProduct.isFavorite,
                    id: _editedProduct.id,
                    title: value,
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
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
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a price.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  if (double.tryParse(value) <= 0) {
                    return 'Please enter a number greater than zero.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    isFavorite: _editedProduct.isFavorite,
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    price: double.parse(value),
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                /** below we are determining how long the input text should be. */
                maxLines: 3,
                /**the below will determine what the button in the keyboard bottom right should be. */
                keyboardType: TextInputType.multiline,
                /**the below will make sure the next focus will be as mentioned. */
                focusNode: _discriptionFocusNode,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a description.';
                  }
                  if (value.length < 10) {
                    return 'Descrition should be more than 10 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    isFavorite: _editedProduct.isFavorite,
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: value,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
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
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Image URL',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      /** we have created the below to make the app know that, when ever this particular field looses the focus, it has to check the URL entered in the field and display it in the priscibed place. */
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) => _saveForm(),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter an image URL.';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid URL';
                        }
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Please enter a valid image URL.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          isFavorite: _editedProduct.isFavorite,
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: value,
                        );
                      },
                    ),
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
