import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shoping_app/data/categories.dart';
import 'package:shoping_app/models/category.dart';
import 'package:shoping_app/models/glosory_items.dart';

class NewItems extends StatefulWidget {
  const NewItems({Key? key}) : super(key: key);

  @override
  State<NewItems> createState() => _NewItemsState();
}

class _NewItemsState extends State<NewItems> {
  final _formKey = GlobalKey<FormState>();
  var _enterName = '';
  var _Quantity = 0;
  var _selectedCategories = categories[Categories.vegetables]!;

  void _savedItems() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https('flutter-test-6ba5c-default-rtdb.firebaseio.com',
          'shoping-list.json');
      final response = await http.post(
        url,
        headers: {
          'Content-type': 'application/json',
        },
        body: json.encode(
          {
            'name': _enterName,
            'quantity': _Quantity,
            'category': _selectedCategories.title,
          },
        ),
      );
      print(response.body);
      print(response.statusCode);
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop();
      // response.
      // Navigator.of(context).pop(
      //   GroceryItem(
      //     id: DateTime.now().toString(),
      //     name: _enterName,
      //     quantity: _Quantity,
      //     category: _selectedCategories,
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Items'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Character count must be between 1 and 50';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _enterName = newValue!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                      ),
                      initialValue: '1',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Quantity must be a valid positive number';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _Quantity = int.parse(newValue!);
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategories,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Text(category.value.title),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategories = value!;
                        });
                      },
                      // items: categories.entries.map((entry) {
                      //   return DropdownMenuItem(
                      //     value: entry.value,
                      //     child: Row(
                      //       children: [
                      //         Container(
                      //           width: 16,
                      //           height: 16,
                      //           color: entry.value.color,
                      //         ),
                      //         SizedBox(width: 10),
                      //         Text(entry.value.title),
                      //       ],
                      //     ),
                      //   );
                      // }).toList(),
                      // onChanged: (selectedCategory) {
                      //   // Handle category selection
                      // },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _savedItems,
                    child: Text('Add Items'),
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
