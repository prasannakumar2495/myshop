import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/providers/products_provider.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/editproductscreen';
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  var _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

//this is run, when the screen opens.
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String?;
      if (productId != null) {
        final product = Provider.of<Products>(
          context,
          listen: false,
        ).findById(productId);
        _editedProduct = product;
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    super.dispose();
  }

  String imageUrlListener() {
    var data = '';
    setState(() {
      data = _imageUrlController.text;
    });
    return data;
  }

  void _saveForm() {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false).updateProduct(
        _editedProduct.id!,
        _editedProduct,
      );
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }
    debugPrint(_editedProduct.title);
    Navigator.of(context).pop(); //Moving to the back page.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: (() => _saveForm()),
            icon: const Icon(Icons.save),
          ),
        ],
        title: const Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues['title'],
                decoration: const InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a value.';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    title: newValue!,
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: const InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType:
                    const TextInputType.numberWithOptions(signed: true),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a price.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Price should be more than 0';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    price: double.parse(newValue!),
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the description.';
                  }
                  if (value.length <= 10) {
                    return 'Description should be more than 10 characters.';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    title: _editedProduct.title,
                    description: newValue!,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isNotEmpty
                        ? FittedBox(
                            fit: BoxFit.cover,
                            child: Image.network(_imageUrlController.text),
                          )
                        : const Text('Enter a URL'),
                  ),
                  //https://cdn.pixabay.com/photo/2015/10/27/08/51/autumn-1008520__480.png
                  Expanded(
                    child: TextFormField(
                      /**
                       * We should not use "initialValue" and "controller" together.
                       */
                      //initialValue: _initValues['imageUrl'],
                      decoration: const InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      onFieldSubmitted: (value) => _saveForm(),
                      onChanged: (value) {
                        imageUrlListener();
                        debugPrint(_imageUrlController.text);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the URL.';
                        }
                        if (!value.startsWith('http') ||
                            !value.startsWith('https')) {
                          return 'Please enter a valid URL.';
                        }
                        // if (!value.endsWith('.png') ||
                        //     !value.endsWith('jpg') ||
                        //     !value.endsWith('jpeg')) {
                        //   return 'Please enter a valid image URL.';
                        // }
                        return null;
                      },
                      onSaved: (newValue) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: newValue!,
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
