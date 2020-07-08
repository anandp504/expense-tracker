import 'package:expensesapp/com/anand/domain/expenses.dart';
import 'package:flutter/material.dart';

class SelectedCategoryItemWidget extends StatelessWidget {
  const SelectedCategoryItemWidget(this.selectedItem, this.deleteSelectedItem);

  final PaymentMode selectedItem;
  final VoidCallback deleteSelectedItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
          children: <Widget>[
            TextFormField(
              // decoration: InputDecoration(labelText: 'Payment Mode'),
              initialValue: selectedItem.mode,
              style: const TextStyle(fontSize: 14),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, size: 22),
              color: Colors.grey[700],
              onPressed: deleteSelectedItem,
            ),
          ],
        ),
    );
  }
}

class CategoryTextField extends StatelessWidget {
  const CategoryTextField(this.controller, this.focusNode);

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        focusNode: focusNode,
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x4437474F),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          suffixIcon: Icon(Icons.search),
          border: InputBorder.none,
          hintText: "Search Payment Mode",
          contentPadding: const EdgeInsets.only(
            left: 16,
            right: 20,
            top: 14,
            bottom: 14,
          ),
        ),
      );
  }
}

class NoItemsFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.folder_open,
          size: 24,
          color: Colors.grey[900].withOpacity(0.7),
        ),
        const SizedBox(width: 10),
        Text(
          "No Items Found",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[900].withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class PopupCategoryListItemWidget extends StatelessWidget {
  const PopupCategoryListItemWidget(this.item);

  final PaymentMode item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Text(
        item.mode,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}