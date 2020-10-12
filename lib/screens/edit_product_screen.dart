import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProduct extends StatefulWidget {
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();

  final _form = GlobalKey<FormState>(); //To connect the from data

  bool _isinit = true;
  bool _isLoading = false;
  var _editedProduct = Product(id: null, description: '', imageUrl: '', price: 0, title: '');
  var _initValue = {
    'title': '',
    'price': '',
    'imageUrl': '',
    'description': '',
  };
  //when using focusnode make sure to dispose it
  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isinit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        final product =
            Provider.of<Products>(context, listen: false).findById(productId);
        _editedProduct = product;
        _initValue = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
          'description': _editedProduct.description,
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  void _formSumbit() {
    var valid = _form.currentState.validate();          //to validate the input 
    if (!valid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct)
          .catchError((onError) {                 //taking error from products provider 
        return showDialog(                        // we have to return 
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error occurred...'),
                  content: Text(onError.toString()),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text('Okay'))
                  ],
                  
                ));
      }).then((_) {
        setState(() {                             // when ever we use statefull widget we have to change data using setState() method
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    }
  }

  //--------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _form,                  //To connect with the global key
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Title'),
                      initialValue: _initValue['title'],
                      textInputAction: TextInputAction.next,                     //change the submit button to next button
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_priceFocusNode),   //used to go to next form field
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide title';
                        }
                        return null;
                      },
                      onSaved: (newValue) => _editedProduct = Product(
                          id: null,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          price: _editedProduct.price,
                          title: newValue),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Price'),
                      initialValue: _initValue['price'],
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode),
                      onSaved: (newValue) => _editedProduct = Product(
                          id: null,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          price: double.parse(newValue),
                          title: _editedProduct.title),
                    ),
                    TextFormField(
                      initialValue: _initValue['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      focusNode: _descriptionFocusNode,
                      onSaved: (newValue) => _editedProduct = Product(
                          id: null,
                          description: newValue,
                          imageUrl: _editedProduct.imageUrl,
                          price: _editedProduct.price,
                          title: _editedProduct.title),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a Url')
                              : FittedBox(
                                  fit: BoxFit.cover,
                                  child:
                                      Image.network(_imageUrlController.text)),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image Url'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            onFieldSubmitted: (_) => _formSumbit(),
                            onSaved: (newValue) => _editedProduct = Product(
                                id: null,
                                description: _editedProduct.description,
                                imageUrl: newValue,
                                price: _editedProduct.price,
                                title: _editedProduct.title),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
