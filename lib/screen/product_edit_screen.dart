import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products_detail.dart';
import '../provider/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/product_edit_screen';
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusMode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _isInit = true;

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  var _editableProduct = Product(
    id: '',
    description: '',
    imageUrl: ' ',
    price: 0.0,
    title: '',
  );

  var _updateProduct = {
    'title': '',
    'description': '',
    'imageUrl': '',
    'price': '',
    'id': ''
  };

  @override
  void initState() {
    // TODO: implement initState
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit == true) {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        final productId = ModalRoute.of(context)?.settings.arguments as String;

        _editableProduct =
            Provider.of<Products>(context).findProductById(productId);
        _updateProduct = {
          'title': _editableProduct.title,
          'description': _editableProduct.description,
          'imageUrl': '',
          'price': _editableProduct.price.toString(),
          //'id': _editableProduct.id!,
        };
      }
    }
    _imageUrlController.text = _editableProduct.imageUrl;
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _priceFocusMode.dispose();
    _descriptionNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    super.dispose();
  }

  void _saveData() {
    _form.currentState?.validate();
    _form.currentState?.save();
    if (_editableProduct.id.isNotEmpty) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editableProduct.id, _editableProduct);
    } else {
      Provider.of<Products>(context, listen: false)
          .addProduct(_editableProduct);
    }

    Navigator.of(context).pop();

    print('Description ${_editableProduct.description}');
    print(_editableProduct.title);
    print(_editableProduct.price);
    print(_editableProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Product Screen',
        ),
        actions: [
          IconButton(
            onPressed: _saveData,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _updateProduct['title'],
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
                textInputAction: TextInputAction.next,
                //focusNode: _,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusMode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editableProduct = Product(
                    description: _editableProduct.description,
                    id: _editableProduct.id,
                    imageUrl: _editableProduct.imageUrl,
                    title: value!,
                    price: _editableProduct.price,
                    isFavourite: _editableProduct.isFavourite,
                  );
                },
              ),
              TextFormField(
                initialValue: _updateProduct['price'],
                decoration: const InputDecoration(
                  label: Text('Price'),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusMode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter valid amount';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter valid amouont';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editableProduct = Product(
                    description: _editableProduct.description,
                    id: _editableProduct.id,
                    imageUrl: _editableProduct.imageUrl,
                    title: _editableProduct.title,
                    price: double.parse(value!),
                    isFavourite: _editableProduct.isFavourite,
                  );
                },
              ),
              TextFormField(
                initialValue: _updateProduct['description'],
                decoration: const InputDecoration(
                  label: Text('Description'),
                ),
                maxLines: 3,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Description';
                  }
                  if (value.length < 10) {
                    return 'Please enter atleast 10 Characers';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editableProduct = Product(
                    description: value!,
                    id: _editableProduct.id,
                    imageUrl: _editableProduct.imageUrl,
                    title: _editableProduct.title,
                    price: _editableProduct.price,
                    isFavourite: _editableProduct.isFavourite,
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
                    child: _imageUrlController.text.isEmpty
                        ? const Text('Image url is empty')
                        : FittedBox(
                            fit: BoxFit.contain,
                            child: Image.network(_imageUrlController.text),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      //initialValue: _updateProduct['imageUrl'],
                      decoration: const InputDecoration(
                        label: Text(
                          'Image Url',
                        ),
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Image Url';
                        }
                        if (!value.startsWith('http') &&
                            (!value.endsWith('.jpg') ||
                                !value.endsWith('.jpeg') ||
                                !value.endsWith('.png'))) {
                          return 'Please enter valid url';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editableProduct = Product(
                          description: _editableProduct.description,
                          id: _editableProduct.id,
                          imageUrl: value!,
                          title: _editableProduct.title,
                          price: _editableProduct.price,
                          isFavourite: _editableProduct.isFavourite,
                        );
                      },
                      onFieldSubmitted: (_) {
                        _saveData();
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
