import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  Widget buildListTile(String title, IconData icon, Function handler) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: TextStyle(fontSize: 20)),
      onTap: handler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 150,
            width: double.infinity,
            color: Theme.of(context).accentColor,
            padding: EdgeInsets.only(left: 10),
            child: Text('Cooking Up',
                style: TextStyle(
                    fontSize: 30,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 30,
          ),
          FlatButton(onPressed: ()=> Navigator.of(context).pushNamed('/user-products'), child: Text('Admin'),),
        ],
      ),
    );
  }
}