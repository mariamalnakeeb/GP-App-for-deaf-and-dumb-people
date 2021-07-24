import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'popupmenu.dart';

class AppBarReusable extends StatelessWidget implements PreferredSizeWidget {
  AppBarReusable();
  @override
  Size get preferredSize => const Size.fromHeight(55);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xffe4e4e4),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Deaf Teacher',
            style: TextStyle(color: Colors.black),
          ),
          PopupMenuReusable()
        ],
      ),
    );
    // TODO: implement build
    throw UnimplementedError();
  }
}
