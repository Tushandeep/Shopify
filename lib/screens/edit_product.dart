import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/constant.dart';
import '../providers/products.dart';

import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit-product';
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();

  final _imageUrlController = TextEditingController();

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  Product editProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: "",
    imageUrl: '',
  );

  var _isInit = true;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  bool canEdit = false;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final idAndEdit =
          ModalRoute.of(context)!.settings.arguments as List<dynamic>;
      canEdit = idAndEdit[1];
      if (idAndEdit[0] != null) {
        final Product product = Provider.of<Products>(context, listen: false)
            .findById(idAndEdit[0].toString());
        editProduct = product;
        _initValues = {
          'title': editProduct.title,
          'description': editProduct.description,
          'price': editProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = editProduct.imageUrl;
      }
    }
    _isInit = false;
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      String val = _imageUrlController.text;
      if (val.isNotEmpty ||
          val.startsWith("http") ||
          val.startsWith("https") ||
          val.endsWith('jpg') ||
          val.endsWith('png') ||
          val.endsWith('jpeg')) return;
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      if (editProduct.id != null) {
        try {
          await Provider.of<Products>(context, listen: false)
              .updateProduct(editProduct.id, editProduct);
        } catch (error) {
          await showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Something Went Wrong!'),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        try {
          await Provider.of<Products>(context, listen: false)
              .addProduct(editProduct);
        } catch (error) {
          await showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Something Went Wrong!'),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
      setState(() {
        _isLoading = false;
      });
      Future.delayed(const Duration(seconds: 0), () {
        Navigator.pop(context);
      });
    }
  }

  OutlineInputBorder get decorateBorder {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  OutlineInputBorder get decorateErrorBorder {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(
        color: Theme.of(context).errorColor,
      ),
    );
  }

  InputDecoration decorateTextField(String label, String hint) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
      hintText: hint,
      enabledBorder: decorateBorder,
      disabledBorder: decorateBorder,
      focusedBorder: decorateBorder,
      focusedErrorBorder: decorateErrorBorder,
      errorBorder: decorateErrorBorder,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(canEdit ? 'Edit Product' : 'Add Product'),
        actions: [
          Tooltip(
            message: canEdit ? 'Save Editing' : 'Add Product',
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: const Icon(Icons.save_rounded),
                onPressed: _saveForm,
              ),
            ),
          ),
        ],
      ),
      body: (_isLoading)
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: TextFormField(
                          initialValue: _initValues['title'],
                          decoration: decorateTextField('Title', 'Title'),
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_imageUrlFocusNode);
                          },
                          validator: (val) {
                            return (val != null && val.isNotEmpty)
                                ? null
                                : 'Invalid Title';
                          },
                          onSaved: (val) {
                            editProduct = Product(
                              title: val!.trim(),
                              price: editProduct.price,
                              id: editProduct.id,
                              description: editProduct.description,
                              imageUrl: editProduct.imageUrl,
                              isFavorite: editProduct.isFavorite,
                            );
                          },
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: TextFormField(
                          controller: _imageUrlController,
                          decoration:
                              decorateTextField('Image URL', 'Image URL'),
                          onEditingComplete: () {
                            setState(() {});
                          },
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocusNode);
                            setState(() {});
                          },
                          textInputAction: TextInputAction.next,
                          validator: (val) {
                            return (val != null ||
                                    val!.isNotEmpty && val.startsWith("http") ||
                                    val.startsWith("https") ||
                                    val.endsWith('.jpg') ||
                                    val.endsWith('.png') ||
                                    val.endsWith('.jpeg'))
                                ? null
                                : 'Invalid Image URL';
                          },
                          onSaved: (val) {
                            editProduct = Product(
                              title: editProduct.title,
                              price: editProduct.price,
                              id: editProduct.id,
                              description: editProduct.description,
                              imageUrl: val!.trim(),
                              isFavorite: editProduct.isFavorite,
                            );
                          },
                          focusNode: _imageUrlFocusNode,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Container(
                          width: size.width * 0.77,
                          height: size.height * 0.35,
                          margin: const EdgeInsets.only(
                            top: 8.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Center(child: Text('Enter a URL'))
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: TextFormField(
                          initialValue: _initValues['description'],
                          maxLines: 6,
                          textAlignVertical: TextAlignVertical.top,
                          keyboardType: TextInputType.multiline,
                          decoration:
                              decorateTextField('Description', 'Description'),
                          focusNode: _descriptionFocusNode,
                          onSaved: (val) {
                            editProduct = Product(
                              title: editProduct.title,
                              price: editProduct.price,
                              id: editProduct.id,
                              description: val!.trim(),
                              imageUrl: editProduct.imageUrl,
                              isFavorite: editProduct.isFavorite,
                            );
                          },
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Invalid Description';
                            }
                            if (val.length < 10) {
                              return 'Should be at least 10 characters long.';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: TextFormField(
                          initialValue: _initValues['price'],
                          decoration: decorateTextField('Price', '\$23xx.xx'),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          validator: (val) {
                            return (val != null &&
                                    val.isNotEmpty &&
                                    double.tryParse(val) != null &&
                                    double.parse(val) > 0)
                                ? null
                                : 'Invalid Price';
                          },
                          onSaved: (val) {
                            editProduct = Product(
                              title: editProduct.title,
                              price: double.parse(val!.trim()),
                              id: editProduct.id,
                              description: editProduct.description,
                              imageUrl: editProduct.imageUrl,
                              isFavorite: editProduct.isFavorite,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            primaryAppColor,
                          ),
                        ),
                        onPressed: _saveForm,
                        child: Text(
                          canEdit ? 'Save Editing' : 'Add Product',
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
