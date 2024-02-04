import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  List<dynamic> settingsList = [
    {
      'title': 'App lock',
      'icon': Icon(Icons.lock_outline)
    },
    {
      'title': 'Backup',
      'icon': Icon(Icons.backup_outlined)
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SETTING', style: TextStyle(
          fontSize: 21,
          color: Colors.orange.shade100,
          fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.orange.shade100),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            width: 400,
            height: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade600),
              borderRadius: BorderRadius.circular(7),
            ),

            child: ListView.separated(
              itemCount: settingsList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 15,),
              itemBuilder: (context, index) {
                return ClipRRect(

                  child: ListTile(
                    title: Text(settingsList[index]['title'].toString(), style: TextStyle(fontSize: 18,
                    color: Colors.orange.shade100,
                    fontWeight: FontWeight.bold)),
                    leading: settingsList[index]['icon'],
                    trailing: Icon(Icons.arrow_forward_ios_rounded, color: Colors.orange.shade100,),
                    tileColor: Colors.grey.shade600,
                    onTap: () {
                      Navigator.pushNamed(context, '/app-lock');
                    }
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
