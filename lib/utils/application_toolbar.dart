import 'package:flutter/material.dart';

class ApplicationToolbar extends StatelessWidget with PreferredSizeWidget{
  const ApplicationToolbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.handshake),
          Text("News 24")
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}